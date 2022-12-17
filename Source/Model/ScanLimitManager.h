//
//  DateManager.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/22.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Launcherリストの上限 */
extern const NSUInteger kMaxLauncherListCount;

/** 回数の上限および、日時関連を管理します */
@interface ScanLimitManager : NSObject

/** 1日のスキャン上限に達したかを判定します */
+ (BOOL)isScanLimitNumberOfDaily;

/** スキャン成功回数をカウントします */
+ (void)countedScanSuccessful;

@end
