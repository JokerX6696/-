#!/public/store5/DNA/Test/zhengfuxing/conda/bin/python
# 10:20 开始
import re
samples = ["CB-3","F1-2","F1-3","F2-1","F2-2","F3-3","NCRC-F1-1","F1-1"]
for sample in samples:

    align = './reads_alignment/' + sample + '_liyu' + '_mapped_al.txt'

    f_al = open(align,'r')
    data = f_al.readlines()
    f_al.close

    # bam reads name && mapping rate
    ##########################################################
    readal_l = {}

    for line in data:
        name = line.split('\t')[0]
        info = line.split('\t')[1]
        maped = [int(i) for i in re.findall('(\d+)[M]',info)]
        All = [int(i) for i in re.findall('(\d+)[^D]',info)]  #  这里只去出 del 的比对，因为会造成read 增长
        rate = sum(maped) / sum(All)
        if name not in readal_l:
            readal_l[name] = rate
        else:
            if rate > readal_l[name]:
                readal_l[name] = rate
    del(data)

    ##########################################################
    align = './reads_alignment/' + sample + '_jiyu' + '_mapped_al.txt'

    f_al = open(align,'r')
    data = f_al.readlines()
    f_al.close
    readal_j = {}

    for line in data:
        name = line.split('\t')[0]
        info = line.split('\t')[1]
        maped = [int(i) for i in re.findall('(\d+)[M]',info)]
        All = [int(i) for i in re.findall('(\d+)[^D]',info)]
        rate = sum(maped) / sum(All)
        if name not in readal_j:
            readal_j[name] = rate
        else:
            if rate > readal_j[name]:
                readal_j[name] = rate
    del(data)

    ##########################################################
    align = './reads_alignment/' + sample + '_tuantoufang' + '_mapped_al.txt'

    f_al = open(align,'r')
    data = f_al.readlines()
    f_al.close
    readal_t = {}

    for line in data:
        name = line.split('\t')[0]
        info = line.split('\t')[1]
        maped = [int(i) for i in re.findall('(\d+)[M]',info)]
        All = [int(i) for i in re.findall('(\d+)[^D]',info)]
        rate = sum(maped) / sum(All)
        if name not in readal_t:
            readal_t[name] = rate
        else:
            if rate > readal_t[name]:
                readal_t[name] = rate
    del(data)

    ##########################################################

    with open(sample + '_common_readsname.xls', 'r') as f:
        cm = [line.replace('\n','') for line in f.readlines()]

    with open(sample + '_common_readsname_result.xls', 'w') as f:
        print('reads_name','jiyu','liyu','tuantoufang',sep='\t',file=f)
        for read in cm:
            print(read,end='\t',file=f)
            if read in readal_j:
                print("%.2f" %readal_j[read],end='\t',file=f)
            else:
                print('NA',end='\t',file=f)
            if read in readal_l:
                print("%.2f" %readal_l[read],end='\t',file=f)
            else:
                print('NA',end='\t',file=f)
            if read in readal_t:
                print("%.2f" %readal_t[read],file=f)
            else:
                print('NA',file=f)
    del(cm)
    #######################################################

    with open(sample + '_j_l_readsname.xls', 'r') as f:
        JL = [line.replace('\n','') for line in f.readlines()]

    with open(sample + '_j_l_readsname_result.xls', 'w') as f:
        print('reads_name','jiyu','liyu',sep='\t',file=f)
        for read in JL:
            print(read,end='\t',file=f)
            if read in readal_j:
                print("%.2f" %readal_j[read],end='\t',file=f)
            else:
                print('NA',end='\t',file=f)
            if read in readal_l:
                print("%.2f" %readal_l[read],file=f)
            else:
                print('NA',file=f)


    del(JL)
    #######################################################
    with open(sample + '_j_t_readsname.xls', 'r') as f:
        JT = [line.replace('\n','') for line in f.readlines()]

    with open(sample + '_j_t_readsname_result.xls', 'w') as f:
        print('reads_name','jiyu','tuantoufang',sep='\t',file=f)
        for read in JT:
            print(read,end='\t',file=f)
            if read in readal_j:
                print("%.2f" %readal_j[read],end='\t',file=f)
            else:
                print('NA',end='\t',file=f)
            if read in readal_t:
                print("%.2f" %readal_t[read],file=f)
            else:
                print('NA',file=f)


    del(JT)
    #######################################################
    with open(sample + '_l_t_readsname.xls', 'r') as f:
        LT = [line.replace('\n','') for line in f.readlines()]
    with open(sample + '_l_t_readsname_result.xls', 'w') as f:
        print('reads_name','liyu','tuantoufang',sep='\t',file=f)
        for read in LT:
            print(read,end='\t',file=f)
            if read in readal_j:
                print("%.2f" %readal_l[read],end='\t',file=f)
            else:
                print('NA',end='\t',file=f)
            if read in readal_t:
                print("%.2f" %readal_t[read],file=f)
            else:
                print('NA',file=f)


