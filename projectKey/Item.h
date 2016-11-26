//
//  Item.h
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Item : NSObject

+ (instancetype)itemFromDict:(NSDictionary *)dict;

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *shortDescr;
@property(nonatomic, assign) NSUInteger ean;
@property(nonatomic, copy) NSString *photoLink;



@property(nonatomic, assign) CGFloat cost;
@property(nonatomic, assign) NSUInteger quantity;

@end
