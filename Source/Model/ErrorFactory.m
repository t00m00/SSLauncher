//
//  ErrorFactory.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/17.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "ErrorFactory.h"

#import <DropboxSDK/DBError.h>
#import "EDAMErrors.h"
#import "ErrorFactory+Protected.h"

/** 使用するエラードメイン名 */
NSString * const TMErrorDomain = @"com.toomoo.Scanner.SSLauncher";

NSString * const TMErrorUserInfoFileName = @"TMErrorUserInfoFileName";


@implementation ErrorFactory

#pragma mark -
#pragma mark == ErrorFactory クラスメソッド ==

/** Errorオブジェクトを生成します */
+ (NSError *)createWithError:(NSError *)error
{
    // Errorオブジェクトの生成
    return [[self class] createWithError:error userInfo:nil];
}


/** アプリで使用するErrorオブジェクトを生成します(エラーオブジェクトからアプリで使用するエラーコードにマッピングします) */
+ (NSError *)createWithError:(NSError *)error userInfo:(NSDictionary *)dict
{
    if (error == nil) {
        return nil;
    }
    
    // 万一のためログに残す
    NSLog(@"[Error Factory]. (Domain=%@, code=%ld, detail=%@)",
          error.domain, (long)error.code, error.localizedDescription);
    
    NSInteger viewerErrorCode = 0;
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:[error userInfo]];
    [mutableDict addEntriesFromDictionary:dict];
    
    // Errorコードのマッピング判別
    if ([[error domain] isEqualToString:NSCocoaErrorDomain]) {
        
        // Cocoaドメイン
        viewerErrorCode = [[self class] mappingErrorCodeOfCocoaErrorDomain:[error code]];
        
    }  else if ([[error domain] isEqualToString:NSURLErrorDomain]) {
        
        // NSURLドメイン
        viewerErrorCode = [[self class] mappingErrorCodeOfURLErrorDomain:[error code]];
        
    } else if ([[error domain] isEqualToString:TMErrorDomain]) {
        
        // アプリドメイン（そのまま返す）
        [error setValue:mutableDict forKeyPath:@"userInfo"]; // userInfoを置き換えたいため仕方なくKVCを使用
        return error;
        
    } else if ([[error domain] isEqualToString:DBErrorDomain]) {
        
        // Dropboxドメイン
        viewerErrorCode = [[self class] mappingErrorCodeOfDropboxErrorDomain:[error code]];
        
    } else {
//        TMLogError(nil, @"[createWithError:] Unknown Domain. (domain:%@)", [error domain]);
        
        // 不明なエラー
        viewerErrorCode = TMErrorCodeInternal;
        
    }
    
    // Errorオブジェクトの生成
    return [NSError errorWithDomain:TMErrorDomain code:viewerErrorCode userInfo:mutableDict];
}


/** アプリで使用するErrorオブジェクトを生成します */
+ (NSError *)createWithTMErrorCode:(TMErrorCode)code userInfo:(NSDictionary *)info;
{
    // Errorオブジェクトの生成
    return [NSError errorWithDomain:TMErrorDomain code:code userInfo:info];
}

/** Evernoteのエラーコードでアプリで使用するErrorオブジェクトを生成します */
+ (NSError *)createWithEvernoteErrorCode:(NSInteger)code userInfo:(NSDictionary *)info;
{
    // Evernote
    NSInteger viewerErrorCode = [[self class] mappingErrorCodeOfEvernoteException:code];
    return [NSError errorWithDomain:TMErrorDomain code:viewerErrorCode userInfo:info];
}

@end

@implementation ErrorFactory (Protected)

#pragma mark -
#pragma mark == ErrorFactory (Protected) クラスメソッド ==

/** CocoaErrorDomainのエラーコードをマッピングします */
+ (TMErrorCode)mappingErrorCodeOfCocoaErrorDomain:(NSInteger)code
{
    TMErrorCode resultCode;
    
    switch (code) {
        case NSFileNoSuchFileError: // ファイルが存在しない
            resultCode = TMErrorCodeFileNotFound;
            break;
            
        case NSFileLockingError: // ファイル他で使用されている
            resultCode = TMErrorCodeFileShared;
            break;
            
        case NSFileReadTooLargeError: // ファイルサイズが大きすぎる
            resultCode = TMErrorCodeFileTooLarge;
            break;
            
        case NSFileWriteFileExistsError: // ファイルが既に存在する
            resultCode = TMErrorCodeWriteFileExists;
            break;
            
        case NSFileWriteInvalidFileNameError: // ファイル名の不正
            resultCode = TMErrorCodeWriteFileExists;
            break;
            
        case NSFileWriteOutOfSpaceError: // ディスクの空き容量が足りません
            resultCode = TMErrorCodeWriteOutOfSpace;
            break;
            
//        case NSFileWriteVolumeReadOnlyError: // 読み取り専用のファイルです
//            resultCode = TMErrorCodeWriteVolumeReadOnlyFile;
//            break;
            
        default:
//            TMLogError(nil, @"[mappingErrorCodeOfCocoaErrorDomain:] Unknown ErrorCode. (code:%d)", code);
            
            // 不明なエラー
            resultCode = TMErrorCodeInternal;
            break;
    }
    
    return resultCode;
}

/** NSURLErrorDomainのエラーコードをマッピングします */
+ (TMErrorCode)mappingErrorCodeOfURLErrorDomain:(NSInteger)code
{
    TMErrorCode resultCode;
    
    switch (code) {
        case NSURLErrorNotConnectedToInternet:      // インターネットに接続していない
        case NSURLErrorNetworkConnectionLost:       // ネットワークのコネクション損失
        case NSURLErrorDNSLookupFailed:             // DNSルックアップに失敗
        case NSURLErrorResourceUnavailable:         // リソースを取得できない
            resultCode = TMURLErrorCodeNotConnectedToInternet;
            break;

        case NSURLErrorTimedOut:                    // タイムアウト
            resultCode = TMURLErrorCodeNotConnectedToInternet;
            break;
            
        case NSURLErrorBadServerResponse:           // サーバーの応答が壊れている
            resultCode = TMURLErrorCodeNotConnectedToInternet;
            break;
            
        case NSURLErrorDataLengthExceedsMaximum:    //  データの長さが長い
            resultCode = TMURLErrorDataLengthExceedsMaximum;
            break;
            
        default:
            
            // 不明なエラー
            resultCode = TMErrorCodeInternal;
            break;
    }
    
    return resultCode;
}

/** Dropboxのエラーコードをマッピングします */
+ (TMErrorCode)mappingErrorCodeOfDropboxErrorDomain:(NSInteger)code
{
    TMErrorCode resultCode;
    switch(code) {
        case 400:                                                       // Bad input parameter. Error message should indicate which one and why.
            // パラメーターエラー
            resultCode = TMCloudErrorCodeBadParameter;
            break;
            
        case 429:
            // Your app is making too many requests and is being rate limited. 429s can trigger on a per-app or per-user basis.
            // Dropboxに対して多量のリクエスト発行
            resultCode = TMCloudErrorCodeTooManyRequest;
            break;
            
        case 401:
            // Bad or expired token. This can happen if the user or Dropbox revoked or
            // expired an access token. To fix, you should re-authenticate the user.
            // 不正なトークン
            resultCode = TMCloudErrorCodeBadToken;
            break;
            
        case DBErrorInsufficientDiskSpace:
        case 507:                                                       // User is over Dropbox storage quota.
            // Dropboxの容量オーバー
            resultCode = TMCloudErrorCodeOverStorageQuota;
            break;
            
        case 403:                                                       // Bad OAuth request (wrong consumer key, bad nonce, expired timestamp...). Unfortunately, re-authenticating the user won't help here.
        case 404:                                                       // File or folder not found at the specified path.
        case 405:                                                       // Request method not expected (generally should be GET or POST).
        case 503:                                                       // If the response includes the Retry-After header, this means your OAuth 1.0 app is being rate limited. Otherwise, this indicates a transient server error, and your app should retry its request.
        case DBErrorInvalidResponse:                                    // Sent when the client does not get valid JSON when it's expecting it
        case DBErrorFileNotFound:                                       // ファイルが見つからない。（ファイル取得を行わないので起こるはずがない）
        case DBErrorGenericError:                                       // 汎用エラー。Dropboxで何らかのエラーが起こっている
            resultCode = TMCloudErrorCodeMightBeServerStopped;
            break;
            
        case DBErrorIllegalFileType:                                    // Error sent if you try to upload a directory
            resultCode = TMErrorCodeInternal;
            break;
            
        default:
            if(500 <= code && code < 600) {
                // Dropboxサーバーが停止している可能性がある。
                resultCode = TMCloudErrorCodeMightBeServerStopped;
            } else {
//                TMLogError(nil, @"[mappingErrorCodeOfDropboxErrorDomain:] Unknown ErrorCode. (code:%d)", code);
                
                // Unknown;
                resultCode = TMErrorCodeInternal;
            }
    }
    return resultCode;
}

/** Evernoteのエラーをマッピングします */
+ (TMErrorCode)mappingErrorCodeOfEvernoteException:(NSInteger)code
{
    
    TMErrorCode resultCode;

    switch (code) {
            
        case EDAMErrorCode_BAD_DATA_FORMAT:         /**< 不正なパラメーター(データフォーマット) */
            code = TMCloudErrorCodeBadParameter;
            break;
            
        case EDAMErrorCode_PERMISSION_DENIED:       /**< 不正なトークン使用(認証し直し)。許可されていない */
            code = TMCloudErrorCodeBadToken;
            break;

        case EDAMErrorCode_DATA_REQUIRED:           /**< 必要なパラメータ/フィールドが存在しなかった */
            code = TMCloudErrorCodeDataRequired;
            break;
            
        case EDAMErrorCode_LIMIT_REACHED:           /**< 動作は、データモデルの制限に起因する拒否 */
            code = TMCloudErrorCodeLimitReached;
            break;
            
        case EDAMErrorCode_QUOTA_REACHED:           /**< ネットワークストレージの容量オーバー */
            code = TMCloudErrorCodeOverStorageQuota;
            break;
            
        case EDAMErrorCode_INVALID_AUTH:            /**< ユーザー名および/またはパスワードが正しくない */
            code = TMCloudErrorCodeInvalidAuth;
            break;
            
        case EDAMErrorCode_AUTH_EXPIRED:            /**< 認証トークンの有効期限切れ */
            code = TMCloudErrorCodeAuthExpired;
            break;
            
        case EDAMErrorCode_DATA_CONFLICT:           /**< データが競合しています */
            code = TMCloudErrorCodeDataConflict;
            break;
            
        case EDAMErrorCode_ENML_VALIDATION:         /**< 提出されたノートの内容は、不正な形式だった */
            code = TMCloudErrorCodeBadToken;
            break;
            
        case EDAMErrorCode_SHARD_UNAVAILABLE:       /**< 共有サービスがダウンしている */
            code = TMCloudErrorCodeBadToken;
            break;
            
        case EDAMErrorCode_LEN_TOO_SHORT:           /**< 操作は、文字列の長さのような何かが短すぎたデータモデルの制限、拒否 */
            code = TMCloudErrorCodeLenTooShort;
            break;
            
        case EDAMErrorCode_LEN_TOO_LONG:            /**< 操作は、文字列の長さのような何かが長すぎたデータモデルの制限、拒否 */
            code = TMCloudErrorCodeLenTooLong;
            break;
            
        case EDAMErrorCode_TOO_FEW:                 /**< 操作は、何かの数が少なすぎるがあったデータモデルの制限に否定した。 */
            code = TMCloudErrorCodeTooFew;
            break;
            
        case EDAMErrorCode_TOO_MANY:                /**< 操作は、何かのあまりに多くがあったデータモデルの制限に否定した。 */
            code = TMCloudErrorCodeTooMany;
            break;
            
        case EDAMErrorCode_UNSUPPORTED_OPERATION:   /**< 現在サポートされていないため、操作は拒否されました。 */
            code = TMCloudErrorCodeUnsupportedOperation;
            break;
            
        case EDAMErrorCode_TAKEN_DOWN:              /**< 対応するオブジェクトへのアクセスがテイクダウン通知に応答して、
                                                             禁止されているため、操作が拒否されました。 */
            code = TMCloudErrorCodeMightBeServerStopped;
            break;
            
        case EDAMErrorCode_RATE_LIMIT_REACHED:      /**< 多量のリクエスト発行 */
            code = TMCloudErrorCodeTooManyRequest;
            break;

        case EDAMErrorCode_INTERNAL_ERROR:
        case EDAMErrorCode_UNKNOWN:
        default:
            code = TMCloudErrorCodeMightBeServerStopped;
            break;
    }
    
    return resultCode;
}

@end










