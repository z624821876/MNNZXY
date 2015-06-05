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
#import "MyButton.h"

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
    
    [self buildFootView];

}

- (void)buildFootView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"提交评论" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 40, UI_SCREEN_WIDTH, 40);
    [self.view addSubview:btn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH - 20, 270)];
        [img setImage:[[UIImage imageNamed:@"create1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
        [cell.contentView addSubview:img];
        
        OrderCell *view = [[OrderCell alloc] initWithFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH - 20, 100)];
        view.tag = 10;
        [cell.contentView addSubview:view];
        NSLog(@"%f",view.bottom);
        
        MyTextView *textView = [[MyTextView alloc] initWithFrame:CGRectMake(10, view.bottom, UI_SCREEN_WIDTH - 20, 100)];
        textView.font = [UIFont systemFontOfSize:17];
        textView.tag = 11;
        textView.delegate = self;
        textView.backgroundColor = [UIColor clearColor];
        textView.placeholder = @"写评论什么的,很重要的说~";
        [cell.contentView addSubview:textView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, textView.bottom + 1.5, UI_SCREEN_WIDTH - 20, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:lineView];
        
        MyButton *isAnonymous = [MyButton buttonWithType:UIButtonTypeCustom];
        isAnonymous.frame = CGRectMake(img.left + 15, lineView.bottom + 10, 100, 20);
        [isAnonymous setImage:[UIImage imageNamed:@"reg8.png"] forState:UIControlStateNormal];
        [isAnonymous setImage:[UIImage imageNamed:@"reg9.png"] forState:UIControlStateSelected];
        [isAnonymous setTitle:@"是否匿名" forState:UIControlStateNormal];
        [isAnonymous setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        isAnonymous.tag = 12;
        [isAnonymous addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:isAnonymous];
    }
    BaseCellModel *model = _dataArray[indexPath.section];

    MyButton *btn = (MyButton *)[cell.contentView viewWithTag:12];
    btn.selected = model.type == 2;
    btn.indexPath = indexPath;
    
    MyTextView *textView = (MyTextView *)[cell.contentView viewWithTag:11];
    textView.text = model.content;
    textView.indexPath = indexPath;
    
    OrderCell *view = (OrderCell *)[cell.contentView viewWithTag:10];
    [view changeDataWithModel:model];
    
    return cell;
}

- (BOOL)textViewShouldEndEditing:(MyTextView *)textView
{
    BaseCellModel *model = _dataArray[textView.indexPath.section];
    model.content = textView.text;
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(MyTextView *)textView
{
    if (textView.indexPath.section == 0) {
        CGRect rect = _tabelView.frame;
        rect.origin.y -= 100;
        _tabelView.frame = rect;
    }else if (textView.indexPath.section == [_dataArray count] - 1) {
        CGRect rect = _tabelView.frame;
        rect.origin.y -= 150;
        _tabelView.frame = rect;

    }else {
        
        [_tabelView scrollRectToVisible:CGRectMake(0, 290 * textView.indexPath.section + 120, UI_SCREEN_WIDTH, _tabelView.height) animated:YES];

    }
    return YES;
}

- (void)btnClick:(MyButton *)btn
{
    BaseCellModel *model = _dataArray[btn.indexPath.section];

    if (model.type == 1) {
        model.type = 2;
    }else {
        model.type = 1;
    }
    
    [_tabelView reloadData];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (_tabelView.top < 64) {
        CGRect rect = _tabelView.frame;
        rect.origin.y = 64;
        _tabelView.frame = rect;
    }
    
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
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
