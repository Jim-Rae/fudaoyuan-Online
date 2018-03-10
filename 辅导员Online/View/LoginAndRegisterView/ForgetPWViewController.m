//
//  ForgetPWViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/20.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "MyTextField.h"
#import "ViewModel.h"
#import "AppDelegate.h"
#import "UIViewController+XYSideCategory.h"
#import "ProgressHUD.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ForgetPWViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) MyTextField *emailTextField;
@property(nonatomic, strong) MyTextField *verificationCodeTextField;
@property(nonatomic, strong) UIButton *getVerificationCodeBtn;
@property(nonatomic, strong) MyTextField *passwordTextField;
@property(nonatomic, strong) MyTextField *password2TextField;
@property(nonatomic, strong) UIButton *resetPWBtn;

@end

@implementation ForgetPWViewController

- (void)loadView
{
    [super loadView];
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpView];
}

- (void)setUpView{
    [self.view addSubview:self.emailTextField];
    [self.view addSubview:self.verificationCodeTextField];
    [self.view addSubview:self.getVerificationCodeBtn];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.password2TextField];
    [self.view addSubview:self.resetPWBtn];
}


#pragma mark - emailTextField
- (MyTextField *)emailTextField{
    if (!_emailTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = SCREEN_HEIGHT*0.05f;
        _emailTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _emailTextField.tipsLabel.text = @"请输入注册邮箱";
        _emailTextField.tipsLabel.textColor = [UIColor redColor];
        _emailTextField.tipsLabel.font = [UIFont systemFontOfSize:18];
        _emailTextField.tipsLabel.hidden = YES;
        
        _emailTextField.titleLabel.text = @"注册邮箱";
        _emailTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _emailTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _emailTextField.textField.font = [UIFont systemFontOfSize:22];
        _emailTextField.textField.placeholder = @"请输入注册邮箱";
        _emailTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.textField.autocapitalizationType = NO;
        _emailTextField.textField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.textField.delegate = self;
    }
    return _emailTextField;
}

#pragma mark - verificationCodeTextField
- (MyTextField *)verificationCodeTextField{
    if (!_verificationCodeTextField) {
        CGFloat w = SCREEN_WIDTH*0.445f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = SCREEN_HEIGHT*0.21f;
        _verificationCodeTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _verificationCodeTextField.titleLabel.text = @"验证码";
        _verificationCodeTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _verificationCodeTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _verificationCodeTextField.textField.font = [UIFont systemFontOfSize:20];
        _verificationCodeTextField.textField.placeholder = @"请输入验证码";
        _verificationCodeTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _verificationCodeTextField.textField.autocapitalizationType = NO;
        _verificationCodeTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _verificationCodeTextField.textField.delegate = self;
    }
    return _verificationCodeTextField;
}

#pragma mark - passwordTextField
- (MyTextField *)passwordTextField{
    if (!_passwordTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = SCREEN_HEIGHT*0.37f;
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
        CGFloat y = SCREEN_HEIGHT*0.53f;
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
        CGFloat y = SCREEN_HEIGHT*0.72f;
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
    }else if (![ViewModel isAvailableEmail:_emailTextField.textField.text]){
        _emailTextField.tipsLabel.text = @"邮箱格式不正确";
        _emailTextField.tipsLabel.hidden = NO;
    }else if (![_passwordTextField.textField.text isEqual:_password2TextField.textField.text]){
        _password2TextField.tipsLabel.text = @"两次密码不一致";
        _password2TextField.tipsLabel.hidden = NO;
    }else {
        [ProgressHUD showProgressHUD:@"提交中..."];
        NSDictionary *infDic = @{@"vcode":_verificationCodeTextField.textField.text, @"email":_emailTextField.textField.text, @"password":_passwordTextField.textField.text};
        [ViewModel updateLoginInfWithInfDic:infDic finish:^(BOOL success, NSString *message) {
            if (success) {
                if (message==nil) {
                    [self showAlertControllerWithTitle:@"密码修改成功" message:nil handler:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:@"验证码错误" message:nil handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
                
            } else {
                if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                    [self showAlertControllerWithTitle:@"密码修改失败" message:@"服务器内部错误" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:@"密码修改失败" message:@"请检查网络连接情况" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
            }
        }];
    }
}

#pragma mark - getVerificationCodeBtn
- (UIButton *)getVerificationCodeBtn{
    if (!_getVerificationCodeBtn) {
        CGFloat w = SCREEN_WIDTH*0.35f;
        CGFloat h = SCREEN_HEIGHT*0.12f*0.6f;
        CGFloat x = SCREEN_WIDTH*0.55f;
        CGFloat y = SCREEN_HEIGHT*0.21f+SCREEN_HEIGHT*0.12f*0.4f;
        _getVerificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getVerificationCodeBtn.frame = CGRectMake(x, y, w, h);
        _getVerificationCodeBtn.backgroundColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _getVerificationCodeBtn.layer.cornerRadius = 7;
        _getVerificationCodeBtn.layer.masksToBounds = YES;
        _getVerificationCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _getVerificationCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _getVerificationCodeBtn.titleLabel.minimumScaleFactor = 0.25f;
        [_getVerificationCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVerificationCodeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getVerificationCodeBtn;
}

- (void)getVerificationCode{
    if ([_emailTextField.textField.text length]==0) {
        _emailTextField.tipsLabel.hidden = NO;
    }else if (![ViewModel isAvailableEmail:_emailTextField.textField.text]){
        _emailTextField.tipsLabel.text = @"邮箱格式不正确";
        _emailTextField.tipsLabel.hidden = NO;
    }else{
        [ProgressHUD showProgressHUD:@"发送中..."];
        [ViewModel getMailCodeWithEmail:_emailTextField.textField.text finish:^(BOOL success, NSString *message) {
            if (success) {
                if (message==nil) {
                    [self showAlertControllerWithTitle:@"发送验证码成功，请查看邮箱！" message:nil handler:^{
                        [self addCountDown];
                    }];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:message message:nil handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }

            } else {
                if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                    [self showAlertControllerWithTitle:@"获取验证码失败" message:@"服务器内部错误" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:@"获取验证码失败" message:@"请检查网络连接情况" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
            }
        }];
    }
}

//添加倒计时
- (void)addCountDown{
    //设置倒计时时间
    //通过检验发现，方法调用后，timeout会先自动-1，所以如果从120秒开始倒计时timeout应该写120
    //__block 如果修饰指针时，指针相当于弱引用，指针对指向的对象不产生引用计数的影响
    __block int timeout = 121;
    
    //获取全局队列
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //创建一个定时器，并将定时器的任务交给全局队列执行(并行，不会造成主线程阻塞)
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    
    // 设置触发的间隔时间
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    //1.0 * NSEC_PER_SEC  代表设置定时器触发的时间间隔为1s
    //0 * NSEC_PER_SEC    代表时间允许的误差是 0s
    
    //block内部 如果对当前对象的强引用属性修改 应该使用__weak typeof(self)weakSelf 修饰  避免循环调用
    __weak typeof(self)weakSelf = self;
    //设置定时器的触发事件
    dispatch_source_set_event_handler(timer, ^{
        
        //倒计时  刷新button上的title ，当倒计时时间为0时，结束倒计时
        
        //1. 每调用一次 时间-1s
        timeout --;
        
        //2.对timeout进行判断时间是停止倒计时，还是修改button的title
        if (timeout <= 0) {
            
            //停止倒计时，button打开交互，背景颜色还原，title还原
            
            //关闭定时器
            dispatch_source_cancel(timer);
            
            //MRC下需要释放，这里不需要
            // dispatch_realse(timer);
            
            //button上的相关设置
            //注意: button是属于UI，在iOS中多线程处理时，UI控件的操作必须是交给主线程(主队列)
            //在主线程中对button进行修改操作
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.getVerificationCodeBtn.userInteractionEnabled = YES;//开启交互性
                weakSelf.getVerificationCodeBtn.backgroundColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
                [weakSelf.getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else {
            
            //处于正在倒计时，在主线程中刷新button上的title，时间-1秒
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * title = [NSString stringWithFormat:@"%d秒后重获验证码",timeout];
                [weakSelf.getVerificationCodeBtn setTitle:title forState:UIControlStateNormal];
                weakSelf.getVerificationCodeBtn.userInteractionEnabled = NO;//关闭交互性
                weakSelf.getVerificationCodeBtn.backgroundColor = [UIColor grayColor];
            });
        }
    });
    
    dispatch_resume(timer);
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
    if ([_emailTextField.textField.text length]!=0) {
        _emailTextField.tipsLabel.hidden = YES;
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
