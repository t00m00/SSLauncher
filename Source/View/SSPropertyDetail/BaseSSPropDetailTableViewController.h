//
//  BaseSSPropDetailTableViewController.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/15.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPalameters+Extension.h"

@class LauncherData;

/** 詳細プロパティのベースとなるクラスです（LauncherDataプロパティを定義するため） */
@interface BaseSSPropDetailTableViewController : UITableViewController

@property (strong, nonatomic) LauncherData *data;

+ (TMDelimiterType)TMDelimiterTypeFromIndex:(NSUInteger)index;

@end
