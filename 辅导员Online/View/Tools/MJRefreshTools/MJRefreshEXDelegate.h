//
//  MJRefreshEXDelegate.h
//  辅导员Online
//
//  Created by JackBryan on 2017/12/20.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MJRefreshEXDelegate <NSObject>

@optional
/**
 *    下拉 重新加载数据
 */
- (void)onRefreshing:(id)control;

@optional
/**
 *    上拉 加载更多数据
 */
- (void)onLoadingMoreData:(id)control pageNum:(NSNumber *)pageNum;

@end
