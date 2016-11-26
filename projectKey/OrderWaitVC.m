//
//  OrderWaitVC.m
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "OrderWaitVC.h"
 #import "FLAnimatedImage.h"

@interface OrderWaitVC () {
    NSTimer *timer;
}

@end

@implementation OrderWaitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showAnimation];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)showAnimation {
    NSString *str=[[NSBundle mainBundle] pathForResource:@"buy" ofType:@"gif"];
    NSData *fileData = [NSData dataWithContentsOfFile:str];
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:fileData];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    CGRect rect = _gifContainer.frame;
    rect.origin = CGPointZero;
    imageView.frame = rect;
    [_gifContainer addSubview:imageView];
    
//    image
}

- (void)setPrrogress {
    CGFloat progress = _progressView.progress;
    progress += 0.1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
