//
//  OrderProgressManager.h
//  projectKey
//
//  Created by Сергей Лукоянов on 27.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderProgressManager : NSObject

+ (id)sharedInstance;
- (void)sendItems:(NSArray *)items;

@end
