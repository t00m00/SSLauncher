//
//  BaseSSPropDetailTableViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/15.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "BaseSSPropDetailTableViewController.h"
#import "SSPalameters+Extension.h"
#import "LauncherData.h"

@interface BaseSSPropDetailTableViewController ()
@end

@implementation BaseSSPropDetailTableViewController

+ (TMDelimiterType)TMDelimiterTypeFromIndex:(NSUInteger)index
{
    
    TMDelimiterType retValue = 0;
    
    switch (index) {
        case 0:
            retValue = TMDelimiterTypeUnderScore;
            break;
            
        case 1:
            retValue = TMDelimiterTypeHyphen;
            break;
            
        case 2:
            retValue = TMDelimiterTypeNone;
            break;
            
        default:
            break;
    }
    
    return retValue;
}

@end
