//
//  SettingTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/05.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "SettingTableViewController.h"
#import "CloudFacade.h"
#import "SSLUserDefaults.h"
#import "SyncAlertView.h"

/** Developerサイトを開くためのURL */
static NSString * const kDeveloperWebsiteURL = @"http://";

@interface SettingTableViewController () <CloudFacadeDelegate>

@property (assign, nonatomic) BOOL isSelectedDisConnect;

@property (weak, nonatomic) IBOutlet UILabel *dropboxUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *evernoteUserLabel;

@property (strong, nonatomic) CloudFacade *cloudFacade;

@end

@implementation SettingTableViewController

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
    
    self.cloudFacade = [CloudFacade createCloudFacade];
    self.cloudFacade.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{

    [[self class] updateUserNameOfCloudWithSignInStatus];
    
    // 保存したユーザー名を設定
    self.dropboxUserLabel.text      = [SSLUserDefaults dropboxUserName];
    self.evernoteUserLabel.text     = [SSLUserDefaults evernoteUserName];
}

- (void)viewDidAppear:(BOOL)animated
{
    // ユーザー名の取得しなおし(明示的にviewDidAppearが呼び出されているので、このメソッドを移動しないこと)
//    [self.cloudFacade allUserName];
    [self.cloudFacade performSelector:@selector(allUserName) withObject:nil afterDelay:0.1f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
            
            // クラウドセクション
            [self performCloudSectionAtIndexPath:indexPath];
            break;
            
        case 2:
            // デベロッパセクション
            [self performSelector:@selector(performDeveloperSectionAtIndexPath:)
                       withObject:indexPath
                       afterDelay:0.01f];
            
//            [self performDeveloperSectionAtIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
- (void)displayConnected:(SSLCloudType)type
{
    // クラウドに接続済みと表示する
    self.dropboxUserLabel.text = NSLocalizedString(@"Common_Cloud_Connect", @"");
    [SSLUserDefaults setDropboxUserName:NSLocalizedString(@"Common_Cloud_Connect", @"")];
}
 */

#pragma mark - Private Class Method

/** 各クラウドのログイン状況に応じてユーザー名の表示を更新 */
+ (void)updateUserNameOfCloudWithSignInStatus
{
    
    NSString * const noConnect = NSLocalizedString(@"Common_Cloud_NoConnect", @"");
    
    // Dropbox
    if (NO == [CloudFacade signedinWithCloudType:SSLCloudTypeDropbox] ) {

        [SSLUserDefaults setDropboxUserName:noConnect];
    }
    
    // Evernote
    if (NO == [CloudFacade signedinWithCloudType:SSLCloudTypeEvernote] ) {
        
        [SSLUserDefaults setEvernoteUserName:noConnect];
    }
    
    // GoogleDrive
    if (NO == [CloudFacade signedinWithCloudType:SSLCloudTypeGoogleDrive] ) {
        
//        [SSLUserDefaults setDropboxUserName:noConnect];
    }

    // iCloud
    if (NO == [CloudFacade signedinWithCloudType:SSLCloudTypeiCloud] ) {
        
//        [SSLUserDefaults setDropboxUserName:noConnect];
    }

    // OneDrive
    if (NO == [CloudFacade signedinWithCloudType:SSLCloudTypeOneDrive] ) {
        
//        [SSLUserDefaults setDropboxUserName:noConnect];
    }
}

#pragma mark - Private Method

/** クラウドセクションを選択された際の動作を行います */
- (void)performCloudSectionAtIndexPath:(NSIndexPath *)indexPath
{
    SSLCloudType type = SSLCloudTypeDropbox;
    
    switch (indexPath.row) {
        case 0:
            type = SSLCloudTypeDropbox;
            break;
            
        case 1:
            type = SSLCloudTypeEvernote;
            break;
            
        default:
            break;
    }
    
    self.isSelectedDisConnect = NO;
    BOOL ret = [CloudFacade signin:type fromController:self];
    
    if (ret == NO) {
        
        self.isSelectedDisConnect = YES;
        NSString * const userName = NSLocalizedString(@"Common_Cloud_NoConnect", @"");
        
        switch (type) {
            case SSLCloudTypeDropbox:
            {
                self.dropboxUserLabel.text = userName;
                [SSLUserDefaults setDropboxUserName:userName];
            }
                break;
                
            case SSLCloudTypeEvernote:
                self.evernoteUserLabel.text = userName;
                [SSLUserDefaults setEvernoteUserName:userName];
                break;
                
            default:
                break;
        }

    }
}

/** デベロッパーセクション */
- (void)performDeveloperSectionAtIndexPath:(NSIndexPath *)indexPath
{
    SyncAlertView *syncAlertView =
    [[SyncAlertView alloc] initWithTitle:NSLocalizedString(@"Common_Alert_Title_DevWebsite", @"")
                                 message:@""
                       cancelButtonTitle:NSLocalizedString(@"Common_Alert_Button_Cancel", @"")
                       otherButtonTitles:NSLocalizedString(@"Common_Alert_Button_Open_Safari", @"")];
    
    if ([syncAlertView syncShow] == 1) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kDeveloperWebsiteURL]];
    }
}

#pragma mark - CloudFacadeDelegate
/** ユーザー名の取得 */
- (void)    cloudFacade:(CloudFacade *)cloudFacade
              cloudType:(SSLCloudType)type
               userName:(NSString *)userName
userNameFailedWithError:(NSError *)error
{
    
    NSString *tmpUserName = userName;
    
    if (error != nil) {
        tmpUserName = NSLocalizedString(@"Common_Cloud_NoConnect", @"");
        
        // ★ToDo★ エラー。アラート表示
        
    }
    
    if (self.isSelectedDisConnect == YES) {
        // 明示的に接続解除した。
        // 非同期でユーザ名を取得しているのでタイミング的に未接続でもユーザ名がとれてしまう場合がある。
        return;
    }
    
    switch (type) {
        case SSLCloudTypeDropbox:
            self.dropboxUserLabel.text = tmpUserName;
            [SSLUserDefaults setDropboxUserName:tmpUserName];
            break;
            
        case SSLCloudTypeEvernote:
            self.evernoteUserLabel.text = tmpUserName;
            [SSLUserDefaults setEvernoteUserName:tmpUserName];
            break;
            
        default:
            break;
    }
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
