# DNTextInputView
在需要输入评论的时候，弹出一个输入框进行输入评论

![snapshot](https://github.com/626600815/DNTextInputView/blob/master/DNTextInputView/DNTextInputView/Simulator%20Screen%20Shot%202016%E5%B9%B45%E6%9C%886%E6%97%A5%20%E4%B8%8A%E5%8D%8811.07.39.png)

###使用说明

在需要弹出对话框的controller中加入代码

     [[DNTextInputView shareInstance] showToVC:self WithTitle:@"你是谁" inputBlock:^(NSString *text) {
            NSLog(@"发送的内容：%@",text);
     }];

