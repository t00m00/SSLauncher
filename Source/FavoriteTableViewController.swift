//
//  FavoriteTableViewController.swift
//  SSLauncher
//
//  Created by toomoo on 2015/01/15.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

import UIKit
import NotificationCenter

// O-Cのヘッダは「SSLauncher-Bridging-Header.h」に記載してある

class FavoriteTableViewController: BaseLauncherTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // 初回起動以外かつ、お気に入り画面にデータが無い場合は必ずリスト画面から始まるようにする
        if (SSLUserDefaults.isDescriptionViewShow()  == false &&
            self.dynamicType.countDataForTableView() == 0) {
            
            self.tabBarController?.selectedIndex = 1;
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        if self.dynamicType.countDataForTableView() == 0 {
            
            // データがないのでウィジェットを消す
            let widgetController = NCWidgetController.widgetController()
            widgetController.setHasContent(false, forWidgetWithBundleIdentifier: "com.toomoo.Scanner.SSLauncher.WidgetList")
        } else {
            
            // データがあるのでウィジェットを表示
            let widgetController = NCWidgetController.widgetController()
            widgetController.setHasContent(true, forWidgetWithBundleIdentifier: "com.toomoo.Scanner.SSLauncher.WidgetList")
        }
        */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate
    override func tableView(tableView: UITableView,
        moveRowAtIndexPath sourceIndexPath: NSIndexPath,
        toIndexPath destinationIndexPath: NSIndexPath) {
        
            LauncherDataManager.shared().moveObjectAtIndexOfFavorite(UInt(sourceIndexPath.row), toIndex: UInt(destinationIndexPath.row))
    }

    // MARK: - Table view data source

    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return Int(LauncherDataManager.shared().countOfFavorite())
    }
    */

    // MARK: - Super Class Instance Method
    // お気に入りの状態が更新された。
    // このメソッドがコールされるのは、必ずお気に入りの状態を解除したときである。
    override func didViewRowActionOfFavorite(action: UITableViewRowAction!, indexPath: NSIndexPath!) {
        
        // performselectorの代わり
//        NSTimer.scheduledTimerWithTimeInterval(0.6, target: self.tableView, selector: Selector("reloadData"), userInfo: nil, repeats: false)
        
        // お気に入りのソートバリューをリセットする
        dispatch_async(dispatch_get_main_queue()) {
            LauncherDataManager.shared().resetFavoriteSortValueInNonFavorite()
        }
        
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        self.updataEditButtonEnable()
    }
    
    // MARK: - Super Class Method
    /** セルを構成するためのLauncherDataを返却する(サブクラスで必要に応じてオーバライド推奨) */
    override class func cellOfDataForRow(indexPath: NSIndexPath!) -> LauncherData  {
        return LauncherDataManager.shared().objectAtIndexOfFavorite(UInt(indexPath.row))
    }

    /** 各画面で対象となるデータ数を返却する(サブクラスで必要に応じてオーバライド推奨) */
    override class func countDataForTableView() -> UInt {
        return LauncherDataManager.shared().countOfFavorite()
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
