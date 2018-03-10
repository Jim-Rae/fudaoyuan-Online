//
//  MyUserDefaults.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/26.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "MyUserDefaults.h"

@implementation MyUserDefaults

+ (void)saveToUserDefaultsWithDictionary:(NSDictionary<NSString *, id> *)keyedValues{
    //获取NSUserDefaults单例对象
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //进行数据存储
    [defaults setValuesForKeysWithDictionary:keyedValues];
    //同步到磁盘
    [defaults synchronize];
    
    NSLog(@"储存成功");
}

+ (NSDictionary<NSString *, id> *)getDictionaryFromUserDefaultsWithValuesForKeys:(NSArray<NSString *> *)keys{
    //获取NSUserDefaults单例对象
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    //获取数据
    NSDictionary *dic = [defaults dictionaryWithValuesForKeys:keys];
    return dic;
}

@end
