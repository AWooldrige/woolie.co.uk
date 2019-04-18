---
title: Vagrant Shared Directory Hangs on Ubuntu 13.10
created_at: 2013-12-17 22:20:00 +0000
updated_at: 2013-12-17 22:20:00 +0000
kind: article
excerpt: >-
    How to get yourself up and running again after running any command in a
    Vagrant shared directory hangs.
---

### The Symptom
Performing any operation on the Vagrant shared directory hangs. E.g. `ls
/vagrant`.


### How to Fix It
 * Update VirtualBox to a version greater than 4.3.
 * In the same directory as your Vagrantfile, install the vagrant-vbguest
   plugin with: `vagrant plugin install --plugin-source https://rubygems.org --plugin-prerelease vagrant-vbguest`.

### Detail: What causes this symptom
The problem occurs with the following configuration:

 * Vagrant with VirtualBox below version 4.3.
 * The [official Ubuntu 13.10 box](http://cloud-images.ubuntu.com/vagrant/saucy/20131208/saucy-server-cloudimg-amd64-vagrant-disk1.box)
   installed.

The shared folders hang because of a small bug that was fixed in version 4.3 of VirtualBox (see the bugfix in [changeset 48529](https://www.virtualbox.org/changeset/48529/vbox)). Updating VirtualBox on the host machine is easy, you just install the latest version. Unfortunatly the bug wasn't in the code for the host, but within the Guest Additions source (`trunk/src/VBox/Additions/linux/sharedfolders/dirops.c`). The version of Guest Additions hard baked into the [Ubuntu 13.10 Vagrant box](http://cloud-images.ubuntu.com/vagrant/saucy/20131208/saucy-server-cloudimg-amd64-vagrant-disk1.box) is older than 4.3, so doesn't have the fix.

The `vagrant-vbguest` plugin sorts this by checking the version of the Guest Additions on startup, and updating it if neccessary.
