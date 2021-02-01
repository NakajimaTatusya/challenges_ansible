#!/bin/bash

# -e エラーが発生したら（exit status が 0以外だったら）スクリプトの実行を終了する
# -o pipefail: パイプラインの途中でエラーが発生してもスクリプトの実行を終了する
set -e -o pipefail

# CONST
readonly WORK_DIR=tmp
readonly SFTP_PATH="~/challenges_ansible/csv_files"

# 引数チェック
if [ $# -ne 0 ]; then
  echo "引数は指定しない"
  exit 1
fi

# ディレクト周りの初期化処理
# 直接コマンドラインやcronなどさまざまな環境から実行しても問題にならないようにする
## 実行スクリプトとパスの保管
readonly PID=$$
cd `dirname ${BASH_SOURCE[0]}`
readonly ABS_BASE_PATH=`pwd`
readonly SCRIPT=${BASH_SOURCE[0]##*/}
## 作業用ディレクトリを作る
mkdir -p ${WORK_DIR}
cd ${WORK_DIR}


function color_echo() {
  local color_name color
  readonly color_name="$1"
  shift
  case $color_name in
    red) color=31 ;;
    green) color=32 ;;
    yellow) color=33 ;;
    blue) color=34 ;;
    cyan) color=36 ;;
    *) raise "An undefined color was specified." ;;
  esac
  printf "\033[${color}m%b\033[m\n" "$*"
}


# 任意のエラーを生成する関数。コマンドがエラーを出さない場合でもエラー扱いにするためのもの
# 引数はエラーメッセージ
function raise() {
  echo $1 1>&2
  return 1
}


# エラー時の処理。いわゆるcatch。エラーの原因個所を特定できるようにするための引数を受け取る
# 引数は行番号と関数（コマンド）名
err_buf=""
function err() {
  # Usage: trap 'err ${LINENO[0]} ${FUNCNAME[1]}' ERR
  status=$?
  lineno=$1
  func_name=${2:-main}
  err_str="ERROR: [`date +'%Y-%m-%d %H:%M:%S'`] ${SCRIPT}:${func_name}() returned non-zero exit status ${status} at line ${lineno}"
  color_echo red ${err_str} 
  err_buf+=${err_str}
}


# エラーの有無にかかわらず、最後に実行する関数
function finally() {
  echo ${err_buf} >> ${SCRIPT}.log
  color_echo green "`date +'%Y-%m-%d %H:%M:%S'` Finished."
}


# メイン処理記述
function main() {
  color_echo green "`date +'%Y-%m-%d %H:%M:%S'` started."
  # エラー時の挙動を指定。エラーの発生個所（行番号と関数名）を引数としてエラー処理関数に送る。
  trap 'err ${LINENO[0]} ${FUNCNAME[1]}' ERR
  # エラーの有無にかかわらず最後に実行する（最後に実行する処理がない場合は不要）
  trap finally EXIT

  color_echo blue `pwd`

  ls -altr 2>&1

  # パスの存在確認
  if [ ! -e ${SCRIPT}.log ]; then
    color_echo blue "path is not exists"
  fi
  # ファイルが存在する？
  if [ ! -f ${SCRIPT}.log ]; then
    color_echo blue "file isn't exists"
  fi
  # ディレクトリが存在するか？
  if [ ! -d ${WORK_DIR} ]; then
    color_echo red "directory not found."
  fi
  # シンボリックリンクが存在するか
  if [ ! -L ./loglink ]; then
    color_echo red "link not found."
  fi
  # 空ファイルではないか
  if [ ! -s ${SCRIPT}.log ]; then
    color_echo red "file is empty."
  fi
  # ファイルが書込可能か
  if [ ! -w ${SCRIPT}.log ]; then
    color_echo red "file is readonly."
  fi
  # ファイルが実行可能か
  if [ ! -x ${SCRIPT}.log ]; then
    color_echo red "file not excutable."
  fi
}

# グローバルスコープにコードをべた書きしない
main
