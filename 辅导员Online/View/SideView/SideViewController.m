//
//  SideViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/5.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "SideViewController.h"
#import "XYSideViewController.h"
#import "MainViewController.h"
#import "UIViewController+XYSideCategory.h"
#import "EditViewController.h"
#import "ShowImageViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MySignViewController.h"
#import "ListViewController.h"
#import "UserInfModel.h"
#import <UIImageView+AFNetworking.h>
#import "ViewModel.h"
#import "AppDelegate.h"

@interface SideViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *rootTableView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *setBtn;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIImageView *menuImageView;
@property (nonatomic, strong) UILabel *identificationLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIAlertController * alertController;
@property (nonatomic, assign) BOOL isLogin;

@end

@implementation SideViewController

-(void)dealloc{
    [self removeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //根据测拉偏移量设置view的宽度
    self.view.frame = CGRectMake(0, 0, _sideContentOffset, self.view.frame.size.height);
    
    self.view.backgroundColor = [UIColor whiteColor];
    _imageArray = @[@"ic_receipt_grey", @"ic_favorite_grey", @"ic_assignment_ind_grey"];
    _titleArray = @[@"基地推荐", @"我的收藏", @"我要签到"];
    
    _isLogin = NO;
    [self setUpCustomViews];
    [self addObserver];
}

//添加观察者
-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatePortrait:) name:@"portrait_changed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLogin) name:@"isLogin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didNotLogin) name:@"isNotLogin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateIdentificationLabel) name:@"didIdentify" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserNameLabel:) name:@"userName_changed" object:nil];
}

//移除观察者
-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"portrait_changed" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"isLogin" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"isNotLogin" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"didIdentify" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"userName_changed" object:nil];
}

//更新用户名
-(void)updateUserNameLabel:(NSNotification *)notification{
    NSString *token = ((AppDelegate *)[UIApplication sharedApplication].delegate).token;
    [ViewModel getUserInfWithToken:token finish:^(BOOL success) {
        UserInfModel *userInf = [[UserInfModel alloc]init];
        userInf = [UserInfModel unarchive];
        _userNameLabel.text = userInf.NickName;
    }];
}

//更新头像
-(void)updatePortrait:(NSNotification *)notification{
    UserInfModel *userInf = [[UserInfModel alloc]init];
    userInf = [UserInfModel unarchive];
    NSString *picURL = [NSString stringWithFormat:@"https://fx.scnu.edu.cn/%@",userInf.UserPicName];
    [_portraitImageView setImageWithURL:[NSURL URLWithString:picURL]];
}

//更新认证Label
-(void)updateIdentificationLabel{
    _identificationLabel.text = @"已认证";
    _identificationLabel.textColor = [UIColor colorWithRed:40/255.0 green:130/255.0 blue:246/255.0 alpha:1];
}

//已经登录
-(void)didLogin{
    _isLogin = YES;
    UserInfModel *userInf = [[UserInfModel alloc]init];
    userInf = [UserInfModel unarchive];
    if (userInf) {
        //拼接头像URL
        NSString *picURL = [NSString stringWithFormat:@"https://fx.scnu.edu.cn/%@",userInf.UserPicName];
        [_portraitImageView setImageWithURL:[NSURL URLWithString:picURL]];
        if (userInf.Confirmed) {
            _identificationLabel.text = @"已认证";
            _identificationLabel.textColor = [UIColor colorWithRed:40/255.0 green:130/255.0 blue:246/255.0 alpha:1];
        } else {
            _identificationLabel.text = @"未认证";
            _identificationLabel.textColor = [UIColor orangeColor];
        }
        _userNameLabel.text = userInf.NickName;
        _identificationLabel.hidden = NO;
        _userNameLabel.hidden = NO;
        _loginBtn.hidden = YES;
    }
}

//未登录
-(void)didNotLogin{
    _isLogin = NO;
    _portraitImageView.image = [UIImage imageNamed:@"user"];
    _identificationLabel.hidden = YES;
    _userNameLabel.hidden = YES;
    _loginBtn.hidden = NO;
}

- (void)setUpCustomViews
{
    [self.view addSubview:self.menuImageView];
    [self.view addSubview:self.portraitImageView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.editBtn];
    [self.view addSubview:self.setBtn];
    [self.view addSubview:self.identificationLabel];
    [self.view addSubview:self.userNameLabel];
    [self.view addSubview:self.rootTableView];
}

#pragma mark - identificationLabel
-(UILabel *)identificationLabel
{
    if(!_identificationLabel){
        _identificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height*0.29, 100, 30)];
        _identificationLabel.font = [UIFont boldSystemFontOfSize:20];
        _identificationLabel.textAlignment = NSTextAlignmentCenter;
        _identificationLabel.hidden = YES;
    }
    return _identificationLabel;
}

#pragma mark - userNameLabel
-(UILabel *)userNameLabel
{
    if(!_userNameLabel){
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-self.view.frame.size.width*0.6)/2, self.view.frame.size.height*0.24, self.view.frame.size.width*0.6, 30)];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:20];
        _userNameLabel.adjustsFontSizeToFitWidth = YES;
        _userNameLabel.minimumScaleFactor = 10;
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.hidden = YES;
    }
    return _userNameLabel;
}

#pragma mark - menuImageView
-(UIImageView *)menuImageView
{
    if (!_menuImageView) {
         _menuImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.35)];
        UIImage * menuImage = [UIImage imageNamed:@"menu"];
        menuImage = [menuImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 120, 150) resizingMode:UIImageResizingModeStretch];
        _menuImageView.image = menuImage;
    }
    return _menuImageView;
}

#pragma mark - portraitImageView
-(UIImageView *)portraitImageView
{
    if(!_portraitImageView){
        CGFloat h = self.view.frame.size.height * 0.16;
        CGFloat w = h;
        CGFloat x = (self.view.frame.size.width - w) / 2;
        CGFloat y = (self.view.frame.size.height*0.3 - h) / 2;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.height/2;
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds = YES;
        _portraitImageView.image = [UIImage imageNamed:@"user"];
        _portraitImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

-(void)tapPortrait{
    if (_isLogin) {
        ShowImageViewController * showImageVC = [[ShowImageViewController alloc]initWithImageView:_portraitImageView];
        [self presentViewController:showImageVC animated:NO completion:nil];
    } else {
        [self login];
    }
}

#pragma mark - backBtn

-(UIButton *)backBtn
{
    if(!_backBtn){
        _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _backBtn.frame = CGRectMake(0, 20, 50, 50);
        _backBtn.backgroundColor = [UIColor clearColor];
        [_backBtn setImage:[[UIImage imageNamed:@"ic_arrow_back_white"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

-(void)back
{
    [self XYSideCloseVC];
}

#pragma mark - loginBtn

-(UIButton *)loginBtn
{
    if(!_loginBtn){
        _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginBtn.frame = CGRectMake(self.view.frame.size.width/2-60, self.view.frame.size.height * 0.245, 120, 50);
        [_loginBtn setTitle:@"登录 / 注册" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(void)login
{
    LoginViewController * loginViewController = [[LoginViewController alloc]init];
    loginViewController.title = @"登录";
    [self XYSidePushViewController:loginViewController animated:YES];
}

#pragma mark - editBtn

-(UIButton *)editBtn
{
    if(!_editBtn){
        _editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _editBtn.frame = CGRectMake(self.view.frame.size.width-50, 20, 50, 50);
        _editBtn.backgroundColor = [UIColor clearColor];
        [_editBtn setImage:[[UIImage imageNamed:@"ic_edit_white"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

-(void)edit
{
    if (_isLogin) {
        EditViewController * editCotroller = [[EditViewController alloc]initWithImage:_portraitImageView.image];
        editCotroller.title = @"编辑个人信息";
        [self XYSidePushViewController:editCotroller animated:YES];
    } else {
        [self login];
    }
}

#pragma mark - setBtn

-(UIButton *)setBtn
{
    if(!_setBtn){
        _setBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _setBtn.frame = CGRectMake(0, self.view.frame.size.height-48-10, 120, 48);
        _setBtn.backgroundColor = [UIColor clearColor];
        [_setBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_setBtn setImage:[[UIImage imageNamed:@"ic_settings_grey"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_setBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _setBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [_setBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -17, 0, 0)];
        [_setBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -7)];
        [_setBtn addTarget:self action:@selector(set) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setBtn;
}

-(void)set
{
    SettingViewController *settingViewController = [[SettingViewController alloc]init];
    settingViewController.title = @"设置";
    [self XYSidePushViewController:settingViewController animated:YES];
}

#pragma mark - rootTableView

- (UITableView *)rootTableView
{
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.35+10, self.view.frame.size.width, 55*_titleArray.count) style:UITableViewStylePlain];
        _rootTableView.delegate = self;
        _rootTableView.dataSource = self;
        _rootTableView.backgroundColor = [UIColor clearColor];
        _rootTableView.scrollsToTop = NO;
        _rootTableView.scrollEnabled = NO;
        _rootTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return _rootTableView;
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
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _titleArray[indexPath.row]];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", _imageArray[indexPath.row]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self XYSideCloseVC];
            break;
        case 1:{
            [self showAlertControllerWithTitle:@"温馨提示" message:@"该功能暂未开放，敬请期待！" handler:nil];
        }
            break;
        case 2:{
            MySignViewController *mySignViewController = [[MySignViewController alloc] init];
            mySignViewController.title = [NSString stringWithFormat:@"%@", _titleArray[indexPath.row]];
            [self XYSidePushViewController:mySignViewController animated:YES];
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
