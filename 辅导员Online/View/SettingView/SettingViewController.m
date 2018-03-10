//
//  SettingViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/23.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "ChangePWViewController.h"
#import "AboutUsViewController.h"
#import "ProgressHUD.h"
#import "ViewModel.h"
#import "UIViewController+XYSideCategory.h"
#import "MyUserDefaults.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, copy) NSString *token;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _token = ((AppDelegate *)[UIApplication sharedApplication].delegate).token;
    
    _titleArray = @[@"关于我们", @"修改密码", @"退出登录"];
    [self.view addSubview:self.tabelView];
}


#pragma mark - tabelView

- (UITableView *)tabelView
{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
        _tabelView.scrollEnabled = NO;
//        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _tabelView;
}

#pragma mark --- tableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _titleArray[indexPath.row]];
    if (indexPath.row==1||indexPath.row==2) {
        if (((AppDelegate *)[UIApplication sharedApplication].delegate).isLogin) {
            if (indexPath.row==2){
                cell.textLabel.textColor = [UIColor redColor];
            }
        } else {
            cell.hidden = YES;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            AboutUsViewController *aboutUsViewController = [[AboutUsViewController alloc]init];
            aboutUsViewController.title = @"关于我们";
            [self.navigationController pushViewController:aboutUsViewController animated:YES];
        }
            break;
        case 1:{
            ChangePWViewController *changePWViewController = [[ChangePWViewController alloc]init];
            changePWViewController.title = @"修改密码";
            [self.navigationController pushViewController:changePWViewController animated:YES];
        }
            break;
        case 2:{
            [ProgressHUD showProgressHUD:@"退出中..."];
            [ViewModel logoutWithToken:_token finish:^(BOOL success) {
                if (success) {
                    [ProgressHUD hideAllHUDAnimated:NO];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"isNotLogin" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    [MyUserDefaults saveToUserDefaultsWithDictionary:@{@"UserName":[NSNull null],@"PassWord":[NSNull null]}];
                } else {
                    if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                        [self showAlertControllerWithTitle:@"退出登录失败" message:@"服务器内部错误" handler:nil];
                        [ProgressHUD hideAllHUDAnimated:NO];
                    } else {
                        [self showAlertControllerWithTitle:@"退出登录失败" message:@"请检查网络连接情况" handler:nil];
                        [ProgressHUD hideAllHUDAnimated:NO];
                    }
                }
            }];
        }
            break;
        default:
            break;
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
