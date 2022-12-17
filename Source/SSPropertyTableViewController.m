//
//  SSPropertyTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/08/30.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SSPropertyTableViewController.h"
#import "LauncherData.h"
#import "LauncherData+Managing.h"
#import "FileManageFacade.h"
#import "SSLUserDefaults.h"
#import "BaseSSPropDetailTableViewController.h"


/** SegueID */
static NSString * const kUnwindSegueClosePTVC = @"ClosePTVCUnwindSegue";


@interface SSPropertyTableViewController () <UITextFieldDelegate>

// 状態変数
@property (assign, nonatomic) BOOL isEditting;                                  /**< Launcherの編集か */

// Navigation Item
@property (weak, nonatomic) IBOutlet UIBarButtonItem *naviButtonCancel;

// タイトルセクション
@property (weak, nonatomic) IBOutlet UITextField *launcherTitle;

// クラウドセクション
@property (weak, nonatomic) IBOutlet UITableViewCell *cloudCell;
@property (weak, nonatomic) IBOutlet UILabel *cloudUserLable;
@property (weak, nonatomic) IBOutlet UITableViewCell *cloudSaveDirPathCell;
@property (strong, nonatomic) UITextField *cloudSaveDirPathTxtField;

// 公開リンクセクション
@property (weak, nonatomic) IBOutlet UILabel *sharableLinkLabel;
@property (weak, nonatomic) IBOutlet UISwitch *sharableLinkSwitch;


// スキャナセクション
@property (weak, nonatomic) IBOutlet UITableViewCell *scannerNameCell;
@property (assign, nonatomic) BOOL isScannerNameAuto;
@property (weak, nonatomic) IBOutlet UILabel *scannerNameLabel;

// ファイル形式セクション
@property (weak, nonatomic) IBOutlet UILabel *fileFormatLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

// 読み取り設定セクション
@property (weak, nonatomic) IBOutlet UILabel *colorModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanSideLabel;
@property (weak, nonatomic) IBOutlet UISwitch *continueScanSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *blankPageSkipSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *reduceBleedThroughSwitch;
@property (weak, nonatomic) IBOutlet UILabel *paperSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *compressionLabel;

// 読み取り後ファイルセクション
@property (weak, nonatomic) IBOutlet UISwitch *autoDeleteSwitch;

// その他セクション
@property (weak, nonatomic) IBOutlet UISwitch *previewSwitch;

@end

@implementation SSPropertyTableViewController
{
    /** 保存先のテキストフィールドを編集したか。をクラウドタイプごとに保存 */
    NSMutableDictionary *_editedOfSaveTextFiled;

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self->_editedOfSaveTextFiled = [NSMutableDictionary dictionary];
    
    // 新規 or 変更でタイトルなどの変更
    if (self.data != nil) {
        // 編集
        self.isEditting = YES;
        
        self.navigationItem.title   = NSLocalizedString(@"LEditView_Navigation_Title", @"");

        // backBarButtonItemにボタンを設定することで "<" が表示される
        self.naviButtonCancel.title = NSLocalizedString(@"LEditView_Navigation_Title", @"");
        self.navigationItem.backBarButtonItem = self.naviButtonCancel;;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;

        // 画面はじからのスワイプで戻れるようになる
        //        self.navigationController.interactivePopGestureRecognizer.delegate = (id <UIGestureRecognizerDelegate>)self;

    } else {
        // 新規

        UIFont *font = [UIFont boldSystemFontOfSize:17.f];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName: font}
                                                              forState:UIControlStateNormal];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initCells];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 編集の場合はここで保存処理を行う
    if (self.isEditting == YES) {
        
        [self saveData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** セルが選択された */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/** フッターに表示する文字列を動的に変更する */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    const NSUInteger cloudSecton = 1;
    if (section == cloudSecton) {
    
        NSString *title = @"";
        
        switch (self.data.cloudType) {

            case SSLCloudTypeEvernote:
                title = NSLocalizedString(@"LCreateView_Cloud_Section_Evernote_FooterTitle", @"");
                break;
                
            case SSLCloudTypeiCloud:
            case SSLCloudTypeOneDrive:
            case SSLCloudTypeGoogleDrive:
            case SSLCloudTypeDropbox:
            default:
                
                title = NSLocalizedString(@"LCreateView_Cloud_Section_FooterTitle", @"");
                break;
        }
        
        return title;
    }
    
    return [super tableView:tableView titleForFooterInSection:section];
}

#pragma mark -
#pragma mark ===== Private Instance Method =====

/** セルの初期化を行います(必要なセルのみ) */
- (void)initCells
{
    
    if (self.data == nil) {
        // 新規作成の場合、LauncherDataインスタンスを生成する
        self.data = [LauncherData create];
    }
    
    // タイトルセル
    self.launcherTitle.text = self.data.title;
    self.launcherTitle.delegate = self;
    
    // クラウドセル
    self.cloudCell.textLabel.text = [LauncherData cloudTypeText:self.data.cloudType];
    [self.cloudCell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    
    // 公開リンクセル
    UIColor *textColor = nil;
    BOOL enableShareLinkSwitch = YES;
    BOOL isShareLink = NO;
    if (self.data.cloudType == SSLCloudTypeDropbox) {

        textColor   = [UIColor blackColor];
        enableShareLinkSwitch = YES;
        isShareLink = self.data.isShareLink;

    } else {
        // 公開リンクに非対応
        textColor = [UIColor lightGrayColor];
        enableShareLinkSwitch = NO;
        isShareLink = self.data.isShareLink = NO;
        
    }
    
    self.sharableLinkLabel.textColor = textColor;
    self.sharableLinkSwitch.enabled = enableShareLinkSwitch;
    self.sharableLinkSwitch.on = isShareLink;
    
    // ユーザー名取得
    self.cloudUserLable.text = [[self class] cloudUserName:self.data.cloudType];
 
    self.cloudSaveDirPathCell.textLabel.text = [[self class] cloudSaveDirTitle:self.data.cloudType];
    self.cloudSaveDirPathCell.textLabel.minimumScaleFactor = 10.0f/17.0f;
    self.cloudSaveDirPathCell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    // クラウドの保存情報
    CGRect baseframe = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 0, baseframe.size.width / 1.5f, self.cloudSaveDirPathCell.frame.size.height);
    
    self.cloudSaveDirPathTxtField = [[UITextField alloc] initWithFrame:frame];
    self.cloudSaveDirPathTxtField.delegate = self;
    self.cloudSaveDirPathTxtField.tag = 1;

    //=================================================================================
    // 保存先の表示文字列決定
    self.cloudSaveDirPathTxtField.text = self.data.cloudSavePath;
    
    if (NO == self.isEditting) {

        // 最後に入力されたcloudSavePathを使用
        NSString *userDefCloudSavePath =
        [SSLUserDefaults cloudSavePathAtCloudType:[LauncherData cloudTypeText:self.data.cloudType]];
        
        userDefCloudSavePath =
        (userDefCloudSavePath.length <= 0) ? NSLocalizedString(@"LData_Default_CloudSavePath", @"") : userDefCloudSavePath;
        
        self.cloudSaveDirPathTxtField.text = userDefCloudSavePath;
    }
    
    if (0 < [self saveTextFiledText].length) {
//        NSLog(@"[self saveTextFiledText]=%@", [self saveTextFiledText]);
        self.cloudSaveDirPathTxtField.text = [self saveTextFiledText];
    }

    //=================================================================================
    self.cloudSaveDirPathTxtField.textAlignment = NSTextAlignmentRight;
    self.cloudSaveDirPathTxtField.textColor = [UIColor grayColor];
    self.cloudSaveDirPathTxtField.returnKeyType = UIReturnKeyDone;
    self.cloudSaveDirPathTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.cloudSaveDirPathCell.accessoryView = self.cloudSaveDirPathTxtField;

    // スキャナセル
    self.isScannerNameAuto = self.data.isScannerConnectAuto;
    self.scannerNameCell.textLabel.text = NSLocalizedString(@"LCreateView_ScannerName_Title", @"");
    self.scannerNameLabel.text = self.data.scannerName;
    
    // ファイル形式
    self.fileFormatLabel.text = [SSPalameters stringFromSSFileFormat:self.data.fileformat];
    
    // Prefix, Suffixの取得
    NSString *prefix = @"";
    NSString *suffix = @"";
    
    if (self.data.fileNamePrefix != TMFileNamePrefixNone) {
        prefix = [LauncherData displayPrefixText:self.data];
    }

    if (self.data.fileNameSuffix != TMFileNameSuffixNone) {
        suffix = [LauncherData displaySuffixText:self.data];
    }

    NSMutableString *fixFileName = [NSMutableString stringWithString:prefix];
    
    // ファイル名セル
    if (self.data.fileNameFormat == SSFileNameFormatDirect) {
        // 直接指定
        
        if (self.data.fileNameFormatEx == SSFileNameFormatExScanRuntime) {

            // スキャン実行時
            [fixFileName appendString:NSLocalizedString(@"SSParam_FileNameFormat_ExeScanDirect", @"")];

        } else {
            
            // 直接指定なので指定された値を表示する
            [fixFileName appendString:self.data.fileName];
        }

    } else {
        
        // 規定値
        [fixFileName appendString:[SSPalameters stringFromSSFileNameFormat:self.data.fileNameFormat]];
    }
    
    [fixFileName appendString:suffix];
    self.fileNameLabel.text = [NSString stringWithString:fixFileName];

    
    // カラーモードセル
    self.colorModeLabel.text =
    [SSPalameters stringFromSSColorMode:self.data.colorMode];

    // 画質セル
    self.scanModeLabel.text =
    [SSPalameters stringFromSSScanMode:self.data.scanMode];
    
    // 読み取り面セル
    self.scanSideLabel.text =
    [SSPalameters stringFromSSScanningSide:self.data.scanSide];

    // 継続読み取りセル
    self.continueScanSwitch.on =
    (self.data.continueScan == SSContinueScanEnable) ? YES : NO;

    // 白紙削除セル
    self.blankPageSkipSwitch.on =
    (self.data.blankPageSkip == SSBlankPageSkipDel) ? YES : NO;
    
    // 裏写り軽減セル
    self.reduceBleedThroughSwitch.on =
    (self.data.reduceBleed == SSReduceBleedThroughEnable) ? YES : NO;
    
    // 用紙サイズセル
    self.paperSizeLabel.text =
    [SSPalameters stringFromSSPaperSize:self.data.paperSize];
    
    // 圧縮率セル
    self.compressionLabel.text =
    [SSPalameters stringFromSSCompression:self.data.compression];
    
    // 自動的に削除するセル
    self.autoDeleteSwitch.on =
    (self.data.autoDelete == SSAutoDeleteDel) ? YES : NO;

    // プレビュー
    self.previewSwitch.on = self.data.isPreview;

}

/** |data| の内容をファイルに保存します */
- (void)saveData
{
    // 各設定値の保存(別画面へ移動して設定するプロパティについては既に済)
    self.data.title = (self.launcherTitle.text.length <= 0) ?
    NSLocalizedString(@"LData_Default_Title", @"") : self.launcherTitle.text;
    
    self.data.cloudSavePath = self.cloudSaveDirPathTxtField.text;
    self.data.isShareLink = self.sharableLinkSwitch.on;
    self.data.isScannerConnectAuto = self.isScannerNameAuto;
    self.data.scannerName = self.scannerNameLabel.text;
    self.data.fileNameDisplay = self.fileNameLabel.text;

    self.data.continueScan = (self.continueScanSwitch.on == YES) ?
    SSContinueScanEnable : SSContinueScanDisable;
    
    self.data.blankPageSkip = (self.blankPageSkipSwitch.on == YES) ?
    SSBlankPageSkipDel : SSBlankPageSkipNoDel;
    
    self.data.reduceBleed = (self.reduceBleedThroughSwitch.on == YES) ?
    SSReduceBleedThroughEnable : SSReduceBleedThroughDisable;
    
    self.data.autoDelete = (self.autoDeleteSwitch.on == YES) ?
    SSAutoDeleteDel : SSAutoDeleteNoDel;
    
    self.data.isPreview = self.previewSwitch.on;
    
    [SSLUserDefaults setCloudSavePath:self.data.cloudSavePath
                          AtCloudType:[LauncherData cloudTypeText:self.data.cloudType]];
    
    BOOL ret = NO;
    // |self.data|をファイルに保存
    if (self.isEditting == NO) {
        
        ret = [FileManageFacade saveNewLauncherData:self.data];
    } else {
        ret = [FileManageFacade saveOverwriteLauncherData:self.data];
    }
    
    if (ret == NO) {
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Err_App_Title_Internal", @"")
                                   message:NSLocalizedString(@"Err_App_Body_Internal", @"")
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:NSLocalizedString(@"Common_Alert_Button_OK", @""), nil];
        
        [alert show];
    }
    
    // 初期説明画面を2度と表示させない
    [SSLUserDefaults setDescriptionViewShow:NO];

//    NSLog(@"[saveNewLauncherData:] ret=%d", ret);
}

/** テキストフィールドの値を |data| に保持させる */
- (void)textFieldTmpSave
{
    // テキストの値を一時保存する
    self.data.title = self.launcherTitle.text;
    self.data.cloudSavePath = self.cloudSaveDirPathTxtField.text;
}

/** スイッチの値を |data| に保持させる */
- (void)switchTmpSave
{
    self.data.isShareLink = self.sharableLinkSwitch.on;
    
    self.data.continueScan = (self.continueScanSwitch.on == YES) ?
    SSContinueScanEnable : SSContinueScanDisable;

    self.data.blankPageSkip = (self.blankPageSkipSwitch.on == YES) ?
    SSBlankPageSkipDel : SSBlankPageSkipNoDel;
    
    self.data.reduceBleed = (self.reduceBleedThroughSwitch.on == YES) ?
    SSReduceBleedThroughEnable : SSReduceBleedThroughDisable;
    
    self.data.autoDelete = (self.autoDeleteSwitch.on == YES) ?
    SSAutoDeleteDel : SSAutoDeleteNoDel;
    
    self.data.isPreview = self.previewSwitch.on;
}

// 画面遷移のため、データを仮保存する
- (void)tmpSaved
{
    [self textFieldTmpSave];
    [self switchTmpSave];
}


// 保存先テキストフィールドの値を保存
- (void)setSaveTextFiledText
{
    [self->_editedOfSaveTextFiled setObject:self.cloudSaveDirPathTxtField.text forKey:@(self.data.cloudType).stringValue];
}

- (NSString *)saveTextFiledText
{
    return [self->_editedOfSaveTextFiled objectForKey:@(self.data.cloudType).stringValue];
}


#pragma mark -
#pragma mark ===== Private Class Method =====

/** クラウドのユーザ名を取得する */
+ (NSString *)cloudUserName:(SSLCloudType)type
{
    NSString *typeString = [SSLUserDefaults dropboxUserName];
    
    switch (type) {
            
        case SSLCloudTypeEvernote:
            typeString = [SSLUserDefaults evernoteUserName];
            break;
            
        case SSLCloudTypeiCloud:
            typeString = NSLocalizedString(@"Common_Cloud_iCloud", @"");
            break;
            
        case SSLCloudTypeOneDrive:
            typeString = NSLocalizedString(@"Common_Cloud_OneDrive", @"");
            break;
            
        case SSLCloudTypeGoogleDrive:
            typeString = NSLocalizedString(@"Common_Cloud_GoogleDrive", @"");
            break;
            
        default:
        case SSLCloudTypeDropbox:
            
            typeString = [SSLUserDefaults dropboxUserName];
            break;
    }
    
    return typeString;
}

/** 各クラウドに合わせた"保存先名"を取得する */
+ (NSString *)cloudSaveDirTitle:(SSLCloudType)type
{
    NSString *typeString = [SSLUserDefaults dropboxUserName];
    
    switch (type) {
            
        case SSLCloudTypeEvernote:
            typeString = NSLocalizedString(@"LCreateView_CloudSaveDir_Evernote_Title", @"");
            break;
            
        case SSLCloudTypeiCloud:
            typeString = NSLocalizedString(@"LCreateView_CloudSaveDir_Title", @"");
            break;
            
        case SSLCloudTypeOneDrive:
            typeString = NSLocalizedString(@"LCreateView_CloudSaveDir_Title", @"");
            break;
            
        case SSLCloudTypeGoogleDrive:
            typeString = NSLocalizedString(@"LCreateView_CloudSaveDir_Title", @"");
            break;
            
        default:
        case SSLCloudTypeDropbox:
            
            typeString = NSLocalizedString(@"LCreateView_CloudSaveDir_Title", @"");
            break;
    }
    
    return typeString;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:kUnwindSegueClosePTVC] == YES) {
        return;
    }
    
    BaseSSPropDetailTableViewController *bsspdTVC =
    (BaseSSPropDetailTableViewController *)[segue destinationViewController];
    
    if ([bsspdTVC isKindOfClass:[BaseSSPropDetailTableViewController class]] == NO) {
        // ココで落ちて気づかないことが多いのでログを出力する
        NSLog(@"**********");
        NSLog(@"destinationViewController is not BaseSSPropDetailTableViewController Kind class");
        NSLog(@"**********");
    }
    
    // テキストの値を一時保存する
    [self tmpSaved];
    
    bsspdTVC.data = self.data;
}

#pragma mark -
#pragma mark ===== UITextFieldDelegate =====
/** テキストフィールド、完了ボタン押下時の動作 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
 
    // テキストの値を一時保存する
    [self textFieldTmpSave];
    
    [self setSaveTextFiledText];

    // キーボード閉じる
    [textField resignFirstResponder];
    return YES;
}

/** テキストフィールド編集開始 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}


#pragma mark -
#pragma mark ===== Action Method =====
- (IBAction)pushDone:(id)sender
{
    
    [self saveData];
    
    // 画面を閉じる
    [self performSegueWithIdentifier:kUnwindSegueClosePTVC sender:self];
}

#pragma mark -
#pragma mark ===== Segue =====
/*
- (BOOL)canPerformUnwindSegueAction:(SEL)action
                fromViewController:(UIViewController *)fromViewController
                        withSender:(id)sender
{
 
    NSLog(@"Property view");
    NSLog(@"fromViewController = %@", NSStringFromClass([fromViewController class]));
    
    return NO;
}
*/

@end
