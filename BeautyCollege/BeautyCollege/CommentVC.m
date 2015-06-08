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
#import "IQKeyboardManager.h"

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
    [btn addTarget:self action:@selector(confirmComment:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)confirmComment:(UIButton *)btn
{
    [self.view endEditing:YES];
    NSMutableArray *array = [NSMutableArray array];
    for (BaseCellModel *model in _dataArray) {
        NSString *str = [NSString stringWithFormat:@"{\"orderItemId\":\"%@\",\"content\":\"%@\",\"isHidden\": \"%ld\"}",model.modelId,model.content,model.type];
        [array addObject:str];
    }
    NSString *string1 = [array componentsJoinedByString:@","];
    NSString *string2 = [NSString stringWithFormat:@"{\"memberId\":\"%@\", \"param\":[%@]}",[User shareUser].userId,string1];
    NSLog(@"----%@",string2);
    
    NSDictionary *dict = @{@"json":string2};
    NSString *url = [NSString stringWithFormat:@"%@mobi/order/addComments",sBaseUrlStr];
    [[tools shared] HUDShowText:@"正在提交"];

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[tools shared] HUDHide];
        if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDShowHideText:@"评论成功" delay:1.0];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [[tools shared] HUDShowHideText:[responseObject objectForKey:@"message"] delay:1.0];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
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
    btn.selected = model.type == 1;
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
    if (self.view.top < 0) {
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
    }
    BaseCellModel *model = _dataArray[textView.indexPath.section];
    model.content = textView.text;
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(MyTextView *)textView
{
    if ([textView isFirstResponder]) {
//        UITableViewCell *cell = [_tabelView cellForRowAtIndexPath:textView.indexPath];
        
        [_tabelView scrollToRowAtIndexPath:textView.indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        if (textView.indexPath.section == [_dataArray count] - 1 && textView.indexPath.section != 0) {
            CGRect rect = self.view.frame;
            NSLog(@"%f",rect.origin.y);
            rect.origin.y = -180;
            self.view.frame = rect;
        }else {
            CGRect rect = self.view.frame;
            NSLog(@"%f",rect.origin.y);
            rect.origin.y = -100;
            self.view.frame = rect;
        }

//        NSLog(@"%@",NSStringFromCGRect(cell.frame));
//        if (textView.indexPath.section == 0) {
//            CGRect rect = self.view.frame;
//            NSLog(@"%f",rect.origin.y);
//            rect.origin.y = -100;
//            self.view.frame = rect;
//        }else if (textView.indexPath.section == [_dataArray count] - 1) {
//            CGRect rect = self.view.frame;
//            rect.origin.y = -180;
//            self.view.frame = rect;
//        }else {
//        }
        return YES;
    }
        return YES;
}

- (void)btnClick:(MyButton *)btn
{
    BaseCellModel *model = _dataArray[btn.indexPath.section];

    if (model.type == 1) {
        model.type = 0;
    }else {
        model.type = 1;
    }
    
    [_tabelView reloadData];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.view.top < 0) {
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
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
