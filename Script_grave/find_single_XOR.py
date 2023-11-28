#!D:/Application/python/python.exe
import random
import copy
from time import time

# 生成随机位点 
pos_num = 5000000
sample1_chr1_pos = random.sample(range(1, 100000001), pos_num)
sample2_chr1_pos = copy.deepcopy(sample1_chr1_pos)
# 随机在 sample2_chr1_pos 中删除一个位点
del_pos_idx = random.sample(range(1, pos_num+1), 1)[0]
print("删除位点为:",sample2_chr1_pos[del_pos_idx])
del sample2_chr1_pos[del_pos_idx]
# 将顺序打乱
random.shuffle(sample1_chr1_pos)
random.shuffle(sample2_chr1_pos)


def find_single(sample1,sample2):
    all = sample1 + sample2
    ret = 0
    for i in all:
        ret = i ^ ret

    return ret

start_time = time()
ret = find_single(sample1_chr1_pos,sample2_chr1_pos)
print("检测位点为:",ret)
end_time = time()

t = end_time - start_time

print('本次检测用时为',t,'秒')