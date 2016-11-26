//
//  CardRouter.m
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "CardRouter.h"
#import "Webpay.h"

@implementation CardRouter

+ (void)showCardOnVC:(UIViewController *)vc fromItem:(BOOL)fromItem price:(NSString *)price {
    // replace test_public_YOUR_PUBLIC_KEY with your WebPay publishable key
    [WPYTokenizer setPublicKey:@"test_public_YOUR_PUBLIC_KEY"];
    
    WPYCreditCard *card = [WPYCreditCard new];
    card.number = @"5106216009511977";
    card.name =   @"IVAN IVANOV";
    card.cvc =    @"123";
    card.expiryYear = 2018;
    card.expiryMonth = 5;
    
    WPYPaymentViewController *paymentViewController = [WPYPaymentViewController paymentViewControllerWithPriceTag:price card:card callback:^(WPYPaymentViewController *paymentViewController, WPYToken *token, NSError *error) {
        
        [vc.navigationController popViewControllerAnimated:NO];
        
        if (fromItem) {
            [vc performSegueWithIdentifier:@"itemToOrderVC" sender:nil];
        } else{
             [vc performSegueWithIdentifier:@"vcToOrderVC" sender:nil];
        }
    }];
    
    [vc.navigationController pushViewController:paymentViewController animated:YES];
}

@end
