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
         item.ean = dict[@"ean"];
    }
    
    NSArray *images = dict[@"images"];
    NSDictionary *imageDict = images.firstObject;
    item.photoLink = imageDict[@"url"];
    item.quantity = 1;
    
    return item;
}

@end
