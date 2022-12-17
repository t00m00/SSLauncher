//
//  FileManageFacade.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/02.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "FileManageFacade.h"

#import "LauncherData+Managing.h"
#import "LauncherDataManager.h"
#import "TMPathDefine.h"
#import "TMFileManager.h"

@implementation FileManageFacade

/** データフォルダ系の準備 */
+ (BOOL)prepareDataDictionaries
{
    
    BOOL ret = [TMFileManager createDataDic];
    
    if (ret == NO) {
        NSLog(@"[TMFileManager createDataDic] failed.");
    }
    
    
    // 一時ファイルフォルダを削除して作成しなおす
    ret = [TMFileManager removeScannedTmpFileDic];
    
    if (ret == NO) {
        NSLog(@"[TMFileManager removeScannedTmpFileDic] failed.");
    }
    
    ret = [TMFileManager createScannedTmpFileDic];
    
    if (ret == NO) {
        NSLog(@"[TMFileManager createScannedTmpFileDic] failed.");
    }
    
    return ret;
}


/** 新しいLauncherDataを保存します */
+ (BOOL)saveNewLauncherData:(LauncherData *)data
{
    NSString * const fileName = [TMPathDefine launcherDataFileName];
        
    [data setLauncherDataFileName:fileName];
    [data setSortValue:[[LauncherDataManager shared] count] + 1];
    
    return [[self class] saveLauncherData:data fileName:fileName];
}

/** LauncherDataを既存のファイルに上書き保存します */
+ (BOOL)saveOverwriteLauncherData:(LauncherData *)data
{
    return [[self class] saveLauncherData:data fileName:[data launcherDataFileName]];
}

/** 指定されたファイルの削除(複数) */
+ (BOOL)removeItemAndDirAtPaths:(NSArray *)paths
{
    if (0 == [paths count]) {
        // 削除対象なし
        return YES;
    }
    
    for (NSString *path in paths) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    NSMutableArray *pathArray =
    [NSMutableArray arrayWithArray:[[paths objectAtIndex:0] pathComponents]];
    [pathArray removeLastObject];
    
    return [[NSFileManager defaultManager] removeItemAtPath:[NSString pathWithComponents:pathArray]
                                                      error:nil];
}

/** 指定されたファイルの削除 */
+ (BOOL)removeItemAndDirAtPath:(NSString *)path
{
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    NSMutableArray *pathArray = [NSMutableArray arrayWithArray:[path pathComponents]];
    [pathArray removeLastObject];
    
    return [[NSFileManager defaultManager] removeItemAtPath:[NSString pathWithComponents:pathArray]
                                                      error:nil];
}

#pragma mark -
#pragma mark ===== Private Class Method =====
+ (BOOL)saveLauncherData:(LauncherData *)data fileName:(NSString *)name
{
    BOOL ret = [TMFileManager saveLauncherData:[data dataDictionary]
                                  withFileName:name];
    
    if (ret == NO) {
        return ret;
    }
    
    // データを最新へ更新
    [[LauncherDataManager shared] reloadData];
    
    return ret;
}

@end
