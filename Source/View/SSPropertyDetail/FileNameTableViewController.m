//
//  FileNameTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/15.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "FileNameTableViewController.h"
#import "LauncherData.h"
#import "LauncherData+Managing.h"

/** セクションやセルを表す定数 */
static const int kFileNameTypeSection   = 0;
static const int kDirectFileNameSection = 1;
static const int kPrefixSuffixSection   = 2;
static const int kDirectInputCellNum    = 4;

/** キーボード表示用のオフセットY */
static const int kShowKeyboardOffsetY   = 150;
/** キーボード表示用の固定高さ */
static const int kKeyboardHeight        = 300;


@interface FileNameTableViewController () <UITextFieldDelegate>

@property (assign, nonatomic) CGSize orgContentSize;

@property (weak, nonatomic) IBOutlet UITextField *fileNameTextFiled;

@property (weak, nonatomic) IBOutlet UILabel *prefixDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *suffixDetailLabel;

@end

@implementation FileNameTableViewController

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
    
    // テキストフィールド初期化
    self.fileNameTextFiled.delegate = self;
    self.fileNameTextFiled.returnKeyType = UIReturnKeyDone;
    self.fileNameTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

-(void)viewWillAppear:(BOOL)animated
{
 
    NSInteger row = [[self class] indexFromSSFileNameFormat:self.data.fileNameFormat
                                         SSFileNameFormatEx:self.data.fileNameFormatEx];
    
    BOOL isDirectInputEnable = NO;
    if (row == kDirectInputCellNum) {
        
        isDirectInputEnable = YES;
    }
    
    // 直接入力の状態指定
    [self enableDirectFileNameSection:isDirectInputEnable];
    
    // prefix, suffix を更新する
    [self updatePrefixAndSuffix];
}

-(void)viewWillDisappear:(BOOL)animated
{
    // データの反映
    self.data.fileName = self.fileNameTextFiled.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** セルが表示される直前に呼び出される */
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{

    // セルに初期値のチェックマークを設定
    NSInteger targetRow = [[self class] indexFromSSFileNameFormat:self.data.fileNameFormat
                                               SSFileNameFormatEx:self.data.fileNameFormatEx];
    
    if (indexPath.section == kFileNameTypeSection &&
        indexPath.row     == targetRow) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        return;
    }
    
    if (indexPath.section == kDirectFileNameSection) {
        
        if (indexPath.row == 0) {
            
            NSString *fileName = NSLocalizedString(@"LData_Default_FileName", @"");
            
            // 直接入力の場合のみ、保存されたデータを使用する
            if (targetRow == kDirectInputCellNum) {
                
                fileName = self.data.fileName;
            }
        
            self.fileNameTextFiled.text = fileName;
        }
    }
}

/** セルが指定された */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == kDirectFileNameSection ||
        indexPath.section == kPrefixSuffixSection) {
        return;
    }
    
    // 一旦すべてのセルからチェックマークをすべてはずす
    for (NSInteger i = 0; i < [tableView numberOfRowsInSection:kFileNameTypeSection]; ++i)
    {
        UITableViewCell *tmpCell =
            [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kFileNameTypeSection]];
        
        tmpCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // 選択されたセルチェックマークを指定する
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    BOOL isDirectInputEnable = NO;
    if (indexPath.row == kDirectInputCellNum) {
        
        isDirectInputEnable = YES;
    }

    // 直接入力の状態指定
    [self enableDirectFileNameSection:isDirectInputEnable];
    
    // データの反映
    self.data.fileNameFormat   = [[self class] SSFileNameFormatFromIndex:indexPath.row];
    self.data.fileNameFormatEx = [[self class] SSFileNameFormatExFromIndex:indexPath.row];
}

/** 直接入力についてのグループの状態を変更します */
- (void)enableDirectFileNameSection:(BOOL)enabled
{
    // 一旦すべてのセルからチェックマークをすべてはずす
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:kDirectFileNameSection]; ++i)
    {
        UITableViewCell *tmpCell =
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kDirectFileNameSection]];
    
        tmpCell.userInteractionEnabled = enabled;
    }

    UIColor *textColor = [UIColor lightGrayColor];
    if (enabled == YES) {
        
        textColor = [UIColor blackColor];
    }
    
    self.fileNameTextFiled.textColor = textColor;
    self.fileNameTextFiled.enabled = enabled;
}

/** Prefix, Suffix の状態が更新する */
- (void)updatePrefixAndSuffix
{
    self.prefixDetailLabel.text = [LauncherData displayPrefixText:self.data];
    self.suffixDetailLabel.text = [LauncherData displaySuffixText:self.data];
}

#pragma mark -
#pragma mark ===== UITextFieldDelegate =====
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボード閉じる
    [textField resignFirstResponder];
    
    // ファイル名フィールドが空の場合、既定のファイル名とする
    if ([textField.text length] <= 0) {
        
        textField.text = NSLocalizedString(@"LData_Default_FileName", @"");
    }
    
    // 入力フィールド遷移アニメーション
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.tableView.contentSize = self.orgContentSize;
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
    return YES;
}

/** テキストフィールド編集開始 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    self.orgContentSize = self.tableView.contentSize;
    
    // 入力フィールド遷移アニメーション
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + kKeyboardHeight);
                         self.tableView.contentOffset = CGPointMake(0, kShowKeyboardOffsetY);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    
}

#pragma mark -
#pragma mark ===== Private Class Method =====
/** ファイル名フォーマットとのマッピング関数 */
+ (NSUInteger)indexFromSSFileNameFormat:(SSFileNameFormat)val
                     SSFileNameFormatEx:(SSFileNameFormatEx)exVal

{
 
    NSUInteger index = 1;
    
    switch (val) {
        case SSFileNameFormatDirect:            index = kDirectInputCellNum;  break;
        case SSFileNameFormatJP:                index = 0;                    return index;
        case SSFileNameFormatNoSeparator:       index = 1;                    return index;
        case SSFileNameFormatSeparatorHyphen:   index = 2;                    return index;
        default:                                                              return index;
    }
    
    // |SSFileNameFormatDirect| かつ、独自定義にヒットする場合はindexを置き換え
    switch (exVal) {
        case SSFileNameFormatExScanRuntime:
            index = 3;
            break;
            
        default:
            break;
    }
    
    return index;
}

+ (SSFileNameFormat)SSFileNameFormatFromIndex:(NSUInteger)index
{
    
    SSFileNameFormat retValue = SSFileNameFormatNoSeparator;
    
    switch (index) {
        case 0:
            retValue = SSFileNameFormatJP;
            break;
            
        case 1:
            retValue = SSFileNameFormatNoSeparator;
            break;
            
        case 2:
            retValue = SSFileNameFormatSeparatorHyphen;
            break;
            
        case 3:
        case kDirectInputCellNum:
            retValue = SSFileNameFormatDirect;
            break;

        default:
            break;
    }
    
    return retValue;
}

+ (SSFileNameFormatEx)SSFileNameFormatExFromIndex:(NSUInteger)index
{
    
    SSFileNameFormatEx retValue = 0;
    
    switch (index) {
        case 3:
            retValue = SSFileNameFormatExScanRuntime;
            break;
            
        default:
            break;
    }
    
    return retValue;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Prefix, suffixの編集
    BaseSSPropDetailTableViewController *bsspdTVC =
    (BaseSSPropDetailTableViewController *)[segue destinationViewController];
    
    bsspdTVC.data = self.data;
}

@end
