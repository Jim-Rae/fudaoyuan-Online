//
//  PassageListModel.h
//  辅导员Online
//
//  Created by JackBryan on 2017/12/27.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PassageListModel : NSObject

@property (nonatomic, assign)BOOL isheadline;
@property (nonatomic, copy)NSString *SignatureAuthor;
@property (nonatomic, copy)NSString *abstract;
@property (nonatomic, copy)NSString *author;
@property (nonatomic, copy)NSString *classify;
@property (nonatomic, copy)NSString *coverpic;
@property (nonatomic, copy)NSString *favnum;
@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *keyword;
@property (nonatomic, copy)NSString *posttime;
@property (nonatomic, copy)NSString *source;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *visitnum;

@end
