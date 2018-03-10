//
//  UserInfModel.h
//  辅导员Online
//
//  Created by JackBryan on 2017/12/26.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfModel : NSObject

@property (nonatomic, assign)BOOL Activated;
@property (nonatomic, assign)BOOL Confirmed;
@property (nonatomic, copy)NSString *Department;
@property (nonatomic, copy)NSString *Email;
@property (nonatomic, copy)NSString *FullName;
@property (nonatomic, copy)NSString *Message;
@property (nonatomic, copy)NSString *NickName;
@property (nonatomic, copy)NSString *PhoneNumber;
@property (nonatomic, copy)NSString *Pid;
@property (nonatomic, copy)NSString *School;
@property (nonatomic, copy)NSString *SchoolName;
@property (nonatomic, copy)NSString *Sex;
@property (nonatomic, assign)BOOL State;
@property (nonatomic, copy)NSString *UserName;
@property (nonatomic, copy)NSString *UserPicName;
@property (nonatomic, copy)NSString *UserType;

+ (void)archiveWithObject:(NSObject *)obj;

+ (NSObject *)unarchive;

@end
