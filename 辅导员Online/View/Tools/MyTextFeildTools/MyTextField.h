//
//  MyTextField.h
//  辅导员Online
//
//  Created by JackBryan on 2017/11/17.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BRTapAcitonBlock)();
typedef void(^BREndEditBlock)(NSString *text);

@interface MyTextField : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLabel;

/** textField 的点击回调 */
@property (nonatomic, copy) BRTapAcitonBlock tapAcitonBlock;
/** textField 结束编辑的回调 */
@property (nonatomic, copy) BREndEditBlock endEditBlock;

- (void)didTapTextField;

@end
