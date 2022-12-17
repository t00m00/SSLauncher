//
//  SchemeOpenURL.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/05.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SchemeOpenURL.h"

#import "CollaborateFacade.h"
#import "CloudFacade.h"
#import "FileManageFacade.h"
#import "MsgStatusBarViewController.h"
#import "ScanLimitManager.h"
#import "ViewErrorMsg.h"
#import "UIViewController+Searching.h"
#import "BaseLauncherTableViewController.h"
#import "CompleteViewController.h"
#import "TabBarViewController.h"
#import "LauncherDataManager+Managing.h"
#import "LauncherData.h"
#import "UIView+PDF.h"
#import "TMPathDefine.h"
#import "ReaderDocument.h"

@interface SchemeOpenURL () <CloudFacadeDelegate>

@property (assign, nonatomic) BOOL isUploadFinish;
@property (strong, nonatomic) NSError *error;

@end

/** スキームで開かれた場合の処理を行います */
@implementation SchemeOpenURL

/** URLがSSCAからのコールバックか判断します */
+ (BOOL)isEqualCallbackSSCAURL:(NSURL *)url
{
    return [CollaborateFacade isEqualCallbackSSCAURL:url];
}

/** SSCAでのスキャン後の処理をURLに沿って行います */
+ (BOOL)performScannedProcess:(NSURL *)url
{
    
    // SSCAからのURLかチェック
    BOOL ret = [CollaborateFacade isEqualCallbackSSCAURL:url];
    
    if (ret == NO) {
        NSLog(@"Is not SSCA Callback url.");
        return NO;
    }
    
    // 読み取り後ファイル保存
    NSArray *saveFilePaths = [CollaborateFacade saveSSCAFilesWithURL:url];
    
    if ([saveFilePaths count] <= 0) {
        // 読み取りエラー
        NSLog(@"[CollaborateFacade saveSSCAFileWithURL] failed.");

        // SSCAで十分にエラー表示されているのでアラートとしては表示しない。
        [MsgStatusBarViewController showAndCloseWithMessage:NSLocalizedString(@"SSCA_Failed_Scan", @"")];
        return NO;
    }
    
    // アップロード対象のクラウドに接続済みか確認する
     if ([CloudFacade signedin] == NO) {

         UIAlertView *alert =
         [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Err_Cloud_Upload_Title_NoConnect", @"")
                                    message:NSLocalizedString(@"Err_Cloud_Upload_Body_NoConnect", @"")
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"Common_Alert_Button_OK", @""), nil];

         [alert show];
         return NO;
     }
    
    LauncherData *data = [[LauncherDataManager shared] processingObject];

    if (YES == data.isPreview) {

        // プレビュー
        [[self class] showPreview:saveFilePaths];

    } else {

        ret = [[self class] uploadWithFilePaths:saveFilePaths];
    }

    // アップロードをブロックで処理することがあるのでこのretは信用出来ない。
    return ret;
}

/** PDFプレビュー画面を表示する (戻り値: NO の場合は、ファイルをアップロードしない) */
+ (void)showPreview:(NSArray *)paths
{
    // UITabBarViewController に対して presentViewController を呼ぶ
    // 無理やりルートのタブバーを取得
    TabBarViewController *tabBarVC =
    (TabBarViewController *)[[[UIApplication sharedApplication] delegate]
                           performSelector:@selector(tabBarController) withObject:nil];
    
    NSString *path = paths[0];

    NSLog(@"path=%@", path);
    
    if (NO == [ReaderDocument isPDF:path]) {
        NSString * savePath = [TMPathDefine tmpSaveIndividualPDFPath];
        
        // PDFファイル作成
        [UIView createPDFfromUIView:[[self class] loadImages:paths]
                     saveAtFilePath:savePath];
        
        path = savePath;
    }
    
    [tabBarVC showPreview:path
               completion:^(BOOL isUpload) {
                  
                   if (NO == isUpload) {
                       return;
                   }
                   
                   [[self class] uploadWithFilePaths:paths];
               }];
}


/** クラウドへファイルアップロード開始 */
+ (BOOL)uploadWithFilePaths:(NSArray *)paths
{
    SchemeOpenURL *sOpenURL = [[SchemeOpenURL alloc] init];
    
    CloudFacade *facade = [CloudFacade createCloudFacade];
    facade.delegate = sOpenURL;
        
    // 処理中としてアップロードファイルの進行状況を表示する
    NSString *counter =
    [NSString stringWithFormat:NSLocalizedString(@"Common_Cloud_Uploading_CountFormat", ""), 1, [paths count]];
    [MsgStatusBarViewController showWithMessage:
     [NSLocalizedString(@"Common_Cloud_Uploading", @"") stringByAppendingString:counter]];

    [facade uploadFiles:paths];
    
    // 同期処理に変更
    while (sOpenURL.isUploadFinish == NO) {
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
    
    if (sOpenURL.error == nil) {
        // アップロードに成功
        [MsgStatusBarViewController changeMessage:NSLocalizedString(@"Common_Cloud_Upload_Success", @"")];
        [MsgStatusBarViewController closeWithDefaultDelay];
        
        // スキャン回数をカウント
        [ScanLimitManager countedScanSuccessful];
        
        // 一時ファイル削除
        [FileManageFacade removeItemAndDirAtPaths:paths];
        
        return YES;
    }
    
    // アップロードに失敗
    NSDictionary *errorDic = [ViewErrorMsg errorString:sOpenURL.error];
    
    UIAlertView *alert =
    [[UIAlertView alloc] initWithTitle:[errorDic valueForKey:TMErrorMsgKeyTitle]
                               message:[errorDic valueForKey:TMErrorMsgKeyBody]
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:NSLocalizedString(@"Common_Alert_Button_OK", @""), nil];
    [alert show];
    
    // 一時ファイル削除
    [FileManageFacade removeItemAndDirAtPaths:paths];
    
    // 他のプリで0.0 だと不具合があったので刻む
    [MsgStatusBarViewController closeWithDelay:0.001];

    return NO;
}

/** URLがWidgetからの呼び出しか判断します */
+ (BOOL)isEqualWidgetURL:(NSURL *)url
{
    return [CollaborateFacade isEqualWidgetURL:url];
}

/** Widgetから呼び出されてスキャンする */
+ (BOOL)executeScanFromWidget:(NSURL *)url
{
    
    UITabBarController *tabBarController = nil;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS7.1以下
        // Target が iOS 8.1以降にしたので通らない
        
    }else {
        // iOS8.0以降
        tabBarController = [UIViewController topTabBarController];
        
    }
    
    // お気に入り画面表示
    tabBarController.selectedIndex = 0;

    // Launcherの作成画面が表示されている場合は閉じる
    [tabBarController dismissViewControllerAnimated:NO completion:nil];
    
    static BaseLauncherTableViewController *tableViewController = nil;

    // 一度でも BaseLauncherTableViewController の取得に成功した場合は、再度取得しない。
    if (nil == tableViewController ||
        NO == [tableViewController isKindOfClass:[BaseLauncherTableViewController class]]) {

        UINavigationController *navigationController =
        (UINavigationController *)tabBarController.selectedViewController;
        
        tableViewController = (BaseLauncherTableViewController *)navigationController.topViewController;
    }
    
    NSString * const selectedRow = [CollaborateFacade extractSelectedRowInCallWidgetURL:url];
    
    // SSCAとの連携開始
    [tableViewController exeScanningFile:[NSIndexPath indexPathForRow:[selectedRow integerValue] inSection:0]];
    
    return YES;
}

#pragma mark -
#pragma mark ===== CloudFacadeDelegate Method =====
/** ファイルアップロードの成功可否 */
- (void)cloudFacade:(CloudFacade *)cloudFacade
          cloudType:(SSLCloudType)type
    isUploadSuccess:(BOOL)success
  processingFileNum:(NSInteger)fileNum
       totalFileNum:(NSInteger)totalFileNum
              error:(NSError *)error
{

    self.error = nil;
    
    if (success == NO) {
        self.error = error;
        self.isUploadFinish = YES;
        return;
    }
    
    if (totalFileNum == fileNum) {
        
        // 完了としてアップロードファイルの進行状況を表示する
        NSString *counter =
        [NSString stringWithFormat:NSLocalizedString(@"Common_Cloud_Uploading_CountFormat", ""), totalFileNum, totalFileNum];
        [MsgStatusBarViewController changeMessage:
         [NSLocalizedString(@"Common_Cloud_Uploading", @"") stringByAppendingString:counter]];
        
        // すべてのファイルが完了した場合にアップロード完了と判断する
        self.isUploadFinish = YES;
        return;
    }
    
    // 処理中としてアップロードファイルの進行状況を表示する
    NSString *counter =
    [NSString stringWithFormat:NSLocalizedString(@"Common_Cloud_Uploading_CountFormat", ""), ++fileNum, totalFileNum];
    [MsgStatusBarViewController changeMessage:
     [NSLocalizedString(@"Common_Cloud_Uploading", @"") stringByAppendingString:counter]];
}


/** ファイルアップロード後の公開リンク作成の成功可否 */
- (void)cloudFacade:(CloudFacade *)cloudFacade
          cloudType:(SSLCloudType)type
       sharableLink:(NSString *)link
              error:(NSError *)error
{
    self.error = nil;
    
    if (link.length <= 0) {
        
        self.error = error;
    } else {

        // クリップボードに link をコピー
        [[UIPasteboard generalPasteboard] setValue:link forPasteboardType:@"public.text"];
        
        // クリップボードにコピー　の画面を表示
        [CompleteViewController showAndClose];
    }
    
    self.isUploadFinish = YES;
    
}


#pragma mark -
#pragma mark ===== Private Class Method =====
/** 複数のイメージをUIImabeViewにロードします */
+ (NSArray *)loadImages:(NSArray *)paths
{
    NSMutableArray *imges = [NSMutableArray array];
    for (NSString *imgPath in paths) {
        
        // キャッシュさせない
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        UIImageView *view = [[UIImageView alloc] initWithImage:img];
        [imges addObject:view];
    }
    
    return imges;
}




@end
