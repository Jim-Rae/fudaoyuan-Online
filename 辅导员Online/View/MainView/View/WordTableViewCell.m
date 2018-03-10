//
//  WordTableViewCell.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/20.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "WordTableViewCell.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface WordTableViewCell ()

@property (nonatomic, strong) UIView *whiteBG;
@property (nonatomic, strong) UIView *grayBG;


@end

@implementation WordTableViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    [self addSubview:self.whiteBG];
    [self.whiteBG addSubview:self.grayBG];
    [self.whiteBG addSubview:self.titleLabel];
    [self.whiteBG addSubview:self.contentTV];
    [self.grayBG addSubview:self.authorLabel];
    [self.grayBG addSubview:self.timeLabel];
}

- (UIView *)whiteBG{
    if (!_whiteBG) {
        CGFloat w = SCREEN_WIDTH-20;
        CGFloat h = 200;
        CGFloat x = (SCREEN_WIDTH-w)/2;
        CGFloat y = 10;
        _whiteBG = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _whiteBG.backgroundColor = [UIColor whiteColor];
        _whiteBG.layer.cornerRadius = 7;
        _whiteBG.layer.shadowColor = [UIColor blackColor].CGColor;
        _whiteBG.layer.shadowOffset = CGSizeMake(1, 1);
        _whiteBG.layer.shadowOpacity = 0.5;
        _whiteBG.layer.shadowRadius = 2.0;
    }
    return _whiteBG;
}

- (UIView *)grayBG{
    if (!_grayBG) {
        CGFloat w = SCREEN_WIDTH-20;
        CGFloat h = 40;
        CGFloat x = 0;
        CGFloat y = 155;
        _grayBG = [[UIView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _grayBG.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    }
    return _grayBG;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        CGFloat w = SCREEN_WIDTH-40;
        CGFloat h = 55;
        CGFloat x = 10;
        CGFloat y = 0;
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:22];
    }
    return _titleLabel;
}

- (UITextView *)contentTV{
    if (!_contentTV) {
        CGFloat w = SCREEN_WIDTH-23;
        CGFloat h = 105;
        CGFloat x = 3;
        CGFloat y = 45;
        _contentTV = [[UITextView alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _contentTV.font = [UIFont systemFontOfSize:16];
        _contentTV.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1];
        _contentTV.textAlignment = NSTextAlignmentLeft;
        _contentTV.editable = NO;
        _contentTV.scrollEnabled = NO;
        _contentTV.userInteractionEnabled = NO;
    }
    return _contentTV;
}

- (UILabel *)authorLabel{
    if (!_authorLabel) {
        CGFloat w = (SCREEN_WIDTH-20)*0.6f-10;
        CGFloat h = 40;
        CGFloat x = 10;
        CGFloat y = 0;
        _authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _authorLabel.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1];
        _authorLabel.textAlignment = NSTextAlignmentLeft;
        _authorLabel.font = [UIFont systemFontOfSize:16];
    }
    return _authorLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        CGFloat w = (SCREEN_WIDTH-20)*0.4f-10;
        CGFloat h = 40;
        CGFloat x = SCREEN_WIDTH-30-w;
        CGFloat y = 0;
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, y, w, h)];
        _timeLabel.textColor = [UIColor colorWithRed:104/255.0 green:104/255.0 blue:104/255.0 alpha:1];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:16];
    }
    return _timeLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
