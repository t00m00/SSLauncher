//
//  LauncherDataManager.h
//  SSLauncher
//
//  Created by toomoo on 2014/08/29.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LauncherData;

/* @brief LauncherDataの配列を管理します。
 *
 * @note
 *        このクラスはシングルトンです
 */
@interface LauncherDataManager : NSObject

/** インスタンスを取得します */
+ (instancetype)shared;

- (LauncherData *)objectAtIndex:(NSUInteger)index;

- (void)removeObject:(LauncherData *)data;

- (NSUInteger)count;

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

// 更新します
- (void)reloadData;

@end
