//
//  SchemeOpenURL.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/05.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchemeOpenURL : NSObject

/** URLがSSCAからのコールバックか判断します */
+ (BOOL)isEqualCallbackSSCAURL:(NSURL *)url;

/** SSCAでのスキャン後の処理をURLに沿って行います */
+ (BOOL)performScannedProcess:(NSURL *)url;

/** URLがWidgetからの呼び出しか判断します */
+ (BOOL)isEqualWidgetURL:(NSURL *)url;

/** Widgetから呼び出されてスキャンする */
+ (BOOL)executeScanFromWidget:(NSURL *)url;

@end
