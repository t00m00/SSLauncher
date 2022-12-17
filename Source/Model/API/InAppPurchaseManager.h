//
//  InAppPurchaseManager.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/10.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** プロダクト情報連想配列からを値を取得するためのキー */
extern NSString * const kIAPMProductIdentifier;
extern NSString * const kIAPMProductLocalizedTitle;
extern NSString * const kIAPMProductLocalizedDescription;
extern NSString * const kIAPMProductLocalizedPrice;


/** InAppPurchaseManagerのデリゲートです */
@class InAppPurchaseManager;
@protocol IAPManagerProductDelegate <NSObject>
@optional


/** App Storeから取得したプロダクト情報を取得できます(|productInfo|がnilの場合購入できる機能はない) */
- (void)ipaManager:(InAppPurchaseManager *)manager productInfo:(NSDictionary *)infoDic;

@end

@protocol IAPManagerPaymentDelegate <NSObject>
@optional

/** 購入処理中 */
- (void)ipaManagerStatePurchasing:(InAppPurchaseManager *)manager;

/** 購入完了 */
- (void)ipaManagerStatePurchased:(InAppPurchaseManager *)manager paymentProductID:(NSString *)ppID;

/** 購入キャンセル */
- (void)ipaManagerStatePurchaseCancel:(InAppPurchaseManager *)manager;

/** 購入失敗 */
- (void)ipaManagerStatePurchaseFailed:(InAppPurchaseManager *)manager error:(NSError *)error;

/** リストア完了 */
- (void)ipaManagerStateRestored:(InAppPurchaseManager *)manager paymentProductID:(NSString *)ppID;

/** リストア失敗 */
- (void)ipaManagerStateRestored:(InAppPurchaseManager *)manager error:(NSError *)error;

@end

/** アプリ内購入の機能を提供します（シングルトンです） */
@interface InAppPurchaseManager : NSObject

/** インスタンスを取得します */
+ (instancetype)shared;

/** 課金ができるか確認する */
+ (BOOL)canMakePurchases;

/** デリゲートを登録します(weak) */
- (void)addDelegate:(id)delegate;

/** トランザクションの監視登録 */
- (void)addTransaction;

/** トランザクションの監視解除 */
- (void)removeTransaction;

/** 購入対象のプロダクト情報を取得します */
- (void)requestProductsData:(NSSet *)pIDs;

/** 購入処理を開始します */
- (BOOL)requestPayment:(NSString *)pID;

/** リストアを開始します */
- (void)requestRestore;

@end
