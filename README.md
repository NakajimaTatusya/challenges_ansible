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
    * common/       （Windows Server 向け基本設定）
      * files/
      * tasks/
      * vars/
    * deploy/       （ISOイメージからVHDXファイルを作成して、Hyper-V にデプロイする）
      * files/
      * library/    （PowerShell Scripts ちゃんとしたモジュールにはなっていません）
      * tasks/
      * templates/
      * vars/
    * read_csv/     （CSV ファイルを読み込んで、変数を書き換えるテスト）
      * tasks/
    * win_update/   （Windows Update を自動化）
      * tasks/
      * vars/
  * staging/
    * hosts
  * ansible.cfg
  * site.yml  (基本設定実行)
  * test_csv.yml （CSVファイルのテスト）
  * win_update_stagin.yml （Windows Update を実行）
  * win_2016_deploy.yml （Hyper-Vに構築）
