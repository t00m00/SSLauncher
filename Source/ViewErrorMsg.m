//
//  ViewErrorMsg.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/18.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "ViewErrorMsg.h"
#import "ErrorFactory.h"

/** エラーメッセージ取得の際のキー名:タイトル */
NSString * const TMErrorMsgKeyTitle = @"TMErrorMsgKeyTitle";

/** エラーメッセージ取得の際のキー名:本文 */
NSString * const TMErrorMsgKeyBody = @"TMErrorMsgKeyBody";

/** エラーメッセージを管理します */
@implementation ViewErrorMsg

/**
 * @brief エラーメッセージ、タイトルを取得します
 * @return メッセージ、タイトルが格納された連想配列。
 * nilが返ります。
 * @param[in] error マッピング対象のNSErrorオブジェクト
 * @throws なし
 * @note
 */
+ (NSDictionary *)errorString:(NSError * const)error
{
    if (![[error domain] isEqualToString:TMErrorDomain]) {
        
        NSLog(@"[errorString:] faild:Internal");
        
        return @{ TMErrorMsgKeyTitle: NSLocalizedString(@"Err_App_Title_Internal", ""),
                  TMErrorMsgKeyBody : NSLocalizedString(@"Err_App_Body_Internal", "") };
    }
    
    NSString *title = nil;
    NSString *body = nil;
    
    switch ([error code]) {
            
            /*--------------------------------------------------------------------------
             * ファイルシステム
             *------------------------------------------------------------------------*/
            
        case TMErrorCodeWriteOutOfSpace: // ディスク容量不足
            
            title = NSLocalizedString(@"Err_App_Title_DiskFull", "");
            body = NSLocalizedString(@"Err_App_Body_DiskFull", "");
            break;

        case TMErrorCodeFileTooLarge: // ファイルサイズが大きすぎる
        case TMErrorCodeWriteFileUnknown: // ファイルの書き込みに失敗（理由は不明）
        case TMErrorCodeFileNotFound: // ファイルが存在しません
        case TMErrorCodeFileShared: // ファイルが他で使用されている
        case TMErrorCodeWriteFileExists: // ファイルが既に存在する
            
            title = NSLocalizedString(@"Err_App_Title_FileExist", "");
            body = NSLocalizedString(@"Err_App_Body_FileExist", "");
            break;
            
        case TMErrorCodeWriteInvalidFileName: // ファイル名不正
            
            title = NSLocalizedString(@"Err_App_Title_InvalidFileName", "");
            body = NSLocalizedString(@"Err_App_Body_InvalidFileName", "");
            break;
            
            
            /*--------------------------------------------------------------------------
             * 共通
             *------------------------------------------------------------------------*/
        case TMErrorCodeInternal: // 内部エラー
            
            title = NSLocalizedString(@"Err_App_Title_Internal", "");
            body = NSLocalizedString(@"Err_App_Body_Internal", "");
            break;
            
            /*--------------------------------------------------------------------------
             * 通信系
             *------------------------------------------------------------------------*/
        case TMURLErrorCodeNotConnectedToInternet: // インターネットに接続していない
            
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_NoConnectInternet", "");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_NoConnectInternet", "");
            break;
            
        case TMURLErrorCodeTimeOut: // タイムアウト(サーバーが応答しません)
            
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_TimeOut", "");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_TimeOut", "");
            break;
            
        case TMURLErrorBadServerResponse: // サーバーの応答が壊れている
            
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_ServerStopped", "");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_ServerStopped", "");
            break;
            
        case TMURLErrorDataLengthExceedsMaximum: // データの長さが長い
            
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_DataLength", "");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_DataLength", "");
            break;
            
            /*--------------------------------------------------------------------------
             * クラウド
             *------------------------------------------------------------------------*/
        case TMCloudErrorCodeDisconnect: // クラウドと接続されていない
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_NoConnect","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_NoConnect","");
            break;

        case TMCloudErrorCodeOverStorageQuota: // ネットワークストレージの容量オーバー
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_OverStorage","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_OverStorage","");
            break;
            
        case TMCloudErrorCodeBadParameter: // パラメーター異常
            title = NSLocalizedString(@"Err_App_Title_Internal","");
            body = NSLocalizedString(@"Err_App_Body_Internal","");
            break;

        case TMCloudErrorCodeBadToken: // 不正なトークン使用(認証し直し)
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_BadToken","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_BadToken","");
            break;
            
        case TMCloudErrorCodeTooManyRequest: // 多量のリクエスト発行
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_TimeOut","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_TimeOut","");
            break;

        case TMCloudErrorCodeMightBeServerStopped: // クラウドサーバーが停止している可能性がある。
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_ServerStopped","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_ServerStopped","");
            break;
            
        case TMCloudErrorCodeDataRequired:      // 必要なパラメータ/フィールドが存在しなかった。
        case TMCloudErrorCodeENMLValidation:    // 提出されたノートの内容は、不正な形式だった
            // (内部エラーにマッピングする)
            title = NSLocalizedString(@"Err_App_Title_Internal", "");
            body = NSLocalizedString(@"Err_App_Body_Internal", "");
            break;

        case TMCloudErrorCodeLimitReached: // 動作は、データモデルの制限に起因する拒否
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_LimitReached","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_LimitReached","");
            break;
            
        case TMCloudErrorCodeInvalidAuth: // ユーザー名および/またはパスワードが正しくない
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_AccountFailed","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_AccountFailed","");
            break;
            
        case TMCloudErrorCodeAuthExpired: // 認証トークンの有効期限切れ
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_AuthExpired","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_AuthExpired","");
            break;
            
        case TMCloudErrorCodeDataConflict: // データが競合しています
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_DataConflict","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_DataConflict","");
            break;
                        
        case TMCloudErrorCodeShardUnavailable: // クラウドサーバーが停止している可能性がある。
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_ServerStopped","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_ServerStopped","");
            break;
            
        case TMCloudErrorCodeLenTooShort: // 操作は、文字列の長さのような何かが短すぎたデータモデルの制限、拒否
        case TMCloudErrorCodeLenTooLong: // 操作は、文字列の長さのような何かが長すぎたデータモデルの制限、拒否
        case TMCloudErrorCodeTooFew: // 操作は、何かの数が少なすぎるがあったデータモデルの制限に否定した。
        case TMCloudErrorCodeTooMany: // 操作は、何かのあまりに多くがあったデータモデルの制限に否定した。
        case TMCloudErrorCodeTakeDown: // 対応するオブジェクトへのアクセスがテイクダウン通知に応答して、禁止されているため、操作が拒否されました

            title = NSLocalizedString(@"Err_Cloud_Upload_Title_ServerStopped","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_ServerStopped","");
            break;
            
        case TMCloudErrorCodeUnsupportedOperation: // 現在サポートされていないため、操作は拒否されました。
            title = NSLocalizedString(@"Err_Cloud_Upload_Title_UnsupportedOperation","");
            body = NSLocalizedString(@"Err_Cloud_Upload_Body_UnsupportedOperation","");
            break;
        default:
            
            NSLog(@"[errorString:error] faild:Internal" );
            
            title = NSLocalizedString(@"Err_App_Title_Internal", "");
            body = NSLocalizedString(@"Err_App_Body_Internal", "");
            break;
    }
    
    return @{ TMErrorMsgKeyTitle: title,
              TMErrorMsgKeyBody : body };
    
}

@end
