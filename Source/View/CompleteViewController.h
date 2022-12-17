//
//  CompleteViewController.h
//  SSLauncher
//
//  Created by toomoo on 2015/01/31.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteViewController : UIViewController

/** 表示後一定時間で自動的に非表示にする */
+ (void)showAndClose;

+ (void)show;
+ (void)showWithMessage:(NSString *)msg;
+ (void)close;

@end
