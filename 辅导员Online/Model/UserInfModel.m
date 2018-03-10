//
//  UserInfModel.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/26.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "UserInfModel.h"

@implementation UserInfModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"UserInfModel类没有%@这个属性",key);
}

//解档方式
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _Activated = [coder decodeBoolForKey:@"Activated"];
        _Confirmed = [coder decodeBoolForKey:@"Confirmed"];
        _State = [coder decodeBoolForKey:@"State"];
        _Department = [coder decodeObjectForKey:@"Department"];
        _Email = [coder decodeObjectForKey:@"Email"];
        _FullName = [coder decodeObjectForKey:@"FullName"];
        _Message = [coder decodeObjectForKey:@"Message"];
        _NickName = [coder decodeObjectForKey:@"NickName"];
        _PhoneNumber = [coder decodeObjectForKey:@"PhoneNumber"];
        _Pid = [coder decodeObjectForKey:@"Pid"];
        _School = [coder decodeObjectForKey:@"School"];
        _SchoolName = [coder decodeObjectForKey:@"SchoolName"];
        _Sex = [coder decodeObjectForKey:@"Sex"];
        _UserName = [coder decodeObjectForKey:@"UserName"];
        _UserPicName = [coder decodeObjectForKey:@"UserPicName"];
        _UserType = [coder decodeObjectForKey:@"UserType"];
    }
    return self;
}

//归档方法
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeBool:_Activated forKey:@"Activated"];
    [coder encodeBool:_Confirmed forKey:@"Confirmed"];
    [coder encodeBool:_State forKey:@"State"];
    [coder encodeObject:_Department forKey:@"Department"];
    [coder encodeObject:_Email forKey:@"Email"];
    [coder encodeObject:_FullName forKey:@"FullName"];
    [coder encodeObject:_Message forKey:@"Message"];
    [coder encodeObject:_NickName forKey:@"NickName"];
    [coder encodeObject:_PhoneNumber forKey:@"PhoneNumber"];
    [coder encodeObject:_Pid forKey:@"Pid"];
    [coder encodeObject:_School forKey:@"School"];
    [coder encodeObject:_SchoolName forKey:@"SchoolName"];
    [coder encodeObject:_Sex forKey:@"Sex"];
    [coder encodeObject:_UserName forKey:@"UserName"];
    [coder encodeObject:_UserPicName forKey:@"UserPicName"];
    [coder encodeObject:_UserType forKey:@"UserType"];
}

+ (void)archiveWithObject:(NSObject *)obj{
    NSString *docDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *userInfPath = [docDirectory stringByAppendingPathComponent:@"userInf.archiver"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [data writeToFile:userInfPath atomically:YES];
}

+ (UserInfModel *)unarchive{
    NSString *docDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *userInfPath = [docDirectory stringByAppendingPathComponent:@"userInf.archiver"];
    NSData *data = [NSData dataWithContentsOfFile:userInfPath];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end

