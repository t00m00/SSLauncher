//
//  LauncherData+Managing.h
//  SSLauncher
//
//  Created by toomoo on 2014/08/31.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "LauncherData.h"

/** LauncherDataクラスの各プロパティに対応する列挙体
 *  ★注意★
 *    追加する場合は必ず最後に追加していくこと(アプリをアップデートした際の整合性を保つため)。
 */
typedef NS_ENUM(NSInteger, LauncherDataProp) {
    
    // V1.0.0
    LauncherDataPropTitle = 0,
    LauncherDataPropCloudType,
    LauncherDataPropCloudSavePath,
    LauncherDataPropScannerConnectAuto,
    LauncherDataPropScannerName,
    LauncherDataPropAutoDelete,
    LauncherDataPropFileFormat,
    LauncherDataPropScanSide,
    LauncherDataPropColorMode,
    LauncherDataPropConcentration,
    LauncherDataPropScanningMode,
    LauncherDataPropContinueScan,
    LauncherDataPropBlankPageSkip,
    LauncherDataPropReduceBleedThrough,
    LauncherDataPropFileNameFormat,
    LauncherDataPropFileNameFormatEx,
    LauncherDataPropFileName,
    LauncherDataPropFileNameInputExeScan,
    LauncherDataPropPaperSize,
    LauncherDataPropMultiFeed,
    LauncherDataPropCompression,
    // V1.1.0
    LauncherDataPropFileNameDisplay,
    LauncherDataPropFileNamePrefix,
    LauncherDataPropFileNameSuffix,
    LauncherDataPropFileNamePrefixText,
    LauncherDataPropFileNameSuffixText,
    LauncherDataPropFileNamePrefixDelimiter,
    LauncherDataPropFileNameSuffixDelimiter,
    LauncherDataPropFavorite,
    // V2.0.0
    LauncherDataPropShareLink,
    LauncherDataPropPreview,
    // V2.1.0
    LauncherDataPropSequentialNumberType,
    LauncherDataPropSequentialNumberDelimiter,
    
    //============================================
    // 内部データ用
    //============================================
    // V1.0.0
    LauncherDataPropInternalFileName= 500,
    LauncherDataPropInternalSortValue,
    LauncherDataPropInternalFavoriteSortValue,
};

@interface LauncherData (Managing)

//* インスタンスを作成する */
+ (instancetype)create;

//* 連想配列の値でインスタンスを作成する */
+ (instancetype)create:(NSDictionary *)dataDictionary;

//* プロパティの値を連想配列で取得する */
- (NSDictionary *)dataDictionary;

/*****************************************/
/** 各種ゲッター/セッター                   */
/*****************************************/
/** データファイル名 */
- (void)setLauncherDataFileName:(NSString *)launcherDataFileName;
- (NSString *)launcherDataFileName;

/** ソートの値 */
- (void)setSortValue:(NSUInteger)sortValue;
- (NSUInteger)sortValue;
- (void)setFavoriteSortValue:(NSUInteger)favoriteSortValue;
- (NSUInteger)favoriteSortValue;

/** お気に入りソートの値をリセット */
- (void)resetFavoriteSortValue;



/*****************************************/
/** 列挙体に合わせた表示用文字列              */
/*****************************************/
/** クラウドタイプの表示用の文字列を表示する */
+ (NSString *)cloudTypeText:(SSLCloudType)type;

/** 表示用のPrefix文字列を表示する */
+ (NSString *)displayPrefixText:(LauncherData *)data;

/** 表示用のPrefix文字列を表示する("なし"は表示しない) */
+ (NSString *)fileNamePrefixText:(LauncherData *)data;

/** 表示用のSuffix文字列を表示する */
+ (NSString *)displaySuffixText:(LauncherData *)data;

/** 表示用のSuffix文字列を表示する("なし"は表示しない) */
+ (NSString *)fileNameSuffixText:(LauncherData *)data;

/** クラウドタイプに合わせた入力を促す文字列を表示する */
+ (NSString *)promoEnterFileNameWithCloudType:(SSLCloudType)type;

@end
