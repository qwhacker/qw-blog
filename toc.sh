#!/bin/bash
toc(){
  spaces=""
  for file in `ls $1`
  do
    dir_or_file=$1/$file
    if [ -d $dir_or_file ]
    then
        spaces="$2s"
        prefix=`echo ${spaces: 2}|sed 's/s/ /g'`
        if [[ $file != docs ]]
        then
            echo "$prefix* $file" >> _sidebar.md
        fi
        toc $dir_or_file $spaces
    else
        if [[ "$dir_or_file" =~ ^./docs* ]]
        then
            prefix=`echo $2|sed 's/s/ /g'`
            echo "$prefix  * [${file%.*}]($dir_or_file)" >> _sidebar.md
        fi     
    fi
  done  
}

echo "" > _sidebar.md
toc .;