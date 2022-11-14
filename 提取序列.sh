# wkdir=/public/store5/DNA/Project/Reseq/2022/DOE20226436/售后/20221111
# 售后需求：基于XMSH_202210_0775售后筛选的snp和indel位点，提供所有位点前后各150bp的序列

# 解压文件
unzip rawdata/DOE20226436-张红梅-重测序项目售后20221013.zip -d ./
# # 删除文件中的 ^M
dos2unix $(ls DOE20226436-张红梅-重测序项目售后20221013/*/*/*xls) 
# # 将fa文件传至本地
scp zhengfuxing@192.168.50.10:/data/database/reference/DNA/3673/Momordica_charantia/CuGenDB/Dali-11_v1.0/genome.fa.fai ./
scp zhengfuxing@192.168.50.10:/data/database/reference/DNA/3673/Momordica_charantia/CuGenDB/Dali-11_v1.0/genome.fa ./
# 生成上下游的 bed 文件
for file in $(ls DOE20226436-张红梅-重测序项目售后20221013/*/*/*xls)
do    
	wkdir=${file%/*}
	prefix=$(echo ${file##*/}|cut -d"." -f1)
    # 这里发现  有bed 会超出 scaffold91 长度 ;还有些位点会变成负数 因此在这里进行处理
    # 另外 经过对 bedtools 测试 bedtools 在根据 bed 格式文件提取时 采取取后不取前的策略 例如 提取 >MC01:7370100-7370101 结果为 提取了一个碱基 对应了 7370101 位置上的碱基 而7370100 则不会提取
    sed '1d' $file | awk '{OFS=FS="\t";a=$2-151;if(a < 0){a=0};b=$2+150;if($1 == "scaffold91" && b > 308331){b=308331};print $1,a,$2-1}' > ${wkdir}/${prefix}_up.bed
    sed '1d' $file | awk '{OFS=FS="\t";a=$2-151;if(a < 0){a=0};b=$2+150;if($1 == "scaffold91" && b > 308331){b=308331};print $1,$2,b}' > ${wkdir}/${prefix}_down.bed
    paste -d "\t" <(cat $file) <(bedtools getfasta -fi genome.fa -bed ${wkdir}/${prefix}_up.bed |awk '{if(NR % 2 == 0){print $0}else{printf $0"\t"}}'|sed '1i Region_up\tSequence') <(bedtools getfasta -fi genome.fa -bed ${wkdir}/${prefix}_down.bed |awk '{if(NR % 2 == 0){print $0}else{printf $0"\t"}}'|sed '1i Region_down\tSequence') > ${wkdir}/${prefix}_add_300bp.xls
    # 该步骤对应上一步 bedtools 并不会提取bed 中的第一个碱基 为防止老师询问，因此将 100-110 改为 101-110！
    awk '{
  FS="[:-]";
  if(NR != 1){
    A=$2+1;
    B=$4+1;
    print $1":"A"-"$3":"B"-"$5
  }else{
    print $0
  }
  }' ${wkdir}/${prefix}_add_300bp.xls > tmp.xls
  mv tmp.xls ${wkdir}/${prefix}_add_300bp.xls
done


### 检查  paste  后 行数是否相等
for file in $(ls DOE20226436-张红梅-重测序项目售后20221013/*/*/*.xls|grep -v add)
do
    wkdir=${file%/*}
    prefix=$(echo ${file##*/}|cut -d"." -f1)
    line1=`wc -l ${wkdir}/${prefix}_down.bed|awk '{print$1}'`
    line2=`wc -l $file|awk '{print$1}'`
    ret=$((line2 - line1))
        if [[ ret -ne 1 ]];then
            echo "存在错误 错误文件为 $file "
            exit
        fi
    echo "$file 文件行数匹配"
done

rm DOE20226436-张红梅-重测序项目售后20221013/*/*/*bed
