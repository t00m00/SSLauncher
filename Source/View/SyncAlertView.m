//
//  SyncAlertView.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/13.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SyncAlertView.h"

/** 表示するアラートのタイプ */
static const NSInteger kTypeShowAlertInitialFlag        = -1;
static const NSInteger kTypeShowAlertSyncBlockFlag      = 1;
static const NSInteger kTypeShowAlertSyncFlag           = 2;

@interface SyncAlertView () <UIAlertViewDelegate>

@property (strong, nonatomic) UIAlertView *alertView;


@property (assign, nonatomic) NSInteger typeShowAlert;          /**< アラートを表示する際のタイプを保持します */
@property (assign, nonatomic) BOOL      isCompletion;           /**<  */
@property (assign, nonatomic) NSInteger clickedButtonIndex;     /**< ボタンがクリックされたかの判断に使用する */

@property (strong, nonatomic) void(^clickedBlock)(NSInteger buttonIndex);

@end

@implementation SyncAlertView
@dynamic alertViewStyle;

/** ボタンは２つまでしか対応していない */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitle
{
    self = [super init];
    if (self) {
        
        self.alertView = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitle, nil];
        
        self.typeShowAlert = kTypeShowAlertInitialFlag;
    }
    return self;
}

// getter/setter
- (void)setAlertViewStyle:(UIAlertViewStyle)alertViewStyle
{
    self.alertView.alertViewStyle = alertViewStyle;
}

- (UIAlertViewStyle)alertViewStyle
{
    return self.alertView.alertViewStyle;
}

/** 同期でアラートを表示する */
- (void)syncShow:(void(^)(NSInteger buttonIndex))clickedBlock
{
    self.clickedBlock = clickedBlock;
    self.typeShowAlert = kTypeShowAlertSyncBlockFlag;
    [self.alertView show];
}

/** 同期でアラートを表示する */
- (NSInteger)syncShow
{
    self.isCompletion = NO;
    self.typeShowAlert = kTypeShowAlertSyncFlag;
    [self.alertView show];
    
    while (self.isCompletion == NO) {
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
    
    return self.clickedButtonIndex;
}

/** アラートに表示しているテキストフィードを取得する(ゼロはじまり) */
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex
{
    return [self.alertView textFieldAtIndex:textFieldIndex];
}


#pragma mark -
#pragma mark ===== UIAlertViewDelegate Method =====

/** ボタンがタップされると呼び出される */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (self.typeShowAlert) {
        case kTypeShowAlertSyncBlockFlag:

            // ブロック版
            if (self.clickedBlock == nil) {
                return;
            }
            
            self.clickedBlock(buttonIndex);
            self.clickedBlock = nil;
            
            break;

        case kTypeShowAlertSyncFlag:
            
            // 同期版
            self.clickedButtonIndex = buttonIndex;
            self.isCompletion = YES;
            break;

        default:
            break;
    }
    
    self.typeShowAlert = kTypeShowAlertInitialFlag;
}

@end
