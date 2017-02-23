# LedControl

An umbrella app that has a Phoenix frontend for manipulating LEDs on devices like the Raspberry PI.
Based on https://github.com/nerves-project/nerves-examples/tree/master/hello_phoenix

Currently this is just a toy project, but hopefully some of the parts can be released.

## Target

The default target is set to `rpi2` - This is what I developed it on, I'm open to PRs to support
other devices.

You can change the target by either modifying the `apps/fw/mix.exs` default
```elixir
# mix.exs

@target System.get_env("NERVES_TARGET") || "rpi"
```

or prefix all mix commands with your target. `NERVES_TARGET=rpi mix firmware`

## Network Connection

The project is also configured to use static ethernet so you can plug the cable
directly in to your machine. You can change this behaviour by editing the interface
options in `apps/fw/lib/fw.ex`

Add an entry to your /etc/hosts like
```
192.168.0.200 nerves.local
```
where the 192.168.0.200 is replaced by the IP address you chose for your device.

To use DHCP
```elixir
@opts [mode: "dhcp"]
```

You can use also run the exmaple with wifi by switching out the `nerves_networking` dependency
for `nerves_interim_wifi`

For more information See

https://github.com/nerves-project/nerves_networking
https://github.com/nerves-project/nerves_interim_wifi

## Firmware updating

initially, you'll have to
```
$ cd apps/fw
$ mix deps.get
$ mix firmware
$ mix firmware.burn
```

Once this is done, and the device is booted, you can attach to it with
```
$ iex --cookie foobar --name laptop --remsh fw@nerves.local
```
Then navigate to the ip of the device and you'll see the welcome page.

Push new firmware to the device with
```
cd apps/fw
mix firmware && mix firmware.push nerves.local --target=rpi2
```
target should be set to the type of the target.
