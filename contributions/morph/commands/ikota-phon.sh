#! /bin/bash

STYLESHEET=ikota.xsl

function process_entry() {
    local phon=$(echo "#+$1+#" \
	| sed 's/+ò+a+/+ò+/g' \
	| sed 's/+ò+e+/+ò+/g' \
	| sed 's/+ò+o+/+ò+/g' \
	| sed 's/+ò+á+/+ò+/g' \
	| sed 's/+ò+à+/+ò+/g' \
	| sed 's/+ò+ɛ́+/+ò+/g' \
	| sed 's/+ò+ɛ̀+/+ò+/g' \
	| sed 's/+ò+é+/+ò+/g' \
	| sed 's/+ò+è+/+ò+/g' \
	| sed 's/+//g' \
	| sed 's/#//g')
    echo "$phon $*"
}

function cleanup_entry() {
    sed 's/ none//g' \
	| sed 's/+active/active/g' \
	| sed 's/-active/passive/g' \
	| sed 's/-prog/inacc/g' \
	| sed 's/ +prog//g' \
	| sed 's/+neg/neg/g' \
	| sed 's/-neg/pos/g'
}

function process_entries() {
    while read x; do
	process_entry $x | cleanup_entry
    done
}

function help() {
    echo "usage: $(basename $0) GRAMMAR.XML"
}

if test "$#" -ne 1; then
    help
    exit 1
fi

if test "$1" = "-h" || test "$1" = "--help"; then
    help
    exit 0
fi

xsltproc $STYLESHEET "$1" | process_entries
