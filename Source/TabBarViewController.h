//
//  TabBarViewController.h
//  SSLauncher
//
//  Created by toomoo on 2015/02/08.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController

- (void)showPreview:(NSString *)path
         completion:(void (^)(BOOL isUpload))completion;

@end
