//
//  NetManager.m
//  projectKey
//
//  Created by Сергей Лукоянов on 26.11.16.
//  Copyright © 2016 Сергей Лукоянов. All rights reserved.
//

#import "NetManager.h"
#import <AFNetworking/AFNetworking.h>

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
    NSString *fullPath = @"http://ktools.store/";
    fullPath = [fullPath stringByAppendingFormat:@"price/%@",eanStr];
    [self.manager2 GET:fullPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

@end
