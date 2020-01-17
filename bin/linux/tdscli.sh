#!/bin/bash

DEBUG=
DEBUG_LOG=
if [[ "$DEBUG" -eq "1" ]]; then
	DEBUG_LOG="--log-file=cli-debug.log"
fi

LS_DIR=.
LS_EXE=advpls
LS=$LS_DIR/$LS_EXE

while (( "$#" )); do        # While there are arguments still to be shifted...
  #echo "[$1]"
  if [[ $1 = *=* ]]; then
    IFS='='; arr=($1); unset IFS
    if [ "${#arr[@]}" -eq 1 ]; then
      argOut="${arr[0]}="
    elif [ "${#arr[@]}" -eq 2 ]; then
      if [[ ${arr[1]} = *" "* ]]; then
        argOut="${arr[0]}=\"${arr[1]}\""
      else
        argOut="${arr[0]}=${arr[1]}"
      fi
    fi
    argsOut+=" $argOut"
  else
    argsOut+=" $1"
  fi
  shift
done

exec $LS $DEBUG_LOG --tdsCliArguments="${argsOut:1}"

STATUS=$?
if [[ "$DEBUG" -eq "1" ]] && [ $STATUS -ne 0 ]; then
  echo "TDS CLi errorcode $STATUS"
fi

exit $STATUS

