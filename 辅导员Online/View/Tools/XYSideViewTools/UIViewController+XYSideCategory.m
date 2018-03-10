//
//  UIViewController+XYSideCategory.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/7.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "UIViewController+XYSideCategory.h"
#import "XYSideViewController.h"

@implementation UIViewController (XYSideCategory)

- (XYSideViewController *)sideViewController
{
    return (XYSideViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
}

- (void)XYSidePushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.sideViewController closeSideVC];
    [self.sideViewController.currentNavController pushViewController:viewController animated:animated];
}

- (void)XYSideOpenVC
{
    [self.sideViewController openSideVC];
}

- (void)XYSideCloseVC
{
    [self.sideViewController closeSideVC];
}

- (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)())handler{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:
        handler];
    //按钮添加
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
