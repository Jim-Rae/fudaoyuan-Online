//
//  IdentifyViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/17.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "IdentifyViewController.h"
#import "StringPickerView.h"
#import "MyTextField.h"
#import "ViewModel.h"
#import "UIViewController+XYSideCategory.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface IdentifyViewController ()<UITextFieldDelegate>

//高校
@property (nonatomic, strong) MyTextField *schoolTextField;
//院系
@property (nonatomic, strong) MyTextField *departmentTextField;
//邀请码
@property (nonatomic, strong) MyTextField *invitationTextField;
//学(工)号
@property (nonatomic, strong) MyTextField *numberTextField;
//真实姓名
@property (nonatomic, strong) MyTextField *nameTextField;

@property (nonatomic, strong) UIButton *CommitBtn;

@property (nonatomic, strong) NSMutableArray *schoolMArr;

@end

@implementation IdentifyViewController

- (void)loadView
{
    [super loadView];
    self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpViews];

}

- (void)setUpViews{
    [self.view addSubview:self.schoolTextField];
    [self.view addSubview:self.departmentTextField];
    [self.view addSubview:self.invitationTextField];
    [self.view addSubview:self.numberTextField];
    [self.view addSubview:self.nameTextField];
    [self.view addSubview:self.CommitBtn];
}

#pragma mark - schoolTextField
- (MyTextField *)schoolTextField{
    if (!_schoolTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = 0;
        _schoolTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _schoolTextField.titleLabel.text = @"高校";
        _schoolTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _schoolTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _schoolTextField.textField.font = [UIFont systemFontOfSize:22];
        _schoolTextField.textField.placeholder = @"请选择高校";
        _schoolTextField.textField.delegate = self;
        __weak typeof(self) weakSelf = self;
        _schoolTextField.tapAcitonBlock = ^{
            [ProgressHUD showProgressHUD:@"获取数据中..."];
            [ViewModel getSchoolsFinish:^(BOOL success, NSArray *school) {
                if (success) {
                    [StringPickerView showStringPickerWithTitle:@"高校" dataSource:school defaultSelValue:school[0] isAutoSelect:YES resultBlock:^(id selectValue) {
                        weakSelf.schoolTextField.textField.text = selectValue;
                    }];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                        [weakSelf showAlertControllerWithTitle:@"获取数据失败" message:@"服务器内部错误" handler:nil];
                        [ProgressHUD hideAllHUDAnimated:NO];
                    } else {
                        [weakSelf showAlertControllerWithTitle:@"获取数据失败" message:@"请检查网络连接情况" handler:nil];
                        [ProgressHUD hideAllHUDAnimated:NO];
                    }
                }
            }];
        };
    }
    return _schoolTextField;
}

#pragma mark - department
- (MyTextField *)departmentTextField{
    if (!_departmentTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = SCREEN_HEIGHT*0.12f+SCREEN_HEIGHT*0.035f;
        _departmentTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _departmentTextField.titleLabel.text = @"院系";
        _departmentTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _departmentTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _departmentTextField.textField.font = [UIFont systemFontOfSize:22];
        _departmentTextField.textField.placeholder = @"请输入院系";
        _departmentTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _departmentTextField.textField.delegate = self;
    }
    return _departmentTextField;
}

#pragma mark - invitation
- (MyTextField *)invitationTextField{
    if (!_invitationTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = SCREEN_HEIGHT*0.24f+SCREEN_HEIGHT*0.035f*2;
        _invitationTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _invitationTextField.titleLabel.text = @"邀请码";
        _invitationTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _invitationTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _invitationTextField.textField.font = [UIFont systemFontOfSize:22];
        _invitationTextField.textField.placeholder = @"请输入邀请码";
        _invitationTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _invitationTextField.textField.autocapitalizationType = NO;
        _invitationTextField.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _invitationTextField.textField.delegate = self;
    }
    return _invitationTextField;
}

#pragma mark - number
- (MyTextField *)numberTextField{
    if (!_numberTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = SCREEN_HEIGHT*0.36f+SCREEN_HEIGHT*0.035f*3;
        _numberTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _numberTextField.titleLabel.text = @"学(工)号";
        _numberTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _numberTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _numberTextField.textField.font = [UIFont systemFontOfSize:22];
        _numberTextField.textField.placeholder = @"请输入学(工)号";
        _numberTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numberTextField.textField.autocapitalizationType = NO;
        _numberTextField.textField.keyboardType = UIKeyboardTypeNumberPad;
        _numberTextField.textField.delegate = self;
    }
    return _numberTextField;
}

#pragma mark - name
- (MyTextField *)nameTextField{
    if (!_nameTextField) {
        CGFloat w = SCREEN_WIDTH*0.8f;
        CGFloat h = SCREEN_HEIGHT*0.12f;
        CGFloat x = SCREEN_WIDTH*0.1f;
        CGFloat y = SCREEN_HEIGHT*0.48f+SCREEN_HEIGHT*0.035f*4;
        _nameTextField = [[MyTextField alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _nameTextField.titleLabel.text = @"真实姓名";
        _nameTextField.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _nameTextField.titleLabel.font = [UIFont systemFontOfSize:22];
        
        _nameTextField.textField.font = [UIFont systemFontOfSize:22];
        _nameTextField.textField.placeholder = @"请输入真实姓名";
        _nameTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.textField.delegate = self;
    }
    return _nameTextField;
}

#pragma mark - CommitBtn
- (UIButton *)CommitBtn{
    if (!_CommitBtn) {
        CGFloat w = SCREEN_WIDTH*0.35f;
        CGFloat h = SCREEN_HEIGHT*0.07f;
        CGFloat x = (SCREEN_WIDTH-w)/2;
        CGFloat y = SCREEN_HEIGHT*0.60f+SCREEN_HEIGHT*0.035f*5;
        _CommitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _CommitBtn.frame = CGRectMake(x, y, w, h);
        _CommitBtn.backgroundColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
        _CommitBtn.layer.cornerRadius = 6;
        _CommitBtn.layer.masksToBounds = YES;
        _CommitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        [_CommitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_CommitBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        [_CommitBtn addTarget:self action:@selector(clickCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _CommitBtn;
}

#pragma mark - UITextFieldDelegate
//使schoolTextField不能编辑
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField==_schoolTextField.textField) {
        return NO;
    }else{
        return YES;
    }
}

- (void) clickCommitBtn{
    if ([_schoolTextField.textField.text length]==0||[_departmentTextField.textField.text length]==0||[_numberTextField.textField.text length]==0||[_invitationTextField.textField.text length]==0||[_nameTextField.textField.text length]==0) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请填写完整的认证信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        //按钮添加
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSString *token = ((AppDelegate *)[UIApplication sharedApplication].delegate).token;
        NSDictionary *infDic = @{@"token":token, @"invitecode":_invitationTextField.textField.text, @"school": _schoolTextField.textField.text, @"department": _departmentTextField.textField.text, @"pid": _numberTextField.textField.text, @"fullname": _nameTextField.textField.text};
        [ProgressHUD showProgressHUD:@"提交中..."];
        [ViewModel identifyWithInfDic:infDic finish:^(BOOL success, NSString *message) {
            if (success) {
                if (message==nil) {
                    [self showAlertControllerWithTitle:@"认证成功" message:nil handler:^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"didIdentify" object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:message message:nil handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
            } else {
                if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                    [self showAlertControllerWithTitle:@"认证失败" message:@"服务器内部错误" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                } else {
                    [self showAlertControllerWithTitle:@"认证失败" message:@"请检查网络连接情况" handler:nil];
                    [ProgressHUD hideAllHUDAnimated:NO];
                }
            }
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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
