//
//  NSArray+Extend.h
//  word-extractor
//
//  Created by goofygao on 16/3/24.
//  Copyright © 2016年 goofyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extend)
//根据NSSet类型获取NSSarray
+(instancetype)initWithSet:(NSSet *)set;

//去除NSString里重复的项
+(instancetype)initWithArrayWithNoRepeat:(NSString *)string;

//去除NSarray里重复的项
+(instancetype)initWithArrayWithNoRepeArray:(NSArray *)array;

//去除特殊字符
+(instancetype)initWithNoSpecialCharacter:(NSArray *)array;

//求两个数组的交集
+(instancetype)arrayWithOtherArrayIntersection:(NSArray *)array otherArray:(NSArray *)otherArray;
@end
