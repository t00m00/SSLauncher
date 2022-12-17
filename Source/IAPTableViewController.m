//
//  IAPTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/10.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "IAPTableViewController.h"
#import "InAppPurchaseFacade.h"
#import "SSLUserDefaults.h"
#import "IndicatorViewController.h"

@interface IAPTableViewController ()

@property (strong, nonatomic) InAppPurchaseFacade *iapFacade;

@property (weak, nonatomic) IBOutlet UILabel *launcherListUnrestraintTitle;
@property (weak, nonatomic) IBOutlet UILabel *launcherListUnrestraintPrice;
@property (weak, nonatomic) IBOutlet UILabel *restorelabel;

@end

@implementation IAPTableViewController

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
    
    self.iapFacade = [[InAppPurchaseFacade alloc] init];
    
    self.restorelabel.text = NSLocalizedString(@"IAPView_RestoreTitle", @"");
    
    // プロダクト情報(価格)の取得
    [self.iapFacade requestProductInfo:^(InAppPurchaseFacade *iapFacade, NSDictionary *productInfos) {
        
        if (productInfos == nil) {
            return;
        }
        
        // 値の設定
        if (YES == [[productInfos valueForKey:kIAPMProductIdentifier]
                    isEqualToString:kIAPProductsIDSSLListUnrestraint] &&
            NO == [SSLUserDefaults launchUnrestraintKounyu]             ) {
            
            NSString * const title = [productInfos valueForKey:kIAPMProductLocalizedTitle];
            NSString * const price = [productInfos valueForKey:kIAPMProductLocalizedPrice];
            
            self.launcherListUnrestraintTitle.text = title; [self.launcherListUnrestraintTitle sizeToFit];
            self.launcherListUnrestraintPrice.text = price; [self.launcherListUnrestraintPrice sizeToFit];
            
            [SSLUserDefaults setLaunchUnrestraintTitle:title];
            [SSLUserDefaults setLaunchUnrestraintPrice:price];
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.launcherListUnrestraintTitle.text = [SSLUserDefaults launchUnrestraintTitle];
    self.launcherListUnrestraintPrice.text = [SSLUserDefaults launchUnrestraintPrice];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate source

/** セルが表示される直前に呼び出される */
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([SSLUserDefaults launchUnrestraintKounyu] == YES) {
        // リスト解放は購入済みなのでボタンを押せなくする
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}


/** セルが選択が確定する直前 */
-(NSIndexPath *)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            
            if ([SSLUserDefaults launchUnrestraintKounyu] == YES) {
                // リスト解放は購入済みなのでボタンを押せなくする
                return nil;
            }
            
        case 1:
            // リストアボタン
            if ([SSLUserDefaults launchUnrestraintKounyu] == YES) {
                // 現状はリスト解放のみなのでボタンを押せなくする
                return nil;
            }
            
            break;
            
        default:
            break;
    }

    
    return indexPath;
}

/** セルが選択された */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString *payProductID = @"";
    
    //================================================================================
    // ブロックの内容を定義する
    //================================================================================
    /** 購入/リストアの成功 */
    void (^paidSuccess)(InAppPurchaseFacade *iapFacade, NSString *paymanetProductID) =
    ^(InAppPurchaseFacade *iapFacade, NSString *paymanetProductID) {
        
        NSString * const priceText = NSLocalizedString(@"IAPView_LaunchUnrestraintPricePaid", @"");
        self.launcherListUnrestraintPrice.text = priceText;
        
        [SSLUserDefaults setLaunchUnrestraintPrice:priceText];
        
        [self.tableView reloadData];
        
        // 処理中ビュー削除
        [IndicatorViewController close];
        
    };
    
    /** 購入/リストアの失敗 */
    void (^paidFailed)(InAppPurchaseFacade *iapFacade, NSError *error) =
    ^(InAppPurchaseFacade *iapFacade, NSError *error) {
        
        // 処理中ビュー削除
        [IndicatorViewController close];
        
        if (error == nil) {
            // キャンセルされた
            return;
        }
        
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"IAPView_Alert_Title_Error", @"")
                                   message:[error localizedDescription]
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:NSLocalizedString(@"Common_Alert_Button_OK", @""), nil];
        
        [alertView show];

    };
    
    
    //================================================================================
    // 購入処理/リストア処理の開始
    //================================================================================
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                
                payProductID = kIAPProductsIDSSLListUnrestraint;
                break;
            
            case 1:
            {
                // リストア処理開始する
                [self.iapFacade restore:^(InAppPurchaseFacade *iapFacade) {
                }
                                success:paidSuccess
                                  error:paidFailed];
                
                // 処理中ビュー表示
                [IndicatorViewController show];
            }
                return;
                
            default:
                break;
        }
    }

    BOOL ret = [self.iapFacade purchaseProduct:payProductID
                                   proccessing:^(InAppPurchaseFacade *iapFacade){
                                   }
                                       success:paidSuccess
                                         error:paidFailed];
    if (ret == NO) {
        
        // 購入処理開始に失敗
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Err_IAP_Title_PurchaseFailed", @"")
                                   message:NSLocalizedString(@"Err_IAP_Body_PurchaseFailed", @"")
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:NSLocalizedString(@"Common_Alert_Button_OK", @""), nil];
        
        [alertView show];
        
        return;
    }
    
    // 処理中ビュー表示
    [IndicatorViewController show];
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}
 */

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
 */

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
