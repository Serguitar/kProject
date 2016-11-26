//
//  OrderPickupVC.m
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "OrderPickupVC.h"

@interface OrderPickupVC ()

@end

@implementation OrderPickupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:105.0/255.0 blue:0.0/255.0 alpha:1];
    
    CALayer *l = _payButon.layer;
    l.borderColor = color.CGColor;
    l.cornerRadius = _payButon.frame.size.height/2;
    l.borderWidth = 1;
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
