# PE-TestCage

PE-TestCage is a safe local test cage for Windows PE and Windows deployment scripts.

It allows batch-based deployment menus to be tested from a running Windows system without touching real disks, bootloaders or images.

The cage works by placing mock commands before the real Windows tools in `PATH`.

Mocked commands include:

```text
diskpart
dism
bcdboot
wpeutil
shutdown
net
```

This makes it possible to test menu structure, path handling, module calls, confirmation prompts, error handling and command flow without running destructive actions.

## What PE-TestCage is

- A safe test wrapper for WinPE-style batch scripts
- A mock environment for deployment menus
- A way to test menu logic without booting WinPE
- Useful for DP-Menu-Bat, WimTools and similar tools
- A fast local preview environment for menu layout and script flow

## What PE-TestCage is not

- Not a real WinPE replacement
- Not a DISM simulator
- Not a diskpart emulator
- Not a full deployment validation environment
- Not a firmware, UEFI or bootloader test environment

PE-TestCage catches script, menu and flow mistakes. It does not prove that a real deployment will work on real hardware.

Final validation must still be done in a real WinPE environment and on real target hardware.

## Use PE-TestCage for

```text
menu design
layout cleanup
navigation testing
module call testing
path handling
confirmation prompts
error messages
command flow logging
safe destructive-command mocking
```

## Do not use PE-TestCage for

```text
final deployment validation
real diskpart behavior
real DISM apply or capture testing
real bootloader testing
firmware-specific testing
hardware-specific testing
```

## Basic idea

The runner temporarily modifies `PATH` so that dangerous commands are resolved from `MockBin` first:

```text
MockBin\diskpart.cmd
MockBin\dism.cmd
MockBin\bcdboot.cmd
MockBin\wpeutil.cmd
MockBin\shutdown.cmd
MockBin\net.cmd
```

The tested scripts can stay unchanged. They call `diskpart`, `dism` or `bcdboot` as usual, but inside the cage those commands only log what would have happened.

## Runtime layout

```text
PE-TestCage\
├── Run-TestCage.cmd
├── profiles\
│   └── dp-menu.cmd
├── MockBin\
│   ├── diskpart.cmd
│   ├── dism.cmd
│   ├── bcdboot.cmd
│   ├── wpeutil.cmd
│   ├── shutdown.cmd
│   └── net.cmd
├── Drives\
│   ├── S\
│   ├── W\
│   │   └── Windows\
│   └── Z\
├── Temp\
├── Logs\
└── examples\
    ├── Disklayouts\
    └── Images\
```

## Drive model

The default test cage uses `subst` to map local folders to fake deployment drives:

```text
S: = fake EFI/System partition
W: = fake Windows target partition
Z: = fake deployment share / tool drive
```

The mappings are temporary and are removed when the runner exits.

## Usage

Prepare your tool inside the fake `Z:` drive folder, for example:

```text
Drives\Z\DP-Menu-Bat\
```

Then run:

```cmd
Run-TestCage.cmd profiles\dp-menu.cmd
```

Or simply:

```cmd
Run-TestCage.cmd
```

The default profile is `profiles\dp-menu.cmd`.

## Logs

Mocked commands write their calls to:

```text
Logs\diskpart.log
Logs\dism.log
Logs\bcdboot.log
Logs\wpeutil.log
Logs\shutdown.log
Logs\net.log
```

Use these logs to verify what the deployment menu would have executed.

## Safety notes

PE-TestCage does not delete, partition, format, apply images, write bootloaders, reboot or shutdown the host.

Still, run it from a normal user or dedicated test directory. Do not mix test folders with real deployment data unless you enjoy debugging preventable nonsense.
