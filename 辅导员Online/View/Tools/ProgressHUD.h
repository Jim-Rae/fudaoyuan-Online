//
//  ProgressHUD.h
//  辅导员Online
//
//  Created by JackBryan on 2017/12/25.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressHUD : UIView

+ (instancetype)showProgressHUD:(NSString *)showText;

+ (NSUInteger)hideAllHUDAnimated:(BOOL)animated;

@end
