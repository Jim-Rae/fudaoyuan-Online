//
//  ViewModel.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/25.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "ViewModel.h"
#import "MyNetworking.h"
#import "VMconst.h"
#import "UserInfModel.h"

@implementation ViewModel

//登录
+ (void)loginWith:(NSDictionary *)UNandPWDic finish:(void(^)(BOOL success, BOOL validated, NSString *token))finish{
    [MyNetworking postRequestWithURLString:userValidateURL paramDic:UNandPWDic finish:^(BOOL success, NSDictionary *responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"登录响应数据不能解析");
                finish(NO,NO,nil);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    NSString *token = [responseObject valueForKey:@"Token"];
                    finish(YES,YES,token);
                } else {
                    finish(YES,NO,nil);
                }
            }
        } else {
            NSLog(@"登录请求失败");
            finish(NO,NO,nil);
        }
    }];
}

//退登
+ (void)logoutWithToken:(NSString *)token finish:(void(^)(BOOL success))finish{
    [MyNetworking getRequestWithURLString:[userLogoutURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]] progress:nil finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"退登响应数据不能解析");
                finish(NO);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    finish(YES);
                } else {
                    finish(NO);
                }
            }
        } else {
            NSLog(@"退登请求失败");
            finish(NO);
        }
    }];
}

//修改密码
+ (void)changPWeWithNewPW:(NSString *)newPW token:(NSString *)token finish:(void(^)(BOOL success))finish{
    [MyNetworking postRequestWithURLString:[userUpdateInfURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]] paramDic:@{@"password":newPW} finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"修改密码响应数据不能解析");
                finish(NO);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    finish(YES);
                } else {
                    finish(NO);
                }
            }
        } else {
            NSLog(@"修改密码请求失败");
            finish(NO);
        }
    }];
}

//修改昵称
+ (void)changNickNameWithNewNickName:(NSString *)newNickName token:(NSString *)token finish:(void(^)(BOOL success))finish{
    [MyNetworking postRequestWithURLString:[userUpdateInfURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]] paramDic:@{@"nickname":newNickName} finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"修改昵称响应数据不能解析");
                finish(NO);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    finish(YES);
                } else {
                    finish(NO);
                }
            }
        } else {
            NSLog(@"修改昵称请求失败");
            finish(NO);
        }
    }];
}

//发送邮箱验证码
+ (void)getMailCodeWithEmail:(NSString *)email finish:(void(^)(BOOL success, NSString *message))finish{
    [MyNetworking postRequestWithURLString:mailGetCodeURL paramDic:@{@"email":email,@"action":@"res"} finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"发送邮箱验证码响应数据不能解析");
                finish(NO,nil);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    finish(YES,nil);
                } else {
                    NSString *message = [responseObject valueForKey:@"Message"];
                    finish(YES,message);
                }
            }
        } else {
            NSLog(@"发送邮箱验证码请求失败");
            finish(NO,nil);
        }
    }];
}

//获取用户信息
+ (void)getUserInfWithToken:(NSString *)token finish:(void(^)(BOOL success))finish{
    [MyNetworking getRequestWithURLString:[getUserInfURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@",token]] progress:nil finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"获取用户信息响应数据不能解析");
                finish(NO);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    UserInfModel *userInfModel = [[UserInfModel alloc]init];
                    //KVC
                    [userInfModel setValuesForKeysWithDictionary:responseObject];
                    //归档
                    [UserInfModel archiveWithObject:userInfModel];
                    finish(YES);
                } else {
                    finish(NO);
                }
            }
        } else {
            NSLog(@"获取用户信息请求失败");
            finish(NO);
        }
    }];
}

//考勤
+ (void)checkInviteCodeWithToken:(NSString *)token invitecode:(NSString *)invitecode finish:(void(^)(BOOL success, NSString *message))finish{
    [MyNetworking getRequestWithURLString:[checkInviteCodeURL stringByAppendingString:[NSString stringWithFormat:@"?token=%@&invitecode=%@",token,invitecode]] progress:nil finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"考勤响应数据不能解析");
                finish(NO,nil);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    finish(YES,nil);
                } else {
                    NSString *message = [responseObject valueForKey:@"Message"];
                    finish(YES,message);
                }
            }
        } else {
            NSLog(@"考勤请求失败");
            finish(NO,nil);
        }
    }];
}

//上传头像
+ (void)uploadHeadPic:(UIImage *)image withToken:(NSString *)token finish:(void(^)(BOOL success))finish{
    [MyNetworking postRequestWithURLString:fileUpPicURL paramDic:@{@"token":token} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
         //对于图片进行压缩
         NSData *data = UIImageJPEGRepresentation(image, 0.7);
         // NSData *data = UIImagePNGRepresentation(image);
         [formData appendPartWithFileData:data name:@"1" fileName:@"image.png" mimeType:@"image/png"];
     }progress:^(NSProgress *uploadProgress) {
              NSLog(@"上传头像 = %@",uploadProgress);
     }finish:^(BOOL success,NSDictionary *responseObject,NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"上传头像响应数据不能解析");
                finish(NO);
            }else{
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    finish(YES);
                } else {
                    finish(NO);
                }
            }
        }else{
            NSLog(@"上传头像请求失败");
            finish(NO);
        }
    }];
}

//获取学校及学校代号列表
+ (void)getSchoolsFinish:(void(^)(BOOL success, NSArray *school))finish{
    [MyNetworking getRequestWithURLString:getSchoolsURL progress:nil finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"获取学校及学校代号列表响应数据不能解析");
                finish(NO,nil);
            } else {
                NSMutableArray *schoolsArr = [[NSMutableArray alloc]init];
                for (NSDictionary *school in responseObject) {
                    [schoolsArr addObject:[school valueForKey:@"name"]];
                }
                finish(YES,schoolsArr);
            }
        } else {
            NSLog(@"获取学校及学校代号列表请求失败");
            finish(NO,nil);
        }
    }];
}

//身份认证
+ (void)identifyWithInfDic:(NSDictionary *)infDic finish:(void(^)(BOOL success, NSString *message))finish{
    [MyNetworking postRequestWithURLString:userRealNameURL paramDic:infDic finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"身份认证响应数据不能解析");
                finish(NO,nil);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    finish(YES,nil);
                } else {
                    NSString *message = [responseObject valueForKey:@"Message"];
                    finish(YES,message);
                }
            }
        } else {
            NSLog(@"身份认证请求失败");
            finish(NO,nil);
        }
    }];
}

//取回密码
+ (void)updateLoginInfWithInfDic:(NSDictionary *)infDic finish:(void(^)(BOOL success, NSString *message))finish{
    [MyNetworking postRequestWithURLString:userUpdateLogInfURL paramDic:infDic finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"取回密码响应数据不能解析");
                finish(NO,nil);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    finish(YES,nil);
                } else {
                    NSString *message = [responseObject valueForKey:@"Message"];
                    finish(YES,message);
                }
            }
        } else {
            NSLog(@"取回密码请求失败");
            finish(NO,nil);
        }
    }];
}

//注册
+ (void)registerWithInfDic:(NSDictionary *)infDic finish:(void(^)(BOOL success, NSString *message))finish{
    [MyNetworking postRequestWithURLString:userRegisterURL paramDic:infDic finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"注册响应数据不能解析");
                finish(NO,nil);
            } else {
                if ([[responseObject objectForKey:@"State"]boolValue]) {
                    finish(YES,nil);
                } else {
                    NSString *message = [responseObject valueForKey:@"Message"];
                    finish(YES,message);
                }
            }
        } else {
            NSLog(@"注册请求失败");
            finish(NO,nil);
        }
    }];
}

//获取文章列表
+ (void)getPassageListWithSid:(NSString *)sid pageNo:(NSString *)pageNO pageSize:(NSString *)pageSize finish:(void(^)(BOOL success, NSArray<PassageListModel *> *listArr))finish{
    [MyNetworking getRequestWithURLString:[getpostlistURL stringByAppendingString:[NSString stringWithFormat:@"?sid=%@&pageNo=%@&pageSize=%@",sid,pageNO,pageSize]] progress:nil finish:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            if (responseObject==nil) {
                NSLog(@"获取文章列表响应数据不能解析");
                finish(NO,nil);
            } else {
                NSMutableArray<PassageListModel *> *listArr = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in responseObject) {
                    PassageListModel *passageListModel = [[PassageListModel alloc]init];
                    [passageListModel setValuesForKeysWithDictionary:dic];
                    [listArr addObject:passageListModel];
                }
                finish(YES,listArr);
            }
        } else {
            NSLog(@"获取文章列表请求失败");
            finish(NO,nil);
        }
    }];
}

#pragma mark - 验证邮箱格式
//利用正则表达式验证
+ (BOOL)isAvailableEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
