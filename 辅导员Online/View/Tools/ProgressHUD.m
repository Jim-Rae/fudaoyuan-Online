//
//  ProgressHUD.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/25.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "ProgressHUD.h"
#import "UIView+GoodView.h"

#define SCREEN [UIScreen mainScreen].bounds.size
#define KEY_ANIMATION_ROTATE @"KEY_ANIMATION_ROTATE"

@interface ProgressHUD ()

@property (nonatomic,strong) NSString *tipText;
@property (nonatomic,strong) UIView *toast;
@property (nonatomic,strong) UIView *backView;

@end

@implementation ProgressHUD

#pragma mark 加载中动画
+ (instancetype)showProgressHUD:(NSString *)showText{
    ProgressHUD *hud = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds showText:showText];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES view:hud.toast];
    return hud;
}

#pragma mark 隐藏
+ (NSUInteger)hideAllHUDAnimated:(BOOL)animated{
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews =[UIApplication sharedApplication].keyWindow.subviews;
    for (UIView *aView in subviews)
    {
        if ([aView isKindOfClass:[ProgressHUD class]])
        {
            [huds addObject:aView];
        }
    }
    
    for (ProgressHUD *hud in huds)
    {
        [hud hide:animated view:hud.toast];
    }
    return [huds count];
}

static CGFloat toastWidth = 100;
- (instancetype)initWithFrame:(CGRect)frame showText:(NSString *)showText{
    self = [super initWithFrame:frame];
    if (self)
    {
        _backView = [[UIView alloc]initWithFrame:self.frame];
        _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        _tipText=showText;
        _toast = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - toastWidth) / 2, (self.frame.size.height - toastWidth) / 2 , toastWidth,toastWidth)];
        
        CGSize size = [self workOutSizeWithStr:showText andFont:14 value:[NSValue valueWithCGSize:CGSizeMake(self.frame.size.width-30, 999)]];
        if (size.width>100) {
            _toast.width=size.width+30;
        }
        _toast.center=CGPointMake(SCREEN.width/2, SCREEN.height/2);
        _toast.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _toast.layer.cornerRadius = 10;
        _toast.hidden = YES;
        [_backView addSubview:_toast];
        [self addSubview:_backView];
        
        [self loadingAnimated];

    }
    return self;
}

#pragma mark 加载动画
- (void)loadingAnimated {
    
    UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    testActivityIndicator.center = CGPointMake(_toast.width/ 2, _toast.height /2);//只能设置中心，不能设置大小
    [_toast addSubview:testActivityIndicator];
    [testActivityIndicator startAnimating];
    
    UILabel * showTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, testActivityIndicator.bottom+7, _toast.width-10, 20)];
    showTextLabel.text=_tipText;
    showTextLabel.font=[UIFont systemFontOfSize:14];
    showTextLabel.textColor=[UIColor whiteColor];
    showTextLabel.textAlignment=NSTextAlignmentCenter;
    [_toast addSubview:showTextLabel];
    
}

- (void)show:(BOOL)animated view:(UIView *)view
{
    view.hidden = NO;
    if (animated)
    {
        view.transform = CGAffineTransformScale(self.transform,0.2,0.2);
        
        [UIView animateWithDuration:.3 animations:^{
            view.transform = CGAffineTransformScale(self.transform,1.2,1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.3 animations:^{
                view.transform = CGAffineTransformIdentity;
            }];
        }];
    }
}

- (void)hide:(BOOL)animated view:(UIView *)view
{
    [UIView animateWithDuration:animated ? .3 : 0 animations:^{
        view.transform = CGAffineTransformScale(self.transform,1.2,1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animated ? .3 : 0 animations:^{
            view.transform = CGAffineTransformScale(self.transform,0.2,0.2);
        } completion:^(BOOL finished) {
            [view.layer removeAnimationForKey:KEY_ANIMATION_ROTATE];
            [self removeFromSuperview];
        }];
    }];
}

//动态计算高度
- (CGSize)workOutSizeWithStr:(NSString *)str andFont:(NSInteger)fontSize value:(NSValue *)value{
    if (!str) {
        str = @"";
    }
    CGSize size = CGSizeMake(0, 0);
    if (str) {
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
            NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
            size=[str boundingRectWithSize:[value CGSizeValue] options:NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        }
    }
    
    return size;
}

@end
