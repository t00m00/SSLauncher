//
//  SSLUserDefaults.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/07.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSLUserDefaults : NSObject

/**************************************************************************************
 * 初期説明画面関連
 **************************************************************************************/
/** 初期説明画面を表示する必要があるか */
+ (BOOL)isDescriptionViewShow;
+ (void)setDescriptionViewShow:(BOOL)value;

/**************************************************************************************
 * スキャン時のファイル名関連
 **************************************************************************************/
/** スキャン実行時にファイル名を入力する場合、入力されたファイル名を記憶する */
+ (NSString *)fineNameOfScanRuntime:(NSString *)launcherName;
+ (void)setFineNameOfScanRuntime:(NSString *)value launcherName:(NSString *)launcherName;

/**************************************************************************************
 * スキャンのプロパティ関連
 **************************************************************************************/
/** クラウドタイプ毎に最後に入力された保存先を記憶する */
+ (NSString *)cloudSavePathAtCloudType:(NSString *)cloudType;
+ (void)setCloudSavePath:(NSString *)value AtCloudType:(NSString *)typeString;

/**************************************************************************************
 * クラウド関連
 **************************************************************************************/
/** Dropboxのユーザー名 */
+ (NSString *)dropboxUserName;
+ (void)setDropboxUserName:(NSString *)value;

/** Evernoteのユーザー名 */
+ (NSString *)evernoteUserName;
+ (void)setEvernoteUserName:(NSString *)value;

/**************************************************************************************
 * アプリ内課金関連
 **************************************************************************************/
/** 「リストを無制限にする」のタイトル */
+ (NSString *)launchUnrestraintTitle;
+ (void)setLaunchUnrestraintTitle:(NSString *)value;

/** 「リストを無制限にする」の価格 */
+ (NSString *)launchUnrestraintPrice;
+ (void)setLaunchUnrestraintPrice:(NSString *)value;

/** 「リストを無制限にする」の購入 */
+ (BOOL)launchUnrestraintKounyu;
+ (void)setLaunchUnrestraintKounyu:(BOOL)value;

/**************************************************************************************
 * スキャン回数関連
 **************************************************************************************/
/** 最後にスキャンした日 */
+ (NSString *)lastScanDate;
+ (void)setLastScanDate:(NSString *)value;

/** 現在のスキャン成功回数 */
+ (NSInteger)scanSuccessfulCount;
+ (void)setScanSuccessfulCount:(NSInteger)value;

/**************************************************************************************
 * チュートリアル画面関連
 **************************************************************************************/
/** SSCAをインストールするボタンを押下したか */
+ (BOOL)isPushSSCAInstallButton;
+ (void)setPushSSCAInstallButton:(BOOL)value;

/** SSCAをインストールするボタンを押下したか */
+ (BOOL)isPushCloudSettingImage;
+ (void)setPushCloudSettingImage:(BOOL)value;


/**************************************************************************************
 * 画面制御関連
 **************************************************************************************/
/** 最後に表示していた画面 */
/*
+ (NSInteger)lastShowedViewControllerTag;
+ (void)setLastShowedViewControllerTag:(NSInteger)value;
*/

@end
