//
//  PaperSizeTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/16.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "PaperSizeTableViewController.h"
#import "LauncherData.h"

@interface PaperSizeTableViewController ()

@end

@implementation PaperSizeTableViewController

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
    NSInteger targetRow = [[self class] indexFromPaperSize:self.data.paperSize];
    
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
    self.data.paperSize = [[self class] paperSizeFromIndex:indexPath.row];
}

#pragma mark -
#pragma mark ===== Private Class Method =====

/** 原稿サイズとのマッピング関数 */
+ (NSUInteger)indexFromPaperSize:(SSPaperSize)val
{
    
    NSUInteger index = 0;
    
    switch (val) {
        case SSPaperSizeAuto:
            index = 0;
            break;
            
        case SSPaperSizeA4:
            index = 1;
            break;
            
        case SSPaperSizeA5:
            index = 2;
            break;
            
        case SSPaperSizeA6:
            index = 3;
            break;
            
        case SSPaperSizeB5:
            index = 4;
            break;
            
        case SSPaperSizeB6:
            index = 5;
            break;
            
        case SSPaperSizePostCard:
            index = 6;
            break;
            
        case SSPaperSizeBusinessCard:
            index = 7;
            break;
            
        case SSPaperSizeLetter:
            index = 8;
            break;
            
        case SSPaperSizeLegal:
            index = 9;
            break;
            
        default:
            break;
    }
    
    return index;
}

+ (SSPaperSize)paperSizeFromIndex:(NSUInteger)index
{
    
    SSPaperSize retValue = SSPaperSizeAuto;
    
    switch (index) {
        case 0:
            retValue = SSPaperSizeAuto;
            break;
            
        case 1:
            retValue = SSPaperSizeA4;
            break;
            
        case 2:
            retValue = SSPaperSizeA5;
            break;
            
        case 3:
            retValue = SSPaperSizeA6;
            break;
            
        case 4:
            retValue = SSPaperSizeB5;
            break;
            
        case 5:
            retValue = SSPaperSizeB6;
            break;
            
        case 6:
            retValue = SSPaperSizePostCard;
            break;
            
        case 7:
            retValue = SSPaperSizeBusinessCard;
            break;
            
        case 8:
            retValue = SSPaperSizeLetter;
            break;
            
        case 9:
            retValue = SSPaperSizeLegal;
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
