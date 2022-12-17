//
//  SSPalameters+Extension.h
//  SSLauncher
//
//  Created by toomoo on 2014/10/03.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SSPalameters.h"

/**************************************************************************************
 * SSCAのパラメータ用列挙体を独自拡張
 *  SSCAのAPI仕様書に存在しない列挙体
 **************************************************************************************/

/** ファイル名称のフォーマットの独自拡張 */
typedef NS_ENUM(NSInteger, SSFileNameFormatEx) {

    SSFileNameFormatExScanRuntime = 100,                 /**< スキャン実行時に入力 */
    
};

/** ファイル名に付与するプレフィックスタイプ */
typedef NS_ENUM(NSInteger, TMFileNamePrefix) {
    
    TMFileNamePrefixNone = 0,                   /**< なし */
    TMFileNamePrefixyyyyMMdd,                   /**< yyyyMMdd */
    TMFileNamePrefixyyyyMM,                     /**< yyyyMM */
    TMFileNamePrefixyyyy,                       /**< yyyy */
    TMFileNamePrefixMM,                         /**< MM */
    TMFileNamePrefixMMdd,                       /**< MMdd */
    TMFileNamePrefixDirectInput,                /**< 直接入力 */
    
};

/** ファイル名に付与するサフィックスタイプ */
typedef NS_ENUM(NSInteger, TMFileNameSuffix) {
    
    TMFileNameSuffixNone = 0,                   /**< なし */
    TMFileNameSuffixyyyyMMdd,                   /**< yyyyMMdd */
    TMFileNameSuffixyyyyMM,                     /**< yyyyMM */
    TMFileNameSuffixyyyy,                       /**< yyyy */
    TMFileNameSuffixMM,                         /**< MM */
    TMFileNameSuffixMMdd,                       /**< MMdd */
    TMFileNameSuffixDirectInput,                /**< 直接入力 */
    
};

/** 区切り文字タイプ */
typedef NS_ENUM(NSInteger, TMDelimiterType) {
    
    TMDelimiterTypeNone = 0,                    /**< なし */
    TMDelimiterTypeUnderScore,                  /**< "_" アンダースコア */
    TMDelimiterTypeHyphen,                      /**< "-" ハイフン */

};

/** 連番タイプ */
typedef NS_ENUM(NSInteger, TMSequentialNumberType) {
    
    TMSequentialNumberTypeNum = 0,              /**< "n"   カッコなし*/
    TMSequentialNumberTypeNumParentheses,       /**< "(n)" 丸括弧 */
    TMSequentialNumberTypeNumBracket,           /**< "[n]" カギ括弧 */
};

@interface SSPalameters (Extension)

+ (NSString *)stringFromSSFileNameFormatEx:(SSFileNameFormatEx)val
                       SSFileNameFormat:(SSFileNameFormat)orgVal;

+ (NSString *)stringFromTMFileNamePrefix:(TMFileNamePrefix)val;
+ (NSString *)stringFromTMFileNameSuffix:(TMFileNameSuffix)val;
+ (NSString *)stringFromTMDelimiterType:(TMDelimiterType)val;
/** 連番タイプに合わせたフォーマットを返す */
+ (NSString *)stringSequentialNumberType:(TMSequentialNumberType)val;

@end
