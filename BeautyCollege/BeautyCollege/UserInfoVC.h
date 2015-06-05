//
//  UserInfoVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/5.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface UserInfoVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate>


@property (nonatomic, strong) UITableView           *tableView;

@end
