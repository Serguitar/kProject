//
//  Item.m
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "Item.h"

@implementation Item

+ (instancetype)itemFromDict:(NSDictionary *)dict {
   
    Item *item = [Item new];
    
    item.name = dict[@"name"];
    item.shortDescr = dict[@"description"];
    if (dict[@"ean"]) {
        NSString *str = dict[@"ean"];
        item.ean = str.integerValue;
        NSLog(@"ean = %lu", (unsigned long)item.ean);
    }
    
    NSArray *images = dict[@"images"];
    NSDictionary *imageDict = images.firstObject;
    item.photoLink = imageDict[@"url"];
    if (item.photoLink) {
        item.photoLink = [item.photoLink stringByAppendingString:@"?h=400&w=400&fit=fill"];
    }
    item.quantity = 1;
    
    return item;
}

@end
