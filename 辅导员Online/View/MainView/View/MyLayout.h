//
//  MyLayout.h
//  辅导员Online
//
//  Created by JackBryan on 2017/12/19.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLayout : UICollectionViewFlowLayout

//总个数
@property(nonatomic,assign)int itemCount;
//列数
@property(nonatomic,assign)int InteritemCount;
//cell高度
@property(nonatomic,assign)CGFloat cellHight;

@end
