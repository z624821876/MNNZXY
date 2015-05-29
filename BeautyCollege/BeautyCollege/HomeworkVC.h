//
//  HomeworkVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/21.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface HomeworkVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) NSString      *homeworkId;
@property (nonatomic, strong) BaseCellModel *homworkModel;
@property (nonatomic, strong) UITableView   *tableView;
@end
