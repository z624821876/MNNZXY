//
//  PayVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/20.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"
#import "UPPayPlugin.h"

@interface PayVC : MyCustomVC<UITextViewDelegate,UPPayPluginDelegate>

@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *orderDate;
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) NSString *orderId;

@end
