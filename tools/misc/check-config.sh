#!/bin/sh
if [ "$ORACC_BUILDS" == "" ]; then
    echo $0: ORACC_BUILDS is not set. Stop.
    exit 1
fi
echo $0: todo-list=$cfg_todo
if [[ "$cfg_todo" == *"ucp"* ]]; then
    echo $0: ucp requested, checking nsprefix
    if [ "$cfg_nsprefix" == "" ]; then
	echo $0: nsprefix is not set. Stop.
	exit 1
    fi    
fi
if [[ "$cfg_todo" == *"rep"* ]]; then
    echo $0: rep requested, checking project and corpus
    if [ "$cfg_project" == "" ]; then
	echo $0: project is not set. Stop.
	exit 1
    fi
    project=${ORACC_BUILDS}/$cfg_project
    if [ "$cfg_corpus" == "" ]; then
	echo $0: corpus is not set. Stop.
	exit 1
    fi
    if [ ! -d $project ]; then
	echo $0: project $project does not exist. Stop.
	exit 1
    fi
    reptab=$project/00etc/$cfg_corpus-rep.tab
    if [ ! -r $reptab ]; then
	echo $0: reptab $reptab does not exist. Stop.
	exit 1
    fi
    echo $0: using reptab $reptab
fi
