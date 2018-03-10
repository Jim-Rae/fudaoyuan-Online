//
//  LoginViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/18.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "LoginViewController.h"
#import "MyTextField.h"
#import "RegisterViewController.h"
#import "ForgetPWViewController.h"
#import "ProgressHUD.h"
#import "ViewModel.h"
#import "UIViewController+XYSideCategory.h"
#import "AppDelegate.h"
#import "MyUserDefaults.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) MyTextField *accountTextField;
@property (nonatomic, strong) MyTextField *passwordTextField;
@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat backgroundImage_Height;

@end

@implementation LoginViewController

- (void)loadView
{
    [super loadView];
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _backgroundImage = [UIImage imageNamed:@"login_background"];
    _backgroundImage_Height = _backgroundImage.size.height * SCREEN_WIDTH/_backgroundImage.size.width;
    [self setUpView];
}

- (void)setUpView{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.forgetBtn];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.loginBtn];
}

#pragma mark - backgroundImageView
- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _backgroundImage_Height)];
        _backgroundImageView.image = _backgroundImage;
    }
    return _backgroundImageView;
}

#pragma mark - accountTextField
- (MyTextField *)accountTextField{
    if (!_accountTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.03f;
        _accountTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _accountTextField.tipsLabel.text = @"请输入邮箱";
        _accountTextField.tipsLabel.textColor = [UIColor redColor];
        _accountTextField.tipsLabel.font = [UIFont systemFontOfSize:18];
        _accountTextField.tipsLabel.hidden = YES;
        
        _accountTextField.titleLabel.text = @"邮箱";
        _accountTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _accountTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _accountTextField.textField.font = [UIFont systemFontOfSize:22];
        _accountTextField.textField.placeholder = @"请输入邮箱";
        _accountTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTextField.textField.autocapitalizationType = NO;
        _accountTextField.textField.keyboardType = UIKeyboardTypeEmailAddress;
        _accountTextField.textField.delegate = self;
    }
    return _accountTextField;
}

#pragma mark - passwordTextField
- (MyTextField *)passwordTextField{
    if (!_passwordTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.12f+SCREEN_HEIGHT*0.07f;
        _passwordTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _passwordTextField.tipsLabel.text = @"请输入密码";
        _passwordTextField.tipsLabel.textColor = [UIColor redColor];
        _passwordTextField.tipsLabel.font = [UIFont systemFontOfSize:18];
        _passwordTextField.tipsLabel.hidden = YES;
        
        _passwordTextField.titleLabel.text = @"密码";
        _passwordTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _passwordTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _passwordTextField.textField.font = [UIFont systemFontOfSize:22];
        _passwordTextField.textField.placeholder = @"请输入密码";
        _passwordTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.textField.autocapitalizationType = NO;
        _passwordTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.textField.secureTextEntry = YES;
        _passwordTextField.textField.delegate = self;
    }
    return _passwordTextField;
}

#pragma mark - forgetBtn
- (UIButton *)forgetBtn{
    if (!_forgetBtn) {
        CGFloat w = SCREEN_WIDTH*0.35f;
        CGFloat h = SCREEN_HEIGHT*0.07f;
        CGFloat x = SCREEN_WIDTH*0.6f;
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.24f+SCREEN_HEIGHT*0.09f;
        _forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _forgetBtn.frame = CGRectMake(x, y, w, h);
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:22];
        [_forgetBtn setTitleColor:[UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1] forState:UIControlStateNormal];
        [_forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetBtn;
}

- (void)forgetPassword{
    ForgetPWViewController * forgetPWViewController = [[ForgetPWViewController alloc]init];
    forgetPWViewController.title = @"忘记密码";
    [self.navigationController pushViewController:forgetPWViewController animated:YES];
}

#pragma mark - registerBtn
- (UIButton *)registerBtn{
    if (!_registerBtn) {
        CGFloat w = SCREEN_WIDTH*0.35f;
        CGFloat h = SCREEN_HEIGHT*0.08f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.31f+SCREEN_HEIGHT*0.12f;
        _registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _registerBtn.frame = CGRectMake(x, y, w, h);
        _registerBtn.layer.cornerRadius = 6.0f;
        _registerBtn.layer.borderColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1].CGColor;
        _registerBtn.layer.borderWidth = 2.0f;
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [_registerBtn setTitleColor:[UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1] forState:UIControlStateNormal];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerID) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (void)registerID{
    RegisterViewController * registerViewController = [[RegisterViewController alloc]init];
    registerViewController.title = @"注册";
    [self.navigationController pushViewController:registerViewController animated:YES];
}

#pragma mark - loginBtn
- (UIButton *)loginBtn{
    if (!_loginBtn) {
        CGFloat w = SCREEN_WIDTH*0.35f;
        CGFloat h = SCREEN_HEIGHT*0.08f;
        CGFloat x = SCREEN_WIDTH*0.55f;
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.31f+SCREEN_HEIGHT*0.12f;
        _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginBtn.frame = CGRectMake(x, y, w, h);
        _loginBtn.backgroundColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _loginBtn.layer.cornerRadius = 6;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (void)login{
    if ([_accountTextField.textField.text length]==0||[_passwordTextField.textField.text length]==0) {
        if ([_accountTextField.textField.text length]==0){
            _accountTextField.tipsLabel.hidden = NO;
        }
        if ([_passwordTextField.textField.text length]==0) {
            _passwordTextField.tipsLabel.hidden = NO;
        }
    } else {
        [ProgressHUD showProgressHUD:@"登录中..."];
        NSDictionary *loginDic = @{@"UserName":_accountTextField.textField.text,@"PassWord":_passwordTextField.textField.text};
        [ViewModel loginWith:loginDic finish:^(BOOL success, BOOL validated, NSString *token) {
            if (success) {
                if (validated) {
                    ((AppDelegate *)[UIApplication sharedApplication].delegate).token = token;
                    [ProgressHUD hideAllHUDAnimated:NO];
                    [ViewModel getUserInfWithToken:token finish:^(BOOL success) {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"isLogin" object:nil];
                    }];
                    [self.navigationController popViewControllerAnimated:YES];
                    [MyUserDefaults saveToUserDefaultsWithDictionary:loginDic];
                } else {
                    [self showAlertControllerWithTitle:@"登录失败" message:@"账号或密码错误" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
            } else {
                if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                    [self showAlertControllerWithTitle:@"登录失败" message:@"服务器内部错误" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:@"登录失败" message:@"请检查网络连接情况" handler:nil];
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
    if ([_accountTextField.textField.text length]!=0) {
         _accountTextField.tipsLabel.hidden = YES;
    }
    if ([_passwordTextField.textField.text length]!=0) {
        _passwordTextField.tipsLabel.hidden = YES;
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
