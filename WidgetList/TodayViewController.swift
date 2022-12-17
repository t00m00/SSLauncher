//
//  TodayViewController.swift
//  WidgetList
//
//  Created by toomoo on 2015/01/26.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

import UIKit
import NotificationCenter
import SSLExtensionLib

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellHeight: CGFloat = 50.0
    let reuseId = "WidgetList"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        // このメソッドが一番最初である
        
        self.tableView.registerNib(UINib(nibName: "TodayTableViewCell", bundle: nil),
            forCellReuseIdentifier: self.reuseId)

        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }

    // Widget内の左側の余白を消す
//    func  widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
//        
//        return UIEdgeInsetsZero
//    }
    
    
    
    // MARK: - Table view data source
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    // セル数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var dicDatas: NSArray = SSLShardFileManager.readWidgetDatas() as NSArray
        
        var cellCount = dicDatas.count
        
        // ウィジェットには 5つ までしか表示しない
        cellCount = (5 < cellCount) ? 5 : cellCount
        
        self.preferredContentSize =
            CGSizeMake(self.tableView.contentSize.width, self.cellHeight * CGFloat(cellCount))
        
        if cellCount == 0 {
            
            self.tableView.contentSize.height = 0
        }
        
        // ★ToDo:|cellCount = 1|の場合は、「データなし」とかやる？★
        
        return cellCount
    }
    
    // セルの高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return self.cellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : TodayTableViewCell =
        tableView.dequeueReusableCellWithIdentifier(self.reuseId , forIndexPath: indexPath) as! TodayTableViewCell
        
        var dicDatas: NSArray! = SSLShardFileManager.readWidgetDatas() as NSArray
        var wData: WidgetListData =
        WidgetListData.create(dicDatas.objectAtIndex(indexPath.row) as! NSDictionary as [NSObject : AnyObject])
        
        cell.title.text = wData.title
        cell.detail.text = wData.cloudTypeStr
        
        return cell
    }
    
    // セルの選択
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        println("selected : \(indexPath.row)")
        
        // アプリを呼び出す
        let url = SSLauncherURLScheme.createSSLWidgetUrl(UInt(indexPath.row))
        self.extensionContext?.openURL(url, completionHandler: nil)
    }
}
