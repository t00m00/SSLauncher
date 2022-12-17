//
//  DescriptionViewController.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/20.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/** タップイベントを透過させるWindows */
@interface eventTransparentWindow : UIWindow
@end


/** 初期表示の説明画面 */
@interface DescriptionViewController : UIViewController

+ (void)show;
+ (void)close;
+ (void)closeWithAnimation;

@end
