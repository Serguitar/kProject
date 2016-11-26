//
//  NetManager.m
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "NetManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Item.h"

static NSString *const kAPI_LINK = @"http://ktools.store/";

@implementation NetManager

- (AFHTTPRequestOperationManager *)manager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"fi" forHTTPHeaderField:@"accept-language"];
     [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
     [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
     [manager.requestSerializer setValue:@"4bc37a99-049e-4a03-8c35-270810e7e851" forHTTPHeaderField:@"X-IBM-Client-Id"];
     [manager.requestSerializer setValue:@"N1yF3gF4bE6vT1eL3aJ1jT2hH6wI0uV4iX8eJ3xK7tO0lA2jN8" forHTTPHeaderField:@"X-IBM-Client-Secret"];
    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    return manager;
}

- (AFHTTPRequestOperationManager *)manager2 {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    return manager;
}


- (void)loadProductWithEAN:(NSString *)eanStr block:(CommonBlock)block {
    NSString *fullPath = [NSString stringWithFormat:@"https://api.eu.apiconnect.ibmcloud.com/kesko-dev-rauta-api/qa/products/%@",eanStr];
    [self.manager GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

- (void)loadPriceWithEAN:(NSString *)eanStr block:(CommonBlock)block {
    NSString *fullPath = [kAPI_LINK stringByAppendingFormat:@"price/%@",eanStr];
    AFHTTPRequestOperationManager *manager2 = self.manager2;
    manager2.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager2 GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"ean =%@, response =%@",eanStr, responseObject);
        block(responseObject,nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

- (void)sendOrderItems:(NSArray *)items block:(CommonBlock)block {
    NSString *fullPath = [kAPI_LINK stringByAppendingFormat:@"neworder/"];
    NSString *eans = [self stringFromItems:items];
    fullPath = [fullPath stringByAppendingString:eans];
    [self.manager2 GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"eans =%@, response =%@",eans, responseObject);
        block(responseObject,nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

- (void)checkOrder:(NSString *)orderId block:(CommonBlock)block {
    NSString *fullPath = [kAPI_LINK stringByAppendingFormat:@"status/%@",orderId];
    AFHTTPRequestOperationManager *manager2 = self.manager2;
    manager2.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager2 GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    }
   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       block(nil,error);
   }];
}

- (NSString *)stringFromItems:(NSArray *)items {
    NSMutableString *str = [NSMutableString new];
    for (Item *item in items) {
       [str appendFormat:@"%li-%li",item.ean, item.quantity];
        if (item != items.lastObject) {
            [str appendString:@","];
        }
    }
    if (str.length > 0) {
        return str;
    }
    
    return nil;
}

@end
