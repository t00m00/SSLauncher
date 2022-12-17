//
//  eventTransparentView.m
//  SSLauncher
//
//  Created by toomoo on 2015/03/11.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "eventTransparentView.h"

@implementation eventTransparentView

/** イベント判定 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 現在イベントが発生しているViewを取得
    UIView *nowHitView = [super hitTest:point withEvent:event];
    
    // 自分自身(UIView）だったら透過して(nilを返すとイベントを取得しなくなる)
    if ( self == nowHitView )
    {
        return nil;
    }
    
    // それ意外だったらイベント発生させる
    return nowHitView;
}

@end
