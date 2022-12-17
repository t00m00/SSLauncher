//
//  MsgStatusBarViewController.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/15.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgStatusBarViewController : UIViewController

/** 表示後一定時間で自動的に非表示にする */
+ (void)showAndCloseWithMessage:(NSString *)msg;


+ (void)showWithMessage:(NSString *)msg;
/** メッセージを変更する */
+ (void)changeMessage:(NSString *)msg;
+ (void)closeWithDefaultDelay;
+ (void)closeWithDelay:(double)delayInSeconds;

@end
