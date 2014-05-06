Battery Status
==============

A simple battery status inidcator written in LUA using GTK to use with window managers that don't provide one, such as Awesome.

Usage
=====
`sudo apt-get install libgirepository1.0-dev`
You will need to install LGI with luarocks with the command  
`luarocks install lgi lrexlib-pcre`  
Or get it from https://github.com/pavouk/lgi  

Afterwards just run `lua /path/to/status.lua` in your initialization script, and enjoy!
