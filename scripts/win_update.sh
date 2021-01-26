#!/bin/bash

cd ~/challenges_ansible
echo "Windows Updateを実行"
timestamp=`date "+%Y%m%d%H%M%S"`
nohup ansible-playbook -vvv win_update.yml > logs/${timestamp}-win_update.log &
exit 0