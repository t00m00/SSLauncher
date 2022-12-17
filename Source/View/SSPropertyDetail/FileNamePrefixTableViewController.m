//
//  FileNamePrefixTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/10/10.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "FileNamePrefixTableViewController.h"
#import "LauncherData.h"

/** セクションやセルを表す定数 */
static const int kPrefixTypeSection     = 0;
static const int kDirectPrefixSection   = 1;
static const int kDelimiterSection      = 2;

static const int kDirectInputCellNum    = 6;

/** キーボード表示用のオフセットY */
static const int kShowKeyboardOffsetY   = 200;
/** キーボード表示用の固定高さ */
static const int kKeyboardHeight        = 300;


@interface FileNamePrefixTableViewController () <UITextFieldDelegate>

@property (assign, nonatomic) CGSize orgContentSize;

@property (weak, nonatomic) IBOutlet UILabel *labelyyyyMMdd;
@property (weak, nonatomic) IBOutlet UILabel *labelyyyyMM;
@property (weak, nonatomic) IBOutlet UILabel *yyyy;
@property (weak, nonatomic) IBOutlet UILabel *labelMM;
@property (weak, nonatomic) IBOutlet UILabel *labelMMdd;

@property (weak, nonatomic) IBOutlet UITextField *prefixTextField;

@end

@implementation FileNamePrefixTableViewController

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
    self.prefixTextField.delegate = self;
    self.prefixTextField.returnKeyType = UIReturnKeyDone;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSInteger row = [[self class] indexFromTMFileNamePrefix:self.data.fileNamePrefix];
    
    BOOL isDirectInputEnable = NO;
    if (row == kDirectInputCellNum) {
        
        isDirectInputEnable = YES;
    }
    
    // 直接入力の状態指定
    [self enableDirectFileNameSection:isDirectInputEnable];
    
    // 区切り文字の状態指定
    [self enablePrefixDelimiterSection:(isDirectInputEnable != YES)];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    // データの反映
    self.data.fileNamePrefixText = self.prefixTextField.text;
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
    
    if (indexPath.section == kPrefixTypeSection) {
        // Prefix
        // セルに初期値のチェックマークを設定
        NSInteger targetRow = [[self class] indexFromTMFileNamePrefix:self.data.fileNamePrefix];
        
        if (indexPath.row == targetRow) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    } else if (indexPath.section == kDelimiterSection) {
        // 区切り文字
        // セルに初期値のチェックマークを設定
        NSInteger targetRow =
            [[self class] indexFromTMDelimiterType:self.data.fileNamePrefixDelimiter];
        
        if (indexPath.row == targetRow) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self updatePrefixDelimiterFromIndex:targetRow];
        }

        NSInteger fileNamePrefixRow = [[self class] indexFromTMFileNamePrefix:self.data.fileNamePrefix];
        [self enablePrefixDelimiter:cell enabled:fileNamePrefixRow != kDirectInputCellNum];
        
        return;
        
    } else if (indexPath.section == kDirectPrefixSection) {
        
        // 直接入力
        if (indexPath.row == 0) {
            
            NSInteger targetRow = [[self class] indexFromTMFileNamePrefix:self.data.fileNamePrefix];

            NSString *prefix = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_DirectInput", @"");
            
            // 直接入力の場合のみ、保存されたデータを使用する
            if (targetRow == kDirectInputCellNum) {
                
                prefix = self.data.fileNamePrefixText;
            }
            
            self.prefixTextField.text = prefix;
        }
    }
}

/** セルが指定された */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == kDirectPrefixSection) {
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
        case kPrefixTypeSection:

            // データの反映
            self.data.fileNamePrefix = [[self class] TMFileNamePrefixFromIndex:indexPath.row];
            
            BOOL isDirectInputEnable = NO;
            if (indexPath.row == kDirectInputCellNum) {
                
                isDirectInputEnable = YES;
            }
            
            // 直接入力の状態指定
            [self enableDirectFileNameSection:isDirectInputEnable];

            // 区切り文字の状態指定
            [self enablePrefixDelimiterSection:(isDirectInputEnable != YES)];
            
            break;

        case kDelimiterSection:

            // データの反映
            self.data.fileNamePrefixDelimiter =
                [[self class] TMDelimiterTypeFromIndex:indexPath.row];
            
            [self updatePrefixDelimiterFromIndex:indexPath.row];
    
            break;
            
        default:
            break;
    }
}

/** 直接入力についてのグループの状態を変更します */
- (void)enableDirectFileNameSection:(BOOL)enabled
{
    // すべてのセルを操作無効にする
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:kDirectPrefixSection]; ++i)
    {
        UITableViewCell *tmpCell =
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kDirectPrefixSection]];
        
        tmpCell.userInteractionEnabled = enabled;
    }
    
    UIColor *textColor = [UIColor lightGrayColor];
    if (enabled == YES) {
        
        textColor = [UIColor blackColor];
    }
    
    self.prefixTextField.textColor = textColor;
    self.prefixTextField.enabled   = enabled;
}

/** 区切り文字のセクション状態を更新する */
- (void)enablePrefixDelimiterSection:(BOOL)enabled
{
    UIColor *textColor = [UIColor lightGrayColor];
    if (enabled == YES) {
        
        textColor = [UIColor blackColor];
    }
    
    // セクション内のすべてのセルについて更新する
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:kDelimiterSection]; ++i)
    {
        UITableViewCell *tmpCell =
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kDelimiterSection]];
        
        tmpCell.userInteractionEnabled = enabled;
        tmpCell.textLabel.textColor = textColor;
    }
}

/** 区切り文字のセクション状態を更新する */
- (void)enablePrefixDelimiter:(UITableViewCell *)cell enabled:(BOOL)enabled
{
    UIColor *textColor = [UIColor lightGrayColor];
    if (enabled == YES) {
        
        textColor = [UIColor blackColor];
    }
    
    cell.userInteractionEnabled = enabled;
    cell.textLabel.textColor = textColor;
}


/** 区切り文字を更新する */
- (void)updatePrefixDelimiterFromIndex:(NSUInteger)index
{
    NSString * const delimiter =
        [SSPalameters stringFromTMDelimiterType:[[self class] TMDelimiterTypeFromIndex:index]];
    
    self.labelyyyyMMdd.text =
        [[SSPalameters stringFromTMFileNamePrefix:TMFileNamePrefixyyyyMMdd]
         stringByAppendingString:delimiter];
    self.labelyyyyMM.text =
        [[SSPalameters stringFromTMFileNamePrefix:TMFileNamePrefixyyyyMM]
         stringByAppendingString:delimiter];
    self.yyyy.text =
        [[SSPalameters stringFromTMFileNamePrefix:TMFileNamePrefixyyyy]
         stringByAppendingString:delimiter];
    self.labelMM.text =
        [[SSPalameters stringFromTMFileNamePrefix:TMFileNamePrefixMM]
         stringByAppendingString:delimiter];
    self.labelMMdd.text =
        [[SSPalameters stringFromTMFileNamePrefix:TMFileNamePrefixMMdd]
         stringByAppendingString:delimiter];
}

#pragma mark -
#pragma mark ===== UITextFieldDelegate =====
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボード閉じる
    [textField resignFirstResponder];
    
    // ファイル名フィールドが空の場合、既定のファイル名とする
    if ([textField.text length] <= 0) {
        
        textField.text = NSLocalizedString(@"SSParam_Ex_FileName_Prefix_DirectInput", @"");
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
/** Prefixフォーマットとのマッピング関数 */
+ (NSUInteger)indexFromTMFileNamePrefix:(TMFileNamePrefix)val
{
    
    NSUInteger index = 0;
    
    switch (val) {
        case TMFileNamePrefixNone:          index = 0;  return index;
        case TMFileNamePrefixyyyyMMdd:      index = 1;  return index;
        case TMFileNamePrefixyyyyMM:        index = 2;  return index;
        case TMFileNamePrefixyyyy:          index = 3;  return index;
        case TMFileNamePrefixMM:            index = 4;  return index;
        case TMFileNamePrefixMMdd:          index = 5;  return index;
        case TMFileNamePrefixDirectInput:   index = 6;  return index;
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

+ (TMFileNamePrefix)TMFileNamePrefixFromIndex:(NSUInteger)index
{
    
    TMFileNamePrefix retValue = TMFileNamePrefixNone;
    
    switch (index) {
        case 0:
            retValue = TMFileNamePrefixNone;
            break;
            
        case 1:
            retValue = TMFileNamePrefixyyyyMMdd;
            break;
            
        case 2:
            retValue = TMFileNamePrefixyyyyMM;
            break;
            
        case 3:
            retValue = TMFileNamePrefixyyyy;
            break;
        
        case 4:
            retValue = TMFileNamePrefixMM;
            break;
            
        case 5:
            retValue = TMFileNamePrefixMMdd;
            break;
            
        case 6:
            retValue = TMFileNamePrefixDirectInput;
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
