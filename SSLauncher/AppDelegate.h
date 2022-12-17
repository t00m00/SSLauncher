//
//  AppDelegate.h
//  SSLauncher
//
//  Created by toomoo on 2014/08/29.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBarViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//** UITabBarViewControllerを保持する */
@property (weak, nonatomic, readonly) TabBarViewController *tabBarController;

@end
