# cobbler_deploy
Ansible role to deploy a cobbler v3 server and configure it on a RHEL/Centos 8 based host.

It has been developed on Almalinux 8.4 but should work for Centos 8x and derived.

**THIS ROLE SHOULD BE USED AT OWN RISK, AUTHOR HAS DONE TESTING WHILST IN DEVELOPMENT**

It will configure cobbler v3 to be a TFTP boot host and repo mirror.
- it doesn't set cobbler manage_dhcp
- it doesn't set cobbler manage_dns

With no changes you will end up with a *Centos 7.9 minimal* distro, *Debian 10 netinst* and a basic *EPEL8* mirror, mirroring only the *atop* package, to keep things nice and small to start out.

It is advised you override the defaults/main.yml with use of vars/main.yml within the role. See header text in defaults/main.yml.

# Background:

This role will deploy and configure a cobbler v3 server, it is compromised of these tasks (which also run in listed order from main):

- cobbler3x_server - install and configure a cobbler v3 server
- cobbler_distro - add distros which are downloaded (ISOs fetched remotely) with checksum verification (sha256). Optionally add local distros by supplying local ISO.
- cobbler_debian_netinst_fix - ensure that the Netinst initrd is replaced with a network/http capable version (can disable via defaults via **Deploy_debian**)
- cobbler_profiles - add or amend profiles
- cobbler_repos - add or amend repos. Here, amend will likely be a new rpm-list.
- cobbler_systems - add or amend systems, will not remove systems

# Preparing your inventory

The role makes use of ansible `groups['all']` to find all of your inventory hosts. 

For an inventory entry, these variables need to be present:

`hostname.aa.bb ansible_host=192.168.0.2 Cobbler_mac=00:11:22:33:44:55`

If you want to override the default profile then supply one like this:

`hostname.aa.bb ansible_host=192.168.0.2 Cobbler_mac=00:11:22:33:44:55 Cobbler_profile=Alma-84-minimal-x86_64`


# Setting up the role

- 1) copy the defaults/main.yml to vars/main.yml and edit accordingly. See header text.
- 2) Run the role

**If you do nothing for i), you'll end with defaults which results in:<br><br>
   ISOs downloaded: CentOS-7-x86_64-Minimal-2009.iso, debian-10.10.0-amd64-netinst.iso<br>
   Distros setup: Centos-79-minimal-x86_64, debian-10.10.0-netinst-x86_64 (gtk,xen also)<br>
   Profiles setup: same as above<br>
   Repos setup: EPEL8_x86_64 with 'atop' package only<br>
   Systems setup: whatever `groups['all']` in ansible finds**<br>

# Running tasks

- If you want to only run a subset of tasks run with __--tags__  (e.g. "setup_server", "distros", "debian_fix", "profiles", "repos", "systems"  )

- With no tags supplied, all tasks are run.

- With the above in mind, to add or update distros therefore use __--tags=distros__

-- To import locally provided distros pass the variable as follows, (e.g. ISOs you have copied to the Cobbler server manually):

__--tags=distros -e add_local_distro='True'__

  (If you have lots of ISOs which originated from remote sources you may which to also add -e add_download_distro='False')

