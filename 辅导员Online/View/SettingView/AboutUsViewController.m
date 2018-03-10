//
//  AboutUsViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/23.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.label];
}

- (UITextView *)textView{
    if (!_textView) {
        CGFloat w = self.view.frame.size.width-20;
        CGFloat h = self.view.frame.size.height/2;
        CGFloat x = (self.view.frame.size.width-w)/2;
        CGFloat y = 64+10;
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.text = @"辅导员Online面向学校教育工作者和学生，以手机APP为主要终端，以深度内容发布和师生互动为核心，通过汇集权威专家，传播主流声音，实现全方位思想引领，是当代大学生的“精神家园”和“信仰空间”。\r\n\r\n\r\n"
        "FX工作室\r\n"
        "联系方式：15034508@qq.com";
        _textView.editable = NO;
        _textView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _textView;
}

- (UILabel *)label{
    if (!_label) {
        CGFloat w = self.view.frame.size.width-40;
        CGFloat h = 30;
        CGFloat x = (self.view.frame.size.width-w)/2;
        CGFloat y = self.view.frame.size.height-h-10;
        _label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _label.text = @"Copyright © 华南师范大学 | Fx工作室. All rights reserved.";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.adjustsFontSizeToFitWidth = YES;
        _label.minimumFontSize = 5;
    }
    return _label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
