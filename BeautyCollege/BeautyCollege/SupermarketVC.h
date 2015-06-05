//
//  SupermarketVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@interface SupermarketVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MZTimerLabelDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) UITableView *tableView;


@end
