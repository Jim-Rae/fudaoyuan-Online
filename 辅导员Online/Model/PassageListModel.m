//
//  PassageListModel.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/27.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "PassageListModel.h"

@implementation PassageListModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"PassageListModel类没有%@这个属性",key);
}

@end
