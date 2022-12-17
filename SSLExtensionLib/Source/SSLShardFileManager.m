//
//  SSLShardFileManager.m
//  SSLauncher
//
//  Created by toomoo on 2015/01/26.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "SSLShardFileManager.h"

/** グループID */
static NSString * const kGroupIdentifer = @"group.com.toomoo.Scanner";

/** ファイル名Prefix */
static NSString * const kPrefixShardLauncherData = @"ShardLauncherData";

/** ファイル名(複数) */
static NSString * const kDatasName = @"Array";


@implementation SSLShardFileManager

#pragma mark -
#pragma mark ===== Class Method =====

/** 共有ファイルとして保存 */
+ (BOOL)saveWidgetData:(NSDictionary *)data withFavoriteSortNo:(NSString *)num
{
    NSURL *fileURL = [[self class] urlOfLauncherData:num];
    
    return [data writeToURL:fileURL atomically:YES];
}

/** 共有ファイルの読み出し */
+ (NSDictionary *)readWidgetDataWithFavoriteSortNo:(NSString *)num
{
    NSURL *fileURL = [[self class] urlOfLauncherData:num];
    
    return [[NSDictionary alloc] initWithContentsOfURL:fileURL];
}

/** 共有ファイル(複数)として保存 */
+ (BOOL)saveWidgetDatas:(NSArray *)datas
{
    NSURL *fileURL = [[self class] urlOfLauncherData:kDatasName];
    
    return [datas writeToURL:fileURL atomically:YES];
}

/** 共有ファイル(複数)の読み出し */
+ (NSArray *)readWidgetDatas
{
    NSURL *fileURL = [[self class] urlOfLauncherData:kDatasName];
    
     NSArray *datas = [[NSArray alloc] initWithContentsOfURL:fileURL];
    
    return (nil == datas) ? [NSArray array] : datas;
}

#pragma mark -
#pragma mark ===== Private Class Method =====

/** 共有ファイルの読み出し */
+ (NSURL *)urlOfLauncherData:(NSString *)number
{
    NSURL *fileUrl =
    [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kGroupIdentifer];
    
    fileUrl =[fileUrl URLByAppendingPathComponent:
              [kPrefixShardLauncherData stringByAppendingString:number]];
    
    return fileUrl;
}

@end
