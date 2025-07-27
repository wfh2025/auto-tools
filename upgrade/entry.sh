#!/usr/bin/env bash
export PROJ_ROOT=$(cd "$(dirname -- "$0")" && pwd -P)
set -e
function upgrade() {
    local extract pkg_path pkg_file pkg_name pkg_extract
    pkg_path=$1                             # /a/b/hello.tar.gz
    # extract=/Users/wu.feihu/tmp
    extract=${PROJ_ROOT}                    # 压缩包解压到指定目录
    pkg_file=$(basename "${pkg_path}")      # hello.tar.gz
    pkg_name=${pkg_file%.tar.gz}            # hello
    pkg_extract=${extract}/${pkg_name}      # 最终解压目录
    rm -fr "${pkg_extract}"                 # 清空上次解压记录
    tar -zxf "${PROJ_ROOT}"/"${pkg_file}" -C "${extract}"
    find "${pkg_extract}" -type f -name "*.tex" -exec chmod 777 {} \;
}

function main() {
    local funcName="$1"
    shift
    "$funcName" "$@"
}
main "$@"
