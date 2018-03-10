//
//  MyTextField.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/17.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "MyTextField.h"

@interface MyTextField ()


@property (nonatomic, strong) UIView *tapView;

@end

@implementation MyTextField

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.textField];
    }
    return self;
}

#pragma mark - titleLabel
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.5f, self.frame.size.height*0.4f)];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumFontSize = 5;
    }
    return _titleLabel;
}

#pragma mark - tipsLabel
- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.5f, 0, self.frame.size.width*0.5f, self.frame.size.height*0.4f)];
        _tipsLabel.textAlignment = NSTextAlignmentRight;
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
        _tipsLabel.minimumFontSize = 5;
    }
    return _tipsLabel;
}

#pragma mark - textField
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, self.frame.size.height*0.4f, self.frame.size.width, self.frame.size.height*0.6f)];
        _textField.layer.cornerRadius = 7;
        _textField.layer.borderColor= [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1].CGColor;
        _textField.layer.borderWidth= 2.0f;
        _textField.layer.shadowColor = [UIColor blackColor].CGColor;
        _textField.layer.shadowOffset = CGSizeMake(1, 1);
        _textField.layer.shadowOpacity = 0.5;
        _textField.layer.shadowRadius = 2.0;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.adjustsFontSizeToFitWidth = YES;
        _textField.minimumFontSize = 5;
    }
    return _textField;
}

- (void)setTapAcitonBlock:(BRTapAcitonBlock)tapAcitonBlock {
    _tapAcitonBlock = tapAcitonBlock;
    self.tapView.hidden = NO;
}

- (void)setEndEditBlock:(BREndEditBlock)endEditBlock {
    _endEditBlock = endEditBlock;
    [_textField addTarget:_textField action:@selector(didEndEditTextField:) forControlEvents:UIControlEventEditingDidEnd];
}

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc]initWithFrame:self.bounds];
        _tapView.backgroundColor = [UIColor clearColor];
        [_textField addSubview:_tapView];
        _tapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapTextField)];
        [_tapView addGestureRecognizer:myTap];
    }
    return _tapView;
}

- (void)didTapTextField {
    // 响应点击事件时，隐藏键盘
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
    NSLog(@"点击了textField，执行点击回调");
    if (self.tapAcitonBlock) {
        self.tapAcitonBlock();
    }
}

- (void)didEndEditTextField:(UITextField *)textField {
    NSLog(@"textField编辑结束，回调编辑框输入的文本内容:%@", textField.text);
    if (self.endEditBlock) {
        self.endEditBlock(textField.text);
    }
}


@end
