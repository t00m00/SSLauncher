//
//  CompressionTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/16.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "CompressionTableViewController.h"
#import "LauncherData.h"

@interface CompressionTableViewController ()

@end

@implementation CompressionTableViewController

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
    NSInteger targetRow = [[self class] indexFromCompression:self.data.compression];
    
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
    self.data.compression = [[self class] compressionFromIndex:indexPath.row];
}

#pragma mark -
#pragma mark ===== Private Class Method =====

/** 原稿サイズとのマッピング関数 */
+ (NSUInteger)indexFromCompression:(SSCompression)val
{
    
    NSUInteger index = 0;
    
    switch (val) {
        case SSCompressionLvMinus2:
            index = 0;
            break;
            
        case SSCompressionLvMinus1:
            index = 1;
            break;
            
        case SSCompressionLv0:
            index = 2;
            break;
            
        case SSCompressionLv1:
            index = 3;
            break;
            
        case SSCompressionLv2:
            index = 4;
            break;
            
        default:
            break;
    }
    
    return index;
}

+ (SSCompression)compressionFromIndex:(NSUInteger)index
{
    
    SSCompression retValue = SSCompressionLv0;
    
    switch (index) {
        case 0:
            retValue = SSCompressionLvMinus2;
            break;
            
        case 1:
            retValue = SSCompressionLvMinus1;
            break;
            
        case 2:
            retValue = SSCompressionLv0;
            break;
            
        case 3:
            retValue = SSCompressionLv1;
            break;
            
        case 4:
            retValue = SSCompressionLv2;
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
