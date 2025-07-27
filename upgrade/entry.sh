#!/usr/bin/env bash
export PROJ_ROOT=$(cd "$(dirname -- "$0")" && pwd -P)

# 解压修改权限
# $1: 压缩包路径, eg: /a/b/hello.tar.gz
function upgrade() {
    local extract pkg_path pkg_file pkg_name pkg_extract

    # 压缩包必须存在, eg: /a/b/hello.tar.gz
    pkg_path=$1
    if [ ! -f "${pkg_path}" ]; then
        echo "${pkg_path} not exist"
        exit 1
    fi

    # 解析解压后的目录名
    pkg_file=$(basename "${pkg_path}")      # hello.tar.gz
    pkg_name=${pkg_file%.tar.gz}            # hello
    if [ -z "${pkg_name}" ] || [ "${pkg_name}" = "." ] || [ "${pkg_name}" = ".." ]; then
        echo "invalid package name: $pkg_file"
        return 1
    fi

    # 解压后的目录，必须存在, eg: 当前脚本所在目录
    # 可以自定义提取目录
    extract=${PROJ_ROOT}
    if [ ! -d "${extract}" ]; then
        echo "${extract} not exist"
        return 1
    fi

    # 判断解压后的目录是否存在, 存在则删除,避免解压的时候引入脏数据， eg: /a/b/hello
    pkg_extract=${extract}/${pkg_name}
    if [ -d "${pkg_extract}" ]; then
        echo "delete ${pkg_extract}"
        rm -fr "${pkg_extract}"
    fi

    if ! tar -zxf "${pkg_path}" -C "${extract}"; then
        echo "failed to uncompress package, file: ${pkg_path}"
        return 1
    fi

    # 权限变更
    find "${pkg_extract}" -type f -name "*.tex" -exec chmod 644 {} \;
    return 0
}

function dbg() {
    local param=$1
    if [ -d "${param}" ]; then
        echo "${param} exist"
        exit 0
    fi
}

function main() {
    local funcName="$1"
    shift
    "$funcName" "$@"
}
main "$@"
