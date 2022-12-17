//
//  AlertLabelButton.m
//  SSLauncher
//
//  Created by toomoo on 2015/03/09.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "AlertLabelButton.h"

@implementation AlertLabelButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    const CGFloat borderWidth = 1.0f;
    
    CALayer *topBorderLayer = [[CALayer alloc] init];
    topBorderLayer.frame = CGRectMake(0, 0, rect.size.width, borderWidth);
    topBorderLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    [self.layer addSublayer:topBorderLayer];
    
}


@end
