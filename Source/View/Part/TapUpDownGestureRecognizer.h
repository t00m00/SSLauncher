//
//  TapUpDownGestureRecognizer.h
//  SSLauncher
//
//  Created by toomoo on 2015/02/03.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TapUpDownGestureRecognizer;

//** タッチダウン時のブロック定義 */
typedef void (^TapUpDownGestureRecognizerTouchDown)
(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event);

//** タッチアップ時のブロック定義 */
typedef void (^TapUpDownGestureRecognizerTouchUp)
(TapUpDownGestureRecognizer *tapUpDownGesture, NSSet *touches, UIEvent *event, BOOL isTouchUpInside);


@interface TapUpDownGestureRecognizer : UITapGestureRecognizer

@property (copy, nonatomic) TapUpDownGestureRecognizerTouchDown touchDown;
@property (copy, nonatomic) TapUpDownGestureRecognizerTouchUp   touchUp;

- (id)initWithTouchDown:(TapUpDownGestureRecognizerTouchDown)touchDown
                touchUp:(TapUpDownGestureRecognizerTouchUp)touchUp;

@end
