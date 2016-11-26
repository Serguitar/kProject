//
//  OrderProgressManager.m
//  projectKey
//
//  Created by Сергей Лукоянов on 27.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "OrderProgressManager.h"
#import "NetManager.h"

@interface OrderProgressManager () {
    NetManager *netManager;
    NSDictionary *dict;
    NSString *orderId;
    NSTimer *timer;
}
@end

@implementation OrderProgressManager

+ (id)sharedInstance {
    static OrderProgressManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OrderProgressManager alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        netManager = [NetManager new];
    }
    return self;
}

- (void)sendItems:(NSArray *)items {
    [netManager sendOrderItems:items block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        } else {
            NSDictionary *d = object;
            if (d[@"orderId"]) {
                orderId = d[@"orderId"];
                [self startCheckingOrder:orderId];
            }
        }
    }];
}

- (void)startCheckingOrder:(NSString *)orderId {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self checkOrder:orderId];
    }];
}

- (void)checkOrder:(NSString *)orderId {
     [netManager checkOrder:orderId block:^(id object, NSError *error) {
         if (error) {
             NSLog(@"%@",error.localizedDescription);
         } else {
             NSDictionary *d = object;
             if (d[@"status"]) {
                 NSString *status = d[@"status"];
                 
                 if ([status isEqualToString:@"wip"]) {
                     NSLog(@"===wip===");
                     
                 } else if ([status isEqualToString:@"packed"]) {
                     NSLog(@"===packed===");
                     [self stopTimer];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_PACKED" object:nil];
                 } else if ([status isEqualToString:@"shipped"]) {
                     NSLog(@"===pshipped===");
                 }
             }
         }
     }];
}

- (void)stopTimer {
    NSLog(@"Timer stopped");
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

@end
