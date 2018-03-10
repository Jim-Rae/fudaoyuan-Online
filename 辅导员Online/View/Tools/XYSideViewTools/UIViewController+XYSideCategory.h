//
//  UIViewController+XYSideCategory.h
//  辅导员Online
//
//  Created by JackBryan on 2017/11/7.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYSideViewController;

@interface UIViewController (XYSideCategory)

/**
 获取XYSideViewController
 */
@property (nonatomic, strong, readonly)XYSideViewController *sideViewController;
/**
 左侧VC push操作
 */
- (void)XYSidePushViewController:(UIViewController *)viewController animated:(BOOL)animated;
/**
 打开侧拉栏
 */
- (void)XYSideOpenVC;
/**
 关闭侧拉栏
 */
- (void)XYSideCloseVC;

- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)())handler;

@end
