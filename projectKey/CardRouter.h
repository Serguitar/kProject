//
//  CardRouter.h
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CardRouter : NSObject

+ (void)showCardOnVC:(UIViewController *)vc fromItem:(BOOL)fromItem price:(NSString *)price;

@end
