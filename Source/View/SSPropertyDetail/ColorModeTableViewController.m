//
//  ColorModeTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/15.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "ColorModeTableViewController.h"
#import "LauncherData.h"

@interface ColorModeTableViewController ()

@end

@implementation ColorModeTableViewController

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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    NSInteger targetRow = [[self class] indexFromColorMode:self.data.colorMode];
    
    if (indexPath.row == targetRow) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        return;
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
    }
    
    // 選択されたセルチェックマークを指定する
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // データの反映
    self.data.colorMode = [[self class] colorModeFromIndex:indexPath.row];
}


#pragma mark -
#pragma mark ===== Private Class Method =====

/** カラーモードとのマッピング関数 */
+ (NSUInteger)indexFromColorMode:(SSColorMode)val
{
    
    NSUInteger index = 1;
    
    switch (val) {
        case SSColorModeAuto:
            index = 0;
            break;
            
        case SSColorModeColor:
            index = 1;
            break;
            
        case SSColorModeGray:
            index = 2;
            break;
            
        case SSColorModeMono:
            index = 3;
            break;
            
        default:
            break;
    }
    
    return index;
}

+ (SSColorMode)colorModeFromIndex:(NSUInteger)index
{
    
    SSColorMode retValue = SSColorModeAuto;
    
    switch (index) {
        case 0:
            retValue = SSColorModeAuto;
            break;
            
        case 1:
            retValue = SSColorModeColor;
            break;
            
        case 2:
            retValue = SSColorModeGray;
            break;
            
        case 3:
            retValue = SSColorModeMono;
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
