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
    * dotNet35/ (ダウンロードしたファイルから dotNetFramework3.5 をインストールする)
      * files/
      * tasks/
      * vars/
    * ping/
      * tasks/
    * read_csv/     （CSV ファイルを読み込んで、変数を書き換えるテスト）
      * tasks/
    * win_update/   （Windows Update を自動化）
      * tasks/
      * vars/
  * ansible.cfg
  * test_csv.yml （CSVファイルのテスト）
  * win_2016_deploy.yml （VHDXファイル作成）
  * win_common.yml  (基本設定)
  * win_confirm_reachable.yml（疎通確認）
  * win_update.yml （Windows Update）
