//
//  ErrorFactory.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/17.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Viewerで使用するエラードメイン名 */
extern NSString * const TMErrorDomain;

/** エラーのUserInfoキー名：エラーが発生したファイル名(ファイル名は必ず格納されている訳ではないので注意) */
extern NSString * const TMErrorUserInfoFileName;

/** エラーのUserInfoキー名：エラーが発生した際の原因詳細(必ず格納されている訳ではないので注意) */
extern NSString * const TMErrorUserInfoErrorDetail;


/** アプリ で使用するエラーコード(一意にすること)
 * 0 は使用しないでください
 */
typedef NS_ENUM(NSInteger, TMErrorCode) {
    
    /*--------------------------------------------------------------------------
     * アプリ内で発生するエラーコード：1 - 499番台
     *------------------------------------------------------------------------*/
    
    // 共通
    TMErrorCodeInternal = 9999, /**< 内部エラー : 9999 */
    
    // ファイル
    TMErrorCodeFileNotFound = 1,                        /**< ファイルが存在しない */
    TMErrorCodeFileShared,                              /**< ファイルが他で使用されている */
    TMErrorCodeFileTooLarge,                            /**< ファイルサイズが大きすぎる */
    TMErrorCodeWriteFileExists,                         /**< ファイルが既に存在する */
    TMErrorCodeWriteOutOfSpace,                         /**< ディスク容量不足 */
    TMErrorCodeWriteFileUnknown,                        /**< ファイルの書き込みに失敗（理由は不明） */
    TMErrorCodeWriteInvalidFileName,                    /**< ファイル名不正 */
    
    /*--------------------------------------------------------------------------
     * 通信系：100番台
     *------------------------------------------------------------------------*/
    TMURLErrorCodeNotConnectedToInternet = 100,         /**< インターネットに接続していない */
    TMURLErrorCodeTimeOut,                              /**< タイムアウト(サーバーが応答しません) */
    TMURLErrorBadServerResponse,                        /**< サーバーの応答が壊れている */
    TMURLErrorDataLengthExceedsMaximum,                 /**< データの長さが長い */

    
    /*--------------------------------------------------------------------------
     * クラウドで発生するエラーコード：500番台
     *------------------------------------------------------------------------*/
    TMCloudErrorCodeDisconnect = 500,                   /**< クラウドと接続されていない */
    TMCloudErrorCodeBadParameter,                       /**< 不正なパラメーター */
    TMCloudErrorCodeBadToken,                           /**< 不正なトークン使用(認証し直し) */
    TMCloudErrorCodeTooManyRequest,                     /**< 多量のリクエスト発行 */
    TMCloudErrorCodeOverStorageQuota,                   /**< ネットワークストレージの容量オーバー */
    TMCloudErrorCodeMightBeServerStopped,               /**< クラウドサーバーが停止している可能性がある。 */
//    TMCloudErrorURLErrorTimedOut,                       /**< NSURLErrorTimeOut:サーバーが応答しません。通信系にまとめた　*/
    
    TMCloudErrorCodeDataRequired,                       /**< 必要なパラメータ/フィールドが存在しなかった */
    TMCloudErrorCodeLimitReached,                       /**< 動作は、データモデルの制限に起因する拒否 */
    TMCloudErrorCodeInvalidAuth,                        /**< ユーザー名および/またはパスワードが正しくない */
    TMCloudErrorCodeAuthExpired,                        /**< 認証トークンの有効期限切れ */
    TMCloudErrorCodeDataConflict,                       /**< データが競合しています */
    TMCloudErrorCodeENMLValidation,                     /**< 提出されたノートの内容は、不正な形式だった */
    TMCloudErrorCodeShardUnavailable,                   /**< 共有サービスがダウンしている */
    TMCloudErrorCodeLenTooShort,                        /**< 操作は、文字列の長さのような何かが短すぎたデータモデルの制限、拒否 */
    TMCloudErrorCodeLenTooLong,                         /**< 操作は、文字列の長さのような何かが長すぎたデータモデルの制限、拒否 */
    TMCloudErrorCodeTooFew,                             /**< 操作は、何かの数が少なすぎるがあったデータモデルの制限に否定した。 */
    TMCloudErrorCodeTooMany,                            /**< 操作は、何かのあまりに多くがあったデータモデルの制限に否定した。 */
    TMCloudErrorCodeUnsupportedOperation,               /**< 現在サポートされていないため、操作は拒否されました。 */
    TMCloudErrorCodeTakeDown,                           /**< 対応するオブジェクトへのアクセスがテイクダウン通知に応答して、
                                                                  禁止されているため、操作が拒否されました。 */
};

/** @class ErrorFactory
 * @brief エラーを作成します。
 *
 * @note
 */
@interface ErrorFactory : NSObject

/** アプリで使用するErrorオブジェクトを生成します */
+ (NSError *)createWithError:(NSError *)error;

/** アプリで使用するErrorオブジェクトを生成します */
+ (NSError *)createWithError:(NSError *)error userInfo:(NSDictionary *)dict;

/** 指定したエラーコードでアプリで使用するErrorオブジェクトを生成します */
+ (NSError *)createWithTMErrorCode:(TMErrorCode)code userInfo:(NSDictionary *)info;

/** Evernoteのエラーコードでアプリで使用するErrorオブジェクトを生成します */
+ (NSError *)createWithEvernoteErrorCode:(NSInteger)code userInfo:(NSDictionary *)info;

@end
