//
//  CloudListTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/10/31.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "CloudListTableViewController.h"
#import "LauncherData.h"
#import "SSLUserDefaults.h"

// アクセサリーViewのスペーサー
static UIView *g_SpacerView = nil;


@interface CloudListTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dropboxUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *EvernoteUserLabel;

@end

@implementation CloudListTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    g_SpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 1)];
    
}

/** セルが表示される直前に呼び出される */
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // セルに初期値のチェックマークを設定
    NSInteger targetRow = [[self class] indexFromCloud:self.data.cloudType];
    
    if (indexPath.row == targetRow) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        
        cell.accessoryView = g_SpacerView;
    }
    
    switch (indexPath.row) {
        case SSLCloudTypeDropbox:
            self.dropboxUserLabel.text = [SSLUserDefaults dropboxUserName];
            break;
            
            
        case SSLCloudTypeEvernote:
            self.EvernoteUserLabel.text = [SSLUserDefaults evernoteUserName];
            break;
            
        default:
            break;
    }
}

/** セルが指定された */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 一旦すべてのセルからチェックマークをすべてはずす
    for (NSInteger i = 0; i < [tableView numberOfRowsInSection:0]; ++i)
    {
        UITableViewCell *tmpCell =
        [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        tmpCell.accessoryType = UITableViewCellAccessoryNone;
        tmpCell.accessoryView = g_SpacerView;
    }
    
    // 選択されたセルチェックマークを指定する
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // データの反映
    self.data.cloudType = [[self class] cloudFromIndex:indexPath.row];
}


#pragma mark -
#pragma mark ===== Private Class Method =====

/** カラーモードとのマッピング関数 */
+ (NSUInteger)indexFromCloud:(SSLCloudType)val
{
    
    NSUInteger index = 0;
    
    switch (val) {
        case SSLCloudTypeDropbox:
            index = 0;
            break;
            
        case SSLCloudTypeEvernote:
            index = 1;
            break;
            
        case SSLCloudTypeiCloud:
//            index = 2;
            break;
            
        case SSLCloudTypeOneDrive:
//            index = 3;
            break;
            
        case SSLCloudTypeGoogleDrive:
//            index = 4;
            break;
            
        default:
            break;
    }
    
    return index;
}

+ (SSLCloudType)cloudFromIndex:(NSUInteger)index
{
    
    SSLCloudType retValue = SSLCloudTypeDropbox;
    
    switch (index) {
        case 0:
            retValue = SSLCloudTypeDropbox;
            break;
            
        case 1:
            retValue = SSLCloudTypeEvernote;
            break;
            
        case 2:
            retValue = SSLCloudTypeiCloud;
            break;
            
        case 3:
            retValue = SSLCloudTypeOneDrive;
            break;

        case 4:
            retValue = SSLCloudTypeGoogleDrive;
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
