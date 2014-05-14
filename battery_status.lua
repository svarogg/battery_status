
local lgi = require 'lgi'
local Gtk = lgi.require('Gtk')
local GLib = lgi.GLib
local rex = require("rex_posix")

local M = {}
M.__index = M

local statusIcon = Gtk.StatusIcon {
    visible = true,
    tooltip_text = "I'm not sure",
    file = "./battery-icons/100.png"
}

local function get_acpi_res()
  local acpi = io.popen('acpi 2>&1')
  local acpi_res = acpi:read("*line")
  acpi:close()
  return acpi_res
end

local function get_icons_dir()
  local running_script = debug.getinfo(get_icons_dir).short_src
  local dir = rex.match(running_script, [[^(.*\/)?[^\/]+.lua]]) or "./"
  return dir .. "battery-icons/"
end

local icons_dir = get_icons_dir()
local function get_battery_file(percent)
  local img_name = (percent > 90 and "100") or
                   (percent > 70 and "80") or
                   (percent > 50 and "60") or
                   (percent > 30 and "40") or
                   (percent > 10 and "20") or
                   "0"

  return string.format("%s%s.png", icons_dir, img_name)
end

local alert_thresholds = {
  [20] = false,
  [10] = false,
  [5] = false
}
local function alert_low_battery(percent)
  for threashold, was_raised in pairs(alert_thresholds) do
    if percent < threashold then
      if not was_raised then
        local dialog = Gtk.MessageDialog {
          message_type = 'ERROR', buttons = 'CLOSE',
          text = ("Battery low! Have only %s percent!"):format(percent),
          on_response = Gtk.Widget.destroy
        }
        dialog:show_all()

        for other_threashold, other_raised in pairs(alert_thresholds) do
          if other_threashold >= threashold then
            alert_thresholds[other_threashold] = true
          end
        end
      end
    else
      was_raised = false
    end
  end
end

local battery_rex = rex.new([[([^,]{1,3})%]])
local function check_battery()
  local acpi_res = get_acpi_res()
  local percent = tonumber(battery_rex:match(acpi_res))

  if not percent then
    print("Error from acpi:", acpi_res)
    os.exit()
  end

  statusIcon.tooltip_text = acpi_res
  statusIcon.file = get_battery_file(percent)
  alert_low_battery(percent)

  return true
end

function M.run()
  check_battery()
  GLib.timeout_add(GLib.PRIORITY_DEFAULT, 1 * 1000 ,check_battery)
  Gtk.main()            -- make it alive, waiting for events
end

return M