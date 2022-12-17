//
//  WidgetListData+Converting.m
//  SSLauncher
//
//  Created by toomoo on 2015/01/28.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "WidgetListData+Converting.h"
#import "LauncherData+Managing.h"

@implementation WidgetListData (Converting)

+ (instancetype)createWithLauncherData:(LauncherData *)data
{
    WidgetListData *wData = [[WidgetListData alloc] init];
    
    wData.title = data.title;
    wData.cloudTypeStr = [LauncherData cloudTypeText:data.cloudType];
    
    if (YES == data.isShareLink) {
        
        // 「公開リンク」文字を追加
        wData.cloudTypeStr =
        [wData.cloudTypeStr stringByAppendingString:NSLocalizedString(@"Common_Cloud_And_SharableLink", @"")];
    }
    
    wData.favoriteSortValue = data.favoriteSortValue;
    
    return wData;
}

@end
