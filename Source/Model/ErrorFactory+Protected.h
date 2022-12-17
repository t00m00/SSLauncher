//
//  ErrorFactory+Protected.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/17.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "ErrorFactory.h"

@interface ErrorFactory (Protected)

/** CocoaErrorDomainのエラーコードをマッピングします */
+ (TMErrorCode)mappingErrorCodeOfCocoaErrorDomain:(NSInteger)code;

/** URLErrorDomainのエラーコードをマッピングします */
+ (TMErrorCode)mappingErrorCodeOfURLErrorDomain:(NSInteger)code;

/** Dropboxのエラーをマッピングします */
+ (TMErrorCode)mappingErrorCodeOfDropboxErrorDomain:(NSInteger)code;

/** Evernoteのエラーをマッピングします */
+ (TMErrorCode)mappingErrorCodeOfEvernoteException:(NSInteger)code;

@end