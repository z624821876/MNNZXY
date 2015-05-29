//
//  CateVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/27.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface CateVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSString *cateTitle;
@property (nonatomic, strong) NSString *cateId;
@property (nonatomic, strong) UITableView *tableView;

@end
