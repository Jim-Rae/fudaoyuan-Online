//
//  PicTableViewCell.h
//  辅导员Online
//
//  Created by JackBryan on 2017/12/20.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *coverImgView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *contentTV;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *markLabel;

@end
