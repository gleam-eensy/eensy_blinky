# eensy_blinky


## Getting started

Follow the setup on https://www.atomvm.net/doc/main/getting-started-guide.html for the platform that you may be working on.


### Add Gleam related tools

```sh
gleam add eensy
gleam add --dev eensy_dev_tools
```

### You should properly setup your gleam.toml file based on the params needed for your platform

```toml
...

[eensy]
platform = "esp32"
port = "/dev/tty.usbserial-0001"

...
```

### Run the cli dev tools for flashing the blinky runtime

```sh
gleam run -m eensy_dev_tools flash
```