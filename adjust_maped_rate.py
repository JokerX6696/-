#!/public/store5/DNA/Test/zhengfuxing/conda/bin/python
# 三种鱼项目， 目前硬盘已损坏 数据丢失
import os, re
#### 参数
Threshold = 0.8

###
samples = ['CB-3',
        'F1-1',
        'F1-2',
        'F1-3',
        'F2-1',
        'F2-2',
        'F3-3',
        'NCRC-F1-1'
]
file_dir = '/public/store5/DNA/Project/Reseq/2022/DOE202213215-b1/PA/30_percent/stat/PA20230308/DOE202213215-王石-数据高级分析售后-20230301/'
for sample in samples:
    outfile = open(sample + '_stat.xls','w')
    # 统计上一次结果 用于后续修正
    with open('/public/store5/DNA/Project/Reseq/2022/DOE202213215-b1/PA/30_percent/stat/reads_name/' + sample + '_stat.txt', 'r')as f:
        common = int(f.readline().split(' ')[-1])
        j = int(f.readline().split(' ')[-1])
        l = int(f.readline().split(' ')[-1])
        t = int(f.readline().split(' ')[-1])
        l_j = int(f.readline().split(' ')[-1])
        j_t = int(f.readline().split(' ')[-1])
        l_t = int(f.readline().split(' ')[-1])

    # 处理共有
    with open(file_dir + sample + '_common_readsname_result.xls')as f:
        lines = [i.replace('\n', '') for i in f.readlines()]

    for line in lines:
        if 'reads_name' in line:
            continue
        elif 'NA' in line:
            common -= 1
            continue
        jiyu, liyu, tuantoufang = line.split('\t')[1:4]
        if float(jiyu) < Threshold and float(liyu) < Threshold and float(tuantoufang) < Threshold:
            # 如果三个物种均低于阈值，则 共有 -1
            common -= 1
        elif float(jiyu) >= Threshold and float(liyu) >= Threshold and float(tuantoufang) >= Threshold:
            continue
        else:
            if float(jiyu) < Threshold and float(liyu) < Threshold:
                common -= 1
                t += 1
            elif float(jiyu) >= Threshold and float(liyu) >= Threshold:
                common -= 1
                l_j += 1
            elif float(jiyu) < Threshold and float(tuantoufang) < Threshold:
                common -= 1
                l += 1
            elif float(jiyu) >= Threshold and float(tuantoufang) >= Threshold:
                common -= 1
                j_t += 1
            elif float(liyu) < Threshold and float(tuantoufang) < Threshold:
                common -= 1
                j += 1
            elif float(liyu) >= Threshold and float(tuantoufang) >= Threshold:
                common -= 1
                l_t += 1
            else:
                print('error;出现了其他情况!')
                print(line)
                exit(812)



    # 鲫鱼 & 鲤鱼
    with open(file_dir + sample + '_j_l_readsname_result.xls')as f:
        lines = [i.replace('\n', '') for i in f.readlines()]

    for line in lines:
        if 'reads_name' in line:
            continue
        elif 'NA' in line:
            l_j -= 1
            continue
        jiyu, liyu = line.split('\t')[1:3]
        if float(jiyu) < Threshold and float(liyu) < Threshold:
            # 如果2个物种均低于阈值，则 共有 -1
            l_j -= 1
        elif float(jiyu) >= Threshold and float(liyu) >= Threshold:
            continue
        else:
            if float(jiyu) < Threshold:
                l_j -= 1
                l += 1
            elif float(liyu) < Threshold:
                l_j -= 1
                j += 1
            else:
                print('error;出现了其他情况!')
                print(line)
                exit(812)




    # 鲫鱼 & 团头鲂
    with open(file_dir + sample + '_j_t_readsname_result.xls')as f:
        lines = [i.replace('\n', '') for i in f.readlines()]

    for line in lines:
        if 'reads_name' in line:
            continue
        elif 'NA' in line:
            j_t -= 1
            continue
        jiyu, tuantoufang = line.split('\t')[1:3]
        if float(jiyu) < Threshold and float(tuantoufang) < Threshold:
            # 如果2个物种均低于阈值，则 共有 -1
            j_t -= 1
        elif float(jiyu) >= Threshold and float(tuantoufang) >= Threshold:
            continue
        else:
            if float(jiyu) < Threshold:
                j_t -= 1
                t += 1
            elif float(tuantoufang) < Threshold:
                j_t -= 1
                j += 1
            else:
                print('error;出现了其他情况!')
                print(line)
                exit(812)
    # 鲤鱼 & 团头鲂
    with open(file_dir + sample + '_j_t_readsname_result.xls')as f:
        lines = [i.replace('\n', '') for i in f.readlines()]

    for line in lines:
        if 'reads_name' in line:
            continue
        elif 'NA' in line:
            l_t -= 1
            continue
        liyu, tuantoufang = line.split('\t')[1:3]
        if float(liyu) < Threshold and float(tuantoufang) < Threshold:
            # 如果2个物种均低于阈值，则 共有 -1
            l_t -= 1
        elif float(liyu) >= Threshold and float(tuantoufang) >= Threshold:
            continue
        else:
            if float(liyu) < Threshold:
                l_t -= 1
                t += 1
            elif float(tuantoufang) < Threshold:
                l_t -= 1
                l += 1
            else:
                print('error;出现了其他情况!')
                print(line)
                exit(812)

    print('3 样本共有',common,sep='\t',file=outfile)
    print('鲫鱼特有',j,sep='\t',file=outfile)
    print('鲤鱼特有',l,sep='\t',file=outfile)
    print('团头鲂特有',t,sep='\t',file=outfile)
    print('鲤鱼 & 鲫鱼',l_j,sep='\t',file=outfile)
    print('鲫鱼 & 团头鲂',j_t,sep='\t',file=outfile)
    print('鲤鱼 & 团头鲂',l_t,sep='\t',file=outfile)

    outfile.close
