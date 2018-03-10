//
//  MyNetworking.h
//  辅导员Online
//
//  Created by JackBryan on 2017/12/25.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface MyNetworking : NSObject

@property(nonatomic,strong)NSDictionary * HTTPHeadersDic;
+(MyNetworking *)sharedNetWorking;

+(void)getRequestWithURLString:(NSString *)urlStr
                      progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                        finish:(void(^)(BOOL success,id responseObject,NSError *error))finish;

+(void)postRequestWithURLString:(NSString *)urlStr
                       paramDic:(NSDictionary *)paramDic
                         finish:(void (^)(BOOL success,id responseObject,NSError *error))finish;

+(void)postRequestWithURLString:(NSString *)urlStr
                       paramDic:(NSDictionary *)paramDic
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                         finish:(void (^)(BOOL success,id responseObject,NSError *error))finish;

@end
