//
//  NSArray+Extend.m
//  word-extractor
//
//  Created by goofygao on 16/3/24.
//  Copyright © 2016年 goofyy. All rights reserved.
//

#import "NSArray+Extend.h"
#import "Parsimmon.h"

@implementation NSArray (Extend)

//根据NSSet类型获取NSSarray
+(instancetype)initWithSet:(NSSet *)set
{
    return [set allObjects];
}

//去除NSString里重复的项,并且全部单词变成原型
+(instancetype)initWithArrayWithNoRepeat:(NSString *)string {
    ParsimmonLemmatizer *lemmatizer = [[ParsimmonLemmatizer alloc] init];
    NSArray *lemmatizedTokens = [lemmatizer lemmatizeWordsInText:string];
    
    return [[self getSetByArray:lemmatizedTokens] allObjects];
}

//去除NSarray里重复的项
+(instancetype)initWithArrayWithNoRepeArray:(NSArray *)array {
    return [[NSSet setWithArray:array] allObjects];
}

//去除特殊字符
+(instancetype)initWithNoSpecialCharacter:(NSArray *)array {
    
    NSMutableArray *resultArray = [NSMutableArray array];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／,,，：；（）¥「」＂、[]{}#%-*+?,,.=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    for (int i = 0; i < array.count; i++) {
        [resultArray addObject:[array[i] stringByTrimmingCharactersInSet:set]];
    }
    return resultArray;
}
//求两个数组的交集
+(instancetype)arrayWithOtherArrayIntersection:(NSArray *)array otherArray:(NSArray *)otherArray {
//    [sett2 intersectSet:sett];
    NSSet *setOne = [self getSetByArray:array];
    NSMutableSet *setTwo = [self getSetByArray:otherArray];
    [setTwo intersectSet:setOne];
    return [setTwo allObjects];
}


+ (NSMutableSet *)getSetByArray:(NSArray *)array {
    return [NSMutableSet setWithArray:array];
}

@end
