//
//  DescriptionViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/20.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "DescriptionViewController.h"
#import "CloudFacade.h"
#import "CollaborateFacade.h"
#import "TMDeviceInfo.h"
#import "TapUpDownGestureRecognizer.h"
#import "SSUrlScheme.h"
#import "SSLUserDefaults.h"
#import "eventTransparentView.h"

#import <objc/runtime.h>

static const char kAssocKey_Window_Description;

/** SegueID */
static NSString * const kSegueNewSSPTVC             = @"NewSSPTVCSegue";        /**< Launcherの新規作成 */

/** NotificationCenter名 */
static NSString * const kNCenterWillEnterForeground = @"applicationWillEnterForeground";

/** 各ステップの完了イメージ */
static UIImage *checkOKImage = nil;

#pragma mark -
#pragma mark ===== eventTransparentWindow Class =====
@implementation eventTransparentWindow

/** イベント判定 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 現在イベントが発生しているViewを取得
    UIView *nowHitView = [super hitTest:point withEvent:event];
    
    // 自分自身(UIView）だったら透過して(nilを返すとイベントを取得しなくなる)
    if ( self == nowHitView )
    {
        return nil;
    }
    
    // それ意外だったらイベント発生させる
    return nowHitView;
}

@end


#pragma mark -
#pragma mark ===== DescriptionViewController Class =====
@interface DescriptionViewController ()

@property (weak, nonatomic) IBOutlet eventTransparentView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *step1Label;
@property (weak, nonatomic) IBOutlet UILabel *step2Label;
@property (weak, nonatomic) IBOutlet UILabel *step3Label;

@property (weak, nonatomic) IBOutlet UIImageView *sscaIcon;
@property (weak, nonatomic) IBOutlet UIButton *showAppStoreButton;
@property (weak, nonatomic) IBOutlet UIImageView *step2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *step3ImageView;

@property (weak, nonatomic) IBOutlet UIImageView *step1CheckImage;
@property (weak, nonatomic) IBOutlet UIImageView *step2CheckImage;
@property (weak, nonatomic) IBOutlet UIImageView *step3CheckImage;

@property (weak, nonatomic) IBOutlet TapUpDownGestureRecognizer *sscaIconTagGesture;
@property (weak, nonatomic) IBOutlet TapUpDownGestureRecognizer *settingImgTapGesture;
@property (weak, nonatomic) IBOutlet TapUpDownGestureRecognizer *addListImgTapGesture;

@end


@implementation DescriptionViewController

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
    
    //================================================================================
    // 表示テキストの設定
    //================================================================================
    self.titleLabel.text = NSLocalizedString(@"DescriptionVC_Title_text", @"");
    self.step1Label.text = NSLocalizedString(@"DescriptionVC_Step1_text", @"");
    self.step2Label.text = NSLocalizedString(@"DescriptionVC_Step2_text", @"");
    self.step3Label.text = NSLocalizedString(@"DescriptionVC_Step3_text", @"");
    [self.showAppStoreButton setTitle:NSLocalizedString(@"DescriptionVC_AppStoreButton_text", @"")
                             forState:UIControlStateNormal];
    
    checkOKImage = [UIImage imageNamed:@"description_check_ok"];
    
//    // 3.5Inchの場合、はみ出る部分を表示しない
//    if ([TMDeviceInfo is568h] == NO) {
//
//        self.step3ImageView.hidden = YES;
//    }
   
    //================================================================================
    // 角丸め
    //================================================================================
    void (^roundCorner)(UIView*) = ^void(UIView *v) {
        CALayer *layer = v.layer;
//        layer.masksToBounds = YES;                // YESにすると影がつかない
        layer.cornerRadius = 4.0f;
        
        layer.shadowOpacity = 0.6f;
        layer.shadowOffset = CGSizeMake(0, 2);
        layer.shadowRadius = 6.0f;
    };

    void (^roundCornerForIcon)(UIView*) = ^void(UIView *v) {
        CALayer *layer = v.layer;
        
        layer.cornerRadius = 10.0f;
        layer.masksToBounds = YES;

    };

    roundCorner(self.baseView);
    roundCornerForIcon(self.sscaIcon);
    
    //================================================================================
    // UIImageViewのハイライト動作設定
    //================================================================================
    __weak DescriptionViewController *wSelf = self;
    
    // SSCAアイコン
    self.sscaIconTagGesture.touchDown =
    ^void(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event) {

        wSelf.sscaIcon.highlighted = YES;
    };

    self.sscaIconTagGesture.touchUp =
    ^void(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event, BOOL isTouchUpInside) {

        wSelf.sscaIcon.highlighted = NO;
        
        if (YES == isTouchUpInside) {
            [CollaborateFacade openAppStoreToSSCA];
            [SSLUserDefaults setPushSSCAInstallButton:YES];
        }
    };
    
    // 設定画像
    self.settingImgTapGesture.touchDown =
    ^void(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event) {
        
        wSelf.step2ImageView.highlighted = YES;
    };
    
    self.settingImgTapGesture.touchUp =
    ^void(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event, BOOL isTouchUpInside) {
        
        wSelf.step2ImageView.highlighted = NO;
        
        if (YES == isTouchUpInside) {
            // 無理やりルートのタブバーを取得
            UITabBarController *tabBarVC =
            (UITabBarController *)[[[UIApplication sharedApplication] delegate]
                                   performSelector:@selector(tabBarController) withObject:nil];
            
            // 設定画面のインデックス
            tabBarVC.selectedIndex = 2;
            
            [SSLUserDefaults setPushCloudSettingImage:YES];
        }
    };
    
    // リスト追加画像
    self.addListImgTapGesture.touchDown =
    ^void(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event) {
        
        wSelf.step3ImageView.highlighted = YES;
    };
    
    self.addListImgTapGesture.touchUp =
    ^void(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event, BOOL isTouchUpInside) {
        
        wSelf.step3ImageView.highlighted = NO;
        
        if (YES == isTouchUpInside) {
            // 無理やりルートのタブバーを取得
            UITabBarController *tabBarVC =
            (UITabBarController *)[[[UIApplication sharedApplication] delegate]
                                   performSelector:@selector(tabBarController) withObject:nil];
            
            // 新しいList作成画面を表示
            UINavigationController *navigationVC = (UINavigationController *)tabBarVC.selectedViewController;
            [navigationVC.topViewController performSegueWithIdentifier:kSegueNewSSPTVC
                                                                sender:nil];        }
    };
    
    
    if (YES == [DescriptionViewController isCompleteSSCA]) {
        
        self.step1CheckImage.image = checkOKImage;
    
    } else {
    
        // 通知センターを必要とする処理は完了している
        NSNotificationCenter * const nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(appWillEnterForeground:) name:kNCenterWillEnterForeground object:nil];
    }
    
    if (YES == [DescriptionViewController isCompleteCloud]) {

        self.step2CheckImage.image = checkOKImage;
    }
}

// アプリが全面に来た
- (void)appWillEnterForeground:(NSNotificationCenter *)center
{
    if (YES == [DescriptionViewController isCompleteSSCA]) {

        self.step1CheckImage.image = checkOKImage;
    }
}

// SSCAのインストールが完了しているか。
+ (BOOL)isCompleteSSCA
{
    
    if (YES == [SSLUserDefaults isPushSSCAInstallButton] &&
        YES == [SSUrlScheme isSSCAInstall]) {
        
        return YES;
    }
    
    return NO;
}

// クラウドへのサインインが完了しているか。
+ (BOOL)isCompleteCloud
{
    
    if (YES == [SSLUserDefaults isPushCloudSettingImage] &&
        (YES == [CloudFacade signedinWithCloudType:SSLCloudTypeDropbox] ||
         YES == [CloudFacade signedinWithCloudType:SSLCloudTypeEvernote])) {
        
        return YES;
    }
    
    return NO;
}


- (void)dealloc
{
    NSNotificationCenter * const nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:kNCenterWillEnterForeground object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ===== IBAction Method =====
// AppStore表示ボタンを押下した
- (IBAction)pushAppStoreButton:(UIButton *)button
{
    
    // pushするとラベルがStoryboardの値に戻るので再度設定する
    [self.showAppStoreButton setTitle:NSLocalizedString(@"DescriptionVC_AppStoreButton_text", @"")
                             forState:UIControlStateNormal];
    
    [CollaborateFacade openAppStoreToSSCA];
    
    [SSLUserDefaults setPushSSCAInstallButton:YES];
}

#pragma mark -
#pragma mark ===== Class Method =====
+ (void)show
{
    
    NSString *storyboardName = @"DescriptionWindow";
    // iPhone 4S / 5,5S の場合は専用のStoryboardを表示する
    if ([TMDeviceInfo is480h] == YES ||
        [TMDeviceInfo is568h] == YES) {
        
        storyboardName = [storyboardName stringByAppendingString:@"4S-5"];
    }
    
    // 現在のWindowsより全面にだすため、少し高い値を設定する
    const UIWindowLevel kIndicatorWindowLevel = UIWindowLevelNormal + 5;
    
    eventTransparentWindow *window = [[eventTransparentWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    window.userInteractionEnabled = NO;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    DescriptionViewController *descriptionVC = [storyboard instantiateInitialViewController];
    window.alpha = 0.0f;
    window.rootViewController = descriptionVC;
    window.backgroundColor = [UIColor clearColor];
    window.windowLevel = kIndicatorWindowLevel;
    
    [window makeKeyAndVisible];
    
    // ウィンドウのオーナーとしてアプリ自身に括りつけとく
    objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_Description, window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [UIView transitionWithView:window
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        
                        window.alpha = 1.0f;
                        
                    } completion:^(BOOL finished) {
                        
                    }];
}

+ (void)close
{
    
    UIWindow *window = objc_getAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_Description);
    
    if (window == nil) {
        return;
    }
    
    [UIView transitionWithView:window
                      duration:0.1f
                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        
                        window.alpha = 0.0f;
                        
                    } completion:^(BOOL finished) {
                        
                        [window.rootViewController.view removeFromSuperview];
                        window.rootViewController = nil;
                        
                        // 上乗せしたウィンドウを破棄
                        objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_Description, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        
                        // メインウィンドウをキーウィンドウにする
                        UIWindow *nextWindow = [[UIApplication sharedApplication].delegate window];
                        [nextWindow makeKeyAndVisible];
                        
                    }];
}

+ (void)closeWithAnimation
{
    
    UIWindow *window = objc_getAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_Description);
    
    if (window == nil) {
        return;
    }
    
    [UIView transitionWithView:window
                      duration:2.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        
                        window.alpha = 0.0f;
                        
                    } completion:^(BOOL finished) {
                        
                        [window.rootViewController.view removeFromSuperview];
                        window.rootViewController = nil;
                        
                        // 上乗せしたウィンドウを破棄
                        objc_setAssociatedObject([UIApplication sharedApplication], &kAssocKey_Window_Description, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                        
                        // メインウィンドウをキーウィンドウにする
                        UIWindow *nextWindow = [[UIApplication sharedApplication].delegate window];
                        [nextWindow makeKeyAndVisible];
                        
                    }];
}

@end
