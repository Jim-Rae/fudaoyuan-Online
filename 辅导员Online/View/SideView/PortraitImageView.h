//
//  PortraitImageView.h
//  辅导员Online
//
//  Created by JackBryan on 2017/11/15.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PortraitImageView;

@protocol PortraitDelegate <NSObject>

@optional

- (void)portrait:(PortraitImageView *)portraitImageView didSingleTapGesture:(UITapGestureRecognizer *)singleTapGesture;

- (void)portrait:(PortraitImageView *)portraitImageView didLongPressGesture:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

@end

@interface PortraitImageView : UIImageView

@property(nonatomic, assign) id<PortraitDelegate> delegate;

-(void)setOldFrame:(CGRect)oldFrame largeRatio:(CGFloat)ratio;

@end
