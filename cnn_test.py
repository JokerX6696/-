import torch
import torch.nn as nn
import torchvision.transforms as transforms
from torchvision import models
from PIL import Image
torch.manual_seed(0)
# 定义新模型类，该类应与您训练时的结构匹配
class CustomResNet152(nn.Module):
    def __init__(self, num_classes):
        super(CustomResNet152, self).__init__()
        # 加载预训练的 ResNet-152 模型
        self.resnet152 = models.resnet152(pretrained=False)  # pretrained=False 表示不使用预训练权重

        # 修改模型的顶层，替换全连接层
        num_features = self.resnet152.fc.in_features
        self.resnet152.fc = nn.Linear(num_features, num_classes)

    def forward(self, x):
        # 执行前向传播
        x = self.resnet152(x)
        return x

# 创建新模型实例
num_classes = 102  # 请根据您的任务设置类别数目
custom_model = CustomResNet152(num_classes)

# 加载训练好的权重文件
custom_model.load_state_dict(torch.load('D:/desk/cnn/cnn/zfx_train2.pth'),strict=TRUU)
#######################

#######################
# 设置模型为评估模式
custom_model.eval()

# 定义图像预处理变换，与训练时一致
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

# 加载并预处理输入图像
image_path = 'D:/desk/cnn/cnn/train/flower_data/train/64/image_06137.jpg'
input_image = Image.open(image_path)
input_tensor = preprocess(input_image).unsqueeze(0)  # 添加批次维度

# 使用模型进行前向传播
with torch.no_grad():
    output = custom_model(input_tensor)

# 解码模型输出，例如，获取预测类别
_, predicted_class = torch.max(output, 1)

print(f"Predicted Class: {predicted_class.item()}")