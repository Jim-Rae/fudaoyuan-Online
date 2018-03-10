//
//  PicTableViewCell.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/20.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "PicTableViewCell.h"
#import "UIImage+Scaled.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PicTableViewCell ()

@property (nonatomic, strong) UIView *BGView;
@property (nonatomic, strong) UIImageView *portraitImageView;


@end

@implementation PicTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    [self addSubview:self.BGView];
    [self.BGView addSubview:self.coverImgView];
    [self.BGView addSubview:self.portraitImageView];
    [self.BGView addSubview:self.authorLabel];
    [self.BGView addSubview:self.titleLabel];
    [self.BGView addSubview:self.contentTV];
    [self.BGView addSubview:self.timeLabel];
    [self.BGView addSubview:self.markLabel];
}

-(UIView *)BGView{
    if (!_BGView) {
        CGFloat w = SCREEN_WIDTH-20;
        CGFloat h = SCREEN_HEIGHT-64-20;
        CGFloat x = 10;
        CGFloat y = 64+10;
        _BGView = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _BGView.backgroundColor = [UIColor whiteColor];
    }
    return _BGView;
}

-(UIImageView *)coverImgView{
    if (!_coverImgView) {
        CGFloat w = self.BGView.frame.size.width-10;
        CGFloat h = self.BGView.frame.size.height*0.75f;
        CGFloat x = 5;
        CGFloat y = 5;
        _coverImgView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        
        _coverImgView.contentMode = UIViewContentModeCenter;
        _coverImgView.clipsToBounds = YES;
    }
    return _coverImgView;
}

-(UIImageView *)portraitImageView
{
    if(!_portraitImageView){
        CGFloat h = 50;
        CGFloat w = h;
        CGFloat x = 20;
        CGFloat y = 20;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.height/2;
        _portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        _portraitImageView.clipsToBounds = YES;
        _portraitImageView.image = [UIImage imageNamed:@"user"];
    }
    return _portraitImageView;
}

-(UILabel *)authorLabel{
    if (!_authorLabel) {
        CGFloat h = 20;
        CGFloat w = 200;
        CGFloat x = 80;
        CGFloat y = 35;
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _authorLabel.font = [UIFont boldSystemFontOfSize:18];
        _authorLabel.minimumScaleFactor = 0.5f;
        _authorLabel.adjustsFontSizeToFitWidth = YES;
        _authorLabel.textColor = [UIColor whiteColor];
        
    }
    return _authorLabel;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        CGFloat h = 20;
        CGFloat w = self.BGView.frame.size.width-40;
        CGFloat x = 20;
        CGFloat y = self.BGView.frame.size.height*0.7f;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UITextView *)contentTV{
    if (!_contentTV) {
        CGFloat w = self.BGView.frame.size.width-20;
        CGFloat h = self.BGView.frame.size.height*0.18f;
        CGFloat x = 12;
        CGFloat y = self.BGView.frame.size.height*0.75f+10;
        _contentTV = [[UITextView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _contentTV.font = [UIFont systemFontOfSize:14];
        _contentTV.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1];
        _contentTV.textAlignment = NSTextAlignmentLeft;
        _contentTV.editable = NO;
        _contentTV.scrollEnabled = NO;
        _contentTV.userInteractionEnabled = NO;
    }
    return _contentTV;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        CGFloat w = self.BGView.frame.size.width*0.5f;
        CGFloat h = 20;
        CGFloat x = 12;
        CGFloat y = self.BGView.frame.size.height-30;
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _timeLabel.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _timeLabel;
}

- (UILabel *)markLabel{
    if (!_markLabel) {
        CGFloat w = self.BGView.frame.size.width*0.5f;
        CGFloat h = 20;
        CGFloat x = w-12;
        CGFloat y = self.BGView.frame.size.height-30;
        _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _markLabel.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1];
        _markLabel.textAlignment = NSTextAlignmentRight;
        _markLabel.font = [UIFont systemFontOfSize:14];
    }
    return _markLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
