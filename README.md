# cobbler_deploy
Ansible role to deploy a cobbler v3 server and configure it on a RHEL/Centos 8 based host

# Background:

This role will deploy and configure a cobbler v3 server, it is compromised of these tasks:

- cobbler3x_server - install and configure a cobbler v3 server
- distros - add distros which are downloaded (ISOs fetched remotely) with checksum verification (sha256). Optionally add local distros by supplying local ISO.
- debian
- profiles - add or amend profiles
- repos - add or amend repos. Here, amend will likely be a new rpm-list.
- systems - add or amend systems, will not remove systems


# Setting up the role

- Edit the defaults/main.yml file accordingly
- Run the role

# Running tasks

- If you want to only run a subset of tasks run with __--tags__  (e.g. "distros", "repos", "systems", "profiles" )

- With no tags supplied, all tasks are run.

- With the above in mind, to add or update distros therefore use __--tags=distros__

-- To import locally provided distros pass the variable as follows, (e.g. ISOs you have copied to the Cobbler server manually):

__--tags=distros -e add_local_distro='True'__

