//
//  InputAlertViewController.h
//  SSLauncher
//
//  Created by toomoo on 2015/03/09.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputAlertViewController : UIViewController

+ (void)showWithAlertTiltle:(NSString *)title
                placeholder:(NSString *)placeholder
            defaultfileName:(NSString *)fileName
                    clicked:(void(^)(NSInteger buttonIndex, NSString *fileName))clickedBlock;
+ (void)close;

@end
