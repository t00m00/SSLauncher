//
//  TabBarViewController.m
//  SSLauncher
//
//  Created by toomoo on 2015/02/08.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

#import "TabBarViewController.h"
#import "ReaderViewController.h"

@interface TabBarViewController () <ReaderViewControllerDelegate>

@property (nonatomic, copy) void (^completion)(BOOL isUpload);

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPreview:(NSString *)path
         completion:(void (^)(BOOL isUpload))completion;
{
    self.completion = completion;
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
//
//    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
//    
//    NSString *filePath = [pdfs firstObject]; assert(filePath != nil); // Path to first PDF file
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:path password:phrase];
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
        //        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
        
    }
    else // Log an error so that we know that something went wrong
    {
        NSLog(@"%s [ReaderDocument withDocumentFilePath:'%@' password:'%@'] failed.", __FUNCTION__, path, phrase);
    }
}


#pragma mark - ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
                  isPushRightButton:(BOOL)isPushRightButton
{
    // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    self.completion(isPushRightButton);

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
