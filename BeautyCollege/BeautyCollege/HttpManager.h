//
//  HttpManager.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/16.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void(^Complention)(AFHTTPRequestOperation *operation,id json);
typedef void(^Failure)(AFHTTPRequestOperation *operation,NSError *error);


@interface HttpManager : NSObject

@property (nonatomic, copy) Complention complent;
@property (nonatomic, copy) Failure failure;
+ (HttpManager *)shareManger;
- (void)getWithStr:(NSString *)str ComplentionBlock:(Complention)complention Failure:(Failure)failure;
+ (void)postWithStr:(NSString *)str parameters:(NSDictionary *)dic ComplentionBlock:(Complention)complention Failure:(Failure)failure;
@end
