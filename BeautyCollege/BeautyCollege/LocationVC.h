//
//  LocationVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/6.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"
#import <CoreLocation/CoreLocation.h>

typedef void(^ChangeBlock)(NSString *);

@interface LocationVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CLLocationManager *loctionManager;
@property (nonatomic, copy) ChangeBlock block;

@property (nonatomic, assign) NSInteger    type;

@end
