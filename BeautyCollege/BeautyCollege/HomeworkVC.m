//
//  HomeworkVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/21.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "HomeworkVC.h"
#import "KL_ImagesZoomController.h"
#import "ReturncardVC.h"
#import <CoreText/CoreText.h>
#import "MJRefresh.h"

@interface HomeworkVC ()
{
    UIImageView             *_logo;
    UILabel                 *_titleLabel;
    UILabel                 *_timeLabel;
    UIView                  *_markView;
    UIButton                *_currentBtn;
    BaseCellModel           *_homeworkInfo;
    NSMutableArray          *_likeArray;
    NSMutableArray          *_commentArray;
    UIButton                *_likeCountBtn;
    UIButton                *_collectionBtn;
    
    UIImage                 *_saveImg;
    UITextView              *_textView;
}
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation HomeworkVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _currentPage = 1;
    _likeArray = [NSMutableArray array];
    _homeworkInfo = [[BaseCellModel alloc] init];
    _commentArray = [NSMutableArray array];
    [self buildTopView];
    [self buildFootView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 177, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 177 - 40) style:UITableViewStyleGrouped];
    UIView *view = [UIView new];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = view;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    _tableView.tableHeaderView = view1;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
        //计算高度
    _textView = [[UITextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:_textView];


}

- (void)buildFootView
{
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 40, UI_SCREEN_WIDTH, 40)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    CGFloat width = UI_SCREEN_WIDTH / 4.0;
    for (NSInteger i = 0; i < 4; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width * i, 0, width, 40);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 1 || i == 2) {
            [btn setTitle:@"0" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0 );
        }
        NSString *str = [NSString stringWithFormat:@"20-创建课堂-点击效果_0%ld.png",i + 1];
        [btn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
        [footView addSubview:btn];
        if (i == 1) {
            _likeCountBtn = btn;
            [_likeCountBtn setImage:[UIImage imageNamed:@"homework-0.1.png"] forState:UIControlStateSelected];
        }
        if (i == 2) {
            _collectionBtn = btn;
            [_collectionBtn setImage:[UIImage imageNamed:@"homework-0.2.png"] forState:UIControlStateSelected];
        }
    }
}

- (void)btnClick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        {
            ReturncardVC *vc = [[ReturncardVC alloc] init];
            vc.homeworkId = self.homeworkId;
            vc.commentTitle = @"评论";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            NSString *string = [NSString stringWithFormat:@"mobi/class/addLike?memberId=%@&blogId=%@",[User shareUser].userId,_homeworkId];
            [[HttpManager shareManger] getWithStr:string ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
                if ([[json objectForKey:@"code"] integerValue] == 0) {
                    _currentPage = 1;

//                    NSInteger x;
                    if ([_homworkModel.likeId isEqualToString:@"0"]) {
                        _homworkModel.likeId = @"1";
//                        _likeCountBtn.selected = YES;
//                        x = 1;
                    }else {
                        _homworkModel.likeId = @"0";
//                        _likeCountBtn.selected = NO;
//                        x = -1;
                    }
                    [self loadData];

//                    NSInteger count = _likeCountBtn.currentTitle.integerValue;
//                    [_likeCountBtn setTitle:[NSString stringWithFormat:@"%ld",count + x] forState:UIControlStateNormal];
                }else {
                    [[tools shared] HUDShowHideText:@"操作失败" delay:1.5];
                }
                
            } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
        }
            break;
        case 2:
        {
            NSString *string = [NSString stringWithFormat:@"mobi/class/addFavourite?memberId=%@&blogId=%@",[User shareUser].userId,_homeworkId];
            [[HttpManager shareManger] getWithStr:string ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
                if ([[json objectForKey:@"code"] integerValue] == 0) {
                    _currentPage = 1;
//                    NSInteger x;
                    if ([_homworkModel.collectId isEqualToString:@"0"]) {
                        _homworkModel.collectId = @"1";
//                        _collectionBtn.selected = YES;
//                        x = 1;
                    }else {
                        _homworkModel.collectId = @"0";
//                        _collectionBtn.selected = NO;
//                        x = -1;
                    }
                    [self loadData];

//                    NSInteger count = _collectionBtn.currentTitle.integerValue;
//                    [_collectionBtn setTitle:[NSString stringWithFormat:@"%ld",count + x] forState:UIControlStateNormal];
                }else {
                    [[tools shared] HUDShowHideText:@"操作失败" delay:1.5];
                }
                
            } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
        }
            break;
        case 3:
        {
            NSString *str = [NSString stringWithFormat:@"%@mobi/class/getHomeworkLink?blogId=%@",sBaseUrlStr,self.homeworkId];
            //分享
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"美娘女子学院";
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"美娘女子学院";
            [UMSocialData defaultData].extConfig.wechatSessionData.url = str;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = str;
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"54c7576ffd98c5acfd0007ce"
                                              shareText:str
                                             shareImage:[UIImage imageNamed:@"icon.png"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                               delegate:self];

        
        }
            break;

        default:
            break;
    }
    
}

- (void)buildTopView
{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 137)];
    [img setImage:[UIImage imageNamed:@"a.png"]];
    [self.view addSubview:img];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake((UI_SCREEN_WIDTH - 150) / 2.0, 20, 150, 44);
    label.text = @"作业";
    label.font = [UIFont boldSystemFontOfSize:22];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 26, 30, 30);
    [backBtn setImage:[UIImage imageNamed:@"back_03.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _logo = [[UIImageView alloc] initWithFrame:CGRectMake(backBtn.right + 10, backBtn.bottom + 5, 70, 70)];
    _logo.layer.borderColor = [UIColor whiteColor].CGColor;
    _logo.layer.borderWidth = 2;
    _logo.layer.cornerRadius = 35;
    _logo.layer.masksToBounds = YES;
    [_logo setImage:[UIImage imageNamed:@"default_avatar.png"]];
    [self.view addSubview:_logo];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logo.right + 10, _logo.top, UI_SCREEN_WIDTH - _logo.right - 20, 60)];
    _titleLabel.numberOfLines = 3;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(img.right - 150, img.bottom - 20, 140, 20)];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_timeLabel];
    
    UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake(0, img.bottom, UI_SCREEN_WIDTH, 40)];
    optionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:optionView];
    
    NSArray *array = @[@"正文",@"评论"];
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * UI_SCREEN_WIDTH / 2.0, 0, UI_SCREEN_WIDTH / 2.0, 40);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = i;
        if (i == 0) {
            btn.selected = YES;
            _currentBtn = btn;
        }
        [btn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
        [optionView addSubview:btn];
    }
    
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 37, UI_SCREEN_WIDTH / 2.0, 3)];
    _markView.backgroundColor = BaseColor;
    [optionView addSubview:_markView];
}

- (void)changeOption:(UIButton *)btn
{
    
    if (btn.selected) {
        return;
    }
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
    
    CGRect rect = _markView.frame;
    rect.origin.x = btn.left;
    _markView.frame = rect;
    
    if (btn.tag == 0) {
        [_tableView removeHeader];
        [_tableView removeFooter];
    }else {
        __weak typeof(self) weakSelf = self;
        [_tableView addLegendHeaderWithRefreshingBlock:^{
            weakSelf.currentPage = 1;
            [weakSelf loadData];
        }];
        
        [_tableView addLegendFooterWithRefreshingBlock:^{
            weakSelf.currentPage += 1;
            [weakSelf loadData];
        }];
    }
    
        
    [_tableView reloadData];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadData];
}

- (void)loadData
{
    [[tools shared] HUDShowText:@"正在加载..."];
//    self.homeworkId = @"780";
    NSString *str = [NSString stringWithFormat:@"mobi/class/getHomeworkDetail?blogId=%@&pageNo=%ld&pageSize=20",self.homeworkId,_currentPage];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        BOOL isNull = YES;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_likeArray removeAllObjects];
            if (_currentPage == 1) {
                [_commentArray removeAllObjects];
            }
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSDictionary *blogDic = nilOrJSONObjectForKey(resultDic, @"blog");
            NSDictionary *memberDic = nilOrJSONObjectForKey(resultDic, @"member");
            NSArray *likeListarray = nilOrJSONObjectForKey(resultDic, @"likeList");
            NSArray *replyListarray = nilOrJSONObjectForKey(resultDic, @"replyList");
            NSArray *blogImages = nilOrJSONObjectForKey(resultDic, @"blogImages");
            _homeworkInfo.content = nilOrJSONObjectForKey(resultDic, @"content");
            NSNumber *timeNum = nilOrJSONObjectForKey(blogDic, @"ct");
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeNum floatValue] / 1000.0];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy/MM/dd"];
            _homeworkInfo.date = [format stringFromDate:date];
            _homeworkInfo.title = nilOrJSONObjectForKey(blogDic, @"title");
            _homeworkInfo.likeCount = [MyTool getValuesFor:blogDic key:@"objId1"];
            _homeworkInfo.collectCount = [MyTool getValuesFor:blogDic key:@"field1"];
            _homeworkInfo.logo = nilOrJSONObjectForKey(memberDic, @"logo");
            _homeworkInfo.modelId = nilOrJSONObjectForKey(blogDic, @"id");
            NSMutableArray *imgsARR = [NSMutableArray array];
            for (NSDictionary *imgdic in blogImages) {
                NSString *str = nilOrJSONObjectForKey(imgdic, @"image");
                [imgsARR addObject:str];
            }
            _homeworkInfo.cateArray = imgsARR;

            for (NSDictionary *likeDic in likeListarray) {
                NSString *str = [likeDic objectForKey:@"logo"];
                [_likeArray addObject:str];
            }
            
            for (NSDictionary *commentDic in replyListarray) {
                isNull = NO;
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(commentDic, @"id");
                model.logo = nilOrJSONObjectForKey(commentDic, @"logo");
                model.name = nilOrJSONObjectForKey(commentDic, @"nickName");
                model.catId = [MyTool getValuesFor:commentDic key:@"teacherId"];
                NSString *content = nilOrJSONObjectForKey(commentDic, @"content");
                NSString *nickeNameOR = nilOrJSONObjectForKey(commentDic, @"nickNameOR");
                NSString *content2;
                if (nickeNameOR) {
                    content2 = [NSString stringWithFormat:@"@%@:%@",nickeNameOR,content];
                }else {
                    content2 = content;
                }
                model.content = content2;
                NSNumber *timeNum = nilOrJSONObjectForKey(commentDic, @"createTime");
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeNum floatValue] / 1000.0];
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"yyyy/MM/dd"];
                model.date = [format stringFromDate:date];
                NSString *imgUrl = nilOrJSONObjectForKey(commentDic, @"img");
                model.cateArray = [imgUrl componentsSeparatedByString:@","];
                [_commentArray addObject:model];
            }
        }else {
            [[tools shared] HUDShowHideText:@"加载失败" delay:1.5];
        }
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        [self updateGUI];

    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[tools shared] HUDHide];
        if ([_tableView.header isRefreshing]) {
            [_tableView.header endRefreshing];
        }else {
            [_tableView.footer endRefreshing];
        }
        _currentPage -= 1;
    }];
}

- (void)updateGUI
{
    [MyTool setImgWithURLStr:_homeworkInfo.logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:_logo];
    
    _titleLabel.attributedText = [MyTool textTransformEmoji:_homeworkInfo.title];
    _timeLabel.text = _homeworkInfo.date;

    _likeCountBtn.selected = [_homworkModel.likeId floatValue] > 0 ? YES : NO;
    [_likeCountBtn setTitle:_homeworkInfo.likeCount forState:UIControlStateNormal];
    
    NSString *str = _homeworkInfo.collectCount;
    if (!str) {
        str = 0;
    }
    _collectionBtn.selected = [_homworkModel.collectId floatValue] > 0 ? YES : NO;
    [_collectionBtn setTitle:str forState:UIControlStateNormal];
    [_tableView reloadData];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    if (_block) {
        _block();
    }
}

#pragma tableView  delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        return [_homeworkInfo.cateArray count] + 1;
    }else {
        return [_commentArray count] + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_currentBtn.tag == 0) {
        if (indexPath.row == 0) {
//            NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//
//            NSMutableAttributedString *string = [MyTool textTransformEmoji:_homeworkInfo.content];
////            [string setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string.length)];
//            CGSize size = [string boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, MAXFLOAT) options:options  context:nil].size;
//            CGSize size2 = [_homeworkInfo.content boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 20, MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
//            CGFloat heigth; 
//            if (size.height > size2.height) {
//                heigth = size.height;
//            }else {
//                heigth = size2.height;
//            }
            
            NSMutableAttributedString *string = [MyTool textTransformEmoji:_homeworkInfo.content];
            _textView.attributedText = string;
            _textView.font = [UIFont systemFontOfSize:17];
            CGFloat height = [_textView sizeThatFits:CGSizeMake(UI_SCREEN_WIDTH - 20, MAXFLOAT)].height;

            //    [string setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string.length)];
            //
            //    if (string.length <= 0) {
            //        return;
            //    }
//            _textView.frame = CGRectMake(0, 64, UI_SCREEN_WIDTH - 20, height);
//            NSLog(@"%f",height);
//            NSMutableAttributedString *string = [MyTool textTransformEmoji:_homeworkInfo.content];
//            [string setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, string.length)];
//            _textView.attributedText = string;
//            _textView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH - 20, 100);
//            
//            CGFloat heigth = [_textView sizeThatFits:CGSizeMake(UI_SCREEN_WIDTH - 20, MAXFLOAT)].height;
            return height + 10;
        }else {
            return UI_SCREEN_WIDTH - 20 + 20;
        }
    }else {
        
        if (indexPath.row == 0) {
            return 50 + (UI_SCREEN_WIDTH - 80) / 7.0;
        }else {
            BaseCellModel *model = _commentArray[indexPath.row - 1];
            CGFloat width = (UI_SCREEN_WIDTH - 80) / 7.0;
//            NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//            NSMutableAttributedString *string = [MyTool textTransformEmoji:model.content];
//            CGSize size = [string boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - width - 30, MAXFLOAT) options:options  context:nil].size;
//            CGSize size2 = [model.content boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - width - 30, MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
//            CGFloat heigth;
//            if (size.height > size2.height) {
//                heigth = size.height + 5;
//            }else {
//                heigth = size2.height + 5;
//            }
            
            NSMutableAttributedString *string = [MyTool textTransformEmoji:model.content];
            _textView.attributedText = string;
            _textView.font = [UIFont systemFontOfSize:17];
            CGFloat height = [_textView sizeThatFits:CGSizeMake(UI_SCREEN_WIDTH - 20, MAXFLOAT)].height;

            CGFloat imgWidth = (UI_SCREEN_WIDTH - width - 50) / 3.0;
            CGFloat imgMaxHeight = 10 + ([model.cateArray count] + 2) / 3 * (imgWidth + 10);
            CGFloat cellHeight;
            
            if ([model.cateArray count] <= 0) {
                cellHeight = 40 + height + 10;
            }else {
                cellHeight = 40 + height + imgMaxHeight + 10;
            }
            if (cellHeight > width + 20) {
                return cellHeight;
            }else {
                return width + 20;
            }
        }
    }

    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (_currentBtn.tag == 0) {
        
        BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
        if (!cell) {
            cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if (indexPath.row == 0) {
            cell.title = _homeworkInfo.content;
            cell.type = 34;
        }else {
            cell.title = _homeworkInfo.cateArray[indexPath.row - 1];
            cell.type = 35;
            cell.img1.userInteractionEnabled = YES;
            for (UIGestureRecognizer *gr in cell.img1.gestureRecognizers) {
                [cell.img1 removeGestureRecognizer:gr];
            }
            cell.img1.tag = indexPath.row;
            UILongPressGestureRecognizer *longpressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImg:)];
            [cell.img1 addGestureRecognizer:longpressGR];
        }
        return cell;
    }else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"comment"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
        }else {
            for (UIView *view in cell.contentView.subviews) {
                [view removeFromSuperview];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.row == 0) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 10, UI_SCREEN_WIDTH - 20, 20);
            [btn setImage:[UIImage imageNamed:@"zuoye-xin.png"] forState:UIControlStateNormal];
            [btn setTitle:@"喜欢这篇文章的有" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [cell.contentView addSubview:btn];

            CGFloat width = (UI_SCREEN_WIDTH - 80) / 7.0;
            NSInteger index;
            if ([_likeArray count] <= 6) {
                index = [_likeArray count];
            }else {
                index = 6;
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (width + 10) * 6, btn.bottom + 10, width, width)];
                [img setImage:[UIImage imageNamed:@"more.png"]];
                img.contentMode = UIViewContentModeScaleAspectFit;
                [cell.contentView addSubview:img];
            }
            for (NSInteger i = 0; i < index; i ++) {
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (width + 10) * i, btn.bottom + 10, width, width)];
                [MyTool setImgWithURLStr:[_likeArray objectAtIndex:i] withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:img];
                img.layer.cornerRadius = width / 2.0;
                img.layer.masksToBounds = YES;
                [cell.contentView addSubview:img];
            }
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + (UI_SCREEN_WIDTH - 80) / 7.0 - 0.5, UI_SCREEN_WIDTH, 0.5)];
            lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
            [cell.contentView addSubview:lineView];
        }else {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            CGFloat width = (UI_SCREEN_WIDTH - 80) / 7.0;

            BaseCellModel *model = _commentArray[indexPath.row - 1];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [MyTool setBtnImgWithURLStr:model.logo withplaceholderImage:[UIImage imageNamed:@"default_avatar.png"] withImgView:btn];
            btn.frame = CGRectMake(10, 10, width, width);
            btn.layer.cornerRadius = width / 2.0;
            btn.layer.masksToBounds = YES;
            [cell.contentView addSubview:btn];
            
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 80, 10, 70, 20)];
            dateLabel.text = model.date;
            dateLabel.font = [UIFont systemFontOfSize:13];
            dateLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:dateLabel];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            if ([model.catId integerValue] == [[User shareUser].userId integerValue]) {
                UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                deleteBtn.frame = CGRectMake(dateLabel.left - 30, dateLabel.top, 20, 20);
                [deleteBtn setImage:[UIImage imageNamed:@"ico_dustbin.png"] forState:UIControlStateNormal];
                deleteBtn.tag = indexPath.row;
                [deleteBtn addTarget:self action:@selector(deleteComment:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:deleteBtn];
                titleLabel.frame = CGRectMake(btn.right + 10, 10, deleteBtn.left - btn.right - 20, 20);
            }else {
                titleLabel.frame = CGRectMake(btn.right + 10, 10, dateLabel.left - btn.right - 20, 20);
            }
            
            titleLabel.text = model.name;
            [cell.contentView addSubview:titleLabel];
            
//            NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//            NSMutableAttributedString *string = [MyTool textTransformEmoji:model.content];
//            CGSize size = [string boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - btn.right - 20, MAXFLOAT) options:options  context:nil].size;
//            CGSize size2 = [model.content boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - btn.right - 20, MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
//            CGFloat heigth;
//            if (size.height > size2.height) {
//                heigth = size.height + 5;
//            }else {
//                heigth = size2.height + 5;
//            }
            NSMutableAttributedString *string = [MyTool textTransformEmoji:model.content];
            _textView.attributedText = string;
            _textView.font = [UIFont systemFontOfSize:17];
            CGFloat height = [_textView sizeThatFits:CGSizeMake(UI_SCREEN_WIDTH - 20, MAXFLOAT)].height;

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(btn.right + 10, titleLabel.bottom + 10, UI_SCREEN_WIDTH - btn.right - 20, height)];
//            label.font = [UIFont systemFontOfSize:15];
            label.numberOfLines = 0;
            label.attributedText = [MyTool textTransformEmoji:model.content];
            label.adjustsFontSizeToFitWidth = YES;
            [cell.contentView addSubview:label];
            
            CGFloat imgWidth = (UI_SCREEN_WIDTH - btn.right - 40) / 3.0;
            for (NSString *imgUrl in model.cateArray) {
                NSInteger index = [model.cateArray indexOfObject:imgUrl];
                NSInteger x = index % 3;
                NSInteger y = index / 3;
                UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                imgBtn.tag = index;
                [imgBtn setTitle:[NSString stringWithFormat:@"%ld",indexPath.row] forState:UIControlStateNormal];
                [imgBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [imgBtn addTarget:self action:@selector(browseImg:) forControlEvents:UIControlEventTouchUpInside];
                imgBtn.frame = CGRectMake(btn.right + 10 + (imgWidth + 10) * x, label.bottom + 10 + (imgWidth + 10) * y, imgWidth, imgWidth);
                [MyTool setBtnImgWithURLStr:imgUrl withplaceholderImage:nil withImgView:imgBtn];
                [cell.contentView addSubview:imgBtn];
            }
            CGFloat cellHeight = label.bottom + ([model.cateArray count] + 2) / 3 * (imgWidth + 10);
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight + 9.5, UI_SCREEN_WIDTH, 0.5)];
            if (cellHeight > width + 20) {
                
                lineView.frame = CGRectMake(0, cellHeight + 9.5, UI_SCREEN_WIDTH, 0.5);
            }else {
                
                lineView.frame = CGRectMake(0, btn.bottom + 9.5, UI_SCREEN_WIDTH, 0.5);
            }
            lineView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.5];
            [cell.contentView addSubview:lineView];
            
        }
        
        return cell;
    }
}

    //删除作业
- (void)deleteComment:(UIButton *)btn
{
    BaseCellModel *model = _commentArray[btn.tag - 1];

    NSString *str = [NSString stringWithFormat:@"mobi/class/deleteReply?replyId=%@",model.modelId];
    [[tools shared] HUDShowText:@"正在删除..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {

        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDShowHideText:@"删除成功" delay:1.0];
            _currentPage = 1;
            [self loadData];
        }else {
            [[tools shared] HUDShowHideText:@"操作失败" delay:1.0];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_currentBtn.tag == 1) {
        if (indexPath.row != 0) {
            BaseCellModel *model = _commentArray[indexPath.row - 1];
            ReturncardVC *vc = [[ReturncardVC alloc] init];
            vc.homeworkId = _homeworkId;
            vc.replyId = model.modelId;
            vc.type = 2;
            vc.commentTitle = @"评论";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)saveImg:(UIGestureRecognizer *)GR
{
    UIImageView *view = (UIImageView *)GR.view;
    _saveImg = view.image;
    [view removeGestureRecognizer:GR];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UILongPressGestureRecognizer *longpressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImg:)];
        [view addGestureRecognizer:longpressGR];

    });
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        UIImageWriteToSavedPhotosAlbum(_saveImg, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

// 指定回调方法
- (void)image: (UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error == NULL){
        [[tools shared] HUDShowHideText:@"图片保存成功" delay:1.5] ;
    }else{
        [[tools shared] HUDShowHideText:@"图片保存失败" delay:1.5] ;
    }
}

- (void)browseImg:(UIButton *)btn
{
    NSInteger index = [btn.currentTitle integerValue];
    BaseCellModel *model = _commentArray[index - 1];
    KL_ImagesZoomController *img = [[KL_ImagesZoomController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )imgViewSize:CGSizeZero];
    [self.view addSubview:img];
    [img updateImageDate:model.cateArray selectIndex:btn.tag];
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
