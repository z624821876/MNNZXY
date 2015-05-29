//
//  ChatVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/19.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"
#import "FaceBoard.h"
#import "MyTextView.h"

@interface ChatVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,FaceBoardDelegate>
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) MyTextView        *textView;
@property (nonatomic, strong) FaceBoard         *faceBoard;
@property (nonatomic, strong) NSString          *userId;

@property (nonatomic, strong) NSString          *name;
@end
