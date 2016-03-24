//
//  ViewController.m
//  momo
//
//  Created by goofygao on 16/3/24.
//  Copyright © 2016年 goofyy. All rights reserved.
//

#import "ViewController.h"
#import "Parsimmon/Parsimmon.h"
#import "NSArray+Extend.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *singleWordArray;

@property (nonatomic,strong) NSMutableArray *matchSingleWordArray;

@property (nonatomic,strong) NSMutableArray *matchPhraseArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.matchSingleWordArray = [NSMutableArray array];
    self.matchPhraseArray = [NSMutableArray array];
    [self matchRegixOtherphrase];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  单词匹配
 */
- (void)singleWordSuit {
    
    NSMutableArray *articleFileArray = [NSMutableArray array];
    NSMutableArray *singleWordFileArrayNoRepeat = [NSMutableArray array];
    
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_async(group, queue, ^{
        //获取文章里的所有单词，并恢复成原型
        NSString *articleFilePath=[[NSBundle mainBundle] pathForResource:@"alice_in_worderland"ofType:@"txt"];
        NSString *articleFileString = [[NSString  alloc] initWithContentsOfFile:articleFilePath encoding:NSUTF8StringEncoding error:nil];
        //去除重复
        [articleFileArray addObjectsFromArray:[NSArray initWithArrayWithNoRepeat:articleFileString]];
    });

    dispatch_group_async(group, queue, ^{
        //取出单词文件里的所有单词,并恢复成原型
        NSString *singleWordFilePath = [[NSBundle mainBundle] pathForResource:@"540"ofType:@"txt"];
        NSString *singleWordFileString = [[NSString  alloc] initWithContentsOfFile:singleWordFilePath encoding:NSUTF8StringEncoding error:nil];
        NSMutableArray  *singleWordFileArray = [NSMutableArray array];
        [singleWordFileArray addObjectsFromArray:[singleWordFileString componentsSeparatedByString:@"\n"]];
        NSString *string = [singleWordFileArray componentsJoinedByString:@","];
        [singleWordFileArrayNoRepeat addObjectsFromArray:[NSArray initWithArrayWithNoRepeat:string]];
    });

    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSArray *repeatedSingleWord = [NSArray arrayWithOtherArrayIntersection:singleWordFileArrayNoRepeat otherArray:articleFileArray];
        self.matchSingleWordArray = (NSMutableArray *)repeatedSingleWord;
        NSLog(@"%ld",repeatedSingleWord.count);
    });

}


/**
 *  连续词组匹配
 */
- (void)phraseMatch {
    
    NSString *articleFilePath=[[NSBundle mainBundle] pathForResource:@"alice_in_worderland"ofType:@"txt"];
    NSString *articleFileString = [[NSString  alloc] initWithContentsOfFile:articleFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *singleWordFilePath = [[NSBundle mainBundle] pathForResource:@"2686"ofType:@"txt"];
    NSString *singleWordFileString = [[NSString  alloc] initWithContentsOfFile:singleWordFilePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray  *singleWordFileArray = [NSMutableArray array];
    [singleWordFileArray addObjectsFromArray:[singleWordFileString componentsSeparatedByString:@"\n"]];
    
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    NSMutableArray *array3 = [NSMutableArray array];
    NSMutableArray *array4 = [NSMutableArray array];
    
    dispatch_group_async(group, queue, ^{
        NSRange range = NSMakeRange(0, (singleWordFileArray.count - 1)/4);
        [array1 addObjectsFromArray:[self getSinglePhaseAction:array1 range:range fullSingleWordArray:singleWordFileArray articleFileString:articleFileString]];

    });
    
    dispatch_group_async(group, queue, ^{
        NSRange range = NSMakeRange((singleWordFileArray.count - 1)/4 + 1, (singleWordFileArray.count - 1) * 1/4);
        [array2 addObjectsFromArray:[self getSinglePhaseAction:array2 range:range fullSingleWordArray:singleWordFileArray articleFileString:articleFileString]];
    });
    dispatch_group_async(group, queue, ^{
        NSRange range = NSMakeRange((singleWordFileArray.count - 1) * 2/4 + 1,(singleWordFileArray.count - 1) * 1/4);
        [array3 addObjectsFromArray:[self getSinglePhaseAction:array3 range:range fullSingleWordArray:singleWordFileArray articleFileString:articleFileString]];
    });
    
    dispatch_group_async(group, queue, ^{
        NSRange range = NSMakeRange((singleWordFileArray.count - 1) * 3/4 + 1,(singleWordFileArray.count - 1)/4);
       [array4 addObjectsFromArray:[self getSinglePhaseAction:array4 range:range fullSingleWordArray:singleWordFileArray articleFileString:articleFileString]];
    });


    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //获取所有数组
        [self.matchPhraseArray addObjectsFromArray:array1];
        [self.matchPhraseArray addObjectsFromArray:array2];
        [self.matchPhraseArray addObjectsFromArray:array3];
        [self.matchPhraseArray addObjectsFromArray:array4];
    });
    
}

- (NSMutableArray *)getSinglePhaseAction:(NSMutableArray *)array range:(NSRange)range fullSingleWordArray:(NSArray *)singleWordFileArray articleFileString:(NSString *)articleFileString {
    NSMutableArray *tmpArray = [NSMutableArray array];
    [array addObjectsFromArray:[singleWordFileArray subarrayWithRange:range]];
    for (int i = 0; i < array.count; i++) {
        if ([array[i] rangeOfString:@"..."].location != NSNotFound || [array[i] rangeOfString:@"sb."].location != NSNotFound || [array[i] rangeOfString:@"sth."].location != NSNotFound) {
            [tmpArray addObject:array[i]];
        } else {
            if ([articleFileString rangeOfString:singleWordFileArray[i]].location == NSNotFound) {
                [tmpArray addObject:array[i]];
            }
        
        }
        
    }
    [array removeObjectsInArray:tmpArray];
    return array;
}

/**
 *  断层单词匹配 - 正则 类似so ... that    like sb. to 等词
 */

- (void)matchRegixOtherphrase {
    
    NSString *articleFilePath=[[NSBundle mainBundle] pathForResource:@"alice_in_worderland"ofType:@"txt"];
    NSString *articleFileString = [[NSString  alloc] initWithContentsOfFile:articleFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *singleWordFilePath = [[NSBundle mainBundle] pathForResource:@"2686"ofType:@"txt"];
    NSString *singleWordFileString = [[NSString  alloc] initWithContentsOfFile:singleWordFilePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray  *singleWordFileArray = [NSMutableArray array];
    [singleWordFileArray addObjectsFromArray:[singleWordFileString componentsSeparatedByString:@"\n"]];
    /**
     *  特殊的单词 类似so ... that
     */
    //存放匹配单词词组的正则表达式
    NSMutableArray *otherPhraseMatch = [NSMutableArray array];
    ////获取到含... sb. sth. 的词组
    NSMutableArray *otherPhraseMatchContentArray = [NSMutableArray array];
    
    /**
     *  获取含sb. ... 的单词
     */
    for (int i = 0; i < singleWordFileArray.count; i++) {
        if ([singleWordFileArray[i] rangeOfString:@"..."].location != NSNotFound || [singleWordFileArray[i] rangeOfString:@"sb."].location != NSNotFound || [singleWordFileArray[i] rangeOfString:@"sth."].location != NSNotFound) {
            [otherPhraseMatchContentArray addObject:singleWordFileArray[i]];
            if ([singleWordFileArray[i] rangeOfString:@"..."].location != NSNotFound) {
                [otherPhraseMatch addObject:[singleWordFileArray[i] stringByReplacingOccurrencesOfString:@"..." withString:@"[\\s]*+([a-zA-Z])*[\\s]*+([a-zA-Z])*+[\\s]*"]];
            } else if ([singleWordFileArray[i] rangeOfString:@"sb."].location != NSNotFound) {
                [otherPhraseMatch addObject:[singleWordFileArray[i] stringByReplacingOccurrencesOfString:@"sb." withString:@"[\\s]*+([a-zA-Z])*[\\s]*+([a-zA-Z])*+[\\s]*"]];
            } else if ([singleWordFileArray[i] rangeOfString:@"sth."].location != NSNotFound) {
                [otherPhraseMatch addObject:[singleWordFileArray[i] stringByReplacingOccurrencesOfString:@"sth." withString:@"[\\s]*+([a-zA-Z])*[\\s]*+([a-zA-Z])*+[\\s]*"]];
            }
            
        } else {
           
            
        }
    }
    //去除重复项
    otherPhraseMatch = (NSMutableArray *)[NSArray initWithArrayWithNoRepeArray:otherPhraseMatch];
    //获取到含... sb. sth. 的词组去重。
    otherPhraseMatchContentArray = (NSMutableArray *)[NSArray initWithArrayWithNoRepeArray:otherPhraseMatchContentArray];
    
    NSMutableArray *matchSuccessfulWord = [NSMutableArray array];
    NSLog(@"%@",otherPhraseMatch);
    
    for (int i = 0; i < otherPhraseMatch.count; i++) {
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression
                                      regularExpressionWithPattern:otherPhraseMatch[i]
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
        
        [regex enumerateMatchesInString:articleFileString options:0 range:NSMakeRange(0, [articleFileString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
            [matchSuccessfulWord addObject:otherPhraseMatchContentArray[i]];
        }];
        
    }
    //去重
    matchSuccessfulWord = (NSMutableArray *)[NSArray initWithArrayWithNoRepeArray:matchSuccessfulWord];
    NSLog(@"%@",matchSuccessfulWord);
    [self.matchPhraseArray addObjectsFromArray:matchSuccessfulWord];
}


@end
