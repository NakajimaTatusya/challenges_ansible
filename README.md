# challenges ansible

## 目的

1. Ansible 独習
2. roles 独習

## ディレクトリ構成

* challenges_ansible/
  * csv_files/
  * group_vars/
  * host_vars/
  * production/
    * hosts
  * roles/
    * common/
      * files/
      * tasks/
      * vars/
    * read_csv/
      * tasks/
    * win_update/
      * tasks/
      * vars/
  * staging/
    * hosts
  * ansible.cfg
  * site.yml  (master playbook)
  * test_csv.yml
  * win_update_stagin.yml
