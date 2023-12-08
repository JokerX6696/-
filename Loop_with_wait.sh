qualimap=/storge1/USER/zhengfuxing/software/qualimap_v2.3/qualimap

counts=0
ls split_Q1_ret|while read bam
do
    prefix=$(echo $bam|sed 's/.bam//g')
    echo $prefix start in `date`
    nohup $qualimap bamqc -bam result/02.mapping/picard/Q1/Q1.sorted.mkdup.bam --java-mem-size=50G -c -nt 16 -sd -outdir qualimap_Q1/$prefix/ > qualimap_Q1/$prefix.log 2>&1 &
    ((++counts))
    if [[ "$counts" -ge 6 ]];then
        wait
        counts=0
    fi
done
counts=0
ls split_Q2_ret|while read bam
do
    prefix=$(echo $bam|sed 's/.bam//g')
    echo $prefix start in `date`
    nohup $qualimap bamqc -bam result/02.mapping/picard/Q1/Q1.sorted.mkdup.bam --java-mem-size=50G -c -nt 16 -sd -outdir qualimap_Q2/$prefix/ qualimap_Q2/> $prefix.log 2>&1 &
    ((++counts))
    if [[ "$counts" -ge 6 ]];then
        wait
        counts=0
    fi
done