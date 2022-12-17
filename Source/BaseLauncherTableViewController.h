//
//  BaseLauncherTableViewController.h
//  SSLauncher
//
//  Created by toomoo on 2015/01/17.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LauncherData;
@interface BaseLauncherTableViewController : UITableViewController

//=====================================================================================
/** セルを構成するためのLauncherDataを返却する(サブクラスで必要に応じてオーバライド推奨) */
+ (LauncherData *)cellOfDataForRow:(NSIndexPath *)indexPath;

/** 各画面で対象となるデータ数を返却する(サブクラスで必要に応じてオーバライド推奨) */
+ (NSUInteger)countDataForTableView;

//=====================================================================================
/** セルのお気に入りボタンを押下された(サブクラスで必要に応じてオーバライド推奨) */
- (void)didViewRowActionOfFavorite:(UITableViewRowAction *)action
                         indexPath:(NSIndexPath *)indexPath;

/** スキャン処理の実行 */
- (void)exeScanningFile:(NSIndexPath *)indexPath;

//=====================================================================================
/** 編集ボタンの状態を更新 */
- (void)updataEditButtonEnable;

@end
