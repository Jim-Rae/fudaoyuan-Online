//
//  RegisterViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/20.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "RegisterViewController.h"
#import "MyTextField.h"
#import "ViewModel.h"
#import "ProgressHUD.h"
#import "UIViewController+XYSideCategory.h"
#import "AppDelegate.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) CGFloat backgroundImage_Height;

@property (nonatomic, strong) MyTextField *accountTextField;
@property (nonatomic, strong) MyTextField *passwordTextField;
@property (nonatomic, strong) MyTextField *password2TextField;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *activateBtn;

@end

@implementation RegisterViewController

- (void)loadView
{
    [super loadView];
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _backgroundImage = [UIImage imageNamed:@"register_background"];
    _backgroundImage_Height = _backgroundImage.size.height * SCREEN_WIDTH*0.6f/_backgroundImage.size.width;
    [self setUpView];
}

- (void)setUpView{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.password2TextField];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.activateBtn];
}

#pragma mark - backgroundImageView
- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        CGFloat w = SCREEN_WIDTH*0.65f;
        CGFloat h = _backgroundImage_Height;
        CGFloat x = (SCREEN_WIDTH-w)/2;
        CGFloat y = SCREEN_HEIGHT*0.05f;
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
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
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.08f;
        _accountTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _accountTextField.tipsLabel.text = @"请输入注册邮箱";
        _accountTextField.tipsLabel.textColor = [UIColor redColor];
        _accountTextField.tipsLabel.font = [UIFont systemFontOfSize:18];
        _accountTextField.tipsLabel.hidden = YES;
        
        _accountTextField.titleLabel.text = @"注册邮箱";
        _accountTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _accountTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _accountTextField.textField.font = [UIFont systemFontOfSize:22];
        _accountTextField.textField.placeholder = @"请输入注册邮箱";
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
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.24f;
        _passwordTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _passwordTextField.tipsLabel.text = @"请输入8至20位密码";
        _passwordTextField.tipsLabel.textColor = [UIColor redColor];
        _passwordTextField.tipsLabel.font = [UIFont systemFontOfSize:18];
        _passwordTextField.tipsLabel.hidden = YES;
        
        _passwordTextField.titleLabel.text = @"密码";
        _passwordTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _passwordTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _passwordTextField.textField.font = [UIFont systemFontOfSize:22];
        _passwordTextField.textField.placeholder = @"请输入8至20位密码";
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
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.40f;
        _password2TextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _password2TextField.tipsLabel.text = @"请再次输入密码";
        _password2TextField.tipsLabel.textColor = [UIColor redColor];
        _password2TextField.tipsLabel.font = [UIFont systemFontOfSize:18];
        _password2TextField.tipsLabel.hidden = YES;
        
        _password2TextField.titleLabel.text = @"确认密码";
        _password2TextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _password2TextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _password2TextField.textField.font = [UIFont systemFontOfSize:22];
        _password2TextField.textField.placeholder = @"请再次输入密码";
        _password2TextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _password2TextField.textField.autocapitalizationType = NO;
        _password2TextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _password2TextField.textField.secureTextEntry = YES;
        _password2TextField.textField.delegate = self;
    }
    return _password2TextField;
}

#pragma mark - tipsLabel
- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        CGFloat w = SCREEN_WIDTH*0.7f;
        CGFloat h = SCREEN_HEIGHT*0.05f;
        CGFloat x = SCREEN_WIDTH*0.15f;
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.56f;
        _tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _tipsLabel.text = @"(注册邮箱一旦激活成功将不可更改)";
        _tipsLabel.adjustsFontSizeToFitWidth = YES;
        _tipsLabel.minimumFontSize = 5;
        _tipsLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont systemFontOfSize:16];
    }
    return _tipsLabel;
}

#pragma mark - backrBtn
- (UIButton *)backBtn{
    if (!_backBtn) {
        CGFloat w = SCREEN_WIDTH*0.35f;
        CGFloat h = SCREEN_HEIGHT*0.08f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.65f;
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _backBtn.frame = CGRectMake(x, y, w, h);
        _backBtn.layer.cornerRadius = 6.0f;
        _backBtn.layer.borderColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1].CGColor;
        _backBtn.layer.borderWidth = 2.0f;
        _backBtn.layer.masksToBounds = YES;
        _backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [_backBtn setTitleColor:[UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1] forState:UIControlStateNormal];
        [_backBtn setTitle:@"返回登录" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - activateBtn
- (UIButton *)activateBtn{
    if (!_activateBtn) {
        CGFloat w = SCREEN_WIDTH*0.35f;
        CGFloat h = SCREEN_HEIGHT*0.08f;
        CGFloat x = SCREEN_WIDTH*0.55f;
        CGFloat y = _backgroundImage_Height+SCREEN_HEIGHT*0.65f;
        _activateBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _activateBtn.frame = CGRectMake(x, y, w, h);
        _activateBtn.backgroundColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _activateBtn.layer.cornerRadius = 6;
        _activateBtn.layer.masksToBounds = YES;
        _activateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [_activateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_activateBtn setTitle:@"激活邮箱" forState:UIControlStateNormal];
        [_activateBtn addTarget:self action:@selector(activate) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activateBtn;
}

- (void)activate{    
    if (![ViewModel isAvailableEmail:_accountTextField.textField.text]){
        _accountTextField.tipsLabel.text = @"邮箱格式不正确";
        _accountTextField.tipsLabel.hidden = NO;
    }else if ([_accountTextField.textField.text length]==0||[_passwordTextField.textField.text length]<8||[_passwordTextField.textField.text length]>20||[_password2TextField.textField.text length]==0) {
        if ([_accountTextField.textField.text length]==0){
            _accountTextField.tipsLabel.hidden = NO;
        }
        if ([_passwordTextField.textField.text length]<8||[_passwordTextField.textField.text length]>20) {
            _passwordTextField.tipsLabel.hidden = NO;
        }
        if ([_password2TextField.textField.text length]==0) {
            _password2TextField.tipsLabel.hidden = NO;
        }
    }else if (_passwordTextField.textField.text!=_password2TextField.textField.text){
        _password2TextField.tipsLabel.text = @"两次密码不一致";
        _password2TextField.tipsLabel.hidden = NO;
    }else {
        [ProgressHUD showProgressHUD:@"提交中..."];
        NSDictionary *infDic = @{ @"email":_accountTextField.textField.text, @"password":_passwordTextField.textField.text};
        [ViewModel registerWithInfDic:infDic finish:^(BOOL success, NSString *message) {
            if (success) {
                if (message==nil) {
                    [self showAlertControllerWithTitle:@"注册成功" message:nil handler:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:message message:nil handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
                
            } else {
                if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                    [self showAlertControllerWithTitle:@"注册失败" message:@"服务器内部错误" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:@"注册失败" message:@"请检查网络连接情况" handler:nil];
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
