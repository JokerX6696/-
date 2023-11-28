#!D:/Application/python/python.exe
#  阿里面试题
#  给定 两个变量 var_1 var_2 在不引入第三个变量的情况下，交换两个变量的值。

# 最高分答案

var_1 = 100
var_2 = 200

var_1 = var_1 ^ var_2 
var_2 = var_1 ^ var_2  #  var_2 =  (100 ^ 200) ^ 200 = 100 ^ (200 ^ 200) = 100
var_1 = var_1 ^ var_2  #  var_1 =  (100 ^ 200) ^ (100 ^ 200) ^ 200 = (100 ^ 100) ^ (200 ^ 200) ^ 200 =200

print('经过异或交换后 var_1 的值为 %d, var_2 的值为 %d' %(var_1,var_2))



