//
//  UIImage+Scaled.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/22.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "UIImage+Scaled.h"

@implementation UIImage (Scaled)

+(UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    
    UIImage*newImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
    
}

@end
