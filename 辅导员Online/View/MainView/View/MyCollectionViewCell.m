//
//  MyCollectionViewCell.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/19.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "MyCollectionViewCell.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation MyCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        [self setupSubView];
    }
    return self;
}

-(void)setupSubView{
    [self.contentView addSubview:self.iconImgView];
    [self.contentView addSubview:self.titleLabel];
}

-(UIImageView *)iconImgView{
    if (!_iconImgView) {
        CGFloat h = HEIGHT*0.4f;
        CGFloat w = h;
        CGFloat x = (WIDTH-w)/2;
        CGFloat y = HEIGHT*0.2f;
        _iconImgView=[[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
    }
    return _iconImgView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        CGFloat h = HEIGHT*0.1f;
        CGFloat w = WIDTH*0.8f;
        CGFloat x = (WIDTH-w)/2;
        CGFloat y = HEIGHT*0.7f;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.5f;
        _titleLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end


