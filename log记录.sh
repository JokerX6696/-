#!/bin/bash
set -e
# workdir : /public/store5/DNA/Project/Capture/2022/DOE20227411-aa/after-sales/20221012
# https://oa.oebiotech.com/spa/workflow/static4form/index.html?_rdm=1665541840923#/main/workflow/req?em_auth_userid=1204&resourcetype=0&resourceid=362445&requestid=362445&em_client_lang=zh&em_auth_code=49a80608-4513-46f1-88f1-9010ad9ff845&isFormMsg=1&em_client_type=pc&outsysid=d56dc6db9f2e40b5b9be5480fbc7a49e&_key=a76qae
ln -s /public/store5/DNA/Project/Capture/2022/DOE20227411-aa/DOE20227411-顾湘-肿瘤基因组项目结题报告/3.Variants/anno_stat/snp.annotation.xls ./DOE20227411.snp.annotation.xls
ln -s /public/store5/DNA/Project/Capture/2022/DOE20227411-aa/DOE20227411-顾湘-肿瘤基因组项目结题报告/3.Variants/anno_stat/indel.annotation.xls ./DOE20227411.indel.annotation.xls


unzip /public/store5/DNA/Project/Reseq/2022/DOE20224983/DOE20224983-aa/reseq_v3/DOE20224983-顾湘-重测序项目结题报告.zip -d ./ &

unzip /public/store5/DNA/Project/Capture/2022/DOE2022395/reseq_v3/DOE2022395_顾湘老师捕获测序结题报告.zip -d ./ &
wait
mv Report/3.Variants/anno_stat/indel.annotation.xls ./DOE2022395.indel.annotation.xls
mv Report/3.Variants/anno_stat/snp.annotation.xls ./DOE2022395.snp.annotation.xls

rm -r Report


mv DOE20224983-顾湘-重测序项目结题报告/3.Variants/anno_stat/indel.annotation.xls ./DOE20224983_indel.annotation.xls
mv DOE20224983-顾湘-重测序项目结题报告/3.Variants/anno_stat/snp.annotation.xls ./DOE20224983_snp.annotation.xls
rm -r 'DOE20224983-顾湘-重测序项目结题报告'




# 条目 1 
mkdir DOE20227411_DOE2022395_snp DOE20227411_DOE2022395_indel

cd DOE20227411_DOE2022395_snp
awk '{FS=OFS="\t";if(NR==FNR){A[$1,$2,$3,$4]}else if(($1,$2,$3,$4) in A){print $0}}' ../DOE20227411.snp.annotation.xls ../DOE2022395.snp.annotation.xls > DOE2022395_snp.txt &
awk '{FS=OFS="\t";if(NR==FNR){A[$1,$2,$3,$4]}else if(($1,$2,$3,$4) in A){print $0}}' ../DOE2022395.snp.annotation.xls ../DOE20227411.snp.annotation.xls > DOE20227411_snp.txt &
wait
paste -d "\t" <(cut -f 6 DOE20227411_snp.txt) DOE2022395_snp.txt|awk '{FS=OFS="\t";$6=$1;$1="";print $0}'|sed 's/^\t//g' > DOE20227411_DOE2022395_all_snp.xls


rm  *txt
cd ..

cd DOE20227411_DOE2022395_indel
awk '{FS=OFS="\t";if(NR==FNR){A[$1,$2,$3,$4]}else if(($1,$2,$3,$4) in A){print $0}}' ../DOE20227411.indel.annotation.xls ../DOE2022395.indel.annotation.xls > DOE2022395_indel.txt &
awk '{FS=OFS="\t";if(NR==FNR){A[$1,$2,$3,$4]}else if(($1,$2,$3,$4) in A){print $0}}' ../DOE2022395.indel.annotation.xls ../DOE20227411.indel.annotation.xls > DOE20227411_indel.txt &
wait
paste -d "\t" <(cut -f 6 DOE20227411_indel.txt) DOE2022395_indel.txt|awk '{FS=OFS="\t";$6=$1;$1="";print $0}'|sed 's/^\t//g' > DOE20227411_DOE2022395_all_indel.xls

for i in `sed 1d DOE20227411_DOE2022395_all_indel.xls|cut -f1|uniq`
do
	head -1 DOE20227411_DOE2022395_all_indel.xls > DOE20227411_DOE2022395_chr${i}_indel.xls
	awk -v chr=$i '{if($1 == chr)print$0}' DOE20227411_DOE2022395_all_indel.xls >> DOE20227411_DOE2022395_chr${i}_indel.xls
done
rm  *txt
cd ..



# 条目 2 

mkdir DOE20227411_DOE20224983_snp DOE20227411_DOE20224983_indel

cd DOE20227411_DOE20224983_snp
awk '{FS=OFS="\t";if(NR==FNR){A[$1,$2,$3,$4]}else if(($1,$2,$3,$4) in A){print $0}}' ../DOE20227411.snp.annotation.xls ../DOE20224983_snp.annotation.xls > DOE20224983_snp.txt &
awk '{FS=OFS="\t";if(NR==FNR){A[$1,$2,$3,$4]}else if(($1,$2,$3,$4) in A){print $0}}' ../DOE20224983_snp.annotation.xls ../DOE20227411.snp.annotation.xls > DOE20227411_snp.txt &
wait
paste -d "\t" <(cut -f 6 DOE20227411_snp.txt) DOE20224983_snp.txt|awk '{FS=OFS="\t";$6=$1;$1="";print $0}'|sed 's/^\t//g' > DOE20227411_DOE20224983_all_snp.xls

for i in `sed 1d DOE20227411_DOE20224983_all_snp.xls|cut -f1|uniq`
do
	head -1 DOE20227411_DOE20224983_all_snp.xls > DOE20227411_DOE20224983_chr${i}_snp.xls
	awk -v chr=$i '{if($1 == chr)print$0}' DOE20227411_DOE20224983_all_snp.xls >> DOE20227411_DOE20224983_chr${i}_snp.xls
done
rm  *txt
cd ..


cd DOE20227411_DOE20224983_indel
awk '{FS=OFS="\t";if(NR==FNR){A[$1,$2,$3,$4]}else if(($1,$2,$3,$4) in A){print $0}}' ../DOE20227411.indel.annotation.xls ../DOE20224983_indel.annotation.xls > DOE20224983_indel.txt &
awk '{FS=OFS="\t";if(NR==FNR){A[$1,$2,$3,$4]}else if(($1,$2,$3,$4) in A){print $0}}' ../DOE20224983_indel.annotation.xls ../DOE20227411.indel.annotation.xls > DOE20227411_indel.txt &
wait
paste -d "\t" <(cut -f 6 DOE20227411_indel.txt) DOE20224983_indel.txt|awk '{FS=OFS="\t";$6=$1;$1="";print $0}'|sed 's/^\t//g' > DOE20227411_DOE20224983_all_indel.xls

for i in `sed 1d DOE20227411_DOE20224983_all_indel.xls|cut -f1|uniq`
do
	head -1 DOE20227411_DOE20224983_all_indel.xls > DOE20227411_DOE20224983_chr${i}_indel.xls
	awk -v chr=$i '{if($1 == chr)print$0}' DOE20227411_DOE20224983_all_indel.xls >> DOE20227411_DOE20224983_chr${i}_indel.xls
done
rm *txt
cd ..

mkdir results
mv DOE20227411_DOE20224983_snp DOE20227411_DOE20224983_indel DOE20227411_DOE2022395_snp DOE20227411_DOE2022395_indel results

