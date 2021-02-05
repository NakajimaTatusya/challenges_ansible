#!/bin/bash

cd ~/challenges_ansible
echo "疎通確認を実行する"
timestamp=`date "+%Y%m%d%H%M%S"`
#nohup ansible-playbook -vvv win_confirm_reachable.yml > logs/${timestamp}-win_confirm_reachable.log &
#tail -f logs/${timestamp}-win_confirm_reachable.log
cat <(nohup ansible-playbook -vvv win_confirm_reachable.yml 2>&1 </dev/null | tee logs/${timestamp}-win_confirm_reachable.log)
exit 0