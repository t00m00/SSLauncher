//
//  CompleteViewController.m
//  SSLauncher
//
//  Created by toomoo on 2015/01/31.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "CompleteViewController.h"

#import <objc/runtime.h>

static const char kAssocKey_Window_Complete;

@interface CompleteViewController ()

@property (strong, nonatomic) NSString *message;


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation CompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.msgLabel.text = self.message;

    void (^roundCorner)(UIView*) = ^void(UIView *v) {
        CALayer *layer = v.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 6.0f;
    };
    
    roundCorner(self.containerView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark ===== Class Method =====
/** 表示後一定時間で自動的に非表示にする */
+ (void)showAndClose
{
    [[self class] showWithMessage:NSLocalizedString(@"Common_Complete_Msg_Proccesing", ) autoClose:YES];
}

+ (void)show
{
    [[self class] showWithMessage:NSLocalizedString(@"Common_Complete_Msg_Proccesing", ) autoClose:NO];
}

+ (void)showWithMessage:(NSString *)msg
{
    [[self class] showWithMessage:msg autoClose:NO];
}

+ (void)showWithMessage:(NSString *)msg
              autoClose:(BOOL)isClose
{
    
    // 現在のWindowsより全面にだすため、少し高い値を設定する
    const UIWindowLevel kIndicatorWindowLevel = UIWindowLevelStatusBar + 10;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.alpha = 0.0f;
    window.transform = CGAffineTransformMakeScale(1.1, 1.1);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CompleteViewController" bundle:nil];
    CompleteViewController *completeVC = [storyboard instantiateInitialViewController];
    completeVC.message = msg;
    window.rootViewController = completeVC;
    window.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    window.windowLevel = kIndicatorWindowLevel;
    
    [window makeKeyAndVisible];
    
    
    // ウィンドウのオーナーとしてアプリ自身に括りつけとく
    objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_Complete, window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [UIView transitionWithView:window duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
        window.alpha = 1.0f;
        window.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        if (isClose == YES) {
            // 自動で終了させる
            [[self class] closeWithDefaultDelay];
        }
    }];
}

+ (void)close
{
    UIWindow *window = objc_getAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_Complete);
    
    if (window == nil) {
        return;
    }
    
    [UIView transitionWithView:window
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        /*
                         UIView *view = window.rootViewController.view;
                         
                         
                         for (UIView *v in view.subviews) {
                         v.transform = CGAffineTransformMakeScale(0.8, 0.8);
                         }
                         */
                        
                        window.transform = CGAffineTransformMakeScale(0.9, 0.9);;
                        window.alpha = 0;
                    }
                    completion:^(BOOL finished) {
                        
                        [window.rootViewController.view removeFromSuperview];
                        window.rootViewController = nil;
                        
                        // 上乗せしたウィンドウを破棄
                        objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_Complete, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        
                        // メインウィンドウをキーウィンドウにする
                        UIWindow *nextWindow = [[UIApplication sharedApplication].delegate window];
                        [nextWindow makeKeyAndVisible];
                    }];
}

+ (void)closeWithDefaultDelay
{
    [[self class] closeWithDelay:2.0f];
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
