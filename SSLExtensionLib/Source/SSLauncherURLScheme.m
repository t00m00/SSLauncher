//
//  SSLauncherURLScheme.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/03.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SSLauncherURLScheme.h"

/** 本アプリのURLスキーム */
#if defined(MYSELF)
NSString * const kSSLauncherURLScheme = @"sslauncher-self";          // 自分用
#else
NSString * const kSSLauncherURLScheme = @"sslauncher";
#endif

/**************************************************************************************
 * URLの部品
 **************************************************************************************/
static NSString * const kURLSep     = @"://";
static NSString * const kColon      = @":";
static NSString * const kSlash      = @"/";
static NSString * const kAmp        = @"&";
static NSString * const kEqual      = @"=";

/**************************************************************************************
 * Widget(TodayExtension)からの呼び出しに使用する文字列
 **************************************************************************************/
static NSString * const kSSLIsWidgetString      = @"LAUNCHWIDGET";              /**< Widgetから呼び出されたことを判定する文字列 */
static NSString * const kSSLRowIndex            = @"RowIndex";                  /**< 選択された行番号 */

@implementation SSLauncherURLScheme

// SSLaunchrをWidget呼び出すURLSchemeを作成します
+ (NSURL *)createSSLWidgetUrl:(NSUInteger)rowIndex
{
    
    // URLスキーム
    NSMutableString *urlString = [NSMutableString stringWithString:kSSLauncherURLScheme];
    
    // Widgetからの判定
    [urlString appendString:kURLSep];
    [urlString appendString:kSSLIsWidgetString];
    
    // 選択された行番号
    [urlString appendString:kAmp];
    [urlString appendString:kSSLRowIndex];
    [urlString appendString:kEqual];
    [urlString appendString:@(rowIndex).stringValue];
    
    
    return [NSURL URLWithString:[[urlString stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]]
                                 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

/** URLがWidgetからの呼び出しか判断します */
+ (BOOL)isSSLWidgetUrl:(NSURL *)url
{
    NSString *sepStr = [kURLSep stringByAppendingString:kSSLIsWidgetString];
    NSArray *pairs = [[url absoluteString] componentsSeparatedByString:sepStr];
    
    const int noItem = 1, multiItem = 3;
    if (pairs.count <= noItem || multiItem <= pairs.count) {
        // Widgetからのコールバックではない
        return NO;
    }
    
    return YES;
}

/** URL内からWidgetで選択された行番号を取得します */
+ (NSString *)extractSelectedRowInCallWidgetURL:(NSURL *)url
{
    NSString *retStr = @"";
    NSString * const keyword = [NSString stringWithFormat:@"%@%@", kSSLRowIndex, kEqual];
    
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

@end
