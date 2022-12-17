//
//  CloudManageDelegate
//  SSLauncher
//
//  Created by toomoo on 2014/09/06.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

/** クラウドタイプ */
typedef NS_ENUM(NSInteger, SSLCloudType) {
    
    SSLCloudTypeDropbox = 0,
    SSLCloudTypeEvernote,
    SSLCloudTypeiCloud,
    SSLCloudTypeOneDrive,
    SSLCloudTypeGoogleDrive,
    
};

@protocol CloudManagerDelegate;

@protocol CloudManaging <NSObject>
@required

@property (weak, nonatomic) id <CloudManagerDelegate> delegate;

/** 処理対象のURLか判断する */
+ (BOOL)isEqualTargetURL:(NSURL *)url;

/** クラウドストレージへのアプリ認証準備 */
+ (void)prepareAuthenticateApp;

/** クラウドストレージへ認証済みか */
+ (BOOL)signedin;

/** クラウドストレージのアプリ認証画面を表示する */
//+ (void)showLinkView:(UIViewController *)rootController;

/** 「未認証の場合は認証」、「認証済みの場合は解除」を行います */
+ (BOOL)linkOrUnlink:(UIViewController *)rootController;

/** URLから接続情報を取得する */
+ (BOOL)openHandleURL:(NSURL *)url;

/** インスタンスを作成する */
+ (instancetype)createInstance;

/** ユーザー名を取得する */
- (void)userName;

/** クラウドマネージャータイプを取得する */
- (SSLCloudType)type;

/** ファイルをアップロード開始する */
- (void)uploadFileToCloudPath:(NSString *)dst
                 srcLocalPath:(NSString *)src
             specificFileName:(NSString *)fileName;

/** 複数ファイルをアップロード開始する */
- (void)uploadFilesToCloudPath:(NSString *)dst
                 srcLocalPaths:(NSArray *)srces
      specificMultipleFileName:(NSArray *)fileNames;

@optional

/** ファイルの公開リンクを作成する */
- (void)createSharableLinkForFile:(NSString *)filePath;

@end


@protocol CloudManagerDelegate <NSObject>
@optional

/** ユーザー名の取得完了 */
- (void)cloudManager:(id <CloudManaging>)manager
            userName:(NSString *)userName;

/** ユーザー名の取得完了 */
- (void)    cloudManager:(id <CloudManaging>)manager
 userNameFailedWithError:(NSError *)error;

/** ファイルアップロードの完了 */
- (void)cloudManager:(id <CloudManaging>)manager
        uploadedPath:(NSString *)path
               error:(NSError *)error;

/** 公開リンクの作成完了 */
- (void)cloudManager:(id <CloudManaging>)manager
        sharableLink:(NSString *)path
               error:(NSError *)error;

@end




