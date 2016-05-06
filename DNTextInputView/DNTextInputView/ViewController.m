//
//  ViewController.m
//  DNTextInputView
//
//  Created by mainone on 16/5/5.
//  Copyright © 2016年 wjn. All rights reserved.
//

#import "ViewController.h"
#import "DNTextInputView.h"

@interface ViewController () <UITextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnClick:(UIButton *)sender {
    [[DNTextInputView shareInstance] showToVC:self WithTitle:@"你是谁" inputBlock:^(NSString *text) {
        NSLog(@"发送的内容：%@",text);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
