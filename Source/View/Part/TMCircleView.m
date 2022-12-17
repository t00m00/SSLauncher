//
//  TMCircleView.m
//  SSLauncher
//
//  Created by toomoo on 2014/11/06.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "TMCircleView.h"
#import <QuartzCore/QuartzCore.h>

/** リンクイメージ */
static UIImage *kLinkImage = nil;

@interface TMCircleView ()

@property (strong, nonatomic) UIImageView *linkImageView;

@end

@implementation TMCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self->_iconImageView = [[UIImageView alloc] initWithFrame:frame];
        self->_iconImageView.backgroundColor        = [UIColor clearColor];
        self->_iconImageView.layer.cornerRadius     = self.frame.size.width * 0.50f;
        self->_iconImageView.clipsToBounds          = YES;
        
        [self addSubview:self.iconImageView];
        
//        self.layer.shadowOpacity    = 0.2f;
//        self.layer.shadowOffset     = CGSizeMake(0, 4.0f);
//        self.layer.shadowRadius     = 0.5f;
//        self.layer.shadowColor      = [UIColor blackColor].CGColor;

        
        // リンクイメージの表示
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            kLinkImage = [UIImage imageNamed:@"icon_link"];
        });
        
        const CGFloat margin = 5.f;
        
        self.linkImageView =
//        [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame) + margin, CGRectGetMidY(frame) + margin,
        [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(frame) + margin,
//                                                      CGRectGetWidth(frame) / 3 * 2, CGRectGetHeight(frame) / 3 * 2)];
                                                      CGRectGetWidth(frame) / 2, CGRectGetHeight(frame) / 2)];
        
        self.linkImageView.image                = kLinkImage;
        self.linkImageView.backgroundColor      = [UIColor clearColor];
        self.linkImageView.layer.cornerRadius   = self.linkImageView.frame.size.width * 0.50f;
        self.linkImageView.clipsToBounds        = YES;

        self.linkImageView.hidden = self.hiddenLinkImage = YES;
        
        [self addSubview:self.linkImageView];
    }
    return self;
}

- (void)setHiddenLinkImage:(BOOL)hiddenLinkImage
{
    self->_hiddenLinkImage = hiddenLinkImage;
//    self.linkImageView.hidden = NO;
    self.linkImageView.hidden = hiddenLinkImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGContextSetFillColorWithColor(c, [UIColor cyanColor].CGColor);
    CGContextFillEllipseInRect(c, CGRectMake(0, 0, w, h));
}
*/

@end
