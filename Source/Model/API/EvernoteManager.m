//
//  EvernoteManager.m
//  SSLauncher
//
//  Created by toomoo on 2014/11/02.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "EvernoteManager.h"
#import "EvernoteSDK.h"
#import "NSData+EvernoteSDK.h"

#import "NSString+Extracting.h"

NSString * const kEvernoteURLSchemeAppKey           = @"";
static NSString * const kEvernoteConsumerKey        = @"";
static NSString * const kEvernoteConsumerSecret     = @"";

/**************************************************************************************
 * URLの部品
 **************************************************************************************/
static NSString * const kURLSep     = @"://";

/**************************************************************************************
 * タグ関連
 **************************************************************************************/
static NSString * const kNotbookAndTagSep = @"@";
static NSString * const kTagsSeparater    = @"/";


/**************************************************************************************
 * アップロードファイル関連
 **************************************************************************************/
static NSString * const kMimePDF  = @"application/pdf";
static NSString * const kMimeJPEG = @"image/jpeg";
static NSString * const kExtPDF   = @"pdf";
static NSString * const kExtJPEG  = @"jpeg";
static NSString * const kExtJPG   = @"jpg";

@interface EvernoteManager ()

//@property (nonatomic, strong) EDAMUserStoreClient *userStoreClient;

@end

@implementation EvernoteManager

/** プロトコルで宣言したプロパティには synthesizeが必要 */
@synthesize delegate = _delegate;

#pragma mark -
#pragma mark ===== Class Method =====

/** 処理対象のURLか判断する */
+ (BOOL)isEqualTargetURL:(NSURL *)url;
{
    NSArray *pairs = [[url absoluteString] componentsSeparatedByString:kURLSep];
    
    if ([[pairs firstObject] caseInsensitiveCompare:kEvernoteURLSchemeAppKey] == NSOrderedSame) {
        
        return YES;
    }
    
    return NO;
}

/** Evertnoteへのアプリ認証準備 */
+ (void)prepareAuthenticateApp
{

    // Initial development is done on the sandbox service
    // Change this to BootstrapServerBaseURLStringUS to use the production Evernote service
    // Change this to BootstrapServerBaseURLStringCN to use the Yinxiang Biji production service
    // BootstrapServerBaseURLStringSandbox does not support the  Yinxiang Biji service
    
#if defined(DEBUG)
//    NSString *EVERNOTE_HOST = BootstrapServerBaseURLStringSandbox;
    NSString *EVERNOTE_HOST = BootstrapServerBaseURLStringUS;
#else
    NSString *EVERNOTE_HOST = BootstrapServerBaseURLStringUS;
#endif
    
    // set up Evernote session singleton
    [EvernoteSession setSharedSessionHost:EVERNOTE_HOST
                              consumerKey:kEvernoteConsumerKey
                           consumerSecret:kEvernoteConsumerSecret];

}

/** クラウドストレージへ認証済みか */
+ (BOOL)signedin
{
    if ([[EvernoteSession sharedSession] isAuthenticated] == YES) {
        
        return YES;
    }
    
    return NO;
}

/** 「未認証の場合は認証」(YES)、「認証済みの場合は解除」(NO)を行います */
+ (BOOL)linkOrUnlink:(UIViewController *)rootController
{
    BOOL linkFlag = YES;
    
    if (![[EvernoteSession sharedSession] isAuthenticated]) {
        
        [[self class] showLinkView:rootController];
        
        linkFlag = YES;
    } else {
        
        //        NSLog(@"Linked!!");
        [[EvernoteSession sharedSession] logout];
        
        linkFlag = NO;
    }
    
    return linkFlag;
}


/** URLから接続情報を取得する */
+ (BOOL)openHandleURL:(NSURL *)url
{
    BOOL canHandle = NO;
    
    if ([[NSString stringWithFormat:@"en-%@", [[EvernoteSession sharedSession] consumerKey]] isEqualToString:[url scheme]] == YES) {
        
        canHandle = [[EvernoteSession sharedSession] canHandleOpenURL:url];
    }
    
    return canHandle;
}

/** インスタンスを作成する */
+ (instancetype)createInstance
{
    // インスタンスを作成する前に認証チェック
    [[self class] prepareAuthenticateApp];
    if (![[EvernoteSession sharedSession] isAuthenticated]) {
        
        return nil;
    }
    
    EvernoteManager *evernoteMgr = [[EvernoteManager alloc] init];
    
    // クライアント接続用
//    evernoteMgr.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
//    evernoteMgr.restClient.delegate = dropboxMgr;
    
    return evernoteMgr;
}

#pragma mark -
#pragma mark ===== Private Class Method =====
/** Evernoteのアプリ認証画面を表示する */
+ (void)showLinkView:(UIViewController *)rootController
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    if (![session isAuthenticated]) {
        [session authenticateWithViewController:rootController
                              completionHandler:^(NSError *error) {
                                  
                                  if (error || !session.isAuthenticated) {
                                      // 認証失敗
                                      /*
                                         NSLog(@"Error : %@",error);
                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                         message:@"Could not authenticate"
                                                                                        delegate:nil
                                                                               cancelButtonTitle:@"OK"
                                                                               otherButtonTitles:nil];
                                         [alert show];
                                          */
                                      
                                      NSLog(@"Evernote Could not authenticate!");

                                  } else {
                                      
                                      // 認証成功
//                                      NSLog(@"authenticated! noteStoreUrl:%@ webApiUrlPrefix:%@", session.noteStoreUrl, session.webApiUrlPrefix);
                                      [rootController viewDidAppear:NO];
                                  }
                              }];
    }
}

#pragma mark -
#pragma mark ===== Instance Method =====

/** ユーザー名を取得する */
- (void)userName
{
    
    EvernoteUserStore *userStore = [EvernoteUserStore userStore];
    [userStore getUserWithSuccess:^(EDAMUser *user) {

        /** アカウント情報取得に成功 */
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:userName:)]) {
            [self.delegate cloudManager:self userName:user.username];
        }
    }
                          failure:^(NSError *error) {
                              
                              /** アカウント情報取得に失敗 */
                              NSLog(@"error %@", error);
                              if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:userNameFailedWithError:)]) {
                                  [self.delegate cloudManager:self userNameFailedWithError:error];
                              }
                          }];
}

/** クラウドマネージャータイプを取得する */
- (SSLCloudType)type
{
    return SSLCloudTypeEvernote;
}

/** ファイルをアップロード開始する */
- (void)uploadFileToCloudPath:(NSString *)dst
                 srcLocalPath:(NSString *)src
             specificFileName:(NSString *)fileName
{
    [self uploadFilesToCloudPath:dst
                   srcLocalPaths:@[src]
        specificMultipleFileName:@[fileName]];
}

/** 複数ファイルをアップロード開始する */
- (void)uploadFilesToCloudPath:(NSString *)dst
                 srcLocalPaths:(NSArray *)srces
      specificMultipleFileName:(NSArray *)fileNames
{
    
    // 適切なノートブックを取得する
    EDAMGuid notebookGuid =
    [self noteGuidForUpload:[[dst componentsSeparatedByString:kNotbookAndTagSep] objectAtIndex:0]];

    __block NSString *firstFileName = @"";
    NSMutableArray *resources = [NSMutableArray array];
    
    [srces enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString * const src = (NSString *)obj;
        NSString * const fileName = [fileNames objectAtIndex:idx];
        
        NSString *tmpFileName = (fileName != nil) ? fileName : [[src pathComponents] lastObject];
        
        if (0 == idx) {
            firstFileName = tmpFileName;
        }
        
        // リソース生成
        EDAMResource* resource = [[self class] createResource:notebookGuid
                                                     filePath:src
                                                     fileName:tmpFileName];

        [resources addObject:resource];
        
    }];
    
    ENMLWriter* myWriter = [[self class] createWriter:resources];
    
    NSString *noteContent = myWriter.contents;
    
    // ノート作成
    EDAMNote *newNote = [[EDAMNote alloc] init];
    if (notebookGuid != nil) { [newNote setNotebookGuid:notebookGuid]; }
    [newNote setTitle:[firstFileName stringByDeletingPathExtension]];
    
    // タグ名
    NSMutableArray *tags = [self tagForUpload:dst];
    if (tags != nil) {
        [newNote setTagNames:[NSMutableArray arrayWithArray:tags]];
    }
    [newNote setContent:noteContent];
    [newNote setContentLength:(int32_t)noteContent.length];
    [newNote setResources:resources];
    
    /*
     // プログレスを取得
     [[EvernoteNoteStore noteStore] setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
     
     NSLog(@"Total bytes written : %lld , Total bytes expected to be written : %lld",totalBytesWritten,totalBytesExpectedToWrite);
     }];
     */
    
    NSLog(@"Contents : %@",myWriter.contents);
    
    [[EvernoteNoteStore noteStore] createNote:newNote success:^(EDAMNote *note) {
        
        NSLog(@"Note created successfully.");
        
        // アップロード成功
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:uploadedPath:error:)]) {
            [self.delegate cloudManager:self uploadedPath:note.title error:nil];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"Error creating note : %@",error);
        
        // アップロード失敗
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:uploadedPath:error:)]) {
            [self.delegate cloudManager:self uploadedPath:nil error:error];
        }
    }];
    
}

#pragma mark -
#pragma mark ===== Private Class Method =====

/** アップロードするためのResourceを作成します */
+ (EDAMResource *)createResource:(EDAMGuid)notebookGuid
                        filePath:(NSString *)src
                        fileName:(NSString *)name
{
    
    // 添付ファイルに名前を付加する
    EDAMResourceAttributes *rsrcAttr = [[EDAMResourceAttributes alloc] init];
    rsrcAttr.fileName = name;
    
    NSData *myFileData = [NSData dataWithContentsOfFile:src];
    NSData *dataHash = [myFileData enmd5];

    EDAMData *edamData = [[EDAMData alloc] initWithBodyHash:dataHash size:(UInt32)myFileData.length body:myFileData];
    EDAMResource* resource =
    [[EDAMResource alloc] initWithGuid:nil
                              noteGuid:notebookGuid             // nil の場合はデフォルトノートブックとなる
                                  data:edamData
                                  mime:[[self class] mime:[src pathExtension]]
                                 width:0
                                height:0
                              duration:0
                                active:0
                           recognition:0
                            attributes:rsrcAttr
                     updateSequenceNum:0
                         alternateData:nil];

    return resource;
}

/** アップロードするためのResourceを作成します */
+ (ENMLWriter *)createWriter:(NSArray *)resources
{
    
    ENMLWriter* myWriter = [[ENMLWriter alloc] init];
    [myWriter startDocument];
    
    // 複数イメージの場合は繰り返す
    for (EDAMResource *resource in resources) {
        
        [myWriter startElement:@"span"];
        [myWriter startElement:@"br"];
        [myWriter endElement];
        [myWriter writeResource:resource];
        [myWriter endElement];
    }
    
    [myWriter endDocument];
    
    return myWriter;
}


/** 拡張子からmimeを取得します取得 */
+ (NSString *)mime:(NSString *)extension
{
    if (NSOrderedSame == [extension caseInsensitiveCompare:kExtPDF]) {return kMimePDF;}
    if (NSOrderedSame == [extension caseInsensitiveCompare:kExtJPEG] ||
        NSOrderedSame == [extension caseInsensitiveCompare:kExtJPG]) {return kMimeJPEG;}
    
    // デフォルト値
    return kMimePDF;
}


#pragma mark -
#pragma mark ===== Private Instance Method =====
/** アップロード先のノートブックのGuidを取得します(defaultの場合はnilを返す) */
- (EDAMGuid)noteGuidForUpload:(NSString *)targetNotebookName
{
    
    __block BOOL isFinish = NO;
    __block NSArray *existNotebooks = nil;
    __block NSError *localError = nil;
    EDAMGuid guid = nil;
    
    //********************************************************************************
    // Step1:
    //  Evernote上に指定されたノートブック名が存在するか確認する
    //********************************************************************************
    
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {
        
//        NSLog(@"notebooks: %@", notebooks);
        
        existNotebooks = notebooks;
        isFinish = YES;
         
    } failure:^(NSError *error) {

        NSLog(@"notebooks error %@", error);
        
        localError = error;
        isFinish = YES;
    }];
    
    
    // 同期処理に変更
    while (isFinish == NO) {
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }

    if (localError != nil) {
        // アップロード失敗
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(cloudManager:uploadedPath:error:)]) {
            [self.delegate cloudManager:self uploadedPath:nil error:localError];
        }
    }
    
    // 取得したノートブック名と比較
    for (EDAMNotebook *notebook in existNotebooks) {
    
        if ([targetNotebookName isEqualToString:notebook.name]) {
            
            NSLog(@"HIT!! notebook.name=%@", notebook.name);
            NSLog(@"      notebook.guid=%@", notebook.guid);
            guid =  notebook.guid;
            break;
        }
    }
    
    if (guid != nil) {
        // 既に指定されたノートブックは存在するので、そのGuidを返却する
        return guid;
    }

    
    //********************************************************************************
    // Step2:
    //  Evernote上に指定されたノートブック名が存在しないので、新たに作成する
    //********************************************************************************

    // ノートブックの作成
    EDAMNotebook *newNotebook;
    EDAMNoteStoreClient *noteStoreClient = [[EvernoteSession sharedSession] noteStore];
    @try {
    
        
        // 11/3 Notebookを特定するメソッドを作成する
        EDAMNotebook *notebook = [[EDAMNotebook alloc]init];
        // 同一の名前のノートブックが存在すると例外が発生するので注意が必要。
        notebook.name = targetNotebookName;
        newNotebook = [noteStoreClient createNotebook:[[EvernoteSession sharedSession] authenticationToken]
                                             notebook:notebook];
    }
    @catch (EDAMUserException *e) {
        
        // 失敗(エラーを出す必要はなし)
        NSString * errorMessage = [NSString stringWithFormat:@"Error saving note: error code %i", [e errorCode]];
        UIAlertView *alertDone = [[UIAlertView alloc] initWithTitle: @"Evernote" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [alertDone show];

        // 失敗した場合はデフォルトノートブックにアップロードする
        return nil;
    }
    @catch (EDAMSystemException *e) {
        
        // 失敗(エラーを出す必要はなし)
        NSString * errorMessage = [NSString stringWithFormat:@"Error saving note: error code %i", [e errorCode]];
        UIAlertView *alertDone = [[UIAlertView alloc] initWithTitle: @"Evernote" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [alertDone show];
        
        // 失敗した場合はデフォルトノートブックにアップロードする
        return nil;
    }
    
    return newNotebook.guid;
}

/** ノートに指定するタグ名を取得する */
- (NSMutableArray *)tagForUpload:(NSString *)targetNotePath
{
    // タグ名(複数)の文字列を取り出す
    NSString *tagsString = [targetNotePath behindStringsSeparated:kNotbookAndTagSep];
    
    if ([tagsString length] <= 0) {
        return nil;
    }
    
    // タグ名の配列
    NSArray *tmpTags = [tagsString componentsSeparatedByString:kTagsSeparater];
    
    if (tmpTags == nil || tmpTags.count == 0) {
        return nil;
    }
    
    NSMutableArray *tags = [NSMutableArray array];
    // 各タグ名を成形
    for (NSString *t in tmpTags) {

        if ([t length] <= 0) {
            continue;
        }

        NSString *tmpTag = [t trimHeadSpace];
        tmpTag = [tmpTag trimTailSpace];
        
        [tags addObject:tmpTag];
    }
    
    return tags;
}

@end
