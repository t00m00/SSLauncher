//
//  SSLShardFileManager.h
//  SSLauncher
//
//  Created by toomoo on 2015/01/26.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSLShardFileManager : NSObject

/** 共有ファイルとして保存 */
+ (BOOL)saveWidgetData:(NSDictionary *)data withFavoriteSortNo:(NSString *)num;

/** 共有ファイルの読み出し */
+ (NSDictionary *)readWidgetDataWithFavoriteSortNo:(NSString *)num;


/** 共有ファイル(複数)として保存 */
+ (BOOL)saveWidgetDatas:(NSArray *)datas;

/** 共有ファイル(複数)の読み出し */
+ (NSArray *)readWidgetDatas;

@end
