//
//  CloudFacade.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/05.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "CloudFacade.h"
#import "CloudManageDelegate.h"
#import "DropboxManager.h"
#import "EvernoteManager.h"
#import "LauncherDataManager+Managing.h"
#import "LauncherData.h"
#import "ErrorFactory.h"

#import "TMDateManager.h"

@interface CloudFacade () <CloudManagerDelegate>

@property (strong, nonatomic) id <CloudManaging> manager;

@property (strong, nonatomic) NSMutableArray *managers;
@property (assign, nonatomic) NSInteger processingFileNum;
@property (assign, nonatomic) NSInteger totalFileNum;

@end

@implementation CloudFacade

#pragma mark -
#pragma mark ===== Class Method =====
/** クラウドストレージにサインイン済みか判断します */
+ (BOOL)signedin;
{
    LauncherData *data = [[LauncherDataManager shared] processingObject];
    
    if (data == nil) {
        return NO;
    }
    
    return [[self class] signedinWithCloudType:data.cloudType];
}

/** クラウドストレージにサインイン済みか判断します */
+ (BOOL)signedinWithCloudType:(SSLCloudType)type
{
    Class <CloudManaging> cloudClass= [[self class] cloudClassFactoryWithType:type];
    
    [cloudClass prepareAuthenticateApp];
    
    return [cloudClass signedin];
}

/** クラウドストレージにサインインします */
+ (BOOL)signin:(SSLCloudType)type fromController:(UIViewController *)rootController
{
    Class <CloudManaging> cloudClass= [[self class] cloudClassFactoryWithType:type];
    
    [cloudClass prepareAuthenticateApp];
    BOOL ret = [cloudClass linkOrUnlink:rootController];
    
    return ret;
}

/** クラウドストレージから指定されたURLからハンドルを取得します */
+ (void)openHandleURL:(NSURL *)url
{
    Class <CloudManaging> cloudClass= [[self class] cloudClassFactoryWithURL:url];
    
    if ([cloudClass openHandleURL:url] == NO) {
        
        NSLog(@"[openHandleURL:] fiald. (class=%@, url=%@)",
              NSStringFromClass(cloudClass), [url absoluteString]);
    }
}

/** クラウドストレージインスタンスを取得します */
+ (instancetype)createCloudFacade
{
    return [[CloudFacade alloc] init];
}


#pragma mark -
#pragma mark ===== Instance Method =====
/** すべてのクラウドのユーザー名を取得 */
- (void)allUserName
{
    self.managers = [NSMutableArray array];
    
    // すべてのクラウドタイプを作成
    id <CloudManaging> tmpMgr = nil;
    
    // Dropbox
    if ((tmpMgr = [[self class] cloudFactoryWithType:SSLCloudTypeDropbox]) != nil) {
        
        tmpMgr.delegate = self;
        [self.managers addObject:tmpMgr];
    }
    
    // Evernote
    if ((tmpMgr = [[self class] cloudFactoryWithType:SSLCloudTypeEvernote]) != nil) {
        
        tmpMgr.delegate = self;
        [self.managers addObject:tmpMgr];
    }
    
    // 接続していない場合はユーザー名を取得しない(for文に入らない)
    for (id <CloudManaging> tmpMgr in self.managers) {
        [tmpMgr userName];
    }
}

/** 指定された複数ファイルをクラウドへアップロードします */
- (void)uploadFiles:(NSArray *)localPaths
{
    LauncherData *data = [[LauncherDataManager shared] processingObject];
    
    if (data == nil) {
        return;
    }
    
    if ([localPaths count] <= 0 ||
        data == nil) {
        
        // 処理中データの削除
        [[LauncherDataManager shared] setProcessingObject:nil];
        
        return;
    }
    
    self.manager = [[self class] cloudFactoryWithType:data.cloudType];
    self.manager.delegate = self;
    
    // アップロードするファイル数を管理
    self.processingFileNum = 0;
    self.totalFileNum = [localPaths count];
    
    if (1 == [localPaths count]) {
        
        // 1ファイルのみの場合は既存処理へ
        [self uploadFile:[localPaths objectAtIndex:0]
                    data:data];
        return;
    }
    
    // 複数ファイル
    [self uploadMultipleFile:localPaths data:data];
    
}

#pragma mark -
#pragma mark ===== Private Instance Method =====
/** 指定されたファイルをクラウドへアップロードします(1つ) */
- (void)uploadFile:(NSString *)localPath data:(LauncherData *)data
{
    // ファイル名の決定
    NSString *fileName = [[self class] upLoadfileName:[[localPath pathComponents] lastObject]
                                                 data:data];
    
    [self.manager uploadFileToCloudPath:data.cloudSavePath
                           srcLocalPath:localPath
                       specificFileName:fileName];
}

/** 指定されたファイルをクラウドへアップロードします(複数) */
- (void)uploadMultipleFile:(NSArray *)localPaths data:(LauncherData *)data
{
    // 複数ファイル名の決定
    NSArray *multiplefileName = [[self class] upLoadMultiplefileName:localPaths
                                                                data:data];
    
    [self.manager uploadFilesToCloudPath:data.cloudSavePath
                           srcLocalPaths:localPaths
                specificMultipleFileName:multiplefileName];
}

/** アップロードに成功したファイル数をカウントする */
- (void)countUPProcessingFile
{
    self.processingFileNum++;
    
    if (YES == [self.manager isKindOfClass:[EvernoteManager class]]) {
        
        // Evernoteは複数ファイルでも一度しかアップロードしないので、
        // トータルと値を同様にする
        self.processingFileNum = self.totalFileNum;
    }
}


#pragma mark -
#pragma mark ===== CloudManagerDelegate Method =====
/** ユーザー名の取得 */
- (void)cloudManager:(id <CloudManaging>)manager
            userName:(NSString *)userName;
{
    if (self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(cloudFacade:cloudType:userName:userNameFailedWithError:)]) {
        
        [self.delegate cloudFacade:self
                         cloudType:[manager type]
                          userName:userName
           userNameFailedWithError:nil];
    }
}

/** ユーザー名取得に失敗 */
- (void)    cloudManager:(id <CloudManaging>)manager
 userNameFailedWithError:(NSError *)error
{
    if (self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(cloudFacade:cloudType:userName:userNameFailedWithError:)]) {
        
        [self.delegate cloudFacade:self
                         cloudType:[manager type]
                          userName:nil
           userNameFailedWithError:[ErrorFactory createWithError:error]];
    }
}

/** ファイルアップロードの完了 */
- (void)cloudManager:(id <CloudManaging>)manager
        uploadedPath:(NSString *)path
               error:(NSError *)error
{
    // 処理中ファイル数のカウントをアップし、呼び出し元に伝える
    [self countUPProcessingFile];
    
    const BOOL isUploadSuccess = (0 < [path length]) ? YES : NO;
    //★ToDo★ 複数ファイルの公開リンクはどうする？最初のファイルのみ？対応しない？
    LauncherData * const data = [[LauncherDataManager shared] processingObject];
    
    if (isUploadSuccess && data.isShareLink == YES) {
    
        // 公開リンクの作成
        [[self manager] createSharableLinkForFile:path];
        
    } else {
    
        if (self.delegate != nil &&
            [self.delegate respondsToSelector:
             @selector(cloudFacade:cloudType:isUploadSuccess:processingFileNum:totalFileNum:error:)]) {
            
//            [self.delegate cloudFacade:self
//                             cloudType:[manager type]
//                       isUploadSuccess:isUploadSuccess
//                                 error:[ErrorFactory createWithError:error]];
            
            [self.delegate cloudFacade:self
                             cloudType:[manager type]
                       isUploadSuccess:isUploadSuccess
                     processingFileNum:self.processingFileNum
                          totalFileNum:self.totalFileNum
                                 error:[ErrorFactory createWithError:error]];
        }
    }
    
    // 処理中データの削除
    [[LauncherDataManager shared] setProcessingObject:nil];
}

/** 公開リンクの作成完了 */
- (void)cloudManager:(id <CloudManaging>)manager
        sharableLink:(NSString *)path
               error:(NSError *)error
{
    if (self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(cloudFacade:cloudType:sharableLink:error:)]) {
        
        [self.delegate cloudFacade:self
                         cloudType:[manager type]
                      sharableLink:path
                             error:[ErrorFactory createWithError:error]];
    }
    
    // 処理中データの削除
    [[LauncherDataManager shared] setProcessingObject:nil];
}


#pragma mark -
#pragma mark ===== Private Class Method =====
/** アップロード用のファイル名を決定します */
+ (NSString *)upLoadfileName:(NSString *)currentSaveFileName
                        data:(LauncherData *)data;
{
    NSString *retFileName = currentSaveFileName;
    
    // 直接入力
    if (data.fileNameFormat == SSFileNameFormatDirect) {
        retFileName = data.fileName;
        retFileName = [retFileName stringByAppendingPathExtension:
                       [SSPalameters pathExtensionFromSSFileFormat:data.fileformat]];

    } else {
        
        retFileName = [retFileName stringByRemovingPercentEncoding];
    }
    
    NSString * const prefix     = [[self class] prefixString:data];
    NSString * const suffix     = [[self class] suffixString:data];
    NSString * const extension  = [currentSaveFileName pathExtension];
    
    // prefix, suffix を付加
    retFileName = [retFileName stringByDeletingPathExtension];
    retFileName = [[prefix stringByAppendingString:retFileName]
                   stringByAppendingString:suffix];
    retFileName = [retFileName stringByAppendingPathExtension:extension];
    
    return retFileName;
}

/** アップロード用のファイル名を決定します(複数) */
+ (NSArray *)upLoadMultiplefileName:(NSArray *)saveMultipleFileName
                               data:(LauncherData *)data;
{
    NSMutableArray *retMultipleFileName = [NSMutableArray array];
    
    [saveMultipleFileName enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *fileName = [self upLoadfileName:(NSString *)obj data:data];
        
        // ループしながら連番を設定する
        fileName = [self appendingSequenceNaumber:fileName number:++idx data:data];
        
        [retMultipleFileName addObject:fileName];
    }];
    
    return retMultipleFileName;
}

/** ファイル名に連番を付加します */
+ (NSString *)appendingSequenceNaumber:(NSString *)fileName
                                number:(NSUInteger)number
                                  data:(LauncherData *)data;
{
 
    NSString * const extension = [fileName pathExtension];
    NSString *noExtFileName = [fileName stringByDeletingPathExtension];
    
    NSMutableString *format = [NSMutableString string];
    [format appendString:[SSPalameters stringFromTMDelimiterType:data.sequentialNumberDelimiter]];
    [format appendString:[SSPalameters stringSequentialNumberType:data.sequentialNumberType]];
    
    NSString * const sequenceNumberString = [NSString stringWithFormat:format, number];
    
    noExtFileName = [noExtFileName stringByAppendingString:sequenceNumberString];
    
    return [noExtFileName stringByAppendingPathExtension:extension];
}


/** アップロード用のPrefixを決定します */
+ (NSString *)prefixString:(LauncherData *)data;
{
    // Preix
    NSString *prefixDelimiter = [SSPalameters stringFromTMDelimiterType:data.fileNamePrefixDelimiter];
    NSString *preixStr = @"";
    
    switch (data.fileNamePrefix) {
            
        case TMFileNamePrefixDirectInput:
            
            preixStr = data.fileNamePrefixText;
            break;
            
        case TMFileNamePrefixyyyyMMdd:
        case TMFileNamePrefixyyyyMM:
        case TMFileNamePrefixyyyy:
        case TMFileNamePrefixMM:
        case TMFileNamePrefixMMdd:
            
            preixStr = [TMDateManager date:[SSPalameters stringFromTMFileNamePrefix:data.fileNamePrefix]];
            preixStr = [preixStr stringByAppendingString:prefixDelimiter];
            break;
            
        case TMFileNamePrefixNone:
        default:
            preixStr = @"";
            break;
    }
    
    return preixStr;
}

/** アップロード用のSuffixを決定します */
+ (NSString *)suffixString:(LauncherData *)data;
{
    // Suffix
    NSString *suffixDelimiter = [SSPalameters stringFromTMDelimiterType:data.fileNameSuffixDelimiter];
    NSString *suffixStr = @"";
    
    switch (data.fileNameSuffix) {
            
        case TMFileNameSuffixDirectInput:
            
            suffixStr = data.fileNameSuffixText;
            break;
            
        case TMFileNameSuffixyyyyMMdd:
        case TMFileNameSuffixyyyyMM:
        case TMFileNameSuffixyyyy:
        case TMFileNameSuffixMM:
        case TMFileNameSuffixMMdd:
            
            suffixStr = suffixDelimiter;
            suffixStr =
            [suffixStr stringByAppendingString:[TMDateManager date:
                                                [SSPalameters stringFromTMFileNameSuffix:data.fileNameSuffix]]];
            break;
            
        case TMFileNameSuffixNone:
        default:
            suffixStr = @"";
            break;
    }
    
    return suffixStr;
}


/** 指定されたタイプのクラスオブジェクトを返却します */
+ (Class <CloudManaging>)cloudClassFactoryWithType:(SSLCloudType)type
{
    Class <CloudManaging> class = nil;

    switch(type) {
        
        case SSLCloudTypeDropbox:
            class = [DropboxManager class]; 
            break;
            
        case SSLCloudTypeEvernote:
            class = [EvernoteManager class];
            break;
            
        case SSLCloudTypeiCloud:
            
            break;
            
        case SSLCloudTypeOneDrive:
            
            break;
        
        case SSLCloudTypeGoogleDrive:
            
            break;

        default:
            class = [DropboxManager class];
            break;
    }
    
    return class;
}

/** 指定されたタイプのクラスオブジェクトを返却します */
+ (id <CloudManaging>)cloudFactoryWithType:(SSLCloudType)type
{
    id <CloudManaging> instance = nil;
    
    switch(type) {
            
        case SSLCloudTypeDropbox:
            instance = [DropboxManager createInstance];
            break;
            
        case SSLCloudTypeEvernote:
            instance = [EvernoteManager createInstance];
            break;
            
        case SSLCloudTypeiCloud:
            
            break;
            
        case SSLCloudTypeOneDrive:
            
            break;
            
        case SSLCloudTypeGoogleDrive:
            
            break;
            
        default:
            instance = [DropboxManager createInstance];
            break;
    }
    
    return instance;
}

/** 指定されたタイプのクラスオブジェクトを返却します */
+ (Class <CloudManaging>)cloudClassFactoryWithURL:(NSURL *)url
{
    Class <CloudManaging> class = nil;
    
    if ([DropboxManager isEqualTargetURL:url] == YES) {
        
        class = [DropboxManager class];
        
    } else if ([EvernoteManager isEqualTargetURL:url] == YES) {
        
        class = [EvernoteManager class];
        
    } else {
        
        // どれにも該当なし
//        NSLog(@"[CloudClassFactoryWithURL:] no match. (url=%@)", [url absoluteString]);
    }
    
    return class;
}


@end
