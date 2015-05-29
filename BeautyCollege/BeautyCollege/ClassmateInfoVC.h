//
//  ClassmateInfoVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/12.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface ClassmateInfoVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate>

@property (strong ,nonatomic) NSString          *ClassmateId;

@property (strong ,nonatomic) UITableView       *tableView;

@end
