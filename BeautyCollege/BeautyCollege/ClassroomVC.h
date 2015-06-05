//
//  ClassroomVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassroomVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, strong) NSString          *currentLocationId;

@end
