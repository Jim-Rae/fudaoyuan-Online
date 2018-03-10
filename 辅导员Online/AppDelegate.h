//
//  AppDelegate.h
//  辅导员Online
//
//  Created by JackBryan on 2017/11/5.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIImageView * upView;

@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) BOOL networkConnected;

@end

