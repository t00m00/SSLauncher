//
//  InAppPurchaseFacade.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/10.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** アプリ内購入のアイテムID */
extern NSString * const kIAPProductsIDSSLListUnrestraint;  /**< Launcherリストを無制限にする */

/** プロダクト情報を取得するためのキー */
extern NSString * const kIAPMProductIdentifier;
extern NSString * const kIAPMProductLocalizedTitle;
extern NSString * const kIAPMProductLocalizedDescription;
extern NSString * const kIAPMProductLocalizedPrice;


@interface InAppPurchaseFacade : NSObject

/** トランザクションの監視登録 */
+ (void)addTransaction;

/** トランザクションの監視解除 */
+ (void)removeTransaction;

/** プロダクト情報を取得します */
- (void)requestProductInfo:(void(^)(InAppPurchaseFacade *iapFacade, NSDictionary *productInfos))completionBlock;

/** アプリ内購入を開始します */
- (BOOL)purchaseProduct:(NSString *)pID
            proccessing:(void(^)(InAppPurchaseFacade *iapFacade))processingBlock
                success:(void(^)(InAppPurchaseFacade *iapFacade, NSString *paymanetProductID))successBlock
                  error:(void(^)(InAppPurchaseFacade *iapFacade, NSError *error))errorBlock;

/** リストアを開始します */
- (BOOL)restore:(void(^)(InAppPurchaseFacade *iapFacade))processingBlock
        success:(void(^)(InAppPurchaseFacade *iapFacade, NSString *paymanetProductID))successBlock
          error:(void(^)(InAppPurchaseFacade *iapFacade, NSError *error))errorBlock;
@end
