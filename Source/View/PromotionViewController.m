//
//  PromotionViewController.m
//  SSLauncher
//
//  Created by toomoo on 2014/09/19.
//  Copyright (c) 2014年 toomoo. All rights reserved.
//

#import "PromotionViewController.h"

@interface PromotionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoMsgLabel;                     /**< 購入促進Msg表示ラベル */
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@end

@implementation PromotionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.infoMsgLabel.text = self.infoMsg;
    
    void (^addShadow)(UIView*) = ^void(UIView *v) {
        CALayer *layer = v.layer;
//        layer.cornerRadius = 6.0f;
        layer.shadowOpacity = 0.6f;
        layer.shadowOffset = CGSizeMake(0, 2);
        layer.shadowRadius = 6.0f;
    };
    
    addShadow(self.iconImgView);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
