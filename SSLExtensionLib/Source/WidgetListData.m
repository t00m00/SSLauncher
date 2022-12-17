//
//  WidgetListData.m
//  SSLauncher
//
//  Created by toomoo on 2015/01/28.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "WidgetListData.h"

@implementation WidgetListData

//* 連想配列の値でインスタンスを作成する */
+ (instancetype)create:(NSDictionary *)dataDictionary
{
    WidgetListData *data = [[WidgetListData alloc] init];
    
    NSString *title = [dataDictionary valueForKey:@(WidgetListDataPropTitle).stringValue];
    data.title = (title == nil) ? @"" : title;
    
    data.cloudTypeStr = [dataDictionary valueForKey:@(WidgetListDataPropCloudTypeStr).stringValue];
    
    data.favoriteSortValue =
    [[dataDictionary valueForKey:@(WidgetListDataPropFavoriteSortValue).stringValue] integerValue];
    data.favoriteSortValue = (0 == data.favoriteSortValue) ? UINT_MAX : data.favoriteSortValue;
    
    return data;
}

//* プロパティの値を連想配列で取得する */
- (NSDictionary *)widgetDataDictionary
{
    return
    @{
      
      @(WidgetListDataPropTitle).stringValue:                 self.title,
      @(WidgetListDataPropCloudTypeStr).stringValue:          self.cloudTypeStr,
      @(WidgetListDataPropFavoriteSortValue).stringValue:     @(self.favoriteSortValue),
      
      };
}

@end

