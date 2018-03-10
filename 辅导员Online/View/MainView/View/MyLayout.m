//
//  MyLayout.m
//  辅导员Online
//
//  Created by JackBryan on 2017/12/19.
//  Copyright © 2017年 Fx. All rights reserved.
//

#import "MyLayout.h"

@implementation MyLayout
{
    //这个数组就是我们自定义的布局配置数组
    NSMutableArray * _attributeArray;
}

//数组的相关设置在这个方法中
//布局前的准备会调用这个方法
-(void)prepareLayout{
    _attributeArray = [[NSMutableArray alloc]init];
    [super prepareLayout];
    //设置为静态的4列
    //计算每一个item的宽度
    CGFloat WIDTH = ([UIScreen mainScreen].bounds.size.width-self.sectionInset.left-self.sectionInset.right-self.minimumInteritemSpacing*(_InteritemCount-1))/_InteritemCount;
    //设置高度
    CGFloat HIGHT = _cellHight;
    //定义数组保存每个cell的frame
    //itemCount是外界传进来的item的个数，遍历来设置每一个item的布局
    for (int i=0; i<_itemCount; i++) {
        //设置每个item的位置等相关属性
        NSIndexPath * index = [NSIndexPath indexPathForItem:i inSection:0];
        //创建一个布局属性类，通过indexPath来创建
        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        //设置item的位置
        attris.frame = CGRectMake(self.sectionInset.left+(self.minimumInteritemSpacing+WIDTH)*(i%_InteritemCount), (HIGHT+self.minimumLineSpacing)*(i/_InteritemCount), WIDTH, HIGHT);
        [_attributeArray addObject:attris];
    }
    
    //设置itemSize来确保滑动范围的正确
    self.itemSize = CGSizeMake(WIDTH, HIGHT);
}

//这个方法中返回我们的布局数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _attributeArray;
}


@end


