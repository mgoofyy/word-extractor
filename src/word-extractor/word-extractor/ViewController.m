//
//  ViewController.m
//  word-extractor
//
//  Created by goofygao on 16/3/21.
//  Copyright © 2016年 goofyy. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+Extend.h"

@interface ViewController ()

@end

@implementation ViewController
/**
 *  文件大小
 */
CGFloat fileSize;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self readFile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  单个词匹配
 */
- (void)readFile {
    NSLog(@"___________%s",__func__);
    
    NSString *articleFilePath=[[NSBundle mainBundle] pathForResource:@"alice_in_worderland"ofType:@"txt"];
    NSString *articleFileString = [[NSString  alloc] initWithContentsOfFile:articleFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray  *articleFileSingleWord = [NSArray initWithNoSpecialCharacter:[articleFileString componentsSeparatedByString:@" "]];
    
    NSString *singleWordFilePath = [[NSBundle mainBundle] pathForResource:@"540"ofType:@"txt"];
    NSString *singleWordFileString = [[NSString  alloc] initWithContentsOfFile:singleWordFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray  *singleWordFileWord = [singleWordFileString componentsSeparatedByString:@"\n"];
    //获取文章与单个字词出现的词的交集
    NSArray *repeatedSingleWord = [NSArray arrayWithOtherArrayIntersection:articleFileSingleWord otherArray:singleWordFileWord];
    NSLog(@"%@",repeatedSingleWord[0]);
    [self shortWordSuit2];
}

/**
 *  短语匹配
 */

- (void)shortWordSuit2 {
    //连续的短语匹配
    //
    //思路。N多线程获取整个文章的单词，去除特殊字符，放到N个数组里。
    //然后，拿到词组文件的数组，按二维数组存储。
    //
    //匹配思路(单条线程)
    //
    //拿二维数组的第一个词的第一个单词与文章的一部分比较。
    //  if(匹配) {
    //      拿二维数组第一个词的第二个单词比较
    //   } else {
    //      匹配文章的第二个单词
    //   }
    //    2686.txt
    NSString *shortWordPath=[[NSBundle mainBundle] pathForResource:@"2686"ofType:@"txt"];
    NSString *shortWordString = [[NSString  alloc] initWithContentsOfFile:shortWordPath encoding:NSUTF8StringEncoding error:nil];
    NSArray  *shortWordArray = [NSArray initWithNoSpecialCharacter:[shortWordString componentsSeparatedByString:@"\n"]];
    
    NSArray *artitleArray = @[@"how",@"goofyy",@"zhansgan",@"a",@"lot",@"of",@"wht",@"goofy",@"is",@"very",@"much",@"good",@"you",@"konw",@"he",@"is",@"is",@"a",@"good",@"very",@"big",@"boy",@"love",];
    
    NSMutableArray *shortWordErWeiArray = [NSMutableArray array];
    [shortWordErWeiArray addObject:@[@"a lot of",@"vert much",@"very much",@"zhsnagsan dhe",@"sab ye"]];

    for (int i = 0; i < shortWordArray.count; i++) {
        if (![shortWordArray[i]  isEqual: @""] && shortWordArray[i] != nil) {
            NSArray  *shortWordSingle = [NSArray initWithNoSpecialCharacter:[shortWordArray[i] componentsSeparatedByString:@" "]];
            [shortWordErWeiArray addObject:shortWordSingle];
        }
        
    }
//    shortWordErWeiArray = nil;
    NSLog(@"%@",shortWordErWeiArray);
    
    
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[[NSBundle mainBundle] pathForResource:@"alice_in_worderland"ofType:@"txt"]];
//    [fileHandle seekToFileOffset:0];
//    NSData *data = [fileHandle readDataOfLength:fileSize];
//    NSString *artitleString = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
//    NSLog(@"%@",artitleString);
//
//    
//    NSError *error = NULL;
//    NSRegularExpression *regex = [NSRegularExpression
//                                   regularExpressionWithPattern:@"([a-zA-Z])+[\']*([a-zA-Z])*+[\\s]*([a-zA-Z])*+[\\s]*"
//                                   options:NSRegularExpressionCaseInsensitive
//                                   error:&error];
//    
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    /**
//     *  分四条线程读取文件并正则判断
//     */
//    
//    dispatch_group_async(group, queue, ^{
//        
//        
//    });
//
//    
//    dispatch_group_async(group, queue, ^{
//        [regex enumerateMatchesInString:artitleString options:0 range:NSMakeRange([artitleString length] * 3/4, [artitleString length]/4) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//            NSString *num = [artitleString substringWithRange:match.range];
//            NSLog(num);
//        }];
//    });
//    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"___________%s",__func__);
//    });

    
    NSLog(@"%ld",shortWordErWeiArray.count);
    for (int i = 0; i < artitleArray.count;i++ ) {
        int second = 0;
        int j = 0;
        j = i;
        for (int m = 0; m < shortWordErWeiArray.count; m ++) {
            if ([(NSArray *)shortWordErWeiArray[m] indexOfObject:artitleArray[i]] == 0) {
                //第一个单词匹配
                    while([shortWordErWeiArray[m][second] isEqualToString:artitleArray[j]]) {
                        
                        second++;
                        if (second == ((NSArray *)shortWordErWeiArray[m]).count) {
                            second--;
                            NSLog(@"%@",shortWordErWeiArray[m]);
                        }
                        j++;
                        if (j == artitleArray.count - 1) {
                            j--;
                        }


                    }
                
            }
        }
    }
    
    
}



- (void)shortWordSuit {
    /**
     *  两个词的短语
     */
    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"alice_in_worderland"ofType:@"txt"];
//    NSString *string = [[NSString  alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSArray  *lines = [string componentsSeparatedByString:@" "];
//    NSSet *sett = [[NSSet alloc]initWithArray:lines];
    
//    NSString *filePath2=[[NSBundle mainBundle] pathForResource:@"540"ofType:@"txt"];
//    NSString *string2 = [[NSString  alloc] initWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
//    NSArray  *lines2 = [string2 componentsSeparatedByString:@"\n"];
//    NSMutableSet *sett2 = [NSMutableSet setWithArray:lines2];
    /**
     *  空格连续性英语词组
     */
//    NSString *string1 = @"a lot";
//    NSString *regex = @"([a-zA-Z])+[\\S]*([a-zA-Z])[\\S]*";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    BOOL isValid = [predicate evaluateWithObject:string1];
//
//    NSLog(@"%d",isValid);
//    
//    
//    NSString *yourString = @"what's ur' name, how are u ok?";
//    NSError *error = NULL;
//    NSRegularExpression *regex1 = [NSRegularExpression
//                                  regularExpressionWithPattern:@"([a-zA-Z])+[\']*([a-zA-Z])*+[\\s]*([a-zA-Z])*+[\\s]*"
//                                  options:NSRegularExpressionCaseInsensitive
//                                  error:&error];
//    
//    [regex1 enumerateMatchesInString:string options:0 range:NSMakeRange(0, [string length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//        NSString* num = [string substringWithRange:match.range];
//        NSLog(num);
//    }];
    /**
     *  多线程读写
     */
    
//    NSFileManager* manager = [NSFileManager defaultManager];
//    
//    if ([manager fileExistsAtPath:filePath]){
//        
//        NSDictionary *fileSizeDict = [manager attributesOfItemAtPath:filePath error:nil];
//        NSLog(@"%llu",[fileSizeDict fileSize]);
//        fileSize = (CGFloat)[fileSizeDict fileSize];
//        NSLog(@"%f",fileSize);
//    }
////
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
//    [fileHandle seekToFileOffset:0];
//    NSData *data = [fileHandle readDataOfLength:fileSize];
//    NSString *string1 = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
//    NSLog(@"%@",string1);
//    NSError *error = NULL;
//    NSRegularExpression *regex1 = [NSRegularExpression
//                                   regularExpressionWithPattern:@"([a-zA-Z])+[\']*([a-zA-Z])*+[\\s]*([a-zA-Z])*+[\\s]*"
//                                   options:NSRegularExpressionCaseInsensitive
//                                   error:&error];
////
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    /**
//     *  分四条线程读取文件并正则判断
//     */
//    
//    NSLog(@"___________%s,%ld",__func__,[string1 length]);
//    dispatch_group_async(group, queue, ^{
//        
////        [regex1 enumerateMatchesInString:string1 options:0 range:NSMakeRange(0, [string1 length]/4) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
////            NSString* num = [string1 substringWithRange:match.range];
////            NSLog(num);
////        }];
//
//        
//    });
//    
//    dispatch_group_async(group, queue, ^{
//        [regex1 enumerateMatchesInString:string1 options:0 range:NSMakeRange([string1 length]/4, [string1 length]/4) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//            NSString* num = [string1 substringWithRange:match.range];
//            NSLog(num);
//        }];
//
//    });
//    
//    dispatch_group_async(group, queue, ^{
//        [regex1 enumerateMatchesInString:string1 options:0 range:NSMakeRange([string1 length]/2, [string1 length]/4) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//            NSString* num = [string1 substringWithRange:match.range];
//            NSLog(num);
//        }];
//    });
//    dispatch_group_async(group, queue, ^{
//        [regex1 enumerateMatchesInString:string1 options:0 range:NSMakeRange([string1 length] * 3/4, [string1 length]/4) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//            NSString* num = [string1 substringWithRange:match.range];
//            NSLog(num);
//        }];
//    });
//
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"___________%s",__func__);
//    });
 
    
    /**
     *  分词读写 先把词划分开。然后逐个匹配。第一个匹配成功后，匹配第二个
     */
//    NSLog(@"___________%s",__func__);
//    NSString *filePath=[[NSBundle mainBundle] pathForResource:@"alice_in_worderland"ofType:@"txt"];
//    NSString *string = [[NSString  alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSArray  *lines = [string componentsSeparatedByString:@" "];
//    NSLog(@"___________%s",__func__);
//    
//    NSString *wordPhaseFilePath =[[NSBundle mainBundle] pathForResource:@"2686"ofType:@"txt"];
//    NSString *phaseWordString = [[NSString  alloc] initWithContentsOfFile:wordPhaseFilePath encoding:NSUTF8StringEncoding error:nil];
//    NSArray  *phaseWordArray = [phaseWordString componentsSeparatedByString:@"\n"];
////    NSLog(@"___________%s",__func__);
//    NSLog(@"___________%s",__func__);
////    NSLog(@"%@",phaseWordArray);
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < phaseWordArray.count; i++) {
//        NSArray  *everyWord = [phaseWordArray[i] componentsSeparatedByString:@" "];
//        [array addObject:everyWord];
//    }
//    
//    NSLog(@"___________%s",__func__);
//    for (int m = 0; m < lines.count; m++) {
//        //第一次是否相等
//        BOOL isValue = YES;
//        int n = 0;
//        while (isValue) {
//            if ([lines[m] isEqual:array[0][n]]) {
//                isValue = YES;
//                NSLog(@"___________");
//                NSArray *test = (NSArray *)array[0];
//                if (n < test.count) {
//                    n++;
//                }
//            } else {
//                isValue = NO;
//            }
//        }
//        
//    }
//    
//    NSLog(@"___________%s",__func__);
}
//

@end
