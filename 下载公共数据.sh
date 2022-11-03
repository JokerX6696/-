#!/bin/bash
timestart=`date "+%D %H-%M-%S"`
echo "$timestart 开始下载"
for file in \
ERR775190 \
ERR775191 \
ERR775192 \
ERR925433 \
ERR925434 \
ERR925435 \
ERR925409 \
ERR925410 \
ERR925411 \
ERR925412 \
ERR925416 \
ERR925417 \
ERR925436 \
ERR925437 \
ERR925420 \
ERR925421 \
ERR925438 \
ERR925439 \
ERR925424 \
ERR925440 \
ERR925441 \
ERR925430 \
ERR925431 
do
    echo "$file 开始下载"
    
    rn=1
    counts=0
    while [ $rn -ne 0 ]
    do
        ((counts++))
        fasterq-dump --split-3 -O ./test $file
        rn=$?
            if [ $rn -ne 0 ];then
            echo "$file 下载失败!尝试重新下载！"
        else
            echo "$file 下载成功!"
        fi
        if [ $counts -gt 10 ];then
            break
        fi
    done
    
done

timeend=`date "+%D %H-%M-%S"`
echo "$timeend 结束下载"

