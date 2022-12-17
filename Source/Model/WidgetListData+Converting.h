//
//  WidgetListData+Converting.h
//  SSLauncher
//
//  Created by toomoo on 2015/01/28.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//


#import <SSLExtensionLib/WidgetListData.h>

@class LauncherData;

/** LauncherData ⇔ WidgetListData の変換をサポートします */
@interface WidgetListData (Converting)

+ (instancetype)createWithLauncherData:(LauncherData *)data;

@end
