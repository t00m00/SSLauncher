//
//  SSUrlScheme.m
//  SSLauncher
//
//  Created by toomoo on 2014/08/30.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SSUrlScheme.h"
#import "LauncherData.h"

/**************************************************************************************
 * URLの部品
 **************************************************************************************/
static NSString * const kURLSep     = @"://";
static NSString * const kColon      = @":";
static NSString * const kSlash      = @"/";
static NSString * const kAmp        = @"&";
static NSString * const kEqual      = @"=";
static NSString * const kQuestion   = @"?";

/**************************************************************************************
 * SSCAを呼び出すURLの元となる文字列
 **************************************************************************************/
// scansnap://[ScannerName]/[Scan][&AutoDelete=0 | 1][&Format=1 | 2] [&SaveTogether=0 | 1][&ScanningSide=0 | 1][&ColorMode=1 | 2 | 3 | 5] [&ScanMode=1 | 2 | 3 | 99][&ContinueScan=0 | 1][&BlankPageSkip=0 | 1] [&ReduceBleedThrough=0 | 1][&FileNameFormat=0 | 1 | 2 | 3][&PaperSize=0-9] [&MultiFeedControl=0 | 1][&Compression=1-5][OutMode=1 | 2 | 3 | 4][&OutPath= 保存先のパス ][&CallBack=url: | id: ]

static NSString * const kSSScheme               = @"scansnap";
static NSString * const kSSScan                 = @"Scan";
static NSString * const kSSAutoDelete           = @"AutoDelete";
static NSString * const kSSFileFormat           = @"Format";
static NSString * const kSSSaveTogether         = @"SaveTogether";
static NSString * const kSSScanSide             = @"ScanningSide";
static NSString * const kSSColorMode            = @"ColorMode";
static NSString * const kSSMonoConcentration    = @"Concentration";
static NSString * const kSSScanMode             = @"ScanMode";
static NSString * const kSSContinueScan         = @"ContinueScan";
static NSString * const kSSBlankPageSkip        = @"BlankPageSkip";
static NSString * const kSSReduceBleed          = @"ReduceBleedThrough";
static NSString * const kSSFileNameFormat       = @"FileNameFormat";
static NSString * const kSSSaveNameDirectInput  = @"SaveNameDirectInput";
static NSString * const kSSPaperSize            = @"PaperSize";
static NSString * const kSSMultiFeedControl     = @"MultiFeedControl";
static NSString * const kSSCompression          = @"Compression";
static NSString * const kSSOutMode              = @"OutMode";
static NSString * const kSSOutModeValue         = @"4";                         /**< ジェネラルクリップボード */
static NSString * const kSSCallBackURL          = @"CallBack";

/**************************************************************************************
 * SSCAからのコールバックを判定する元となる文字列
 **************************************************************************************/
// sscasample://PFUFILELISTFORMAT&OutMode=2&Format=2&FileCount=1&File1= file1.jpeg
static NSString * const kSSCBIsSSCAString       = @"PFUFILELISTFORMAT";         /**< SSCAから呼び出されたことを判定する文字列 */
static NSString * const kSSCBError              = @"Error";                     /**< エラーの場合 */
static NSString * const kSSCBFormat             = @"Format";                    /**< 現状未使用 */
static NSString * const kSSCBFileCount          = @"FileCount";                 /**< 現状未使用 */
static NSString * const kSSCBFile               = @"File";
static NSString * const kSSCBFileNum1           = @"1";                         /**< 現状必ずファイルの数は１つである */


@implementation SSUrlScheme

// SSCAを呼び出すURLSchemeを作成します
+ (NSURL *)createSSCAUrl:(LauncherData *)data
           withURLScheme:(NSString *)callbackURLScheme;
{
 
    // URLスキーム
    NSMutableString *urlString = [NSMutableString stringWithString:kSSScheme];
    
    [urlString appendString:kURLSep];
    
    // スキャナ名
    if (data.isScannerConnectAuto == NO) {
        [urlString appendString:data.scannerName];
    }

    [urlString appendString:kSlash];
    
    // スキャンを実行
    [urlString appendString:kSSScan];
    
    // 自動削除
    [urlString appendString:kAmp];
    [urlString appendString:kSSAutoDelete];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.autoDelete).stringValue];
    
    // ファイルフォーマット
    [urlString appendString:kAmp];
    [urlString appendString:kSSFileFormat];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.fileformat).stringValue];
    
    // まとめて保存
    // JPEGのみなので未実装(カメラロールには保存しない)
    
    // 読み取り面
    [urlString appendString:kAmp];
    [urlString appendString:kSSScanSide];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.scanSide).stringValue];
    
    // カラーモード
    [urlString appendString:kAmp];
    [urlString appendString:kSSColorMode];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.colorMode).stringValue];
    
    // 白黒濃度
    if (data.colorMode == SSColorModeMono) {
        [urlString appendString:kAmp];
        [urlString appendString:kSSMonoConcentration];
        [urlString appendString:kEqual];
        [urlString appendString:@(data.concentration).stringValue];
    }
    
    // スキャンモード（画質）
    [urlString appendString:kAmp];
    [urlString appendString:kSSScanMode];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.scanMode).stringValue];
    
    // 読み取り継続
    [urlString appendString:kAmp];
    [urlString appendString:kSSContinueScan];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.continueScan).stringValue];
    
    // 白紙削除
    [urlString appendString:kAmp];
    [urlString appendString:kSSBlankPageSkip];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.blankPageSkip).stringValue];
    
    // 裏写り軽減
    [urlString appendString:kAmp];
    [urlString appendString:kSSReduceBleed];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.reduceBleed).stringValue];
    
    // ファイル名フォーマット
    [urlString appendString:kAmp];
    [urlString appendString:kSSFileNameFormat];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.fileNameFormat).stringValue];
    
    // ファイル名（直接指定の場合）
    if (data.fileNameFormat == SSFileNameFormatDirect) {
        [urlString appendString:kAmp];
        [urlString appendString:kSSSaveNameDirectInput];
        [urlString appendString:kEqual];
        [urlString appendString:data.fileName];
    }
    
    // ペーパーサイズ
    [urlString appendString:kAmp];
    [urlString appendString:kSSPaperSize];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.paperSize).stringValue];
    
    // マルチフィード
    [urlString appendString:kAmp];
    [urlString appendString:kSSMultiFeedControl];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.multiFeed).stringValue];
 
    // 圧縮率
    [urlString appendString:kAmp];
    [urlString appendString:kSSCompression];
    [urlString appendString:kEqual];
    [urlString appendString:@(data.compression).stringValue];
    
    // アプリを呼び返すモード
    [urlString appendString:kAmp];
    [urlString appendString:kSSOutMode];
    [urlString appendString:kEqual];
    [urlString appendString:kSSOutModeValue];
    
    // コールバック
    if (0 < [callbackURLScheme length]) {
        [urlString appendString:kAmp];
        [urlString appendString:kSSCallBackURL];
        [urlString appendString:kEqual];
        [urlString appendString:callbackURLScheme];
//        [urlString appendString:kColon];
    }
    
    return [NSURL URLWithString:[[urlString stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

/** URLがSSCAからのコールバックか判断します */
+ (BOOL)isEqualCallbackSSCAURL:(NSURL *)url
{
    
    NSString *sepStr = [kURLSep stringByAppendingString:kSSCBIsSSCAString];
    NSArray *pairs = [[url absoluteString] componentsSeparatedByString:sepStr];
    
    const int noItem = 1, multiItem = 3;
    if (pairs.count <= noItem || multiItem <= pairs.count) {
        // SSCAからのコールバックではない
        return NO;
    }
    
    return YES;
}

/** URL内にエラーがあるか判断します */
+ (BOOL)isEqualCallbackSSCAURLError:(NSURL *)url
{
    NSString *sepStr = [kAmp stringByAppendingString:kSSCBError];
    NSArray *pairs = [[url absoluteString] componentsSeparatedByString:sepStr];
    
    const int noItem = 1, multiItem = 3;
    if (pairs.count <= noItem || multiItem <= pairs.count) {
        // エラーは存在しない
        return NO;
    }
    
    return YES;
}

/** URL内からファイル名を取得します */
+ (NSString *)extractFileNameInCallbackSSCAURL:(NSURL *)url
{
    NSString *retStr = @"";
    NSString * const keyword = [NSString stringWithFormat:@"%@%@%@", kSSCBFile, kSSCBFileNum1, kEqual];
    
    NSArray *pairs = [[url absoluteString] componentsSeparatedByString:keyword];
    
    const int noItem = 1, multiItem = 3;
    if (pairs.count <= noItem || multiItem <= pairs.count) {
        // ファイル名が含まれていない
        return retStr;
    }
    
    NSString *tmpFileName = [pairs lastObject];
    NSArray *fileNames = [tmpFileName componentsSeparatedByString:kAmp];
    
    return [fileNames firstObject];
}


/** URL内にキーワードが何回出現するか数えます（大文字、小文字を無視しない） */
+ (NSInteger)countNumberOfKeywordInURL:(NSURL *)url keyword:(NSString *)keyword
{
    NSArray *pairs = [[url absoluteString] componentsSeparatedByString:keyword];
    return ([pairs count] -1);
}

// SSCAがインストールされているか
+ (BOOL)isSSCAInstall
{
    NSString * const targetURL = [kSSScheme stringByAppendingString:kURLSep];
    return [[UIApplication sharedApplication]
            canOpenURL:[NSURL URLWithString:targetURL]];
}

@end
