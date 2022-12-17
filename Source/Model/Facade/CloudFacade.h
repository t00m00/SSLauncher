//
//  CloudFacade.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/05.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CloudManageDelegate.h"

@class CloudFacade;

@protocol CloudFacadeDelegate <NSObject>
@optional
/** ユーザー名の取得(失敗するとerrorオブジェクトが存在する) */
- (void)    cloudFacade:(CloudFacade *)cloudFacade
              cloudType:(SSLCloudType)type
               userName:(NSString *)userName
userNameFailedWithError:(NSError *)error;

/** ファイルアップロードの成功可否 */
/*
- (void)cloudFacade:(CloudFacade *)cloudFacade
          cloudType:(SSLCloudType)type
    isUploadSuccess:(BOOL)success
              error:(NSError *)error;
*/

/** ファイルアップロードの成功可否 */
- (void)cloudFacade:(CloudFacade *)cloudFacade
          cloudType:(SSLCloudType)type
    isUploadSuccess:(BOOL)success
  processingFileNum:(NSInteger)fileNum
       totalFileNum:(NSInteger)totalFileNum
              error:(NSError *)error;

/** ファイルアップロード後の公開リンク作成の成功可否 */
- (void)cloudFacade:(CloudFacade *)cloudFacade
          cloudType:(SSLCloudType)type
       sharableLink:(NSString *)link
              error:(NSError *)error;

@end

/** 各種クラウドの処理を抽象化します */
@interface CloudFacade : NSObject

@property (weak, nonatomic) id <CloudFacadeDelegate> delegate;

/** クラウドストレージにサインイン済みか判断します */
+ (BOOL)signedin;

/** クラウドストレージにサインイン済みか判断します */
+ (BOOL)signedinWithCloudType:(SSLCloudType)type;

/** クラウドストレージにサインインします */
+ (BOOL)signin:(SSLCloudType)type fromController:(UIViewController *)rootController;

/** クラウドストレージから指定されたURLからハンドルを取得します */
+ (void)openHandleURL:(NSURL *)url;

/** クラウドストレージインスタンスを取得します */
+ (instancetype)createCloudFacade;
//+ (instancetype)createCloudFacade:(SSLCloudType)type;

/** すべてのクラウドのユーザー名を取得 */
- (void)allUserName;

/** 指定されたファイルをクラウドへアップロードします(複数も対応) */
- (void)uploadFiles:(NSArray *)localPaths;

@end
