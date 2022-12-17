//
//  SSUrlScheme.h
//  SSLauncher
//
//  Created by toomoo on 2014/08/30.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LauncherData;

/** SSCAを呼び出すURLSchemeを定義します */
@interface SSUrlScheme : NSObject

// SSCAを呼び出すURLSchemeを作成します
+ (NSURL *)createSSCAUrl:(LauncherData *)data
           withURLScheme:(NSString *)callbackURLScheme;

/** URLがSSCAからのコールバックか判断します */
+ (BOOL)isEqualCallbackSSCAURL:(NSURL *)url;

/** URL内にエラーがあるか判断します */
+ (BOOL)isEqualCallbackSSCAURLError:(NSURL *)url;

/** URL内からファイル名を取得します */
+ (NSString *)extractFileNameInCallbackSSCAURL:(NSURL *)url;

// SSCAがインストールされているか
+ (BOOL)isSSCAInstall;

@end
