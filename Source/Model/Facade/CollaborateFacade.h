//
//  CollaborateFacade.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/03.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LauncherData;

@interface CollaborateFacade : NSObject

/** 指定されたデータでSSCAを呼び出します */
+ (BOOL)openSSCAWithData:(LauncherData *)data;

/** URLがSSCAからのコールバックか判断します */
+ (BOOL)isEqualCallbackSSCAURL:(NSURL *)url;

/** SSCAの戻り値からファイルを保存する(複数ある場合はすべてを保存) */
+ (NSArray *)saveSSCAFilesWithURL:(NSURL *)url;

/** App Store で SSCAのページを開きます  */
+ (BOOL)openAppStoreToSSCA;

/** URLがWidgetからの呼び出しか判断します */
+ (BOOL)isEqualWidgetURL:(NSURL *)url;

/** URL内からWidgetで選択された行番号を取得します */
+ (NSString *)extractSelectedRowInCallWidgetURL:(NSURL *)url;

@end
