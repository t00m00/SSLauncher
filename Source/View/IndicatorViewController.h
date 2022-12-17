//
//  IndicatorViewController.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/14.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndicatorViewController : UIViewController

+ (void)show;
+ (void)showWithMessage:(NSString *)msg;
+ (void)close;

@end
