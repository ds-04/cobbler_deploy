#!/bin/bash
ansible-playbook --diff cobbler_deploy.yml --tags=systems -i ./production
