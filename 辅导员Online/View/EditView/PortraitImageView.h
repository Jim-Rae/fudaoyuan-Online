//
//  PortraitImageView.h
//  辅导员Online
//
//  Created by JackBryan on 2017/11/16.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PortraitImageView;

@protocol PortraitImageViewDelegate <NSObject>

- (void)portraitImageViewDidTap:(PortraitImageView *)portraitImageView;

@end

@interface PortraitImageView : UIImageView

@property (nonatomic, assign) id<PortraitImageViewDelegate> delegate;
- (BOOL) isCameraAvailable;
- (BOOL) isRearCameraAvailable;
- (BOOL) isFrontCameraAvailable;
- (BOOL) doesCameraSupportTakingPhotos;
- (BOOL) isPhotoLibraryAvailable;
- (BOOL) canUserPickVideosFromPhotoLibrary;
- (BOOL) canUserPickPhotosFromPhotoLibrary;
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

@end
