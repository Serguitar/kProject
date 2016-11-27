//
//  OrderProgressManager.m
//  projectKey
//
//  Created by Сергей Лукоянов on 27.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "OrderProgressManager.h"
#import "NetManager.h"
#import <UIKit/UIKit.h>

@interface OrderProgressManager () {
    NetManager *netManager;
    NSDictionary *dict;
    NSString *orderId;
    NSTimer *timer;
    BOOL isRestoreMode;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(restoreIfNeeded)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopTimer)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)sendItems:(NSArray *)items {
    [netManager sendOrderItems:items block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        } else {
            NSLog(@"sendItems response = %@",object);
            NSDictionary *d = object;
            if (d[@"orderId"]) {
                orderId = d[@"orderId"];
                [self startCheckingOrder:orderId];
            }
        }
    }];
}

- (void)startCheckingOrder:(NSString *)orderId {
    [[NSUserDefaults standardUserDefaults] setObject:orderId forKey:@"UNCOMPLETE_ORDER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self checkOrder:orderId isRestoringMode:NO];
    }];
}

- (void)checkOrder:(NSString *)ordId isRestoringMode:(BOOL)isRes {
     [netManager checkOrder:ordId block:^(id object, NSError *error) {
         if (error) {
             NSLog(@"%@",error.localizedDescription);
            [self stopTimer];
            [self removeUncompleteOrder];
         } else {
             NSDictionary *d = object;
             if (d[@"status"]) {
                 NSString *status = d[@"status"];
                 
                 if ([status isEqualToString:@"wip"]) {
                     NSLog(@"===wip===");
                     
                 } else if ([status isEqualToString:@"packed"]) {
                     NSLog(@"===packed===");
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDER_PACKED" object:nil];
                 } else if ([status isEqualToString:@"shipped"]) {
                     NSLog(@"===pshipped===");

                     if (isRestoreMode) {
                         NSLog(@"RESTORED_ORDER_SHIPPED sended");
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"RESTORED_ORDER_SHIPPED" object:nil];
                         isRestoreMode = NO;
                     } else {
                         [self stopTimer];
                         [self removeUncompleteOrder];
                     }
                    
                 }
             }
         }
     }];
}

- (void)removeUncompleteOrder {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UNCOMPLETE_ORDER"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)stopTimer {
    NSLog(@"Timer stopped");
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)restoreIfNeeded {
    NSString *ordId = [[NSUserDefaults standardUserDefaults] objectForKey:@"UNCOMPLETE_ORDER"];
    if (ordId) {
        [self checkOrder:ordId isRestoringMode:YES];
        isRestoreMode = YES;
    }
}

@end
