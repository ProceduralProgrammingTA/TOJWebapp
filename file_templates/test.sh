#!/bin/bash
studentname=$1
taskname=$2
output_limit=1000

shrink() {
  outfile=$1
  message=$2
  outsize="$(wc -c $outfile | awk \'{print $1}\')"
  head -c $output_limit $outfile
  echo
  [ $outsize -gt $output_limit ] && echo $message [$outsize bytes]
}

judge() {
  case=$1
  shift
  echo [case${case}]
  timeout 1 /$studentname/a.out "$@" < /$taskname/in$case > /$studentname/stdout$case 2> /$studentname/stderr$case
  exit_status=$?
  if [ $exit_status -eq 124 ] ; then
    echo Time Limit Exceeded
  elif [ $exit_status -ne 0 ] ; then
    echo Runtime Error
    cat /$studentname/stderr$case
  elif diff -wB /$studentname/stdout$case /$taskname/out$case > /dev/null 2>&1 ; then
    echo Accepted
  else
    echo Wrong Answer
    echo output:
    shrink /$studentname/stdout$case "++ Output is shrinked because it is too large. ++"
    echo expected:
    shrink /$taskname/out$case "++ Output is shrinked because it is too large. ++"
  fi
}

[ -f /$studentname/a.out ] && rm /$studentname/a.out
[ -f /$studentname/stdout1 ] && rm /$studentname/stdout*

timeout 10 gcc -O2 -lm -std=gnu89 -Wall -Wvla -Wdeclaration-after-statement /$studentname/submission.c -o /$studentname/a.out 2> /$studentname/compile_stderr

compile_status=$?
if [ $compile_status -ne 0 ] ; then
  echo Compile Error
  shrink /$studentname/compile_stderr "++ Error message from compiler is shrinked because it is too large. ++"
  [ $compile_status -eq 124 ] && echo ++ Compile time is too long. ++
  exit
elif [ "$(grep warning /$studentname/compile_stderr)" != "" ] ; then
  echo Compile Warning
  shrink /$studentname/compile_stderr "++ Error message from compiler is shrinked because it is too large. ++"
  exit
fi

for i in 1 2 3 4 ; do
  judge $i
done
