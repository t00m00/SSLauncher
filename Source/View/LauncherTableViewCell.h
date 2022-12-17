//
//  LauncherTableViewCell.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/20.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/** セルの高さ */
extern const CGFloat kCellHeight;

@interface LauncherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end
