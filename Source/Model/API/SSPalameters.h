//
//  SSPalameters.h
//  SSLauncher
//
//  Created by toomoo on 2014/08/31.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**************************************************************************************
 * SSCAのパラメータ用列挙体の定義
 *  SSCAのAPI仕様書を元に同一の値となるよう定義している(P2ZZ-0140-04Z0.pdf, #V1.0L30時点)
 **************************************************************************************/
/** SSCAから読み取りデータを自動削除する */
typedef NS_ENUM(NSInteger, SSAutoDelete) {
    
    SSAutoDeleteNoDel = 0,
    SSAutoDeleteDel,
    
};

/** 保存時のファイルフォーマット(現状PDFのみ) */
typedef NS_ENUM(NSInteger, SSFileFormat) {
    
    SSFileFormatPDF  = 1,
    SSFileFormatJpeg,
    
};

/** Jpegをまとめて保存する(カメラロールへの保存。複数ファイルの連携はできない) */
/*
 typedef NS_ENUM(NSInteger, SSJpegSaveTogether) {
 
 SSJpegSaveTogetherDisable = 0,
 SSJpegSaveTogetherEnable
 
 };
 */

/** 読み取り面指定(ix100は指定した値にかかわらず片面のみ) */
typedef NS_ENUM(NSInteger, SSScanningSide) {
    
    SSScanningSideBoth = 0,         /**< 両面 */
    SSScanningSideSingle,           /**< 片面 */
    
};

/** カラー指定(白黒はPDFのみ) */
typedef NS_ENUM(NSInteger, SSColorMode) {
    
    SSColorModeAuto = 1,        /**< 自動 */
    SSColorModeColor,           /**< カラー */
    SSColorModeMono,            /**< 白黒 */
    SSColorModeGray = 5,        /**< グレー */
    
};

/** カラー指定白黒の場合の濃度 */
typedef NS_ENUM(NSInteger, SSMonoConcentration) {
    
    SSMonoConcentrationLvMinus5 = 0,         /**< 最も淡い */
    SSMonoConcentrationLvMinus4,
    SSMonoConcentrationLvMinus3,
    SSMonoConcentrationLvMinus2,
    SSMonoConcentrationLvMinus1,
    SSMonoConcentrationLv0,
    SSMonoConcentrationLv1,
    SSMonoConcentrationLv2,
    SSMonoConcentrationLv3,
    SSMonoConcentrationLv4,
    SSMonoConcentrationLv5,                  /**< 最も濃い */
    
};

/** 解像度 */
typedef NS_ENUM(NSInteger, SSScanMode) {
    
    SSScanModeNormal        = 1,
    SSScanModeFine,
    SSScanModeSuperFine,
    SSScanModeAuto          = 99,
    
};

/** 継続読み取りの有無 */
typedef NS_ENUM(NSInteger, SSContinueScan) {
    
    SSContinueScanDisable = 0,
    SSContinueScanEnable,
    
};

/** 白紙ページの削除 */
typedef NS_ENUM(NSInteger, SSBlankPageSkip) {
    
    SSBlankPageSkipNoDel = 0,
    SSBlankPageSkipDel,
    
};

/** 裏写りを軽減する */
typedef NS_ENUM(NSInteger, SSReduceBleedThrough) {
    
    SSReduceBleedThroughDisable = 0,
    SSReduceBleedThroughEnable,
    
};

/** ファイル名称のフォーマット */
typedef NS_ENUM(NSInteger, SSFileNameFormat) {
    
    SSFileNameFormatJP = 0,                 /**< yyyy年MM月dd日HH時mm分ss秒, yyyy_MM_dd_HH_ mm_ss(日本語以 外の言語) */
    SSFileNameFormatNoSeparator,            /**< yyyyMMddHHmmss */
    SSFileNameFormatDirect,                 /**< 直接入力([スキャン実行時]もここに含む) */
    SSFileNameFormatSeparatorHyphen,        /**< yyyy-MM-dd-HH-mm-ss */
    
};

/** 原稿サイズ */
typedef NS_ENUM(NSInteger, SSPaperSize) {
    
    SSPaperSizeAuto = 0,         /**< 自動 */
    SSPaperSizeA4,               /**<  */
    SSPaperSizeA5,               /**<  */
    SSPaperSizeA6,               /**<  */
    SSPaperSizeB5,               /**<  */
    SSPaperSizeB6,               /**<  */
    SSPaperSizePostCard,         /**< はがき  */
    SSPaperSizeBusinessCard,     /**< 名刺 */
    SSPaperSizeLetter,           /**< レター */
    SSPaperSizeLegal,            /**< リーガル */
    
};

/** マルチフィード検出(ix100の場合は必ず無視される) */
typedef NS_ENUM(NSInteger, SSMultiFeedControl) {
    
    SSMultiFeedControlDisable = 0,      /**< 検出しない */
    SSMultiFeedControlEnable,           /**< 検出する */
    
};

/** 圧縮率 */
typedef NS_ENUM(NSInteger, SSCompression) {
    
    SSCompressionLvMinus2 = 1,      /**< 弱い */
    SSCompressionLvMinus1,          /**< やや弱い */
    SSCompressionLv0,               /**< 標準 */
    SSCompressionLv1,               /**< やや強く */
    SSCompressionLv2,               /**< 強く */
};


@interface SSPalameters : NSObject

/** 各列挙体の文字列マッピング関数 */
+ (NSString *)stringFromSSFileFormat:(SSFileFormat)val;
+ (NSString *)pathExtensionFromSSFileFormat:(SSFileFormat)val;
+ (NSString *)stringFromSSScanningSide:(SSScanningSide)val;
+ (NSString *)stringFromSSColorMode:(SSColorMode)val;
+ (NSString *)stringFromSSMonoConcentration:(SSMonoConcentration)val;
+ (NSString *)stringFromSSScanMode:(SSScanMode)val;
+ (NSString *)stringFromSSFileNameFormat:(SSFileNameFormat)val;
+ (NSString *)stringFromSSPaperSize:(SSPaperSize)val;
+ (NSString *)stringFromSSCompression:(SSCompression)val;

@end
