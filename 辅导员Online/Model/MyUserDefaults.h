//
//  MyUserDefaults.h
//  辅导员Online
//
//  Created by JackBryan on 2017/12/26.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUserDefaults : NSObject

+ (void)saveToUserDefaultsWithDictionary:(NSDictionary<NSString *, id> *)keyedValues;

+ (NSDictionary<NSString *, id> *)getDictionaryFromUserDefaultsWithValuesForKeys:(NSArray<NSString *> *)keys;

@end
