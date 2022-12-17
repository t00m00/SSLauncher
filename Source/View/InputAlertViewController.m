//
//  InputAlertViewController.m
//  SSLauncher
//
//  Created by toomoo on 2015/03/09.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "InputAlertViewController.h"
#import "TapUpDownGestureRecognizer.h"

#import <objc/runtime.h>

static const char kAssocKey_Window;

@interface InputAlertViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

// 受け渡し用変数
@property (copy, nonatomic) NSString *msgTitle;
@property (copy, nonatomic) NSString *buttonLable;
@property (copy, nonatomic) NSString *placeHolder;
@property (copy, nonatomic) NSString *fileName;

@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *scanButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;    /** baseViewの下部の制約 */
@property (weak, nonatomic) IBOutlet TapUpDownGestureRecognizer *scanTapGesture;

/** アラート応答後に表示するブロック */
@property (copy, nonatomic) void (^clickedBlock)(NSInteger buttonIndex, NSString *fileName);

@end

@implementation InputAlertViewController

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

    self.fileNameTextField.delegate = self;
    self.fileNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.fileNameTextField.placeholder = self.placeHolder;
    self.fileNameTextField.text = self.fileName;
    self.fileNameTextField.returnKeyType = UIReturnKeyDone;
    
    // 枠線
    self.fileNameTextField.layer.borderWidth = 1.f;
    self.fileNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    // タイトル
    self.msgLabel.text = self.msgTitle;
    self.scanButton.text = self.buttonLable;
    
    void (^roundCorner)(UIView*) = ^void(UIView *v) {
        CALayer *layer = v.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 6.0f;
    };
    
    roundCorner(self.alertView);
    
    
    //================================================================================
    // ハイライト動作設定
    //================================================================================
    __weak InputAlertViewController *wSelf = self;
    
    // スキャン開始ボタン
    self.scanTapGesture.touchDown =
    ^void(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event) {
        
        wSelf.scanButton.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    };
    
    self.scanTapGesture.touchUp =
    ^void(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event, BOOL isTouchUpInside) {
        
        wSelf.scanButton.backgroundColor = [UIColor clearColor];
        
        if (YES == isTouchUpInside) {
            // スキャン開始
            wSelf.clickedBlock(wSelf.scanButton.tag, wSelf.fileNameTextField.text);

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[self class] close];
            });
        }
    };
    
    // キーボード監視
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // テキスト編集開始
    [self.fileNameTextField becomeFirstResponder];
}

- (void)dealloc
{
    // キーボード閉じる
    [self.fileNameTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ===== Instance Method =====
/**  */
- (void)keyboardWillShow:(NSNotification *)note
{
    
    // キーボードの表示完了時の高さでビューの高さを変える（制約を変更）
    CGRect keyboardFrame = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomLayoutConstraint.constant = keyboardFrame.size.height;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.baseView layoutIfNeeded];
    });
    
}


#pragma mark -
#pragma mark ===== IBAction Method =====
/** アラートの背景をタップされた */
- (IBAction)cancelTapped:(UITapGestureRecognizer *)tapGesture
{    
    // キャンセル
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self class] close];
    });
}


#pragma mark -
#pragma mark ===== UITextFieldDelegate =====
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    // スキャン開始
    self.clickedBlock(self.scanButton.tag, self.fileNameTextField.text);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self class] close];
    });
    
    return YES;
}

/** テキストフィールド編集開始 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    
}

#pragma mark -
#pragma mark ===== UIGestureRecognizerDelegate =====
/** ジェスチャーを発生させるかどうか */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer.view == touch.view) {
        // UIGestureRecognizer を設定したviewにしか反応させない
        return YES;
    }
    
    return NO;
}


#pragma mark -
#pragma mark ===== Class Method =====
+ (void)showWithAlertTiltle:(NSString *)title
                placeholder:(NSString *)placeholder
            defaultfileName:(NSString *)fileName
                    clicked:(void(^)(NSInteger buttonIndex, NSString *fileName))clickedBlock;
{
    [[self class] showWithAlertTiltle:title
                          placeholder:placeholder
                      defaultfileName:fileName
                          buttonLabel:NSLocalizedString(@"Common_Alert_Button_ScanStart", @"")
                              clicked:clickedBlock];
}

+ (void)showWithAlertTiltle:(NSString *)title
                placeholder:(NSString *)placeholder
            defaultfileName:(NSString *)fileName
                buttonLabel:(NSString *)buttonLabel
                    clicked:(void(^)(NSInteger buttonIndex, NSString *fileName))clickedBlock;
{
    
    // AlertViewと同等レベルにだすため、高い値を設定する
    const UIWindowLevel kIndicatorWindowLevel = UIWindowLevelStatusBar + 5;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.alpha = 0.0f;
    window.transform = CGAffineTransformMakeScale(1.1, 1.1);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InputAlertViewWindow" bundle:nil];
    InputAlertViewController *indicatorVC = [storyboard instantiateInitialViewController];
    indicatorVC.msgTitle = title;
    indicatorVC.buttonLable = buttonLabel;
    indicatorVC.placeHolder = placeholder;
    indicatorVC.fileName = fileName;
    indicatorVC.clickedBlock = clickedBlock;
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
