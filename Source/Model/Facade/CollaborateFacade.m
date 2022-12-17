//
//  CollaborateFacade.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/03.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "CollaborateFacade.h"

#import "SSUrlScheme.h"
#import "LauncherData.h"
#import "LauncherDataManager+Managing.h"
#import "TMFileManager.h"
#import "SyncAlertView.h"
#import <SSLExtensionLib/SSLauncherURLScheme.h>


/** App Storeを開くためのURL */
static NSString * const kAppStoreURLBase    = @"itms-apps://itunes.apple.com/app/id";
static NSString * const kAppIDSSCAJP        = @"";
static NSString * const kAppIDSSCAOther     = @"";


@implementation CollaborateFacade

/** 指定されたデータでSSCAを呼び出します */
+ (BOOL)openSSCAWithData:(LauncherData *)data
{
    // SSCA呼び出しようURLの作成
    NSURL *url = [SSUrlScheme createSSCAUrl:data withURLScheme:kSSLauncherURLScheme];
    
//    NSLog(@"openURL url=%@", [url absoluteString]);
    
    BOOL ret = [[UIApplication sharedApplication] openURL:url];
    
    if (ret == YES) {
        // 処理中データとして登録
        [[LauncherDataManager shared] setProcessingObject:data];
    }
        
    return ret;
}

/** URLがSSCAからのコールバックか判断します */
+ (BOOL)isEqualCallbackSSCAURL:(NSURL *)url
{
    return [SSUrlScheme isEqualCallbackSSCAURL:url];
}

/** SSCAの戻り値からファイルを保存する */
+ (NSArray *)saveSSCAFilesWithURL:(NSURL *)url
{

    if ([[self class] isEqualCallbackSSCAURL:url] == NO) {
        // SSCAからのコールバックではない
        return nil;
    }
    
    if ([SSUrlScheme isEqualCallbackSSCAURLError:url] == YES) {
        
        // SSCAが読み取りに失敗
        // 処理中データを解除
        [[LauncherDataManager shared] setProcessingObject:nil];
        return nil;
    }
    
    LauncherData *data = [[LauncherDataManager shared] processingObject];

    NSMutableArray *files = [NSMutableArray array];

    switch (data.fileformat) {
        case SSFileFormatPDF:
        {
            NSString *file = [self saveSSCAPDFFileWithURL:url];
            [files addObject:file];
        }
            break;
            
        case SSFileFormatJpeg:
            files = [NSMutableArray arrayWithArray:[self saveSSCAJPEGFilesWithURL:url]];
            break;

        default:
            break;
    }
    
    return files;
}

/** App Store で SSCAのページを開きます  */
+ (BOOL)openAppStoreToSSCA
{
    NSURL *url = [NSURL URLWithString:
                  [kAppStoreURLBase stringByAppendingString:NSLocalizedString(@"SSCA_AppStore_AppID", @"")]];
    
    return [[UIApplication sharedApplication] openURL:url];
}

/** URLがWidgetからの呼び出しか判断します */
+ (BOOL)isEqualWidgetURL:(NSURL *)url
{
    return [SSLauncherURLScheme isSSLWidgetUrl:url];
}

/** URL内からWidgetで選択された行番号を取得します */
+ (NSString *)extractSelectedRowInCallWidgetURL:(NSURL *)url
{
    return [SSLauncherURLScheme extractSelectedRowInCallWidgetURL:url];
}

#pragma mark -
#pragma mark ===== Private Class Method =====

/** SSCAの戻り値からPDFファイルを保存する */
+ (NSString *)saveSSCAPDFFileWithURL:(NSURL *)url
{
    
    // URLからファイル名取得
    NSString *fileName = [SSUrlScheme extractFileNameInCallbackSSCAURL:url];
    
    // ジェネラルクリップボードから取得
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    // SSCAで読み取ったファイルが連想配列として保持されている
    NSDictionary *fileDataInfo = [pasteboard.items objectAtIndex:0];
    
    const int firstFileKey = 1;
    NSString *saveFilePath = [TMFileManager saveScannedTmpFile:[fileDataInfo valueForKey:@(firstFileKey).stringValue]
                                                  withFileName:fileName];
    
    if ([saveFilePath length] <= 0) {
        NSLog(@"[TMFileManager saveScannedTmpFile:withFileName:] failed");
        return nil;
    }
    
    
    
    
    
    
    
    
    return saveFilePath;
}

/** SSCAの戻り値からJPEGファイルを保存する(複数ある場合はすべてを保存) */
+ (NSArray *)saveSSCAJPEGFilesWithURL:(NSURL *)url
{
    
    // URLからファイル名取得（JPEGの場合はベースのファイル名）
    NSString *basefileName = [SSUrlScheme extractFileNameInCallbackSSCAURL:url];
    
    // ジェネラルクリップボードから取得
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    // SSCAで読み取ったファイルが連想配列として保持されている
    NSDictionary *fileDataInfo = [pasteboard.items objectAtIndex:0];
    
    // 複数ファイルの保存
    NSArray *saveFilePaths = [TMFileManager saveScannedTmpFiles:fileDataInfo
                                                   withFileName:basefileName
                                         sequentialNumberFormat:@"_%d"];   // ★ToDo★
    
    if ([saveFilePaths count] <= 0) {
        NSLog(@"[TMFileManager saveScannedTmpFile:withFileName:] failed");
        return nil;
    }
    
    return saveFilePaths;
}

@end
