//
//  SSPropertyTableViewController.h
//  SSLauncher
//
//  Created by toomoo on 2014/08/30.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LauncherData;
@interface SSPropertyTableViewController : UITableViewController

@property (strong, nonatomic) LauncherData *data;           /**< テーブル表示に使用するdata(編集時のみ) */

@end
