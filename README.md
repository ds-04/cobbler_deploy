# cobbler_deploy
Ansible role to deploy a cobbler v3 server and configure it on a RHEL/Centos 8 based host

# Background:

This role will deploy and configure a cobbler v3 server, it is compromised of these tasks:

- cobbler3x_server - install and 
- repos
-
-
-


# Setting up the role

- Edit the defaults/main.yml file accordingly
- Run the role
- If you want to only run a subset of tasks run with __--tags__  (e.g. "distros", "repos", "systems", "profiles" )


