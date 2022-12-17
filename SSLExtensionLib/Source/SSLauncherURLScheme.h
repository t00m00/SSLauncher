//
//  SSLauncherURLScheme.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/03.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 本アプリのURLスキーム */
extern NSString * const kSSLauncherURLScheme;

@interface SSLauncherURLScheme : NSObject

/** SSLaunchrをWidget呼び出すURLSchemeを作成します */
+ (NSURL *)createSSLWidgetUrl:(NSUInteger)rowIndex;

/** URLがWidgetからの呼び出しか判断します */
+ (BOOL)isSSLWidgetUrl:(NSURL *)url;

/** URL内からWidgetで選択された行番号を取得します */
+ (NSString *)extractSelectedRowInCallWidgetURL:(NSURL *)url;

@end
