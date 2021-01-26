#!/bin/bash

cd ~/challenges_ansible
echo "疎通確認を実行する"
ansible-playbook -vvv win_confirm_reachable.yml
exit 0