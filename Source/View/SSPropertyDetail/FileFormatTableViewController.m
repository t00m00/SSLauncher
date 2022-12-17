//
//  FileFormatTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2015/04/13.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "FileFormatTableViewController.h"

#import "LauncherData.h"


@interface FileFormatTableViewController ()

@end

@implementation FileFormatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/** セルが表示される直前に呼び出される */
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // セルに初期値のチェックマークを設定
    NSInteger targetRow = [[self class] indexFromFileFormat:self.data.fileformat];
    
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
    self.data.fileformat = [[self class] fileFormatFromIndex:indexPath.row];
}


#pragma mark -
#pragma mark ===== Private Class Method =====

/** ファイルフォーマットのマッピング関数 */
+ (NSUInteger)indexFromFileFormat:(SSFileFormat)val
{
    
    NSUInteger index = 0;
    
    switch (val) {
        case SSFileFormatPDF:
            index = 0;
            break;
            
        case SSFileFormatJpeg:
            index = 1;
            break;
            
        default:
            break;
    }
    
    return index;
}

+ (SSFileFormat)fileFormatFromIndex:(NSUInteger)index
{
    
    SSFileFormat retValue = SSFileFormatPDF;
    
    switch (index) {
        case 0:
            retValue = SSFileFormatPDF;
            break;
            
        case 1:
            retValue = SSFileFormatJpeg;
            break;
            
        default:
            break;
    }
    
    return retValue;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
