//
//  XYSideViewController.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/5.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "XYSideViewController.h"
#import <AFNetworkReachabilityManager.h>
#import "AppDelegate.h"
#import "MyUserDefaults.h"
#import "ViewModel.h"
#import "UIViewController+XYSideCategory.h"

#define FULL_SCREEN [UIApplication sharedApplication].keyWindow.frame.size

@interface XYSideViewController () <UIGestureRecognizerDelegate>
{
    CGFloat XYScreenWidth; // 屏幕宽度
    CGFloat XYSccreenHeight; // 屏幕高度
    CGPoint viewStartCenterPoint; // self.view.center
    UIView *tapView; // Tap手势View
    CGPoint beginPoint; // 主VC初始center
    CGPoint beginSidePoint; // 侧拉VC初始center
    UIVisualEffectView * effectView; //毛玻璃视觉管理类
    BOOL flag;
}
@end

@implementation XYSideViewController

- (instancetype)initWithSideVC:(UIViewController *)sideMenuVC currentVC:(UIViewController *)currentMainVC
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (rootVC && [rootVC isKindOfClass:[self class]]) {
        return (XYSideViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    }
    
    if (self = [super init]) {
        XYScreenWidth = [UIScreen mainScreen].bounds.size.width;
        XYSccreenHeight = [UIScreen mainScreen].bounds.size.height;
        viewStartCenterPoint = self.view.center;
        _currentVC = currentMainVC;
        _sideVC = sideMenuVC;
        _sideContentOffset = XYScreenWidth * 3 / 4;
        _currentVCPanEnableRange = 100;
        _isSide = YES;
        beginPoint = self.view.center;
        CGPoint point = self.view.center;
        point.x = 0;
        beginSidePoint = point;
        [self setUpViewControllers];
        [self AFNetworkStatus];
        [self addObserver];
    }
    return self;
}

- (void)AFNetworkStatus{
    
    //1.创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block  可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络状态");
                ((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected = NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"noNetwork" object:nil];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                ((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected = NO;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"noNetwork" object:nil];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝数据网");
                ((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected = YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"hadNetwork" object:nil];
                if (flag) {
                    [self autoLogin];
                    flag = NO;
                }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi网络");
                ((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected = YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"hadNetwork" object:nil];
                if (flag) {
                    [self autoLogin];
                    flag = NO;
                }
                break;
                
            default:
                break;
        }
    }];
    [manager startMonitoring];
}

//添加观察者
-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noNetwork) name:@"noNetwork" object:nil];
}

//移除观察者
-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"noNetwork" object:nil];
}

-(void)noNetwork{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"网络已断开" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //按钮添加
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)dealloc{
    [self removeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    flag = NO;
    [self autoLogin];
}

- (void)autoLogin{
    NSDictionary *loginDic = [MyUserDefaults getDictionaryFromUserDefaultsWithValuesForKeys:@[@"UserName",@"PassWord"]];
    if (!([[loginDic valueForKey:@"UserName"] isEqual:[NSNull null]]||[[loginDic valueForKey:@"PassWord"] isEqual:[NSNull null]])) {
        [ViewModel loginWith:loginDic finish:^(BOOL success, BOOL validated, NSString *token) {
            if (success) {
                if (validated) {
                    ((AppDelegate *)[UIApplication sharedApplication].delegate).token = token;
                    [self showAlertControllerWithTitle:@"登录成功" message:nil handler:^{
                        [ViewModel getUserInfWithToken:token finish:^(BOOL success) {
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"isLogin" object:nil];
                        }];
                    }];
                } else {
//                    [self showAlertControllerWithTitle:@"登录失败" message:@"账号或密码错误" handler:nil];
                }
            } else {
                if (((AppDelegate *)[UIApplication sharedApplication].delegate).networkConnected) {
                    [self showAlertControllerWithTitle:@"登录失败" message:@"服务器内部错误" handler:nil];
                } else {
                    [self showAlertControllerWithTitle:@"登录失败" message:@"请检查网络连接情况" handler:^{
                        flag = YES;
                    }];
                }
                
            }
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self launchAnimation];
}

//#pragma mark - 启动动画
//- (void)launchAnimation {
//    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
//    UIView *launchView = viewController.view;
//    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
//    launchView.frame = [UIApplication sharedApplication].keyWindow.frame;
//    [mainWindow addSubview:launchView];
//
//    UIImageView * bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, FULL_SCREEN.height+FULL_SCREEN.height*0.25-5, FULL_SCREEN.width, FULL_SCREEN.height*0.25)];
//    bottomView.image = [UIImage imageNamed:@"bottom_background"];
//    [launchView addSubview:bottomView];
//
//    UIImageView * logoView = [[UIImageView alloc]initWithFrame:CGRectMake((FULL_SCREEN.width-FULL_SCREEN.height*0.25*384/369)/2, FULL_SCREEN.height, FULL_SCREEN.height*0.25*384/369, FULL_SCREEN.height*0.25)];
//    logoView.image = [UIImage imageNamed:@"logo"];
//    [launchView addSubview:logoView];
//
//    [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//        bottomView.frame = CGRectMake(0, FULL_SCREEN.height-FULL_SCREEN.height*0.2-5, FULL_SCREEN.width, FULL_SCREEN.height*0.25);
//        logoView.frame = CGRectMake((FULL_SCREEN.width-FULL_SCREEN.height*0.25*384/369)/2, FULL_SCREEN.height-FULL_SCREEN.height*0.25-FULL_SCREEN.height*0.2+5, FULL_SCREEN.height*0.25*384/369, FULL_SCREEN.height*0.25);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            launchView.alpha = 0;
//            launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
//        } completion:^(BOOL finished) {
//            [launchView removeFromSuperview];
//        }];
//    }];
//}

- (void)setUpViewControllers
{
    [self addChildViewController:_sideVC];
    _sideVC.view.center = CGPointMake(0, self.view.center.y);
    _sideVC.view.bounds = CGRectMake(0, 0, _sideContentOffset, XYSccreenHeight);
    
    [self.view addSubview:_sideVC.view];
    _currentVC.view.frame = CGRectMake(0, 0, XYScreenWidth, XYSccreenHeight);
    [_currentVC.view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [_currentVC.view addGestureRecognizer:panGestureRecognizer];
    panGestureRecognizer.delegate = self;
    
    effectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    effectView.frame = _currentVC.view.frame;
    effectView.alpha = 0;
    [_currentVC.view addSubview:effectView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesure:)];
    tapView = [[UIView alloc] init];
    tapView.frame = CGRectMake(0, 0, XYScreenWidth - _sideContentOffset, XYSccreenHeight);
    [tapView addGestureRecognizer:tapGesture];
    tapView.hidden = YES;
    [_currentVC.view addSubview:tapView];
    [self.view addSubview:_currentVC.view];
}

#pragma mark - tap 手势, 关闭侧拉栏
- (void)tapGesure:(UITapGestureRecognizer *)tap
{
    [self closeSideVC];
}
#pragma mark - pan手势 打开侧拉栏, 关闭侧拉栏, tap手势关闭侧拉栏
- (void)panGesture:(UIPanGestureRecognizer *)pan
{
    if (![self isPushViewController] || !_isSide) {
        return ;
    }
    CGPoint point =  [pan velocityInView:_currentVC.view];
    CGPoint movePoint = [pan translationInView:_currentVC.view];
    CGPoint tabBarCenterPoint = _currentVC.view.center;
    if (pan.state == UIGestureRecognizerStateChanged) {
        // 手势滑动时相对改变侧拉VC和主VC的center
        CGPoint tabBarVCCenter = beginPoint;
        CGPoint sideVCCenter = beginSidePoint;
        tabBarVCCenter.x = beginPoint.x + movePoint.x;
        sideVCCenter.x = beginSidePoint.x + ((movePoint.x * (_sideContentOffset / 2)) / _sideContentOffset);
        if (tabBarVCCenter.x >= viewStartCenterPoint.x  && (viewStartCenterPoint.x + _sideContentOffset) >= tabBarVCCenter.x) {
            _currentVC.view.center = tabBarVCCenter;
            _sideVC.view.center = sideVCCenter;
            effectView.alpha = 0.5*((tabBarVCCenter.x-viewStartCenterPoint.x)/_sideContentOffset);
        }else if (viewStartCenterPoint.x > tabBarVCCenter.x){
            _currentVC.view.center = self.view.center;
            CGPoint point = self.view.center;
            point.x = 0;
            _sideVC.view.center = point;
        }else if (tabBarVCCenter.x > (viewStartCenterPoint.x + _sideContentOffset)) {
            CGPoint point = self.view.center;
            point.x = viewStartCenterPoint.x + _sideContentOffset;
            _currentVC.view.center = point;
            point.x = _sideContentOffset / 2;
            _sideVC.view.center = point;
        }
        
    }else if (pan.state == UIGestureRecognizerStateEnded) {
        // 根据手势停止的位置决定关闭/代开侧拉VC
        CGFloat changeX = fabs(point.x);
        CGFloat changeY = fabs(point.y);
        if (changeX > changeY && changeX > 50) {
            if (point.x > 0) {
                [self openSideVC];
            }else {
                [self closeSideVC];
            }
        }else {
            if ((tabBarCenterPoint.x > self.view.center.x) && (self.view.center.x + (_sideContentOffset / 2) >= tabBarCenterPoint.x)) {
                [self closeSideVC];
            }else if (tabBarCenterPoint.x > (self.view.center.x + (_sideContentOffset / 2)) && (self.view.center.x + _sideContentOffset) >= tabBarCenterPoint.x) {
                [self openSideVC];
            }
        }
    }
}

#pragma mark - 关闭侧拉栏
- (void)closeSideVC
{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        _currentVC.view.center = weakSelf.view.center;
        CGPoint point = weakSelf.view.center;
        point.x = 0;
        _sideVC.view.center = point;
        effectView.alpha = 0;
    }completion:^(BOOL finished) {
        beginPoint = _currentVC.view.center;
        beginSidePoint = _sideVC.view.center;
    }];
}

#pragma mark - 打开侧拉栏
- (void)openSideVC
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint point = weakSelf.view.center;
        point.x = viewStartCenterPoint.x + _sideContentOffset;
        _currentVC.view.center = point;
        point.x = _sideContentOffset / 2;
        _sideVC.view.center = point;
        effectView.alpha = 0.5;
    }completion:^(BOOL finished) {
        beginPoint = _currentVC.view.center;
        beginSidePoint = _sideVC.view.center;
    }];
}

#pragma mark - 手势代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint beginPointInView = [touch locationInView:_currentVC.view];
    // 控制pan手势范围
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (beginPointInView.x < _currentVCPanEnableRange) {
            return [self isPushViewController];
        }else {
            return NO;
        }
    }
    return NO;
}

#pragma mark -- 判断currentVC导航控制器是否位于根控制器
- (BOOL)isPushViewController
{
    NSArray *viewControllers = [[NSArray alloc] init];
    viewControllers = self.currentNavController.viewControllers;
    if (viewControllers.count == 1) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark - 监听currentVC.center 隐藏tapView
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"center"]) {
        NSValue *centerPoint =  change[@"new"];
        CGPoint point = [centerPoint CGPointValue];
        if (point.x == (viewStartCenterPoint.x + _sideContentOffset)) {
            tapView.hidden = NO;
        }else {
            tapView.hidden = YES;
        }
    }
}

#pragma mark --- 获取主VC当前的导航控制器
- (UINavigationController *)currentNavController
{
    UINavigationController *currentNavVC = [[UINavigationController alloc] init];
    if ([_currentVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)_currentVC;
        currentNavVC = navVC;
    }else if ([_currentVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarVC = (UITabBarController *)_currentVC;
        currentNavVC = tabBarVC.childViewControllers[tabBarVC.selectedIndex];
    }
    return currentNavVC;
}

#pragma mark - sideContentOffset Setter
- (void)setSideContentOffset:(CGFloat)sideContentOffset
{
    _sideContentOffset = sideContentOffset;
    _sideVC.view.frame = CGRectMake(- _sideContentOffset / 2, 0, _sideContentOffset, XYSccreenHeight);
    _currentVC.view.frame = CGRectMake(0, 0, XYScreenWidth, XYSccreenHeight);
    tapView.frame = CGRectMake(0, 0, (XYScreenWidth - _sideContentOffset), XYSccreenHeight);
}

#pragma mark - 判断滑动方向
- (void)directByPointInVelocity:(CGPoint )point
{
    // 根据x坐标来分析滑动的方向
    CGFloat changeX = fabs(point.x);
    CGFloat changeY = fabs(point.y);
    if (changeX > changeY && changeX > 20) {
        if (point.x > 0) {
        }else {
        }
    }
}

@end

