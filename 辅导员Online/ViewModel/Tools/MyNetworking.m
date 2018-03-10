//
//  MyNetworking.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/25.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "MyNetworking.h"

@implementation MyNetworking

+(MyNetworking *)sharedNetWorking{
    static MyNetworking *netWorking = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        netWorking = [[MyNetworking alloc] init];
    });
    return netWorking;
}



+(void)getRequestWithURLString:(NSString *)urlStr
                      progress:(void (^)(NSProgress *downloadProgress))downloadProgress
                        finish:(void(^)(BOOL success,id responseObject,NSError *error))finish{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([MyNetworking sharedNetWorking].HTTPHeadersDic) {
        for (NSString * key in [MyNetworking sharedNetWorking].HTTPHeadersDic) {
            [manager.requestSerializer setValue:[MyNetworking sharedNetWorking].HTTPHeadersDic[key] forHTTPHeaderField:key];
        }
    }
    [manager GET:urlStr parameters:nil progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        finish(YES,responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(NO,nil,error);
    }];
}

+(void)postRequestWithURLString:(NSString *)urlStr
                       paramDic:(NSDictionary *)paramDic
                         finish:(void (^)(BOOL success,id responseObject,NSError *error))finish{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    if ([MyNetworking sharedNetWorking].HTTPHeadersDic) {
        for (NSString * key in [MyNetworking sharedNetWorking].HTTPHeadersDic) {
            [manager.requestSerializer setValue:[MyNetworking sharedNetWorking].HTTPHeadersDic[key] forHTTPHeaderField:key];
        }
    }
    
    [manager POST:urlStr parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        finish(YES,responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(NO,nil,error);
    }];
}

+(void)postRequestWithURLString:(NSString *)urlStr
                       paramDic:(NSDictionary *)paramDic
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       progress:(void (^)(NSProgress *uploadProgress))uploadProgress
                         finish:(void (^)(BOOL success,id responseObject,NSError *error))finish{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if ([MyNetworking sharedNetWorking].HTTPHeadersDic) {
        for (NSString * key in [MyNetworking sharedNetWorking].HTTPHeadersDic) {
            [manager.requestSerializer setValue:[MyNetworking sharedNetWorking].HTTPHeadersDic[key] forHTTPHeaderField:key];
        }
    }
    
    [manager POST:urlStr parameters:paramDic constructingBodyWithBlock:block progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        finish(YES,responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finish(NO,nil,error);
    }];
}

@end
