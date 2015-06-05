//
//  BaseCellModel.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/16.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseCellModel : NSObject
@property (strong, nonatomic) NSString          *status;
@property (strong, nonatomic) NSString          *orderNo;
@property (assign, nonatomic) NSInteger         type;
@property (strong, nonatomic) NSString          *productStore;
@property (strong, nonatomic) NSString          *sex;
@property (strong, nonatomic) NSString          *postcode;
@property (strong, nonatomic) NSString          *address;
@property (strong, nonatomic) NSString          *homeworkCount;
@property (strong, nonatomic) NSString          *memberLevel;
@property (strong, nonatomic) NSString          *job;
@property (strong, nonatomic) NSString          *url;
@property (strong, nonatomic) NSString          *name;
@property (strong, nonatomic) NSString          *logo;
@property (strong, nonatomic) NSString          *comment;
@property (strong, nonatomic) NSString          *commentCount;
@property (strong, nonatomic) NSString          *likeCount;
@property (strong, nonatomic) NSString          *city;
@property (strong, nonatomic) NSString          *title;
@property (strong, nonatomic) NSString          *date;
@property (strong, nonatomic) NSString          *price;
@property (strong, nonatomic) NSString          *count;
@property (strong, nonatomic) NSString          *studentCount;
@property (strong, nonatomic) NSString          *modelId;
@property (strong, nonatomic) NSString          *content;
@property (strong, nonatomic) NSString          *detail;
@property (strong, nonatomic) NSString          *lastMessage;
@property (strong, nonatomic) NSString          *discountPrice;
@property (strong, nonatomic) NSString          *mobile;
@property (strong, nonatomic) NSArray           *cateArray;
@property (strong, nonatomic) NSDictionary      *cateDic;
@property (strong, nonatomic) NSString          *level;
@property (strong, nonatomic) NSString          *catId;

    //物流信息
@property (strong, nonatomic) NSString          *express;
@property (strong, nonatomic) NSString          *expressNo;

@property (strong, nonatomic) NSString          *buyedCount;
@property (strong, nonatomic) NSString          *collectId;
@property (strong, nonatomic) NSString          *likeId;
@property (strong, nonatomic) NSString          *collectCount;

@end
