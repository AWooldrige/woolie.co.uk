---
title: Dell Laptop Stuck at 800MHz - Linux Fix
created_at: 2011-02-20 11:44:54 +0000
kind: article
Legacy WP ID: 558
---

I've got a Dell Inspiron 1720 laptop is which is only 2 years old. It started
running extraordinarily slowly, and the CPU governer wouldn't scale above
800MHz. At first I thought this was down to the operating system. In Ubuntu
10.10, a quick `cpufreq-info` revealed the some strange limits:

    current policy: frequency should be within 800 MHz and 800 MHz. The
    governor "performance" may decide which speed to use within this range.

On the next reboot the dreaded message came up:

    The AC power adapter type cannot be determined. Your system will operate
    slower and the battery will not charge. Please connect a Dell 90W AC
    adapter or higher for best system operation.

Dell place a chip in their adapters which force you to use theirs and no one
else. They say this is to "protect the battery" and identify the wattage of the
adapter. There's nothing wrong with my adapter, yet I now cannot charge the
battery, and my system is stuck at 800MHz. Communication with this chip is
through a one wire protocol, that's what that mysterious centre pin inside the
AC jack is for. The 5 secondish wait on the BIOS page when the adapter is
plugged in suggests there's no life in the chip. To make sure, I tested the
adapter with another working Dell Inspiron.


The author of the fix identifies themselves as "Ambasta", and I can't thank
them enough! Head over to their site to see their fix: [Bypassing the DELL
unrecognized adapter
issue](http://techmonks.net/bypassing-the-dell-unrecognized-adapter-issue).
I've posted it again with slightly more detail below for Ubuntu (the Windows
one is on their site).

## The Fix - Force the Kernel to Ignore BIOS
Note that This only sorts out the CPU issue, not the battery charging. I
haven't found a solution to that so far, and its unlikely that there will be
one to be honest. Apart from getting an external battery charger.

The Dell BIOS doesn't enforce the limit on the CPU, but rather "forcefully
suggests" that the kernel stick to the BIOS suggested limit (as found in
`/proc/acpi/processor/CPUx/bios_limit`). When an AC adapter is unrecognised,
Dell's BIOS asks the kernel to stop the CPU being scaled above its lowest
setting. Thankfully, there is a way to override this faithfulness: pass
`processor.ignore_ppc=1` as a kernel parameter!

### GRUB 2 - Ubuntu 9.10 and Above
Edit the following file: `/etc/default/grub`

On about the 9th line down, you'll see a line that says
`GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"`. This appends whatever you provide
to the end of each Linux entry in the boot menu. Add the kernel parameter from
before to the end of this line:

    GRUB_CMDLINE_LINUX_DEFAULT="quiet splash processor.ignore_ppc=1"

Don't forget to update GRUB and reboot: `sudo update-grub && sudo reboot`

### GRUB 1 - Ubuntu 9.04 and Below
There is a good article at
[grumpymole](http://grumpymole.blogspot.com/2007/05/ubuntu-how-to-edit-grub-boot-parameters.html)
on changing GRUB 1 kernel parameters. That article is much more in detail for
those still with older versions.
