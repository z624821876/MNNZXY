//
//  MoreLessonVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/4.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface MoreLessonVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView       *tableView;

@end
