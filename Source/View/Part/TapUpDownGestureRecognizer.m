//
//  TapUpDownGestureRecognizer.m
//  SSLauncher
//
//  Created by toomoo on 2015/02/03.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "TapUpDownGestureRecognizer.h"

@implementation TapUpDownGestureRecognizer

- (id)initWithTouchDown:(TapUpDownGestureRecognizerTouchDown)touchDown
                touchUp:(TapUpDownGestureRecognizerTouchUp)touchUp
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.touchDown = touchDown;
    self.touchUp = touchUp;
    
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchDown) {
     
        self.touchDown(self, touches, event);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* 指が離れた位置が対象のビュー内か(UIControlEventTouchUpInsideを判定) */
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    BOOL isTouchUpInside = CGRectContainsPoint(self.view.bounds, touchPoint);
    
    if (self.touchUp) {
     
        self.touchUp(self, touches, event, isTouchUpInside);
    }
}

@end
