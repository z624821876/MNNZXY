//
//  LessonsVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/11.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface LessonsVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *lessonsId;
@property (nonatomic, strong) NSString *classCatId;
@end
