# PE-TestCage

PE-TestCage is a safe local test cage for Windows PE and Windows deployment scripts.

It allows batch-based deployment menus to be tested without touching real disks, bootloaders or images.

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
- A fast local preview environment for menu layout and script flow
- Tool-agnostic by design

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
├── Run-TestCage.sh
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
    ├── Images\
    └── hello-menu.cmd
```

## Drive model

The default test cage exposes fake deployment drives:

```text
S: = fake EFI/System partition
W: = fake Windows target partition
Z: = fake deployment share / tool drive
P: = PE-TestCage repository root, Linux/Wine runner only
```

On Windows, `Run-TestCage.cmd` uses `subst` for `S:`, `W:` and `Z:`.

On Linux, `Run-TestCage.sh` uses a local Wine prefix and creates Wine drive mappings through `dosdevices`.

## Windows usage

Start an interactive cage shell:

```cmd
Run-TestCage.cmd
```

Run a script inside the cage:

```cmd
Run-TestCage.cmd Z:\MyTool\Menu.cmd
```

Or run an example:

```cmd
Run-TestCage.cmd examples\hello-menu.cmd
```

Relative paths are resolved from the PE-TestCage repository root.

## Linux usage

Install Wine through your distribution package manager.

Fedora example:

```bash
sudo dnf install wine
```

Arch example:

```bash
sudo pacman -S wine
```

Start an interactive cage shell:

```bash
./Run-TestCage.sh
```

Run a script inside the cage:

```bash
./Run-TestCage.sh 'Z:\MyTool\Menu.cmd'
```

Run the example:

```bash
./Run-TestCage.sh examples/hello-menu.cmd
```

The Linux runner creates a local Wine prefix at:

```text
.wineprefix/
```

This folder is ignored by Git.

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
