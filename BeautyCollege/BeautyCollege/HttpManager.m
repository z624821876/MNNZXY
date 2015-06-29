//
//  HttpManager.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/16.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

+ (HttpManager *)shareManger
{
    static HttpManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HttpManager alloc] init];
    });
    
    return manager;
    
}

- (void)getWithStr:(NSString *)str ComplentionBlock:(Complention)complention Failure:(Failure)failure
{
    NSString *getStr = [NSString stringWithFormat:@"%@%@",sBaseUrlStr,str];
    DDLog(@"requestURL === %@",getStr);
    NSLog(@"%@",getStr);
    NSString *urlStr = [getStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)  {
        complention(operation,operation.responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
        HUDShowErrorServerOrNetwork
    }];
}

+ (void)postWithStr:(NSString *)str parameters:(NSDictionary *)dic ComplentionBlock:(Complention)complention Failure:(Failure)failure
{
    NSString *postStr = [NSString stringWithFormat:@"%@%@",sBaseUrlStr,str];
    DDLog(@"requestURL === %@",postStr);
    NSString *urlStr = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        complention(operation,operation.responseObject);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        failure(operation,error);
//        HUDShowErrorServerOrNetwork
//    }];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFormData:[dic objectForKey:@"Image"] name:@"Image"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        complention(operation,operation.responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
        HUDShowErrorServerOrNetwork
    }];

}

@end
