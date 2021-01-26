#!/bin/bash

cd ~/challenges_ansible
echo "基本設定を実行"
timestamp=`date "+%Y%m%d%H%M%S"`
nohup ansible-playbook -vvv win_basic_setup.yml > logs/${timestamp}-win_basic_setup.log &
exit 0