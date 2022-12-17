//
//  LauncherDataManager+Managing.h
//  SSLauncher
//
//  Created by toomoo on 2014/09/07.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "LauncherDataManager.h"

@interface LauncherDataManager (Managing)

/** 連携中のデータを保持します */
- (void)setProcessingObject:(LauncherData *)data;
- (LauncherData *)processingObject;

@end
