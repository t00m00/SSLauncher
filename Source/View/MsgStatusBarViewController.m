//
//  MsgStatusBarViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/15.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "MsgStatusBarViewController.h"

#import <objc/runtime.h>

//#define STATUSBAR_DEFAULTCOLOR [UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1.0f]
#define STATUSBAR_DEFAULTCOLOR [UIColor colorWithRed:34.0f/255.0f green:134.0f/255.0f blue:250.0f/255.0f alpha:0.9f]


static const char kAssocKey_Window_StatusBar;

@interface MsgStatusBarViewController ()

@property (strong, nonatomic) UIColor *messageTextColor;
@property (strong, nonatomic) NSString *message;

@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation MsgStatusBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.msgLabel.text = self.message;
    self.msgLabel.textColor = self.messageTextColor;
    
    self.backgroundView.backgroundColor = STATUSBAR_DEFAULTCOLOR;
//    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    
    // ステータスバーの高さが変化に対応させる
    CGFloat statusBarHeight = UIApplication.sharedApplication.statusBarFrame.size.height;

    CGRect whiteViewRect = self.whiteView.frame;
    self.whiteView.frame = CGRectMake(whiteViewRect.origin.x,
                                      statusBarHeight - self.whiteView.frame.size.height,
                                      whiteViewRect.size.width,
                                      whiteViewRect.size.height);
    
    self.backgroundView.frame = self.whiteView.frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ===== Class Method =====
/** 表示後一定時間で自動的に非表示にする */
+ (void)showAndCloseWithMessage:(NSString *)msg;
{
    [[self class] showWithMessage:msg textColor:[UIColor whiteColor] autoClose:YES];
}

+ (void)showWithMessage:(NSString *)msg
{
    [[self class] showWithMessage:msg textColor:[UIColor whiteColor] autoClose:NO];
}

+ (void)showWithMessage:(NSString *)msg
              textColor:(UIColor *)textColor
              autoClose:(BOOL)isClose
{
    
    // 現在のStatusBarより全面にだすため、少し高い値を設定する
    const UIWindowLevel kStatusBarWindowLevel = UIWindowLevelStatusBar + 5;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.userInteractionEnabled = NO;
    window.alpha = 0.0f;
    window.transform = CGAffineTransformMakeScale(1.1, 1.1);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MsgStatusBar" bundle:nil];
    MsgStatusBarViewController *msgStatusBarVC = [storyboard instantiateInitialViewController];
    msgStatusBarVC.message = msg;
    msgStatusBarVC.messageTextColor = textColor;
    
    window.rootViewController = msgStatusBarVC;
//    window.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    window.windowLevel = kStatusBarWindowLevel;
    
    [window makeKeyAndVisible];
    
    
    // ウィンドウのオーナーとしてアプリ自身に括りつけとく
    objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_StatusBar, window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [UIView transitionWithView:window
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        
                        window.alpha = 1.0f;
                        window.transform = CGAffineTransformIdentity;
                        
                    } completion:^(BOOL finished) {
        
                        if (isClose == YES) {
                            // 自動で終了させる
                            [[self class] closeWithDefaultDelay];
                        }
                    }];
}

/** メッセージを変更する */
+ (void)changeMessage:(NSString *)msg
{
    UIWindow *window = objc_getAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_StatusBar);
    
    if (window == nil) {
        return;
    }

    MsgStatusBarViewController *msgSBVC = (MsgStatusBarViewController *)window.rootViewController;
    
    [UIView transitionWithView:window
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        msgSBVC.msgLabel.text = msg;
                        
                    }
                    completion:^(BOOL finished) {
                        
                    }];
}

+ (void)close
{
    UIWindow *window = objc_getAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_StatusBar);
    
    if (window == nil) {
        return;
    }
    
    [UIView transitionWithView:window
                      duration:0.3f
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                     
                        MsgStatusBarViewController *msgSBVC = (MsgStatusBarViewController *)window.rootViewController;

                        msgSBVC.msgLabel.center =
                            CGPointMake(msgSBVC.msgLabel.center.x, -msgSBVC.backgroundView.frame.size.height);

                    }
                    completion:^(BOOL finished) {
                        
                        [window.rootViewController.view removeFromSuperview];
                        window.rootViewController = nil;
                        
                        // 上乗せしたウィンドウを破棄
                        objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_StatusBar, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        
                        // メインウィンドウをキーウィンドウにする
                        UIWindow *nextWindow = [[UIApplication sharedApplication].delegate window];
                        [nextWindow makeKeyAndVisible];
                    }];
}

+ (void)closeWithDefaultDelay
{
    [[self class] closeWithDelay:3.0];
}

/** 一定時間後に非表示にする */
+ (void)closeWithDelay:(double)delayInSeconds
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [[self class] close];
        
    });
}

@end
