#!/bin/bash

cd ~/challenges_ansible
echo "個別設定を実行"
timestamp=`date "+%Y%m%d%H%M%S"`
echo "状況確認を行うには> tail -f /home/tnakajima/challenges_ansible/logs/${timestamp}-win_individual_setup.log  を実行してください"
nohup ansible-playbook -vvv win_individual_setup.yml > logs/${timestamp}-win_individual_setup.log &
exit 0