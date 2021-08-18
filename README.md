# cobbler_deploy
Ansible role to deploy a cobbler v3 server and configure it on a RHEL/Centos 8 based host.

It has been developed on Almalinux 8.4 but should work for Centos 8x and derived distros.

Fixes/workarounds for some issues are within this role, but there may be other ways to achieve them, or they may be fixed upstream in cobbler (e.g. reposync flags).

**THIS ROLE SHOULD BE USED AT OWN RISK, AUTHOR HAS DONE TESTING WHILST IN DEVELOPMENT**<br>
Developed/tested on:
- Centos 7.9 ansible controller host with ansible 2.9.23 used to deploy Cobbler onto:<br>
- Almalinux 8.4,<br>
- cobbler v3.2.0 via EPEL RPM/DNF Module,<br>
- SELinux permissive<br>

The role will configure cobbler v3 to be a TFTP boot host and repo mirror.
- it will install and enable xinetd tftp, with logging to /var/log/tftp.log.
- it will not change or manage your firewall settings (e.g. firewalld/iptables). You need to enable tftp and web for clients.
- it doesn't set cobbler manage_dhcp.
- it doesn't set cobbler manage_dns.
- it will not install cobbler-web (override this using var *install_cobbler_web*).
- it will not setup the cobbler-web password.
- it will install dependencies (inc python3-librepo) both for the RPM cobbler (installed here) and also those for source-build of cobbler, in case you need to experiment (it is assumed your target system is going to be dedicated to cobbler). Some dependencies are installed via pip3.

With no changes you will end up with a *Centos 7.9 minimal* distro, *Debian 11 netinst* and a basic *EPEL8* mirror, mirroring only the *atop* package, to keep things nice and small to start out. These are merely provided as examples. You don't have to use them.

It is advised you override the defaults/main.yml with use of vars/main.yml within the role. See header text in defaults/main.yml.

# Default install

By default it will install the RPM found in EPEL.

You can override this to install from source. e.g.:

`-e install_cobber_pkg='False' -e clone_cobbler_src='True'`

*NOTE outstanding issue to fix dockerfile rpm generator script task*


# Background

This role is comprised of these tasks (which also run in listed order from main):

- setup_cobbler3x - install a cobbler v3 server. From RPM or source built (local) RPM. Source build is currently tagged to v3.2.1 and is WIP see issues.
- configure_cobbler3x - configure the cobbler server. Version specific 3.2.0 fixes are also included.
- cobbler_distro - add distros which are downloaded (ISOs fetched remotely) with checksum verification (sha256). Optionally add local distros by supplying local ISO.
- cobbler_debian_netinst_fix - ensure that the Netinst initrd is replaced with a network/http capable version (can disable via defaults via **Deploy_debian**).
- cobbler_profiles - add or amend profiles.
- cobbler_repos - add or amend repos. Here, amend will likely be a new rpm-list.
- cobbler_systems - add or amend systems, will not remove systems.

## Preparing your inventory

The role makes use of ansible `groups['all']` to find all of your inventory hosts. 

For an inventory entry, these variables need to be present:

`hostname.aa.bb ansible_host=192.168.0.2 Cobbler_mac=00:11:22:33:44:55`

If you want to override the default profile then supply one like this:

`hostname.aa.bb ansible_host=192.168.0.2 Cobbler_mac=00:11:22:33:44:55 Cobbler_profile=Alma-84-minimal-x86_64`

## Copy your kickstart/preseed/autoyast files

You should copy or setup a method to provide auto install files into /var/lib/cobbler/templates/

This role will default to sample.ks to make things work. Edit and override accordingly.

## SELinux

Administrators should manage their SELinux environment. SELinux configuration is out of scope here.

This role will set httpd_can_network_connect though.

SELinux config is a potential enchancement.

## Included v3.2.0 fixes

- /etc/profile.d script to warn administrator of cobbler-loaders deprecation.
- Copy syslinux files to /var/lib/cobbler/loaders.

# Setting up the role

- 1) Copy the defaults/main.yml to vars/main.yml and edit accordingly. See header text.
- 2) Ensure you configure ISO URLs to reflect your locality.
- 3) Know your SELinux environ.
- 4) Run the role.
- 5) Review `cobbler checks` output

**If you do nothing for i), you'll end with defaults which results in:<br><br>
   ISOs downloaded: CentOS-7-x86_64-Minimal-2009.iso, debian-10.10.0-amd64-netinst.iso<br>
   Distros setup: Centos-79-minimal-x86_64, debian-10.10.0-netinst-x86_64 (gtk,xen also)<br>
   Profiles setup: same as above<br>
   Repos setup: EPEL8_x86_64 with 'atop' package only<br>
   Systems setup: whatever `groups['all']` in ansible finds though expect it to fail if your inventory is not prepared**<br>

# Running tasks

- If you want to only run a subset of tasks run with __--tags__  (e.g. "setup_server", "configure_server", "distros", "debian_fix", "profiles", "repos", "systems"  )

- With no tags supplied, all tasks are run.

- With the above in mind, to add or update distros therefore use __--tags=distros__

  To import locally provided distros pass the variable as follows, (e.g. ISOs you have copied to the Cobbler server manually):

__--tags=distros -e add_local_distro='True'__

  (If you have lots of ISOs which originated from remote sources you may which to also add -e add_download_distro='False' to focus on local only)

# Default system state (Netboot)

By default systems have netboot set to "N" therefore you need to enable system netboot on CLI, before you attempt to PXE boot a host.

This is a design choice, to avoid accidents.

To enable netboot for a system:

`cobbler system edit --name=my_system.aa.bb  --netboot=Y`

# Editing objects

distros - Role doesn't edit after creation. Use CLI. Potential future enhancement is role to update.<br>
profiles - Role will update.<br>
repos - Role will update.<br>
systems - Role will update.<br>
  
# Removing objects

This role leaves the majority of removal operations to be handled by administrators on the CLI. This is detailed below.

distros - administrator removes manually, not done by this role.<br>
profiles - administrator removes manually, not done by this role - potential future enchancement.<br>
**repos - can be removed** with use of **cobbler_removed_repos**, rationale is administrator may want to immediately remove ISO imported repos.<br>
system - administrator removes manually, not done by this role - potential future enchancement remove hosts no longer found in ansible.<br>

