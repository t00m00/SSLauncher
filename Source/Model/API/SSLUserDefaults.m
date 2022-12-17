//
//  SSLUserDefaults.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/07.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SSLUserDefaults.h"

/**************************************************************************************
 * データkey名
 **************************************************************************************/
static NSString * const kDefDescriptionView             = @"kDefDescriptionView";
static NSString * const kDefFineNameOfScanRuntime       = @"kDefFineNameOfScanRuntime";
static NSString * const kDefDropboxUserName             = @"kDefDropboxUserName";
static NSString * const kDefEvernoteUserName            = @"kDefEvernoteUserName";
static NSString * const kDefLaunchUnrestraintTitle      = @"kDefLaunchUnrestraintTitle";
static NSString * const kDefLaunchUnrestraintPrice      = @"kDefLaunchUnrestraintPrice";
static NSString * const kDefLaunchUnrestraintKounyu     = @"kDefLaunchUnrestraintKounyu";
static NSString * const kDefLastScanDate                = @"kDefLastScanDate";
static NSString * const kDefScanSuccessfulCount         = @"kDefScanSuccessfulCount";
static NSString * const kDefCloudSavePath               = @"kDefCloudSavePath";
static NSString * const kDefLastShowedViewController    = @"kDefLastShowedViewController";
static NSString * const kDefPushSSCAInstallButton       = @"kDefPushSSCAInstallButton";
static NSString * const kDefPushCloudSettingImage       = @"kDefPushCloudSettingImage";


/** アプリ内のデータを保存する */
@implementation SSLUserDefaults

/**************************************************************************************
 * 初期説明画面関連
 **************************************************************************************/
/** 初期説明画面を表示する必要があるか */
+ (BOOL)isDescriptionViewShow
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefDescriptionView:@(YES)}];
    
    return [ud boolForKey:kDefDescriptionView];
}

+ (void)setDescriptionViewShow:(BOOL)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:kDefDescriptionView];
    [ud synchronize];
}

/**************************************************************************************
 * スキャン時のファイル名関連
 **************************************************************************************/
/** スキャン実行時にファイル名を入力する場合、入力されたファイル名を記憶する */
+ (NSString *)fineNameOfScanRuntime:(NSString *)launcherName
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{[kDefFineNameOfScanRuntime stringByAppendingString:launcherName]:
                               @""}];
    
    return [ud stringForKey:[kDefFineNameOfScanRuntime stringByAppendingString:launcherName]];
}

+ (void)setFineNameOfScanRuntime:(NSString *)value launcherName:(NSString *)launcherName
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:[kDefFineNameOfScanRuntime stringByAppendingString:launcherName]];
    [ud synchronize];
}

/**************************************************************************************
 * スキャンのプロパティ関連
 **************************************************************************************/
/** クラウドタイプ毎に最後に入力された保存先を記憶する */
+ (NSString *)cloudSavePathAtCloudType:(NSString *)cloudType
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{[kDefCloudSavePath stringByAppendingString:cloudType]:
                               NSLocalizedString(@"LData_Default_CloudSavePath", @"")}];
    
    return [ud stringForKey:[kDefCloudSavePath stringByAppendingString:cloudType]];
}


+ (void)setCloudSavePath:(NSString *)value AtCloudType:(NSString *)typeString
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:[kDefCloudSavePath stringByAppendingString:typeString]];
    [ud synchronize];
}

/**************************************************************************************
 * クラウド関連
 **************************************************************************************/
/** Dropboxのユーザー名 */
+ (NSString *)dropboxUserName
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefDropboxUserName:
                               NSLocalizedString(@"Common_Cloud_NoConnect", @"")}];
    
    return [ud stringForKey:kDefDropboxUserName];
}

+ (void)setDropboxUserName:(NSString *)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:kDefDropboxUserName];
    [ud synchronize];
}

/** Evernoteのユーザー名 */
+ (NSString *)evernoteUserName
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefEvernoteUserName:
                               NSLocalizedString(@"Common_Cloud_NoConnect", @"")}];
    
    return [ud stringForKey:kDefEvernoteUserName];
}

+ (void)setEvernoteUserName:(NSString *)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:kDefEvernoteUserName];
    [ud synchronize];
}

/**************************************************************************************
 * アプリ内課金関連
 **************************************************************************************/
/** 「リストを無制限にする」のタイトル */
+ (NSString *)launchUnrestraintTitle
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefLaunchUnrestraintTitle:
                               NSLocalizedString(@"IAPView_LaunchUnrestraintTitle", @"")}];
    
    return [ud stringForKey:kDefLaunchUnrestraintTitle];
}

+ (void)setLaunchUnrestraintTitle:(NSString *)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:kDefLaunchUnrestraintTitle];
    [ud synchronize];
}

/** 「リストを無制限にする」の価格 */
+ (NSString *)launchUnrestraintPrice
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefLaunchUnrestraintPrice:
                               NSLocalizedString(@"IAPView_LaunchUnrestraintPrice", @"")}];
    
    return [ud stringForKey:kDefLaunchUnrestraintPrice];
}

+ (void)setLaunchUnrestraintPrice:(NSString *)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:kDefLaunchUnrestraintPrice];
    [ud synchronize];
}

/** 「リストを無制限にする」の購入 */
+ (BOOL)launchUnrestraintKounyu
{
    
#if defined(SCREENSHOT)

    return YES;
    
#else

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefLaunchUnrestraintKounyu:@(NO)}];
    
    return [ud boolForKey:kDefLaunchUnrestraintKounyu];
    
#endif
    
}

+ (void)setLaunchUnrestraintKounyu:(BOOL)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:kDefLaunchUnrestraintKounyu];
    [ud synchronize];
}


/**************************************************************************************
 * スキャン回数関連
 **************************************************************************************/
/** 最後にスキャンした日 */
+ (NSString *)lastScanDate
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefLastScanDate:
                               NSLocalizedString(@"LastScanDate_Default", @"")}];
    
    return [ud stringForKey:kDefLastScanDate];
}

+ (void)setLastScanDate:(NSString *)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:value forKey:kDefLastScanDate];
    [ud synchronize];
}

/** 現在のスキャン成功回数 */
+ (NSInteger)scanSuccessfulCount
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefScanSuccessfulCount:@(0)}];
    
    return [ud integerForKey:kDefScanSuccessfulCount];
}

+ (void)setScanSuccessfulCount:(NSInteger)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:value forKey:kDefScanSuccessfulCount];
    [ud synchronize];
}

/**************************************************************************************
 * チュートリアル画面関連
 **************************************************************************************/
/** SSCAをインストールするボタンを押下したか */
+ (BOOL)isPushSSCAInstallButton
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefPushSSCAInstallButton:@(NO)}];
    
    return [ud boolForKey:kDefPushSSCAInstallButton];
}

+ (void)setPushSSCAInstallButton:(BOOL)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:kDefPushSSCAInstallButton];
    [ud synchronize];
}

/** SSCAをインストールするボタンを押下したか */
+ (BOOL)isPushCloudSettingImage
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefPushCloudSettingImage:@(NO)}];
    
    return [ud boolForKey:kDefPushCloudSettingImage];
}

+ (void)setPushCloudSettingImage:(BOOL)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:kDefPushCloudSettingImage];
    [ud synchronize];
}


/**************************************************************************************
 * 画面制御関連
 **************************************************************************************/
/** 最後に表示していた画面 */
/*
+ (NSInteger)lastShowedViewControllerTag
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // 初期値をセットします。
    [ud registerDefaults:@{kDefLastShowedViewController:@(0)}];
    
    return [ud integerForKey:kDefLastShowedViewController];
}

+ (void)setLastShowedViewControllerTag:(NSInteger)value
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:value forKey:kDefLastShowedViewController];
    [ud synchronize];
}
*/

@end
