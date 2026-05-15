# PE-TestCage Test Matrix

Use this checklist to verify the local cage behavior before testing scripts in real WinPE.

## Cage startup

- [ ] `Run-TestCage.cmd` starts without errors
- [ ] Fake `S:` drive is mapped
- [ ] Fake `W:` drive is mapped
- [ ] Fake `Z:` drive is mapped
- [ ] `TEMP` and `TMP` point to the cage `Temp` directory
- [ ] `MockBin` is placed before system paths in `PATH`

## DP-Menu-Bat profile

- [ ] Profile starts from `profiles\dp-menu.cmd`
- [ ] Missing `Z:\DP-Menu-Bat\Menu\Menu.bat` is reported clearly
- [ ] Existing DP-Menu starts correctly from fake `Z:`
- [ ] Menu refresh works
- [ ] Back and exit paths work

## Mock command behavior

- [ ] `diskpart /s file.txt` does not touch real disks
- [ ] `diskpart` writes to `Logs\diskpart.log`
- [ ] `diskpart` returns fake `list disk` output
- [ ] `diskpart` returns fake `list volume` output
- [ ] `dism` writes to `Logs\dism.log`
- [ ] `bcdboot` writes to `Logs\bcdboot.log`
- [ ] `wpeutil reboot` is blocked and logged
- [ ] `shutdown -r` is blocked and logged
- [ ] `net use` is mocked and logged

## Menu and flow checks

- [ ] Menu layout looks correct
- [ ] Echo spacing is clean
- [ ] Invalid input returns to the expected place
- [ ] Empty input returns to the expected place
- [ ] Module calls use the expected paths
- [ ] Error messages are understandable
- [ ] Confirmation prompts are clear before destructive actions

## Not validated by PE-TestCage

- [ ] Real WinPE boot behavior
- [ ] Real diskpart behavior
- [ ] Real DISM apply/capture behavior
- [ ] Real bcdboot behavior
- [ ] UEFI / BIOS / Secure Boot behavior
- [ ] Hardware-specific driver behavior

Final validation still belongs in a real WinPE environment and on real hardware. The cage only kills the boring mistakes before they waste your afternoon.
