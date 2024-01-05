#! /bin/sh
# Use information from test driving files to regenerate test scripts
# that run only one test, and file lists to be used in Makefiles.
#
# Copyright 2013-2023 Free Software Foundation, Inc.
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Originally written by Patrice Dumas.

# This script is run from "tp/tests/Makefile.am" to regenerate
# "tp/tests/Makefile.onetst".

#set -x

test_file='list-of-tests'
test_scripts_dir='test_scripts'

test -d $test_scripts_dir || mkdir $test_scripts_dir
rm -f $test_scripts_dir/*

dir=`echo $0 | sed 's,/[^/]*$,,'`
outfile=$1
shift
destdir=$1
shift

while test z"$1" = 'z-base' -o z"$1" = 'z-tex_html' -o z"$1" = 'z-other' ; do
  if test z"$1" = 'z-base'; then
    base_test_dirs=$2
  elif test z"$1" = 'z-tex_html'; then
    tex_html_test_dirs=$2
  elif test z"$1" = 'z-other' ; then
    other_test_dirs=$2
  else
    echo "$0: Bad args" 1>&2
    exit 1
  fi
  shift
  shift
done


(
cd "$dir/../tests/$destdir" || exit 1

test_driving_files='# List of files that describe tests.  See tp/tests/README.
test_driving_files_generated_list ='
one_test_files='# List of test scripts that only run one test
one_test_files_generated_list = '

type_test_files='# Lists of test scripts by test type'

gather_tests() {
test_type=$1
shift
type_test_list_variable_name="type_${test_type}_one_test_files_generated_list"
type_test_files="$type_test_files

# list of type $test_type test files
$type_test_list_variable_name = "
one_test_files="$one_test_files \$($type_test_list_variable_name)"
test_dirs=$1
for test_dir in $test_dirs; do
  driving_file=$test_dir/list-of-tests
  if test -f $driving_file; then
    test_driving_files="$test_driving_files $driving_file"
    while read line
    do
    if echo $line | grep '^ *#' >/dev/null; then continue; fi
# there are better ways
    name=`echo $line | awk '{print $1}'`
    file=`echo $line | awk '{print $2}'`
    remaining=`echo $line | sed 's/[a-zA-Z0-9_./-]*  *[a-zA-Z0-9_./-]* *//'`
    test "z$name" = 'z' -o "$zfile" = 'z' && continue
    basename=`basename $file .texi`
    if test "z${test_dir}" = 'z.'; then
      name_prepended=${destdir}_
      relative_command_dir='/..'
    else
      name_prepended=${test_dir}_
      relative_command_dir=
    fi
    one_test_file="$test_scripts_dir/${name_prepended}$name.sh"
    type_test_files="$type_test_files \\
    $one_test_file"
    echo '#! /bin/sh
# This file generated by maintain/regenerate_cmd_tests.sh

if test z"$srcdir" = "z"; then
  srcdir=.
fi

one_test_logs_dir=test_log

' > $one_test_file

    if test $test_type = 'tex_html'; then
      echo '
if test "z$TEX_HTML_TESTS" != z"yes"; then
  echo "Skipping HTML TeX tests that are not easily reproducible"
  exit 77
fi
' >> $one_test_file
    elif test $test_type = 'other'; then
      echo '
if test "z$OTHER_TESTS" != z"yes"; then
  echo "Skipping other tests that are not easily reproducible"
  exit 77
fi
' >> $one_test_file
    fi

    echo "dir=$test_dir
name='$name'
"'mkdir -p $dir

"$srcdir"'"$relative_command_dir"'/run_parser_all.sh -dir $dir $name
exit_status=$?
cat $dir/$one_test_logs_dir/$name.log
exit $exit_status
' >> $one_test_file
    chmod 0755 $one_test_file
    done < $driving_file
  else
    echo "$0: Missing file $driving_file" 1>&2
    exit 1
  fi
done
}

basefile=`basename $outfile`
cat >$outfile <<END_HEADER
# $basefile generated by $0.
#
# Copyright Free Software Foundation, Inc.
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

END_HEADER

gather_tests base "$base_test_dirs"
gather_tests tex_html "$tex_html_test_dirs"
gather_tests other "$other_test_dirs"

echo "$test_driving_files
" >> $outfile

echo "$one_test_files
" >>$outfile

echo "$type_test_files
" >>$outfile

)
