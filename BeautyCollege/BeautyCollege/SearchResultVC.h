//
//  SearchResultVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/6/3.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface SearchResultVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, assign) NSInteger     searchtype;
@property (nonatomic, strong) NSString      *keyword;
@property (nonatomic, strong) UITableView   *tableView;
@end
