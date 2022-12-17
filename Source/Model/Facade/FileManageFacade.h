//
//  FileManageFacade.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/02.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LauncherData;

@interface FileManageFacade : NSObject

/** データフォルダ系の準備 */
+ (BOOL)prepareDataDictionaries;

/** 新しいLauncherDataを保存します */
+ (BOOL)saveNewLauncherData:(LauncherData *)data;

/** LauncherDataを既存のファイルに上書き保存します */
+ (BOOL)saveOverwriteLauncherData:(LauncherData *)data;

/** 指定されたファイルの削除(複数) */
+ (BOOL)removeItemAndDirAtPaths:(NSArray *)paths;

/** 指定されたファイルの削除 */
+ (BOOL)removeItemAndDirAtPath:(NSString *)path;

@end
