# word-extractor
墨墨提词算法

## 简介
提词即是从一段文本里提取出墨墨词库里面有的单词，用户可以将这些单词添加到自己的学习规划。

## 提交
将代码或项目直接放入 src 文件夹内即可。

## 关键功能
1. 用户提供一个文本，文本与某个词库（墨墨词库）做对比，提取出来文本和词库都有的单词；
2. 按用户提供的文本的单词出现前后顺序排列提取出来的单词
3. 重复的单词不重复提取
4. 可以提取短语，例如：
    1. `He knows a bit of Dutch` => `a bit of`.
    2. `as noisy as evey` => `as ... as`.
    3. `keep up with jenny to` => `keep up with sb.`，[更多代词](#会出现的代词)
4. 可以提取短语，例如词库里有个 'a bit of'， 要在句子 ‘He knows a bit of Dutch.' 提取出来; 又例如 'as ... as', 要在句子 'as noisy as evey' 中提取出来
5. 特殊符号的处理，如 clean-up 需要作为一个单词，也要拆分成独立单词，即 clean-up, clean, up
6. （选项功能）一般时态变形的单词的处理，如 look，如果文中的是 looked，需要优先从词库里查询是否有 look 这个单词，如果词库有 look 则不再继续查找，如果没有再查询 looked。ing 形态和加 s,es,ies 形态也同理。
7. （选项功能）不规则时态的处理，如 drunk，需要优先查找 drunk，如果词库有 drunk 则不再继续查找，如果没有再查询 drink。
8. 在保证正确性的前提下尽量提高提取速度，比如避免 auto boxing/unboxing

## 会出现的代词
`["do sth.", "do sth","sb.'s", "sth.", "sb.","sth", "sb", "one's", "somebody's", "somebody", "something"]`
## 解决思路
1. 普通单词 <br />类似 `[liked、come 、 go 、knowledege]`等等等<br />子线程获取文章的内容,并转化成原形并保存成数组，同时子线程获取单个单词的内容，保存成原形，数组，两个线程完成后，回调  

	```
	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
	  
	  });
```
<br />
	在回调里用NSSet去匹配求交集。NSSet底层是HASH实现。测试时显示，10万条数据大概0.02秒完成。(包括两次NSlog)
2. 连贯的短语<br />类似 `[so much, very much]`等等,这种直接把文章内容分成四个段去匹配。分成四个线程匹配完成之后。完成线程回调，合并四个线程匹配的数组。(这个暂时没有想到特别好的方法)。暂时用多线程解决。
3. 非连贯的词语 类似 `[so...much like sb. to sth. good at sth.]`<br />把中间出现的这些 ... 和sb. sth. 换成正成正则表达式。然后在文章中匹配。<br/>

## 部分代码段
NSArray+Extend.h处理数组<br/>

```objective-c
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
```
多线程处理和回调

```Objective-c
dispatch_group_t group = dispatch_group_create();
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
dispatch_group_async(group, queue, ^{
        
});
    
dispatch_group_async(group, queue, ^{
       
});

dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       //回调
});
```
正则匹配

```
NSError *error = NULL;
NSRegularExpression *regex = [NSRegularExpression
                      		regularExpressionWithPattern:otherPhraseMatch[i]options:NSRegularExpressionCaseInsensitiv error:&error];
        
[regex enumerateMatchesInString:articleFileString options:0 range:NSMakeRange(0, [articleFileString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
    [matchSuccessfulWord addObject:otherPhraseMatchContentArray[i]];
        }];
```
其中错误。希望大神指正


