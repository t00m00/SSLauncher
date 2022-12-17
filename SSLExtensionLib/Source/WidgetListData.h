//
//  WidgetListData.h
//  SSLauncher
//
//  Created by toomoo on 2015/01/28.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** WidgetListDataクラスの各プロパティに対応する列挙体
 *  ★注意★
 *    追加する場合は必ず最後に追加していくこと(アプリをアップデートした際の整合性を保つため)。
 */
typedef NS_ENUM(NSInteger, WidgetListDataProp) {
    
    // V2.0.0
    WidgetListDataPropTitle = 0,
    WidgetListDataPropCloudTypeStr,
    WidgetListDataPropFavoriteSortValue,
    
};

@interface WidgetListData : NSObject

@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *cloudTypeStr;
@property (nonatomic, assign) NSUInteger    favoriteSortValue;

//* 連想配列の値でインスタンスを作成する */
+ (instancetype)create:(NSDictionary *)dataDictionary;

//* プロパティの値を連想配列で取得する */
- (NSDictionary *)widgetDataDictionary;

@end
