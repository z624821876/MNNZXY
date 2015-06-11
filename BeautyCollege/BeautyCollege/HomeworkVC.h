//
//  HomeworkVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/21.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"
typedef void(^UpdateBlock)();

@interface HomeworkVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UMSocialUIDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSString      *homeworkId;
@property (nonatomic, strong) BaseCellModel *homworkModel;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSString      *logoUrl;

@property (copy, nonatomic) UpdateBlock block;

@end
