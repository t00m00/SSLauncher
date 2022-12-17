//
//  SyncAlertView.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/13.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncAlertView : NSObject

@property(assign, nonatomic) UIAlertViewStyle alertViewStyle;

/** ボタンは２つまでしか対応していない */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitle;

/** 同期でアラートを表示する(ブロック) */
- (void)syncShow:(void(^)(NSInteger buttonIndex))clickedBlock;

/** 同期でアラートを表示する */
- (NSInteger)syncShow;

/** アラートに表示しているテキストフィードを取得する(ゼロはじまり) */
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

@end
