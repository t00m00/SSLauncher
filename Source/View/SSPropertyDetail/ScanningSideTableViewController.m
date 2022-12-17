//
//  ScanningSideTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/16.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "ScanningSideTableViewController.h"
#import "LauncherData.h"

@interface ScanningSideTableViewController ()

@end

@implementation ScanningSideTableViewController

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
    NSInteger targetRow = [[self class] indexFromScaningSide:self.data.scanSide];
    
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
    self.data.scanSide = [[self class] scanningSideFromIndex:indexPath.row];
}

#pragma mark -
#pragma mark ===== Private Class Method =====

/** 読み取り面とのマッピング関数 */
+ (NSUInteger)indexFromScaningSide:(SSScanningSide)val
{
    
    NSUInteger index = 0;
    
    switch (val) {
        case SSScanningSideBoth:
            index = 0;
            break;
            
        case SSScanningSideSingle:
            index = 1;
            break;
            
        default:
            break;
    }
    
    return index;
}

+ (SSScanningSide)scanningSideFromIndex:(NSUInteger)index
{
    
    SSScanningSide retValue = SSScanningSideBoth;
    
    switch (index) {
        case 0:
            retValue = SSScanningSideBoth;
            break;
            
        case 1:
            retValue = SSScanningSideSingle;
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
