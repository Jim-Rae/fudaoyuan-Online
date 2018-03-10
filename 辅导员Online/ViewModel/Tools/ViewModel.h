//
//  ViewModel.h
//  辅导员Online
//
//  Created by JackBryan on 2017/12/25.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PassageListModel.h"

@interface ViewModel : NSObject

//登录
+ (void)loginWith:(NSDictionary *)UNandPWDic finish:(void(^)(BOOL success, BOOL validated, NSString *token))finish;
//退登
+ (void)logoutWithToken:(NSString *)token finish:(void(^)(BOOL success))finish;
//修改密码
+ (void)changPWeWithNewPW:(NSString *)newPW token:(NSString *)token finish:(void(^)(BOOL success))finish;
//修改昵称
+ (void)changNickNameWithNewNickName:(NSString *)newNickName token:(NSString *)token finish:(void(^)(BOOL success))finish;
//发送邮箱验证码
+ (void)getMailCodeWithEmail:(NSString *)email finish:(void(^)(BOOL success, NSString *message))finish;
//获取用户信息
+ (void)getUserInfWithToken:(NSString *)token finish:(void(^)(BOOL success))finish;
//考勤
+ (void)checkInviteCodeWithToken:(NSString *)token invitecode:(NSString *)invitecode finish:(void(^)(BOOL success, NSString *message))finish;
//上传头像
+ (void)uploadHeadPic:(UIImage *)image withToken:(NSString *)token finish:(void(^)(BOOL success))finish;
//获取学校及学校代号列表
+ (void)getSchoolsFinish:(void(^)(BOOL success, NSArray *school))finish;
//身份认证
+ (void)identifyWithInfDic:(NSDictionary *)infDic finish:(void(^)(BOOL success, NSString *message))finish;
//取回密码
+ (void)updateLoginInfWithInfDic:(NSDictionary *)infDic finish:(void(^)(BOOL success, NSString *message))finish;
//注册
+ (void)registerWithInfDic:(NSDictionary *)infDic finish:(void(^)(BOOL success, NSString *message))finish;
//获取文章列表
+ (void)getPassageListWithSid:(NSString *)sid pageNo:(NSString *)pageNO pageSize:(NSString *)pageSize finish:(void(^)(BOOL success, NSArray<PassageListModel *> *listArr))finish;


//验证邮箱格式
+ (BOOL)isAvailableEmail:(NSString *)email;

@end
