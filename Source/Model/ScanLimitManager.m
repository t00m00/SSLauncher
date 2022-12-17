//
//  ScanLimitManager.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/22.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "ScanLimitManager.h"
#import "SSLUserDefaults.h"

/** Launcherリストの上限 */
const NSUInteger kMaxLauncherListCount       = 1;

/** 1日のスキャン回数の上限 */
static const NSUInteger kMaxScanCountOfDaily = 3;

/** 日付フォーマット(yyyyMMdd) */
static NSString * const kDateFormatyyyyMMdd = @"yyyyMMdd";


@implementation ScanLimitManager

#pragma mark -
#pragma mark ===== Class Method =====
/** 1日のスキャン上限に達したかを判定します */
+ (BOOL)isScanLimitNumberOfDaily
{
    
    if ([[self class] scanSuccessfulOfDayly] < kMaxScanCountOfDaily) {

        return NO;
    }

    return YES;
}

/** スキャン成功回数をカウントします */
+ (void)countedScanSuccessful
{
    NSString *nowDate  = [[self class] dateyyyyMMdd];
    [SSLUserDefaults setLastScanDate:nowDate];
    
    NSInteger successCount = [SSLUserDefaults scanSuccessfulCount];
    [SSLUserDefaults setScanSuccessfulCount:++successCount];
}


#pragma mark -
#pragma mark ===== Private Class Method =====

/** １日のスキャン成功回数を取得します */
+ (NSInteger)scanSuccessfulOfDayly
{
    NSInteger successCount = [SSLUserDefaults scanSuccessfulCount];
    NSString *nowDate  = [[self class] dateyyyyMMdd];
    NSString *lastDate = [SSLUserDefaults lastScanDate];
    
    // 日付が変わっている場合は、スキャン回数をリセットする
    if ([lastDate integerValue] < [nowDate integerValue]) {
     
        successCount = 0;
        [SSLUserDefaults setScanSuccessfulCount:successCount];

    } else if ([nowDate integerValue] < [lastDate integerValue]) {

        // |lastDate|の方が大きい場合は、不正な日付操作が行われた
        const int badOperation = 999;
        NSLog(@"ScanLimit Failed. (badOperation=%d)", badOperation);
        return badOperation;
    }
    
    return successCount;
}


/** 今日の日付を取得する(yyyyMMdd) */
+ (NSString *)dateyyyyMMdd
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = kDateFormatyyyyMMdd;
    df.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSString *dateString = [df stringFromDate:[NSDate date]];
    
    return dateString;
}



@end
