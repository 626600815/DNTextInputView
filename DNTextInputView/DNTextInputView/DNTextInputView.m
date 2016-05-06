//
//  DNTextInputView.m
//  DNTextInputView
//
//  Created by mainone on 16/5/5.
//  Copyright © 2016年 wjn. All rights reserved.
//

#import "DNTextInputView.h"
#import "UIView+DN.h"
//背景色
#define BGCOLOR [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:0.91]
//输入框宽
#define IPWIDTH  [UIScreen mainScreen].bounds.size.width
#define IPHeight_Screen [UIScreen mainScreen].bounds.size.height
#define IPHeight 135.0f


@interface DNTextInputView () <UITextViewDelegate>

@property (nonatomic, strong) UIViewController *tempVC;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) textInputBlock textBlock;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *selectButton;


@end

@implementation DNTextInputView

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

+ (DNTextInputView *)shareInstance {
    static DNTextInputView *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[DNTextInputView alloc] init];
    });
    return shareInstance;
}

- (void)showToVC:(UIViewController *)vc WithTitle:(NSString *)title inputBlock:(textInputBlock)block {
    self.tempVC = vc;
    self.textBlock = [block copy];
    [self initTextInputWithTitle:title];
}

- (void)initTextInputWithTitle:(NSString *)title {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
    
    self.frame = CGRectMake(0, IPHeight_Screen, IPWIDTH, IPHeight);
    self.backgroundColor = BGCOLOR;
    
    //添加控件到view上
    [self.tempVC.view addSubview:self.backView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.textView];
    [self addSubview:self.cancelButton];
    [self addSubview:self.selectButton];
    
    if (title.length > 0) {
        self.titleLabel.text = title;
    }
    
    [self showToWindow];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [self changeSelectState];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length > 0) {
            [self selected];
        }
         return NO;
    }
    return YES;
}

#pragma mark - Method
//键盘弹出
-(void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue]; // 这里得到了键盘的frame
    
    self.y  = keyboardRect.origin.y - IPHeight;
}
//键盘消失
-(void)keyboardWillBeHidden:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue]; // 这里得到了键盘的frame
    
    self.y  = keyboardRect.origin.y;
}
//取消输入
- (void)clean {
    [self dismissInput];
}
//发送文字
- (void)selected {
    if (self.textBlock) {
        self.textBlock(self.textView.text);
        self.textBlock = nil;
    }
    [self dismissInput];
}
//消失评论框
- (void)dismissInput {
    self.textView.text = @"";
    [self.textView resignFirstResponder];
    [self changeSelectState];
    [UIView animateWithDuration:.3 animations:^{
        self.backView.alpha = 0;
        [self removeFromSuperview];
    }];
}
//显示评论框
- (void)showToWindow {
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    [self.textView becomeFirstResponder];
    [UIView animateWithDuration:.3 animations:^{
        self.backView.alpha = .5;
    }];
}
//改变发送按钮状态
- (void)changeSelectState {
    if (![self.textView.text isEqual:@""]) {
        self.selectButton.userInteractionEnabled = YES;
        self.selectButton.alpha                  = 1;
    }else{
        self.selectButton.userInteractionEnabled = NO;
        self.selectButton.alpha                  = 0.3;
    }
}

#pragma mark - 初始化
- (UITextView *)textView {
    if (!_textView) {
        _textView                              = [[UITextView alloc]initWithFrame:CGRectMake(15, 40, self.frame.size.width-30, 90)];
        _textView.layer.borderColor            = [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:.3] CGColor];
        _textView.layer.borderWidth            = 1;
        _textView.backgroundColor              = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        _textView.delegate                     = self;
        _textView.font                         = [UIFont systemFontOfSize:15];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.returnKeyType                = UIReturnKeySend;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.backgroundColor              = [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:0.9];
    }
    return _textView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel                 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        _titleLabel.textAlignment   = NSTextAlignmentCenter;
        self.titleLabel.text        = @"说点什么";
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton        = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame  = CGRectMake(0, 0, 40, 40);
        _cancelButton.center = CGPointMake(20, 20);
        [_cancelButton setImage:[UIImage imageNamed:@"DNTextInput.bundle/textIpnut_clean_back"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clean) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton        = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame  = CGRectMake(0, 0, 40, 40);
        _selectButton.center = CGPointMake(self.frame.size.width - 20, 20);
        _selectButton.alpha  = 0.3;
        _selectButton.userInteractionEnabled = NO;
        [_selectButton setImage:[UIImage imageNamed:@"DNTextInput.bundle/textIpnut_selected_back"] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UIView *)backView {
    if (!_backView) {
        _backView                   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPWIDTH, IPHeight_Screen)];
        _backView.backgroundColor   = [UIColor blackColor];
        _backView.alpha             = 0;
        __weak typeof(self)weakSelf = self;
        [_backView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weakSelf dismissInput];
        }];
    }
    return _backView;
}

@end
