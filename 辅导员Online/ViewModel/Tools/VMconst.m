//
//  VMconst.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/24.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  学校及学校代号列表接口
 *
 *       方法：get
 *  请求行参数：
 *  请求体参数：
 */
NSString *const getSchoolsURL = @"http://fx.scnu.edu.cn/api/GetSchools.ashx";

/**
 *  退出登录接口
 *
 *       方法：get
 *  请求行参数：token(必须)
 *  请求体参数：
 */
NSString *const userLogoutURL = @"https://fx.scnu.edu.cn/api/UserLogout.ashx";

/**
 *  取回密码接口
 *
 *       方法：post
 *  请求行参数：
 *  请求体参数：vcode(验证码)(必须)  password(密码)(必须)  email(邮箱)(必须)
 */
NSString *const userUpdateLogInfURL = @"https://fx.scnu.edu.cn/api/UserUpdateLogInf.ashx";

/**
 *  发送邮箱验证码
 *
 *       方法：post
 *  请求行参数：
 *  请求体参数：email(邮箱)(必须)  action(res)(必须)
 */
NSString *const mailGetCodeURL = @"https://fx.scnu.edu.cn/api/MailGetCode.ashx";

/**
 *  更新用户信息接口
 *
 *       方法：post
 *  请求行参数：token(必须)
 *  请求体参数：nickname(昵称)(可选)  password(密码)(可选)
 */
NSString *const userUpdateInfURL = @"https://fx.scnu.edu.cn/api/UserUpdateInf.ashx";

/**
 *  点赞接口
 *
 *       方法：get
 *  请求行参数：token(必须)  pid(文章id)(必须)  ack(点赞动作)(1是点赞，2是取消点赞)(必须)
 *  请求体参数：
 */
NSString *const postActionURL = @"https://fx.scnu.edu.cn/api/PostAction.ashx";

/**
 *  上传头像接口
 *
 *       方法：post
 *  请求行参数：
 *  请求体参数：token(必须)   图片(必须)
 */
NSString *const fileUpPicURL = @"https://fx.scnu.edu.cn/api/FileUpPic.ashx";

/**
 *  获取用户信息接口
 *
 *       方法：get
 *  请求行参数：
 *  请求体参数：token(必须)   图片(必须)
 */
NSString *const getUserInfURL = @"https://fx.scnu.edu.cn/api/GetUserInf.ashx";

/**
 *  获取文章列表接口
 *
 *       方法：get
 *  请求行参数：sid(必须)  pageNo(可选)   pageSize(可选)
 *  请求体参数：
 */
NSString *const getpostlistURL = @"http://fx.scnu.edu.cn/api/getpostlist.ashx";

/**
 *  提交注册信息接口
 *
 *       方法：post
 *  请求行参数：
 *  请求体参数：email(必须)  password(必须)
 */
NSString *const userRegisterURL = @"https://fx.scnu.edu.cn/api/UserRegister.ashx";

/**
 *  考勤接口
 *
 *       方法：get
 *  请求行参数：token(必须)  invidecode(必须)
 *  请求体参数：
 */
NSString *const checkInviteCodeURL = @"http://fx.scnu.edu.cn/api/CheckInviteCode.ashx";

/**
 *  登录接口
 *
 *       方法：post
 *  请求行参数：
 *  请求体参数：UserName(必须)  Password(必须)
 */
NSString *const userValidateURL = @"https://fx.scnu.edu.cn/api/UserValidate.ashx";

/**
 *  身份认证接口
 *
 *       方法：post
 *  请求行参数：
 *  请求体参数：token(必须)  invitecode(必须)  school(必须)  department(必须)  pid(必须)  fullname(必须)
 */
NSString *const userRealNameURL = @"https://fx.scnu.edu.cn/api/UserRealName.ashx";

/**
 *  公告内容接口(html)
 *
 *       方法：get
 *  请求行参数：id(必须)
 *  请求体参数：
 */
NSString *const noticeArticleURL = @"https://fx.scnu.edu.cn/h5android/pages/noticeArticle/noticeArticle.html";

/**
 *  文章内容接口(html)
 *
 *       方法：get
 *  请求行参数：sid(必须)  thumb(必须)  id(必须)
 *  请求体参数：
 */
NSString *const articleURL = @"https://fx.scnu.edu.cn/FXonline/pages/article/showarticle_android.html";


