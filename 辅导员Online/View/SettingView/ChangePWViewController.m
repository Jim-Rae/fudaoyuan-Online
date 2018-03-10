//
//  ChangePWViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/23.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "ChangePWViewController.h"
#import "MyTextField.h"
#import "ViewModel.h"
#import "AppDelegate.h"
#import "UIViewController+XYSideCategory.h"
#import "ProgressHUD.h"
#import "MyUserDefaults.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ChangePWViewController ()<UITextFieldDelegate>


@property (nonatomic, strong) MyTextField *passwordTextField;
@property (nonatomic, strong) MyTextField *password2TextField;
@property (nonatomic, strong) UIButton *resetPWBtn;
@property (nonatomic, copy) NSString *token;

@end

@implementation ChangePWViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _token = ((AppDelegate *)[UIApplication sharedApplication].delegate).token;
    
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.password2TextField];
    [self.view addSubview:self.resetPWBtn];
}

#pragma mark - passwordTextField
- (MyTextField *)passwordTextField{
    if (!_passwordTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = SCREEN_HEIGHT*0.2f;
        _passwordTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _passwordTextField.tipsLabel.text = @"请输入8至20位新密码";
        _passwordTextField.tipsLabel.textColor = [UIColor redColor];
        _passwordTextField.tipsLabel.font = [UIFont systemFontOfSize:18];
        _passwordTextField.tipsLabel.hidden = YES;
        
        _passwordTextField.titleLabel.text = @"新密码";
        _passwordTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _passwordTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _passwordTextField.textField.font = [UIFont systemFontOfSize:22];
        _passwordTextField.textField.placeholder = @"请输入8至20位新密码";
        _passwordTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.textField.autocapitalizationType = NO;
        _passwordTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.textField.secureTextEntry = YES;
        _passwordTextField.textField.delegate = self;
    }
    return _passwordTextField;
}

#pragma mark - password2TextField
- (MyTextField *)password2TextField{
    if (!_password2TextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = SCREEN_HEIGHT*0.4f;
        _password2TextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _password2TextField.tipsLabel.text = @"请再次输入新密码";
        _password2TextField.tipsLabel.textColor = [UIColor redColor];
        _password2TextField.tipsLabel.font = [UIFont systemFontOfSize:18];
        _password2TextField.tipsLabel.hidden = YES;
        
        _password2TextField.titleLabel.text = @"确认密码";
        _password2TextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _password2TextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _password2TextField.textField.font = [UIFont systemFontOfSize:22];
        _password2TextField.textField.placeholder = @"请再次输入新密码";
        _password2TextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _password2TextField.textField.autocapitalizationType = NO;
        _password2TextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _password2TextField.textField.secureTextEntry = YES;
        _password2TextField.textField.delegate = self;
    }
    return _password2TextField;
}

#pragma mark - resetPWBtn
- (UIButton *)resetPWBtn{
    if (!_resetPWBtn) {
        CGFloat w = SCREEN_WIDTH*0.35f;
        CGFloat h = SCREEN_HEIGHT*0.08f;
        CGFloat x = (SCREEN_WIDTH-w)/2;
        CGFloat y = SCREEN_HEIGHT*0.6f;
        _resetPWBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _resetPWBtn.frame = CGRectMake(x, y, w, h);
        _resetPWBtn.backgroundColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _resetPWBtn.layer.cornerRadius = 6;
        _resetPWBtn.layer.masksToBounds = YES;
        _resetPWBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [_resetPWBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_resetPWBtn setTitle:@"修改密码" forState:UIControlStateNormal];
        [_resetPWBtn addTarget:self action:@selector(resetPW) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetPWBtn;
}

- (void)resetPW{
    if ([_passwordTextField.textField.text length]<8||[_passwordTextField.textField.text length]>20||[_password2TextField.textField.text length]==0){
        if ([_passwordTextField.textField.text length]<8||[_passwordTextField.textField.text length]>20) {
            _passwordTextField.tipsLabel.hidden = NO;
        }
        if ([_password2TextField.textField.text length]==0) {
            _password2TextField.tipsLabel.hidden = NO;
        }
    }else if (![_passwordTextField.textField.text isEqual:_password2TextField.textField.text]){
        _password2TextField.tipsLabel.text = @"两次密码不一致";
        _password2TextField.tipsLabel.hidden = NO;
    }else {
        [ProgressHUD showProgressHUD:@"修改中..."];
        [ViewModel changPWeWithNewPW:_passwordTextField.textField.text token:_token finish:^(BOOL success) {
            if (success) {
                [ProgressHUD hideAllHUDAnimated:NO];
                [self showAlertControllerWithTitle:@"密码重置成功" message:nil handler:^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [MyUserDefaults saveToUserDefaultsWithDictionary:@{@"PassWord":_passwordTextField.textField.text}];
                }];
            } else {
                if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                    [self showAlertControllerWithTitle:@"密码重置失败" message:@"服务器内部错误" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:@"密码重置失败" message:@"请检查网络连接情况" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }   
            }
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([_passwordTextField.textField.text length]>=7&&[_passwordTextField.textField.text length]<=21) {
        _passwordTextField.tipsLabel.hidden = YES;
    }
    if ([_password2TextField.textField.text length]!=0) {
        _password2TextField.tipsLabel.hidden = YES;
    }
    return YES;
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
