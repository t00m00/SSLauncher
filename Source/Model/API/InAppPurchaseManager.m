//
//  InAppPurchaseManager.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/10.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import <StoreKit/StoreKit.h>

/** プロダクト情報連想配列からを値を取得するためのキー */
NSString * const kIAPMProductIdentifier = @"ProductIdentifier";
NSString * const kIAPMProductLocalizedTitle = @"ProductLocalizedTitle";
NSString * const kIAPMProductLocalizedDescription = @"ProductLocalizedDescription";
NSString * const kIAPMProductLocalizedPrice = @"ProductLocalizedPrice";



static InAppPurchaseManager *sharedInstance = nil;

@interface InAppPurchaseManager () <SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (strong, nonatomic) NSMutableArray *delegates;
@property (strong, nonatomic) SKProductsRequest *productsRequest;
@property (strong, nonatomic) NSMutableDictionary *productsInfo;

@end

@implementation InAppPurchaseManager

#pragma mark -
#pragma mark ===== Class Method =====

+ (instancetype)shared
{
	
	static dispatch_once_t once;
	dispatch_once( &once, ^{
        
		sharedInstance = [[self alloc] init];
	});
    
	return sharedInstance;
}

+ (instancetype)allocWithZone:(NSZone *)zone
{
	
	__block id ret = nil;
	
	static dispatch_once_t once;
	dispatch_once( &once, ^{
        
		sharedInstance = [super allocWithZone:zone];
		ret = sharedInstance;
	});
	
	return  ret;
}

// 「3. ペイメント処理を進めてよいか判断します。」部分
+ (BOOL)canMakePurchases
{
    if([SKPaymentQueue canMakePayments])
    {
        return YES;
    }else {

        return NO;
    }
}

#pragma mark -
#pragma mark ===== Instance Method =====

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.delegates = [NSMutableArray array];
        self.productsInfo = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;
}

/** デリゲートを登録します(weak) */
- (void)addDelegate:(id)delegate
{
    [self.delegates addObject:[NSValue valueWithNonretainedObject:delegate]];
}

/** トランザクションの監視登録 */
- (void)addTransaction
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

/** トランザクションの監視解除 */
- (void)removeTransaction
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

// 「4. プロダクトに関する情報を取得します。」部分
- (void)requestProductsData:(NSSet *)pIDs
{
    self.productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers: pIDs];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

/** 購入処理を開始します */
- (BOOL)requestPayment:(NSString *)pID
{
    // プロダクト情報の再取得（不要なのでコメントアウト）
//    [self requestProductsData:[NSSet setWithObject:pID]];
    
    SKProduct *product = [self.productsInfo valueForKey:pID];
    
    if (product == nil) {
        return NO;
    }
    
    // 購入処理開始
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];

    return YES;
}

/** リストアを開始します */
- (void)requestRestore
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


#pragma mark -
#pragma mark ===== SKProductsRequestDelegate Method =====
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    
    // 初期化
    self.productsInfo = [NSMutableDictionary dictionary];
    
    // 購入できる機能なし
    if (response == nil) {
//        NSLog(@"There is no function that can be purchased now.");
        
        // デリゲートの呼び出し
        for (id delegate in self.delegates) {
            
            if ([delegate respondsToSelector:@selector(ipaManager:productInfo:)]) {
                
                [delegate ipaManager:self productInfo:nil];
            }
        }
        return;
    }
    
    // 確認できなかった、有効期限が無効であるidentifierをログに記録
    for (NSString *identifier in response.invalidProductIdentifiers) {
        NSLog(@"invalid product identifier: %@", identifier);
    }
    
    for (SKProduct *product in response.products ) {
//        NSLog(@"valid product identifier: %@", product.productIdentifier);
//        
//        NSLog(@"%@",[product productIdentifier]);
//        NSLog(@"%@",[product localizedTitle]);
//        NSLog(@"%@",[product localizedDescription]);
//        NSLog(@"%@",[product price]);
//        NSLog(@"%@",[[self class] localizedPriceString:product.price locale:product.priceLocale]);

        NSString * const localizedPrice = [[self class] localizedPriceString:product.price locale:product.priceLocale];
        
        NSDictionary *productInfo = @{
                                      kIAPMProductIdentifier:               product.productIdentifier,
                                      kIAPMProductLocalizedTitle:           product.localizedTitle,
                                      kIAPMProductLocalizedDescription:     product.localizedDescription,
                                      kIAPMProductLocalizedPrice:           localizedPrice
                                      };
        
        // デリゲートの呼び出し
        for (NSValue *value in self.delegates) {
            
            id <IAPManagerProductDelegate> delegate = [value nonretainedObjectValue];
            
            if ([delegate respondsToSelector:@selector(ipaManager:productInfo:)]) {
                
                [delegate ipaManager:self productInfo:productInfo];
            }
        }
        
        // プロダクト情報を保持
        [self.productsInfo setObject:product forKey:product.productIdentifier];
    }
}


#pragma mark -
#pragma mark ===== SKPaymentTransactionObserver Method =====
- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                // 購入処理中。基本何もしなくてよい。処理中であることがわかるようにインジケータをだすなど。
                // デリゲートの呼び出し
                for (NSValue *value in self.delegates) {
                    
                    id <IAPManagerPaymentDelegate> delegate = [value nonretainedObjectValue];
                    
                    if ([delegate respondsToSelector:@selector(ipaManagerStatePurchasing:)]) {
                        
                        [delegate ipaManagerStatePurchasing:self];
                    }
                }
                break;
                
            case SKPaymentTransactionStatePurchased:
                // 購入処理成功
//                NSLog(@"paymentSuccess");
//                NSLog(@"transaction : %@",transaction);
//                NSLog(@"transaction.payment.productIdentifier : %@",transaction.payment.productIdentifier);
                
 
                // デリゲートの呼び出し
                for (NSValue *value in self.delegates) {
                    
                    id <IAPManagerPaymentDelegate> delegate = [value nonretainedObjectValue];
                    
                    if ([delegate respondsToSelector:@selector(ipaManagerStatePurchased:paymentProductID:)]) {
                        
                        [delegate ipaManagerStatePurchased:self paymentProductID:transaction.payment.productIdentifier];
                    }
                }
                
                [queue finishTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                // 購入処理失敗。ユーザが購入処理をキャンセルした場合もここ
                if (transaction.error.code == SKErrorPaymentCancelled) {
                    NSLog(@"payment Cancel");
                    
                    // デリゲートの呼び出し
                    for (NSValue *value in self.delegates) {
                        
                        id <IAPManagerPaymentDelegate> delegate = [value nonretainedObjectValue];
                        
                        if ([delegate respondsToSelector:@selector(ipaManagerStatePurchaseCancel:)]) {
                            
                            [delegate ipaManagerStatePurchaseCancel:self];
                        }
                    }
                    
                } else {

                    NSLog(@"payment Failed");
                    NSLog(@"error : %@",[transaction.error localizedDescription]);
                    
                    // デリゲートの呼び出し
                    for (NSValue *value in self.delegates) {
                        
                        id <IAPManagerPaymentDelegate> delegate = [value nonretainedObjectValue];
                        
                        if ([delegate respondsToSelector:@selector(ipaManagerStatePurchaseCancel:)]) {
                            
                            [delegate ipaManagerStatePurchaseFailed:self error:transaction.error];
                            
                        }
                    }
                    
                    if (transaction.error.code == SKErrorUnknown) {
                        
                        NSLog(@"SKErrorUnknown");
                    }
                }
                
                [queue finishTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                
                //リストア処理開始
//                NSLog(@"リストア処理");
//                NSLog(@"transaction : %@",transaction);
//                NSLog(@"transaction.originalTransaction.payment.productIdentifier : %@",transaction.originalTransaction.payment.productIdentifier);
                
                
                // デリゲートの呼び出し
                /*
                 for (NSValue *value in self.delegates) {
                 
                    id <IAPManagerPaymentDelegate> delegate = [value nonretainedObjectValue];
                 
                    if ([delegate respondsToSelector:@selector(ipaManagerStateRestored:paymentProductID:)]) {
                 
                        [delegate ipaManagerStateRestored:self paymentProductID:transaction.payment.productIdentifier];
                    }
                 }
                 */
                
                [queue finishTransaction:transaction];
                
                break;
                
            default:
                
                [queue finishTransaction:transaction];
                break;
        }
    }
}


/** リストアの失敗 */
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"restore failed : %@", error);
    NSLog(@"error:%@", error.localizedDescription);

    // TODO: 失敗のアラート表示等
    // デリゲートの呼び出し
    for (NSValue *value in self.delegates) {
        
        id <IAPManagerPaymentDelegate> delegate = [value nonretainedObjectValue];
        
        if ([delegate respondsToSelector:@selector(ipaManagerStateRestored:error:)]) {
            
            [delegate ipaManagerStateRestored:self error:error];
            
        }
    }
}

/** すべてのリストアの完了 */
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
//    NSLog(@"Restore completed");
    // デリゲートの呼び出し
    for (NSValue *value in self.delegates) {
        
        id <IAPManagerPaymentDelegate> delegate = [value nonretainedObjectValue];
        
        if ([delegate respondsToSelector:@selector(ipaManagerStateRestored:paymentProductID:)]) {
            
            [delegate ipaManagerStateRestored:self paymentProductID:nil];
            
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    // このメソッドの実装では、対応する項目をアプリケーションのUIから削除します。
//    NSLog(@"removedTransactions");
    
    // ここでのトランザクションの解除は不要
//    [self removeTransaction];
}


#pragma mark -
#pragma mark ===== Private Class Method =====
// 価格をローカライズします。
+ (NSString *)localizedPriceString:(NSDecimalNumber *)price locale:(NSLocale *)locale
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:locale];
    
    return [numberFormatter stringFromNumber:price];
}

@end
