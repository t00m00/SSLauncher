//
//  FileNameSuffixTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/10/10.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "FileNameSuffixTableViewController.h"
#import "LauncherData.h"

/** セクションやセルを表す定数 */
static const int kSuffixTypeSection     = 0;
static const int kDirectSuffixSection   = 1;
static const int kDelimiterSection      = 2;

static const int kDirectInputCellNum    = 6;

/** キーボード表示用のオフセットY */
static const int kShowKeyboardOffsetY   = 220;
/** キーボード表示用の固定高さ */
static const int kKeyboardHeight        = 300;

@interface FileNameSuffixTableViewController () <UITextFieldDelegate>

@property (assign, nonatomic) CGSize orgContentSize;

@property (weak, nonatomic) IBOutlet UILabel *labelyyyyMMdd;
@property (weak, nonatomic) IBOutlet UILabel *labelyyyyMM;
@property (weak, nonatomic) IBOutlet UILabel *yyyy;
@property (weak, nonatomic) IBOutlet UILabel *labelMM;
@property (weak, nonatomic) IBOutlet UILabel *labelMMdd;

@property (weak, nonatomic) IBOutlet UITextField *suffixTextField;

@end

@implementation FileNameSuffixTableViewController

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
    self.suffixTextField.delegate = self;
    self.suffixTextField.returnKeyType = UIReturnKeyDone;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSInteger row = [[self class] indexFromTMFileNameSuffix:self.data.fileNameSuffix];
    
    BOOL isDirectInputEnable = NO;
    if (row == kDirectInputCellNum) {
        
        isDirectInputEnable = YES;
    }
    
    // 直接入力の状態指定
    [self enableDirectFileNameSection:isDirectInputEnable];
    
    // 区切り文字の状態指定
    [self enableSuffixDelimiterSection:(isDirectInputEnable != YES)];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    // データの反映
    self.data.fileNameSuffixText = self.suffixTextField.text;
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
    
    if (indexPath.section == kSuffixTypeSection) {
        // Suffix
        // セルに初期値のチェックマークを設定
        NSInteger targetRow = [[self class] indexFromTMFileNameSuffix:self.data.fileNameSuffix];
        
        if (indexPath.row == targetRow) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else if (indexPath.section == kDelimiterSection) {
        // 区切り文字
        // セルに初期値のチェックマークを設定
        NSInteger targetRow =
        [[self class] indexFromTMDelimiterType:self.data.fileNameSuffixDelimiter];
        
        if (indexPath.row == targetRow) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self updateSuffixDelimiterFromIndex:targetRow];
        }
        
        NSInteger fileNamesuffixRow = [[self class] indexFromTMFileNameSuffix:self.data.fileNameSuffix];
        [self enableSuffixDelimiter:cell enabled:fileNamesuffixRow != kDirectInputCellNum];
        
        return;
        
    } else if (indexPath.section == kDirectSuffixSection) {
        
        // 直接入力
        if (indexPath.row == 0) {
            
            NSInteger targetRow = [[self class] indexFromTMFileNameSuffix:self.data.fileNameSuffix];
            
            NSString *suffix = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_DirectInput", @"");
            
            // 直接入力の場合のみ、保存されたデータを使用する
            if (targetRow == kDirectInputCellNum) {
                
                suffix = self.data.fileNameSuffixText;
            }
            
            self.suffixTextField.text = suffix;
        }
    }
}

/** セルが指定された */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == kDirectSuffixSection) {
        return;
    }
    
    // 一旦すべてのセルからチェックマークをすべてはずす
    for (NSInteger i = 0; i < [tableView numberOfRowsInSection:indexPath.section]; ++i)
    {
        UITableViewCell *tmpCell =
        [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i
                                                            inSection:indexPath.section]];
        
        tmpCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // 選択されたセルチェックマークを指定する
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    switch (indexPath.section) {
        case kSuffixTypeSection:
            
            // データの反映
            self.data.fileNameSuffix = [[self class] TMFileNameSuffixFromIndex:indexPath.row];
            
            BOOL isDirectInputEnable = NO;
            if (indexPath.row == kDirectInputCellNum) {
                
                isDirectInputEnable = YES;
            }
            
            // 直接入力の状態指定
            [self enableDirectFileNameSection:isDirectInputEnable];
            
            // 区切り文字の状態指定
            [self enableSuffixDelimiterSection:(isDirectInputEnable != YES)];
            
            break;
            
        case kDelimiterSection:
            
            // データの反映
            self.data.fileNameSuffixDelimiter =
            [[self class] TMDelimiterTypeFromIndex:indexPath.row];
            
            [self updateSuffixDelimiterFromIndex:indexPath.row];
            
            break;
            
        default:
            break;
    }
}

/** 直接入力についてのグループの状態を変更します */
- (void)enableDirectFileNameSection:(BOOL)enabled
{
    // 一旦すべてのセルからチェックマークをすべてはずす
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:kDirectSuffixSection]; ++i)
    {
        UITableViewCell *tmpCell =
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kDirectSuffixSection]];
        
        tmpCell.userInteractionEnabled = enabled;
    }
    
    UIColor *textColor = [UIColor lightGrayColor];
    if (enabled == YES) {
        
        textColor = [UIColor blackColor];
    }
    
    self.suffixTextField.textColor = textColor;
    self.suffixTextField.enabled   = enabled;
}

/** 区切り文字のセクション状態を更新する */
- (void)enableSuffixDelimiterSection:(BOOL)enabled
{
    UIColor *textColor = [UIColor lightGrayColor];
    if (enabled == YES) {
        
        textColor = [UIColor blackColor];
    }
    
    // すべてのセルを操作無効にする
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:kDelimiterSection]; ++i)
    {
        UITableViewCell *tmpCell =
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kDelimiterSection]];
        
        tmpCell.userInteractionEnabled = enabled;
        tmpCell.textLabel.textColor = textColor;
    }
}

/** 区切り文字のセクション状態を更新する */
- (void)enableSuffixDelimiter:(UITableViewCell *)cell enabled:(BOOL)enabled
{
    UIColor *textColor = [UIColor lightGrayColor];
    if (enabled == YES) {
        
        textColor = [UIColor blackColor];
    }
    
    cell.userInteractionEnabled = enabled;
    cell.textLabel.textColor = textColor;
}


/** 区切り文字を更新する */
- (void)updateSuffixDelimiterFromIndex:(NSUInteger)index
{
    NSString * const delimiter =
    [SSPalameters stringFromTMDelimiterType:[[super class] TMDelimiterTypeFromIndex:index]];
    
    self.labelyyyyMMdd.text =
    [delimiter stringByAppendingString:[SSPalameters stringFromTMFileNameSuffix:TMFileNameSuffixyyyyMMdd]];
    self.labelyyyyMM.text =
    [delimiter stringByAppendingString:[SSPalameters stringFromTMFileNameSuffix:TMFileNameSuffixyyyyMM]];
    self.yyyy.text =
    [delimiter stringByAppendingString:[SSPalameters stringFromTMFileNameSuffix:TMFileNameSuffixyyyy]];
    self.labelMM.text =
    [delimiter stringByAppendingString:[SSPalameters stringFromTMFileNameSuffix:TMFileNameSuffixMM]];
    self.labelMMdd.text =
    [delimiter stringByAppendingString:[SSPalameters stringFromTMFileNameSuffix:TMFileNameSuffixMMdd]];
}

#pragma mark -
#pragma mark ===== UITextFieldDelegate =====
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボード閉じる
    [textField resignFirstResponder];
    
    // ファイル名フィールドが空の場合、既定のファイル名とする
    if ([textField.text length] <= 0) {
        
        textField.text = NSLocalizedString(@"SSParam_Ex_FileName_Suffix_DirectInput", @"");
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
/** Suffixフォーマットとのマッピング関数 */
+ (NSUInteger)indexFromTMFileNameSuffix:(TMFileNameSuffix)val
{
    
    NSUInteger index = 0;
    
    switch (val) {
        case TMFileNameSuffixNone:          index = 0;  return index;
        case TMFileNameSuffixyyyyMMdd:      index = 1;  return index;
        case TMFileNameSuffixyyyyMM:        index = 2;  return index;
        case TMFileNameSuffixyyyy:          index = 3;  return index;
        case TMFileNameSuffixMM:            index = 4;  return index;
        case TMFileNameSuffixMMdd:          index = 5;  return index;
        case TMFileNameSuffixDirectInput:   index = 6;  return index;
        default:                                        return index;
    }
    
    return index;
}

/** 区切り文字フォーマットとのマッピング関数 */
+ (NSUInteger)indexFromTMDelimiterType:(TMDelimiterType)val
{
    
    NSUInteger index = 0;
    
    switch (val) {
        case TMDelimiterTypeUnderScore:     index = 0;  return index;
        case TMDelimiterTypeHyphen:         index = 1;  return index;
        case TMDelimiterTypeNone:           index = 2;  return index;
        default:                                        return index;
    }
    
    return index;
}

+ (TMFileNameSuffix)TMFileNameSuffixFromIndex:(NSUInteger)index
{
    
    TMFileNameSuffix retValue = TMFileNameSuffixNone;
    
    switch (index) {
        case 0:
            retValue = TMFileNameSuffixNone;
            break;
            
        case 1:
            retValue = TMFileNameSuffixyyyyMMdd;
            break;
            
        case 2:
            retValue = TMFileNameSuffixyyyyMM;
            break;
            
        case 3:
            retValue = TMFileNameSuffixyyyy;
            break;
            
        case 4:
            retValue = TMFileNameSuffixMM;
            break;
            
        case 5:
            retValue = TMFileNameSuffixyyyyMMdd;
            break;
            
        case 6:
            retValue = TMFileNameSuffixDirectInput;
            break;
            
        default:
            break;
    }
    
    return retValue;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
