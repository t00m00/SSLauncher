//
//  ViewErrorMsg.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/18.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>


/** エラーメッセージ取得の際のキー名:タイトル */
extern NSString * const TMErrorMsgKeyTitle;

/** エラーメッセージ取得の際のキー名:本文 */
extern NSString * const TMErrorMsgKeyBody;


@interface ViewErrorMsg : NSObject

/** エラーメッセージ、タイトルを取得します */
+ (NSDictionary *)errorString:(NSError * const)error;

@end
