Battery Status
==============

A simple battery status inidcator written in LUA using GTK to use with window managers that don't provide one, such as Awesome.

Installation
============
To install the dependencies:
For DPKG based distros: `sudo apt-get install lua5.1 luarocks libgirepository1.0-dev acpi`.
For RPM based distros: `sudo yum install lua5.1 luarocks gobject-introspection-devel acpi`
Than use the rockspec to install the rock.

Usage
=====
Add `show_battery_status` to your initialization script, or simply run it in console.
Mouseover to see some stats.