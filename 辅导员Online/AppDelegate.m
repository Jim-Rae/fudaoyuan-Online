//
//  AppDelegate.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/5.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "AppDelegate.h"
#import "XYSideViewController.h"
#import "SideViewController.h"
#import "MainViewController.h"
#import <IQKeyboardManager.h>
#import <AFNetworkReachabilityManager.h>

#define offset ([UIScreen mainScreen].bounds.size.width * 3/4)

@interface AppDelegate ()

@end

@implementation AppDelegate

//添加观察者
-(void)addObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLogin) name:@"isLogin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didNotLogin) name:@"isNotLogin" object:nil];
}

//移除观察者
-(void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"isLogin" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"isNotLogin" object:nil];
}

//已经登录
-(void)didLogin{
    _isLogin = YES;
}

//未登录
-(void)didNotLogin{
    _isLogin = NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _isLogin = NO;
    _networkConnected = NO;
    
    //关闭设置为NO, 默认值为NO.
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    //添加观测者
    [self addObserver];
    
    //测拉VC
    SideViewController * sideViewController = [[SideViewController alloc]init];
    sideViewController.sideContentOffset = offset;
    
    //主VC
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
    //设置导航栏的颜色
    navController. navigationBar.barTintColor = [UIColor colorWithRed:80/255.0 green:177/255.0 blue:80/255.0 alpha:1];
    //设置导航标题的颜色
    navController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //设置导航返回按钮的颜色
    navController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    // 初始化XYSideViewController 设置为window.rootViewController
    XYSideViewController *rootViewController = [[XYSideViewController alloc] initWithSideVC:sideViewController currentVC:navController];
    rootViewController.sideContentOffset = offset;
    self.window.rootViewController = rootViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
