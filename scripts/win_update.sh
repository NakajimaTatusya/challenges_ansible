#!/bin/bash

cd ~/challenges_ansible
echo "Windows Updateを実行"
timestamp=`date "+%Y%m%d%H%M%S"`
echo "状況確認コマンド$> tail -f /home/tnakajima/challenges_ansible/logs/${timestamp}-win_update.log  を実行"
nohup ansible-playbook -vvv win_update.yml > logs/${timestamp}-win_update.log &
exit 0