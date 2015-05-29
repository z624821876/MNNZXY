//
//  CommentVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/19.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "CommentVC.h"
#import "OrderCell.h"
#import "MyTextView.h"

@interface CommentVC ()

@end

@implementation CommentVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"评价";
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 40) style:UITableViewStyleGrouped];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    UIView *view = [UIView new];
    _tabelView.tableFooterView = view;
    _tabelView.backgroundColor = [UIColor whiteColor];
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tabelView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH - 20, 230)];
        [img setImage:[[UIImage imageNamed:@"create1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
        [cell.contentView addSubview:img];
        
        OrderCell *view = [[OrderCell alloc] initWithFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH - 20, 120)];
        view.tag = 10;
        [cell.contentView addSubview:view];
        NSLog(@"%f",view.bottom);
        MyTextView *textView = [[MyTextView alloc] initWithFrame:CGRectMake(10, view.bottom, UI_SCREEN_WIDTH - 20, 100)];
        textView.font = [UIFont systemFontOfSize:17];
        textView.tag = 11;
        textView.backgroundColor = [UIColor clearColor];
        textView.placeholder = @"写评论什么的,很重要的说~";
        [cell.contentView addSubview:textView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, textView.bottom + 1.5, UI_SCREEN_WIDTH - 20, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lineView];
    }
 
    BaseCellModel *model = _dataArray[indexPath.section];
    OrderCell *view = (OrderCell *)[cell.contentView viewWithTag:10];
    [view changeDataWithModel:model];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
