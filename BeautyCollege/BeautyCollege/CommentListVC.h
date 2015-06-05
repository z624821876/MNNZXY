//
//  CommentListVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/6/5.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface CommentListVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSArray       *dataArray;

@end
