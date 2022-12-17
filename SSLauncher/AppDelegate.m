//
//  AppDelegate.m
//  SSLauncher
//
//  Created by toomoo on 2014/08/29.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "AppDelegate.h"
#import "SchemeOpenURL.h"
#import "CloudFacade.h"
#import "InAppPurchaseFacade.h"
#import "FileManageFacade.h"
#import "UIViewController+Searching.h"
#import "EvernoteSDK.h"
#import "SSLUserDefaults.h"
#import "TabBarViewController.h"

#import "KTouchPointerWindow.h"

@interface AppDelegate()

@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask; // バックグラウンドタスク

//@property (strong, nonatomic) CloudFacade *cloudFacade;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch
    
    // StoreKitのトランザクション監視開始
    [InAppPurchaseFacade addTransaction];
    
    // フォルダなどの準備
    [FileManageFacade prepareDataDictionaries];
    
    // ナビゲーションバーの色変更など
    [UINavigationBar appearance].barTintColor =
    [UIColor colorWithRed:34/255.0 green:130/255.0 blue:250/255.0 alpha:1.0];   // アイコン色
    
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // タップ座標表示(デモ用)
#if defined(DEBUG) || defined(PRESEN)
    KTouchPointerWindowInstall();
#endif
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
//    NSLog(@"application openURL = %@", [url absoluteString]);
    
    
    
    if ([SchemeOpenURL isEqualCallbackSSCAURL:url] == YES) {
        
        // 即時に起動させるため、処理を遅延実行させる
        [SchemeOpenURL performSelector:@selector(performScannedProcess:) withObject:url afterDelay:0.0f];
        
        return YES;
        
    }
    
    if ([SchemeOpenURL isEqualWidgetURL:url] == YES) {
        
        // 即時起動するとアプリ連携で固まるので遅延実行する
        // Widgetで選択されたセルでスキャンを開始する
        [SchemeOpenURL performSelector:@selector(executeScanFromWidget:) withObject:url afterDelay:0.0f];
        
        return YES;
    }
    
    
    // 上記のどこにも当てはまらない場合は、Dropboxなどのクラウドとの接続のCallbackと判断する
    [CloudFacade openHandleURL:url];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        
        // iOS7.1以下
        [self.window.rootViewController viewDidAppear:NO];
        //            [self.window.rootViewController performSelector:@selector(viewDidAppear:) withObject:@(NO) afterDelay:0.1f];
        
        
    }else {
        
        // iOS8.0以降
        UIViewController *viewController = [UIViewController topMostController];
        
        if (YES == [viewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tabBarController = (UITabBarController*)viewController;
            UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
            
            [navigationController.topViewController viewDidAppear:NO];
            //            [navigationController.topViewController performSelector:@selector(viewDidAppear:) withObject:@(NO) afterDelay:0.1f];
        }
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 最後に表示していた画面を記憶する
//    [SSLUserDefaults setLastShowedViewControllerTag:self.tabBarController.selectedIndex];
    
    self.bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // このブロック内は一定時間内 (10分程度)に処理が完了しなかった場合に実行される。
        [application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }];
    
    
    // StoreKitのトランザクション監視解除
    [InAppPurchaseFacade removeTransaction];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSNotification* center = [NSNotification notificationWithName:@"applicationWillEnterForeground" object:self];
    // 通知実行
    [[NSNotificationCenter defaultCenter] postNotification:center];
    
    // StoreKitのトランザクション監視開始
    [InAppPurchaseFacade addTransaction];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // アプリがアクティブになった場合に処理を続きから行う
    [[EvernoteSession sharedSession] handleDidBecomeActive];
    
    // UITabBarControllerの保持
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        self->_tabBarController = (TabBarViewController *)[UIViewController topTabBarController];
        
        // 初回起動時にお気に入り画面を飛ばして、リスト画面を表示する
        if ([SSLUserDefaults isDescriptionViewShow] == YES) {
            
            self.tabBarController.selectedIndex = 1;
        }
    });

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
