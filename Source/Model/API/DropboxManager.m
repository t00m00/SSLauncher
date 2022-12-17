//
//  DropboxManager.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/05.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "DropboxManager.h"
#import <DropboxSDK/DropboxSDK.h>


NSString * const kDropboxURLSchemeAppKey = @"";
static NSString * const kDropboxAppKey = @"";
static NSString * const kDropboxAppSecret = @"";

/**************************************************************************************
 * URLの部品
 **************************************************************************************/
static NSString * const kURLSep     = @"://";

@interface DropboxManager () <DBRestClientDelegate>

@property (nonatomic, strong) DBRestClient *restClient;

@end

@implementation DropboxManager

/** プロトコルで宣言したプロパティには synthesizeが必要 */
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark ===== Class Method =====

/** 処理対象のURLか判断する */
+ (BOOL)isEqualTargetURL:(NSURL *)url;
{
    NSArray *pairs = [[url absoluteString] componentsSeparatedByString:kURLSep];
    
    if ([[pairs firstObject] caseInsensitiveCompare:kDropboxURLSchemeAppKey] == NSOrderedSame) {
        return YES;
    }

    return NO;
}

/** Dropboxへのアプリ認証準備 */
+ (void)prepareAuthenticateApp
{
    if ([DBSession sharedSession] != nil) {
        return;
    }
    
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:kDropboxAppKey
                                                   appSecret:kDropboxAppSecret
                                                        root:kDBRootDropbox];
    [DBSession setSharedSession:dbSession];
}

/** クラウドストレージへ認証済みか */
+ (BOOL)signedin
{
    if ([[DBSession sharedSession] isLinked] == YES) {
        return YES;
    }
    
    return NO;
}

/** 「未認証の場合は認証」(YES)、「認証済みの場合は解除」(NO)を行います */
+ (BOOL)linkOrUnlink:(UIViewController *)rootController
{
    BOOL linkFlag = YES;
    
    if (![[DBSession sharedSession] isLinked]) {
        
        [[self class] showLinkView:rootController];
        
        linkFlag = YES;
    } else {
        
//        NSLog(@"Linked!!");
        [[DBSession sharedSession] unlinkAll];
        
        linkFlag = NO;
    }
    
    return linkFlag;
}


/** URLから接続情報を取得する */
+ (BOOL)openHandleURL:(NSURL *)url
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
//            NSLog(@"App linked successfully! (Dropbox)");
            // At this point you can start making API calls
        }
        return YES;
    }
    
    return NO;
}

/** インスタンスを作成する */
+ (instancetype)createInstance
{
    // インスタンスを作成する前に認証チェック
    [[self class] prepareAuthenticateApp];
    if (![[DBSession sharedSession] isLinked]) {
        
        return nil;
    }
    
    DropboxManager *dropboxMgr = [[DropboxManager alloc] init];
    
    // クライアント接続用
    dropboxMgr.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    dropboxMgr.restClient.delegate = dropboxMgr;
    
    return dropboxMgr;
}

#pragma mark -
#pragma mark ===== Private Class Method =====
/** Dropboxのアプリ認証画面を表示する */
+ (void)showLinkView:(UIViewController *)rootController
{
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:rootController];
    }
}

#pragma mark -
#pragma mark ===== Instance Method =====

/** ユーザー名を取得する */
- (void)userName
{
    [self.restClient loadAccountInfo];
}

/** クラウドマネージャータイプを取得する */
- (SSLCloudType)type
{
    return SSLCloudTypeDropbox;
}

/** ファイルをアップロード開始する */
- (void)uploadFileToCloudPath:(NSString *)dst
                 srcLocalPath:(NSString *)src
             specificFileName:(NSString *)fileName
{
    NSString *tmpFileName = (fileName != nil) ? fileName : [[src pathComponents] lastObject];
    
    [self.restClient uploadFile:tmpFileName toPath:dst withParentRev:nil fromPath:src];
    
}

/** 複数ファイルをアップロード開始する */
- (void)uploadFilesToCloudPath:(NSString *)dst
                 srcLocalPaths:(NSArray *)srces
      specificMultipleFileName:(NSArray *)fileNames
{
    
    [srces enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
        NSString * const src = (NSString *)obj;
        NSString * const fileName = [fileNames objectAtIndex:idx];
        
        NSString *tmpFileName = (fileName != nil) ? fileName : [[src pathComponents] lastObject];
        
        [self.restClient uploadFile:tmpFileName toPath:dst withParentRev:nil fromPath:src];
        
    }];
}

/** ファイルの公開リンクを作成する */
- (void)createSharableLinkForFile:(NSString *)filePath
{
    [self.restClient loadSharableLinkForFile:filePath];
}

#pragma mark -
#pragma mark ===== DBRestClientDelegate Method =====
/** ファイルアップロードに成功 */
- (void)restClient:(DBRestClient *)client
      uploadedFile:(NSString *)destPath
              from:(NSString *)srcPath
          metadata:(DBMetadata *)metadata
{
//    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:uploadedPath:error:)]) {
        [self.delegate cloudManager:self uploadedPath:metadata.path error:nil];
    }
}

/** ファイルアップロードに失敗 */
- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
//    NSLog(@"File upload failed with error: %@", error);
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:uploadedPath:error:)]) {
        [self.delegate cloudManager:self uploadedPath:nil error:error];
    }
}

/** アカウント情報取得に成功 */
- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:userName:)]) {
        [self.delegate cloudManager:self userName:info.displayName];
    }
}

/** アカウント情報取得に失敗 */
- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:userNameFailedWithError:)]) {
        [self.delegate cloudManager:self userNameFailedWithError:error];
    }
}

/** 公開リンク作成に成功 */
- (void)restClient:(DBRestClient*)restClient
loadedSharableLink:(NSString*)link
           forFile:(NSString*)path
{
    
    NSLog(@"Sharable link %@",link);
    NSLog(@"File Path %@ ",path);
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:sharableLink:error:)]) {
        [self.delegate cloudManager:self sharableLink:link error:nil];
    }
}

/** 公開リンク作成に失敗 */
- (void)restClient:(DBRestClient*)restClient loadSharableLinkFailedWithError:(NSError*)error
{
    NSLog(@"Error %@",error);
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:sharableLink:error:)]) {
        [self.delegate cloudManager:self sharableLink:nil error:error];
    }
}

@end
