//
//  IndicatorViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/14.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "IndicatorViewController.h"

#import <objc/runtime.h>

static const char kAssocKey_Window;

@interface IndicatorViewController ()

@property (strong, nonatomic) NSString *message;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@end

@implementation IndicatorViewController

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
    
    // インジケータ開始
//    [self.indicator startAnimating];
    self.msgLabel.text = self.message;
    
    void (^roundCorner)(UIView*) = ^void(UIView *v) {
        CALayer *layer = v.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 6.0f;
    };
    
    roundCorner(self.containerView);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark ===== Class Method =====
+ (void)show
{
    [[self class] showWithMessage:NSLocalizedString(@"Common_Indicator_Msg_Proccesing", )];
}

+ (void)showWithMessage:(NSString *)msg;
{
    
    // 現在のWindowsより全面にだすため、少し高い値を設定する
    const UIWindowLevel kIndicatorWindowLevel = UIWindowLevelNormal + 10;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.alpha = 0.0f;
    window.transform = CGAffineTransformMakeScale(1.1, 1.1);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IndicatorWindow" bundle:nil];
    IndicatorViewController *indicatorVC = [storyboard instantiateInitialViewController];
    indicatorVC.message = msg;
    window.rootViewController = indicatorVC;
//    window.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    window.windowLevel = kIndicatorWindowLevel;
    
    [window makeKeyAndVisible];
    
    
    // ウィンドウのオーナーとしてアプリ自身に括りつけとく
    objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window, window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [UIView transitionWithView:window duration:0.2f options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{
        window.alpha = 1.0f;
        window.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)close
{
    UIWindow *window = objc_getAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window);
    
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
                        
                        window.alpha = 0;
                    }
                    completion:^(BOOL finished) {
                        
                        [window.rootViewController.view removeFromSuperview];
                        window.rootViewController = nil;
                        
                        // 上乗せしたウィンドウを破棄
                        objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        
                        // メインウィンドウをキーウィンドウにする
                        UIWindow *nextWindow = [[UIApplication sharedApplication].delegate window];
                        [nextWindow makeKeyAndVisible];
                    }];
}

@end
