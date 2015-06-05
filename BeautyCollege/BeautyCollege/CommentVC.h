//
//  CommentVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/19.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface CommentVC : MyCustomVC<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (nonatomic, strong) NSString          *goodsId;
@property (nonatomic, strong) NSArray           *dataArray;
@property (nonatomic, strong) UITableView       *tabelView;

@end
