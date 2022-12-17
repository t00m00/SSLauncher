//
//  BaseLauncherTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2015/01/17.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "BaseLauncherTableViewController.h"

#import "LauncherTableViewCell.h"
#import "PromotionViewController.h"
#import "FileManageFacade.h"
#import "LauncherDataManager.h"
#import "LauncherData.h"
#import "LauncherData+Managing.h"
#import "LauncherDataManager+Favorite.h"
#import "CloudFacade.h"
#import "CollaborateFacade.h"
#import "SSPropertyTableViewController.h"
#import "SSLUserDefaults.h"
#import "SyncAlertView.h"
#import "SSLUserDefaults.h"
#import "ScanLimitManager.h"
#import "UIViewController+Searching.h"
#import "DescriptionViewController.h"
#import "InputAlertViewController.h"
#import "TMCircleView.h"

/** SegueID */
static NSString * const kSegueNewSSPTVC             = @"NewSSPTVCSegue";            /**< Launcherの新規作成 */
static NSString * const kSeguePersuadeListIAPVC     = @"PersuadeListIAPVCSegue";    /**< リストの機能購入を促す(リスト数) */
static NSString * const kSeguePersuadeCountIAPVC    = @"PersuadeCountIAPVCSegue";   /**< リストの機能購入を促す(使用回数) */
static NSString * const kSegueEditSSPTVC            = @"EditSSPTVCSegue";           /**< Launcherの編集 */

/** ロゴイメージ */
static UIImage *kLogoImageDropbox  = nil;
static UIImage *kLogoImageEvernote = nil;

@interface BaseLauncherTableViewController ()

@property (strong, nonatomic) SyncAlertView *syncAlertView;
@property (assign, nonatomic) BOOL isEditWithSwipe;                             /**< セルのスワイプが行われたか判断 */

@end

@implementation BaseLauncherTableViewController

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
    
    // テーブルビューの余白の線を消す
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // cell背景色を変更する
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    // Mailboxのようにセルの背景色の上部のみ白色にする
    UIView *headerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    self.tableView.contentInset = UIEdgeInsetsMake(-[[UIScreen mainScreen] bounds].size.height, 0, 0, 0);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UINib *nib = [UINib nibWithNibName:@"LauncherTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LauncherTableViewCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //    [[LauncherDataManager shared] reloadData];
    [self.tableView reloadData];
    
    [self updataEditButtonEnable];
}

- (void)viewWillDisappear:(BOOL)animated
{

}

- (void)viewDidDisappear:(BOOL)animated
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        
        // iOS7.1以下
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        
        if (YES == [window.rootViewController isKindOfClass:[UITabBarController class]]   &&
            NO  == [window.rootViewController isMemberOfClass:[SSPropertyTableViewController class]]) {
            
            [self setEditing:NO animated:NO];
        }
        
    }else {
        
        // iOS8.0以降
        UIViewController *viewController = [UIViewController topMostController];
        
        // ★ToDo: if文のネストを少なくする★
        if (YES == [viewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tabBarController = (UITabBarController*)viewController;
            UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
            
            if (NO == [navigationController.topViewController isMemberOfClass:[SSPropertyTableViewController class]]) {
                
                [self setEditing:NO animated:NO];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 編集モード切り替え時に呼び出される */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    // スワイプ判定をリセット
    if (editing == NO) {
        
        self.isEditWithSwipe = NO;
    }
}

/** セルが表示される直前に呼び出される */
/*
 - (void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
 forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 
 }
 */

#pragma mark -
#pragma mark ===== Instance Method =====
/** セルのお気に入りボタンを押下された(サブクラスで必要に応じてオーバライド推奨) */
- (void)didViewRowActionOfFavorite:(UITableViewRowAction *)action
                         indexPath:(NSIndexPath *)indexPath
{
    // do nothing
}

/** 編集ボタンの状態を更新 */
- (void)updataEditButtonEnable
{
    BOOL enable = YES;
    if (0 == [[self class] countDataForTableView]) {
        enable = NO;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = enable;
}

#pragma mark -
#pragma mark ===== Class Method =====

/** セルを構成するためのLauncherDataを返却する(サブクラスで必要に応じてオーバライド推奨) */
+ (LauncherData *)cellOfDataForRow:(NSIndexPath *)indexPath
{
    return [[LauncherDataManager shared] objectAtIndex:indexPath.row];
}

/** 各画面で対象となるデータ数を返却する(サブクラスで必要に応じてオーバライド推奨) */
+ (NSUInteger)countDataForTableView
{
    return [[LauncherDataManager shared] count];
}

#pragma mark - Table view data source
/** セクション数 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

/** セル数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self class] countDataForTableView];
}

/** セルの内容作成 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    static NSString *CellIdentifier = @"LauncherCell";
    static NSString *CellIdentifier = @"LauncherTableViewCell";
    LauncherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self updateCell:cell cellForRowAtIndexPath:indexPath];
    
    return cell;
}

/** セルの高さを変更 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    return 60.0f;
    return kCellHeight;
}

/** セルが選択された */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isEditing == NO) {
        
        [self exeScanningFile:indexPath];
        
    } else {
        // 編集中
        [self performSegueWithIdentifier:kSegueEditSSPTVC
                                  sender:[[self class] cellOfDataForRow:indexPath]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// Override to support conditional editing of the table view.
/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

// セルを左にスワイプした際のボタン表示
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditWithSwipe == NO) {
        
        // nil を返却することでデフォルトの "削除" ボタンを表示する
        return nil;
    }
    
    NSMutableArray *actions = [NSMutableArray array];
    
    //編集ボタン
    UITableViewRowAction *editAction =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                       title:NSLocalizedString(@"Launcher_Cell_Button_Edit", @"")
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                         
                                         // 編集する
                                         [self performSegueWithIdentifier:kSegueEditSSPTVC
                                                                   sender:[[self class] cellOfDataForRow:indexPath]];
                                     }];
    
    editAction.backgroundColor = [UIColor colorWithRed:71/255.0f green:136/255.0f blue:94/255.0f alpha:1.0f];   // 緑青色
    [actions addObject:editAction];
    
    LauncherData *data = [[self class] cellOfDataForRow:indexPath];
    
    NSString *starTitle = NSLocalizedString(@"Launcher_Cell_Button_Favorite", @"");
    if (data.isFavorite == YES) {
        
        starTitle = NSLocalizedString(@"Launcher_Cell_Button_Favorite_Selected", @"");;
    }
    
    // お気に入りボタン
    UITableViewRowAction *starAction =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                       title:starTitle
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                         
                                         // 現在の設定と反対を代入する
                                         LauncherData *data = [[self class] cellOfDataForRow:indexPath];
                                         data.isFavorite = data.isFavorite != YES;
                                         
                                         // |data|のファイルを保存
                                         BOOL ret = [FileManageFacade saveOverwriteLauncherData:data];
                                         if (ret == NO) {
                                             UIAlertView *alert =
                                             [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Err_App_Title_Internal", @"")
                                                                        message:NSLocalizedString(@"Err_App_Body_Internal", @"")
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:NSLocalizedString(@"Common_Alert_Button_OK", @""), nil];
                                             
                                             [alert show];
                                         }
                                         
                                         [[LauncherDataManager shared] updateFavoriteData];
                                         
                                         [tableView setEditing:NO];   // これでアニメーション付きでセルを閉じれる
                                         
                                         // サブクラスのためにイベントを発火
                                         [self didViewRowActionOfFavorite:action indexPath:indexPath];
                                     }];
    
    starAction.backgroundColor = [UIColor colorWithRed:252/255.0f green:200/255.0f blue:0/255.0f alpha:1.0f];   // 向日葵色
    [actions addObject:starAction];
    
    return actions;
}

/** セルのスワイプ動作検知に使用 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Detemine if it's in editing mode
    
    if (self.editing == NO) {
        // セルのスワイプの場合はこちらに入る
        self.isEditWithSwipe = YES;
    }
    
    return UITableViewCellEditingStyleDelete;
}

/** table viewの変更を確定させる */
- (void)  tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // [メモ] セルを削除する前に紐付けているデータを削除しないと例外が発生する
        [[LauncherDataManager shared] removeObject:[[self class] cellOfDataForRow:indexPath]];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // 並べ替えをデータに反映
    [[LauncherDataManager shared] moveObjectAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark -
#pragma mark ===== Segue =====

/** 閉じる画面遷移を実行するか判定する
 *    |fromViewController|が自分自身の場合、YESを返すとクラッシュするので注意。(自分自身に遷移メソッドが実装されていないため)
 *
 **/
- (BOOL)canPerformUnwindSegueAction:(SEL)action
                 fromViewController:(UIViewController *)fromViewController
                         withSender:(id)sender
{
    
    //    NSLog(@"Launcher view");
    //    NSLog(@"fromViewController = %@", NSStringFromClass([fromViewController class]));
    
    return YES;
}

/** UnwindSegue */
// canPerformUnwindSegueAction:fromViewControllerwithSender: メソッドの後に実行される
- (IBAction)SSLauncherViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    
    if ([segue.identifier isEqualToString:@"BackToFirstViewFromLastViewSegue"]) {
        // ここに必要な処理を記述
        //        NSLog(@"Back to launcher.");
    }
    
    //    NSLog(@"return action invoked.");
}

/** セグエ実行の直前に呼ばれる */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Launcherデータの編集
    if ([[segue identifier] isEqualToString:kSegueEditSSPTVC] == YES) {
        
        SSPropertyTableViewController *sspTVC =
        (SSPropertyTableViewController *)[segue destinationViewController];
        
        sspTVC.data = (LauncherData *)sender;
        
    } else if (([[segue identifier] isEqualToString:kSeguePersuadeListIAPVC] == YES)) {
        
        // Launcherリスト個数の上限
        UINavigationController *naviVC =
        (UINavigationController *)[segue destinationViewController];
        
        PromotionViewController *promoVC = (PromotionViewController *)naviVC.topViewController;
        promoVC.infoMsg = NSLocalizedString(@"PromoVC_Info_Msg_List", @"");
        
    } else if (([[segue identifier] isEqualToString:kSeguePersuadeCountIAPVC] == YES)) {
        
        // スキャン回数の上限
        UINavigationController *naviVC =
        (UINavigationController *)[segue destinationViewController];
        
        PromotionViewController *promoVC = (PromotionViewController *)naviVC.topViewController;
        promoVC.infoMsg = NSLocalizedString(@"PromoVC_Info_Msg_Count", @"");
    }
}

#pragma mark -
#pragma mark ===== Action Method =====

/** 「+」ボタンを押下された */
- (IBAction)pushAddListButton:(UIBarButtonItem *)barButton
{
    [DescriptionViewController close];
    
    if ([SSLUserDefaults launchUnrestraintKounyu] == NO &&
        kMaxLauncherListCount <= [[self class] countDataForTableView]) {
        
        // 購入を促す画面を表示
        [self performSegueWithIdentifier:kSeguePersuadeListIAPVC
                                  sender:nil];
        
        return;
    }
    
    // Launcher新規作成画面へ移動
    [self performSegueWithIdentifier:kSegueNewSSPTVC
                              sender:nil];
}



#pragma mark -
#pragma mark ===== Private Instace Method =====
/** セルの内容更新 */
- (void)updateCell:(LauncherTableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LauncherData *data = [[self class] cellOfDataForRow:indexPath];
    [self updateCell:cell cellOfDataForRow:data];
}

- (void)updateCell:(LauncherTableViewCell *)cell cellOfDataForRow:(LauncherData *)data
{
    cell.titleLabel.text = data.title;
    cell.placeLabel.text =
    [data.cloudSavePath stringByAppendingPathComponent:data.fileNameDisplay];
    
    /** ロゴイメージ */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        kLogoImageDropbox   = [UIImage imageNamed:@"dropbox-icon"];
        kLogoImageEvernote  = [UIImage imageNamed:@"evernote-icon"];
        
    });
    
    const CGFloat wh = 33;
    TMCircleView *circleView = [[TMCircleView alloc] initWithFrame:CGRectMake(0, 0, wh, wh)];
    
    switch (data.cloudType) {
        case SSLCloudTypeDropbox:
            circleView.iconImageView.image = kLogoImageDropbox;
            break;
            
        case SSLCloudTypeEvernote:
            circleView.iconImageView.image = kLogoImageEvernote;
            break;
            
        case SSLCloudTypeiCloud:
            
            break;
            
        case SSLCloudTypeOneDrive:
            
            break;
            
        case SSLCloudTypeGoogleDrive:
            
            break;
            
        default:
            break;
    }
    
    circleView.hiddenLinkImage = (data.isShareLink == NO);
    
    cell.accessoryView = circleView;
}

/** スキャン処理の実行 */
- (void)exeScanningFile:(NSIndexPath *)indexPath
{
    
    // スキャン上限の確認
    if ([SSLUserDefaults launchUnrestraintKounyu]   == NO   &&
        [ScanLimitManager isScanLimitNumberOfDaily] == YES  ) {
        
        // 購入を促す画面を表示
        [self performSegueWithIdentifier:kSeguePersuadeCountIAPVC
                                  sender:nil];
        
        return;
    }
    
    LauncherData *data = [[self class] cellOfDataForRow:indexPath];
    
    // SSCAを呼び出すブロックを作成
    void(^clickedBlock)(NSInteger buttonIndex, NSString *newFileName) =
    ^void(NSInteger buttonIndex, NSString *newFileName){
        
        if (0 <= buttonIndex && newFileName != nil) {
            
            // 「スキャン実行時に入力」が選択されていて、アラートが表示された場合はファイル名を更新
            [SSLUserDefaults setFineNameOfScanRuntime:newFileName launcherName:data.launcherDataFileName];
            newFileName = ([newFileName length] <= 0) ? NSLocalizedString(@"LData_Default_FileName", @"") : newFileName;
            data.fileName = newFileName;
        }
        
        // 指定された行のデータでSSCAの呼び出し
        BOOL ret = [CollaborateFacade openSSCAWithData:data];
        
        if (ret == NO) {
            // エラーメッセージの表示
            NSLog(@"Error openURL");
            
            // 現在のブロック処理を抜け出す必要があるので、遅延実行とする
            [self performSelector:@selector(showDerivationViewToAppStore) withObject:nil afterDelay:0.01f];
        }
        
        return;
    };
    
    if (data.fileNameFormatEx == SSFileNameFormatExScanRuntime) {
    
        // ファイル名を入力させる
        [InputAlertViewController showWithAlertTiltle:[LauncherData promoEnterFileNameWithCloudType:data.cloudType]
                                          placeholder:[[[LauncherData fileNamePrefixText:data]
                                                        stringByAppendingString:NSLocalizedString(@"LData_Default_FileName", @"")]
                                                       stringByAppendingString:[LauncherData fileNameSuffixText:data]]
                                             defaultfileName:[SSLUserDefaults fineNameOfScanRuntime:data.launcherDataFileName]
                                                clicked:^(NSInteger buttonIndex, NSString *fileName) {
                                                    clickedBlock(buttonIndex, fileName);
                                                }];
        return;
    }
    
    // ファイル名の入力がが必要ない場合
    clickedBlock(-1, nil);
}

/** App Storeへの誘導するアラートを表示 */
- (void)showDerivationViewToAppStore
{
    // すでに|self.syncAlertView|の内容は不要になっているので、上書きしても問題なし
    self.syncAlertView =
    [[SyncAlertView alloc] initWithTitle:NSLocalizedString(@"SSCA_Failed_NoInstalled_Title", @"")
                                 message:@""
                       cancelButtonTitle:NSLocalizedString(@"Common_Alert_Button_OK", @"")
                       otherButtonTitles:NSLocalizedString(@"Common_Alert_Button_Install", @"")];
    
    // アラート表示
    [self.syncAlertView syncShow:^(NSInteger buttonIndex) {
        
        //                NSLog(@"buttonIndex=%ld", (long)buttonIndex );
        
        const int installButton = 1;
        if (buttonIndex == installButton) {
            // SSCAのサイトを表示させる
            [CollaborateFacade openAppStoreToSSCA];
        }
        
    }];
}

@end
