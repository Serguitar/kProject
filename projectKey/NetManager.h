//
//  NetManager.h
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CommonBlock)(id object, NSError *error);


@interface NetManager : NSObject

- (void)loadProductWithEAN:(NSString *)eanStr block:(CommonBlock)block;
- (void)loadPriceWithEAN:(NSString *)eanStr block:(CommonBlock)block;
- (void)sendOrderItems:(NSArray *)items block:(CommonBlock)block;
- (void)checkOrder:(NSString *)orderId block:(CommonBlock)block;

@end
