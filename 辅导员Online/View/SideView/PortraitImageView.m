//
//  PortraitImageView.m
//  辅导员Online
//
//  Created by JackBryan on 2017/11/15.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "PortraitImageView.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
//回弹时间
#define BOUNDCE_DURATION 0.3f

@interface PortraitImageView ()

@property(nonatomic, assign) int flag;
@property(nonatomic, assign) CGRect oldFrame;
@property(nonatomic, assign) CGRect latestFrame;
@property(nonatomic, assign) CGRect largeFrame;

@end

@implementation PortraitImageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer];
    }
    return self;
}

-(void)setOldFrame:(CGRect)oldFrame largeRatio:(CGFloat)ratio{
    _oldFrame = oldFrame;
    _latestFrame = oldFrame;
    _latestFrame = CGRectMake(0, 0, ratio * _oldFrame.size.width, ratio * _oldFrame.size.height);
    _flag = 0;
}

#pragma mark - 手势

-(void)addGestureRecognizer{
    //添加单击手势
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTapGestureRecognizer];
    
    //添加双击手势
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    doubleTapGestureRecognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTapGestureRecognizer];
    
    //只有当doubleTapGestureRecognizer识别失败的时候(即识别出这不是双击操作)，singleTapGestureRecognizer才能开始识别
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    
    //添加长按手势
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(didLongPress:)];
    //判定为长按手势 需要的时间
    longPressGestureRecognizer.minimumPressDuration = 1;
    //判定时间,允许用户移动的距离
    longPressGestureRecognizer.allowableMovement = 100;
    [self addGestureRecognizer:longPressGestureRecognizer];
    
    // 添加pinch捏合手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    // 添加pan平移手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self addGestureRecognizer:panGestureRecognizer];
}

//单击手势
-(void)didSingleTap:(UITapGestureRecognizer *)singleTapGestureRecognizer{
    [self.delegate portrait:self didSingleTapGesture:singleTapGestureRecognizer];
}

//双击手势
-(void)didDoubleTap:(UITapGestureRecognizer *)doubleTapGestureRecognizer{
    if (_flag==0) {
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake((SCREEN_SIZE.width-_largeFrame.size.width)/2, (SCREEN_SIZE.height-_largeFrame.size.height)/2., _largeFrame.size.width, _largeFrame.size.height);
        }completion:^(BOOL finished) {
            _latestFrame = self.frame;
            _flag = 1;
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = _oldFrame;
        }completion:^(BOOL finished) {
            _latestFrame = self.frame;
            _flag = 0;
        }];
    }
}

//长按手势
-(void)didLongPress:(UILongPressGestureRecognizer *)longPressGestureRecognizer{
    [self.delegate portrait:self didLongPressGesture:longPressGestureRecognizer];
}

// pinch捏合手势
- (void) didPinch:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        self.transform = CGAffineTransformScale(self.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        CGRect newFrame = self.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.frame = newFrame;
            _latestFrame = newFrame;
        }];
    }
}

// pan平移手势
- (void) didPan:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // 计算accelerator
        CGFloat absCenterX = 0 + SCREEN_SIZE.width / 2;
        CGFloat absCenterY = 0 + SCREEN_SIZE.height / 2;
        CGFloat scaleRatio = self.frame.size.width / SCREEN_SIZE.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - self.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - self.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:self.superview];
        [self setCenter:(CGPoint){self.center.x + translation.x * acceleratorX, self.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:self.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // 回弹到original frame
        CGRect newFrame = self.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.frame = newFrame;
            _latestFrame = newFrame;
        }];
    }
}

#pragma mark - 回弹效果

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // 回弹到original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < _oldFrame.size.width) {
        newFrame = _oldFrame;
    }
    if (newFrame.size.width > _largeFrame.size.width) {
        newFrame = _largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // 水平位置
    if (newFrame.origin.x > 0) newFrame.origin.x = 0;
    if (CGRectGetMaxX(newFrame) < SCREEN_SIZE.width) newFrame.origin.x = SCREEN_SIZE.width - newFrame.size.width;
    // 垂直位置
    if (newFrame.origin.y > 0) newFrame.origin.y = 0;
    if (CGRectGetMaxY(newFrame) < 0 + SCREEN_SIZE.height) {
        newFrame.origin.y = 0 + SCREEN_SIZE.height - newFrame.size.height;
    }
    // 适配矩形框
    if (_oldFrame.size.width >= _oldFrame.size.height && newFrame.size.height <= SCREEN_SIZE.height) {
        newFrame.origin.y = 0 + (SCREEN_SIZE.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

@end
