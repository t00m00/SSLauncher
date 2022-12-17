//
//  InAppPurchaseFacade.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/10.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "InAppPurchaseFacade.h"
#import "InAppPurchaseManager.h"
#import "SSLUserDefaults.h"

// アプリ内購入のアイテムID
NSString * const kIAPProductsIDSSLListUnrestraint = @"com.toomoo.Scanner.SSLauncher.LauncherListUnrestraint";


@interface InAppPurchaseFacade () <IAPManagerProductDelegate, IAPManagerPaymentDelegate>

/** 各種ハンドル */
@property (strong, nonatomic) void(^pInfoCompletionBlock)(InAppPurchaseFacade *iapFacade, NSDictionary *productInfos);

@property (strong, nonatomic) void(^processingBlock)(InAppPurchaseFacade *iapFacade);
@property (strong, nonatomic) void(^successBlock)(InAppPurchaseFacade *iapFacade, NSString *paymanetProductID);
@property (strong, nonatomic) void(^errorBlock)(InAppPurchaseFacade *iapFacade, NSError *error);

@property (strong, nonatomic) void(^restoreProcessingBlock)(InAppPurchaseFacade *iapFacade);
@property (strong, nonatomic) void(^restoreSuccessBlock)(InAppPurchaseFacade *iapFacade, NSString *paymanetProductID);
@property (strong, nonatomic) void(^restoreErrorBlock)(InAppPurchaseFacade *iapFacade, NSError *error);

@end


@implementation InAppPurchaseFacade

#pragma mark -
#pragma mark ===== Class Method =====
/** トランザクションの監視登録 */
+ (void)addTransaction
{
    [[InAppPurchaseManager shared] addTransaction];
}

/** トランザクションの監視解除 */
+ (void)removeTransaction
{
    [[InAppPurchaseManager shared] removeTransaction];
}

#pragma mark -
#pragma mark ===== Instance Method =====
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[InAppPurchaseManager shared] addDelegate:self];
    }
    return self;
}

/** プロダクト情報を取得します */
- (void)requestProductInfo:(void(^)(InAppPurchaseFacade *iapFacade, NSDictionary *productInfos))completionBlock
{
    self.pInfoCompletionBlock = completionBlock;
    
    NSSet *products = [NSSet setWithObject:kIAPProductsIDSSLListUnrestraint];
    
    [[InAppPurchaseManager shared] requestProductsData:products];
}

/** アプリ内購入を開始します */
- (BOOL)purchaseProduct:(NSString *)pID
            proccessing:(void(^)(InAppPurchaseFacade *iapFacade))processingBlock
                success:(void(^)(InAppPurchaseFacade *iapFacade, NSString *paymanetProductID))successBlock
                  error:(void(^)(InAppPurchaseFacade *iapFacade, NSError *error))errorBlock
{
    if ([InAppPurchaseManager canMakePurchases] == NO) {
        
        // アプリ内購入禁止
        NSLog(@"Prohibited in-app purchase");
        return NO;
    }
    
    self.processingBlock = processingBlock;
    self.successBlock = successBlock;
    self.errorBlock = errorBlock;
    
    return [[InAppPurchaseManager shared] requestPayment:pID];
}


/** リストアを開始します */
- (BOOL)restore:(void(^)(InAppPurchaseFacade *iapFacade))processingBlock
        success:(void(^)(InAppPurchaseFacade *iapFacade, NSString *paymanetProductID))successBlock
          error:(void(^)(InAppPurchaseFacade *iapFacade, NSError *error))errorBlock
{
    self.restoreProcessingBlock = processingBlock;
    self.restoreSuccessBlock = successBlock;
    self.restoreErrorBlock = errorBlock;
    
    [[InAppPurchaseManager shared] requestRestore];
    
    return YES;
}

#pragma mark -
#pragma mark ===== IAPManagerProductDelegate Method =====
/** App Storeから取得したプロダクト情報を取得できます(|productInfo|がnilの場合購入できる機能はない) */
- (void)ipaManager:(InAppPurchaseManager *)manager productInfo:(NSDictionary *)infoDic
{
    self.pInfoCompletionBlock(self, infoDic);
}

#pragma mark -
#pragma mark ===== IAPManagerPaymentDelegate Method =====
/** 購入処理中 */
- (void)ipaManagerStatePurchasing:(InAppPurchaseManager *)manager
{
    if (self.processingBlock != nil) {
        
        self.processingBlock(self);
    }
}

/** 購入完了 */
- (void)ipaManagerStatePurchased:(InAppPurchaseManager *)manager
                paymentProductID:(NSString *)ppID
{
    [SSLUserDefaults setLaunchUnrestraintKounyu:YES];
   
    if (self.successBlock != nil) {
        
        self.successBlock(self, ppID);
    }
}

/** 購入キャンセル */
- (void)ipaManagerStatePurchaseCancel:(InAppPurchaseManager *)manager
{
    if (self.errorBlock != nil) {
        
        self.errorBlock(self, nil);
    }
}

/** 購入失敗 */
- (void)ipaManagerStatePurchaseFailed:(InAppPurchaseManager *)manager
                                error:(NSError *)error
{
    if (self.errorBlock != nil) {
        
        self.errorBlock(self, error);
    }
}

/** リストア完了 */
- (void)ipaManagerStateRestored:(InAppPurchaseManager *)manager
               paymentProductID:(NSString *)ppID
{
    
    [SSLUserDefaults setLaunchUnrestraintKounyu:YES];

    if (self.restoreSuccessBlock != nil) {
        
        self.restoreSuccessBlock(self, ppID);
    }

}

/** リストア失敗 */
- (void)ipaManagerStateRestored:(InAppPurchaseManager *)manager
                          error:(NSError *)error
{
    
    if (self.restoreErrorBlock != nil) {
        
        self.restoreErrorBlock(self, error);
    }

}

@end
