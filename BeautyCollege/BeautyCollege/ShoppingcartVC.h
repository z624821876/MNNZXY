//
//  ShoppingcartVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/23.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface ShoppingcartVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
