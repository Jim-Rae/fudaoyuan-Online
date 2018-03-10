//
//  MySignViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/23.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "MySignViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ViewModel.h"
#import "UIViewController+XYSideCategory.h"
#import "ProgressHUD.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface MySignViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat image_Height;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;


@end

@implementation MySignViewController

- (void)loadView
{
    [super loadView];
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _image = [UIImage imageNamed:@"sign_background"];
    _image_Height = _image.size.height * SCREEN_WIDTH*0.8f/_image.size.width;
    [self setUpView];
}

- (void)setUpView{
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.label];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.button];
}

#pragma mark - imageView
- (UIImageView *)imageView{
    if (!_imageView) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = _image_Height;
        CGFloat x = (SCREEN_WIDTH-w)/2;
        CGFloat y = SCREEN_HEIGHT*0.08f;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _imageView.image = _image;
    }
    return _imageView;
}

#pragma mark - label
- (UILabel *)label{
    if (!_label) {
        CGFloat w = SCREEN_WIDTH*0.6f;
        CGFloat h = SCREEN_HEIGHT*0.08f;
        CGFloat x = (SCREEN_WIDTH-w)/2;
        CGFloat y = _image_Height+SCREEN_HEIGHT*0.16f;
        _label = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _label.text = @"请输入考勤码";
        _label.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _label.font = [UIFont systemFontOfSize:22];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

#pragma mark - textField
- (UITextField *)textField{
    if (!_textField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.08f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = _image_Height+SCREEN_HEIGHT*0.28f;
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
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

#pragma mark - button
- (UIButton *)button{
    if (!_button) {
        CGFloat w = SCREEN_WIDTH*0.35f;
        CGFloat h = SCREEN_HEIGHT*0.08f;
        CGFloat x = (SCREEN_WIDTH-w)/2;
        CGFloat y = _image_Height+SCREEN_HEIGHT*0.45f;
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake(x, y, w, h);
        _button.layer.cornerRadius = 6.0f;
        _button.layer.borderColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1].CGColor;
        _button.layer.borderWidth = 2.0f;
        _button.layer.masksToBounds = YES;
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [_button setTitleColor:[UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1] forState:UIControlStateNormal];
        [_button setTitle:@"提交" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)submit{
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).isLogin) {
        NSString *token = ((AppDelegate *)[UIApplication sharedApplication].delegate).token;
        [ProgressHUD showProgressHUD:@"签到中..."];
        [ViewModel checkInviteCodeWithToken:token invitecode:_textField.text finish:^(BOOL success, NSString *message){
            if (success) {
                if (message==nil) {
                    [self showAlertControllerWithTitle:@"签到成功" message:nil handler:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:message message:nil handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
            } else {
                if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                    [self showAlertControllerWithTitle:@"签到失败" message:@"服务器内部错误" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:@"签到失败" message:@"请检查网络连接情况" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
            }
        }];
    } else {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请先登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *loginViewController = [[LoginViewController alloc]init];
            loginViewController.title = @"登录";
            [self.navigationController pushViewController:loginViewController animated:YES];
            
        }];
        //按钮添加
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
