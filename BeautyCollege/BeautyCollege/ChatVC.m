//
//  ChatVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/19.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "ChatVC.h"
#import "ChatCell.h"
#import "MJRefresh.h"
#import "MyTextAttachment.h"
#import "AFHTTPRequestOperation.h"

@interface ChatVC ()
{
    UIView      *_footView;
    NSMutableArray      *_messageArray;
    NSMutableArray      *_reserveArray;
    UITextView          *_CalculateheightTV;
    BOOL                _stop;
}

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSTimer       *timer;
@end


@implementation ChatVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = _name;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _CalculateheightTV = [[UITextView alloc] init];
    [self.view addSubview:_CalculateheightTV];
    
    [self buildFooterView];
    _currentPage = 1;
    _reserveArray = [NSMutableArray array];
    _messageArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 50) style:UITableViewStylePlain];
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [[tools shared] HUDShowText:@"加载中..."];
        [weakSelf loadData];
    }];
    
    if (!_faceBoard) {
        _faceBoard = [[FaceBoard alloc] init];
        _faceBoard.delegate = self;
        _faceBoard.inputTextView = _textView;
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:YES];
    [_footView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
    [self performSelector:@selector(refreshMessage) withObject:self afterDelay:3];
    [[tools shared] HUDShowText:@"加载中..."];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_footView removeObserver:self forKeyPath:@"frame"];
    
    [_timer invalidate];
    _timer = nil;
    _stop = YES;
}


- (void)refreshMessage
{
    _stop = NO;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_timer invalidate];
        _timer = nil;
        _timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(getMessage) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        while (!_stop) {
            [[NSRunLoop currentRunLoop] run];
        }
    });
}

- (void)getMessage
{
    NSString *str = [NSString stringWithFormat:@"mobi/dialogue/checkMessageIOS?memberId=%@&friendId=%@",[User shareUser].userId,self.userId];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            if ([[json objectForKey:@"result"] integerValue] == 1) {
                _currentPage = 1;
                [self loadData];
            }
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)loadData
{
    NSString *str = [NSString stringWithFormat:@"mobi/dialogue/getMessagePage?memberId=%@&friendId=%@&pageNo=%ld&pageSize=10",[User shareUser].userId,_userId,_currentPage];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        BOOL isNull = NO;;
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            if (_currentPage == 1) {
                [_reserveArray removeAllObjects];
            }
            [_messageArray removeAllObjects];

            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(resultDic, @"data");
            for (NSDictionary *dic in array) {
                isNull = YES;
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.date = [MyTool getValuesFor:dic key:@"ct"];
                model.url = nilOrJSONObjectForKey(dic, @"image");
                model.content = nilOrJSONObjectForKey(dic, @"content");
                model.logo = nilOrJSONObjectForKey(dic, @"img");
                model.status = [MyTool getValuesFor:dic key:@"isMine"];
                [_messageArray addObject:model];
            }
        }else {
            [[tools shared] HUDShowHideText:@"暂无数据" delay:1.5];
        }
        [_tableView.header endRefreshing];
        if (!isNull) {
            _currentPage -=1;
            [_tableView reloadData];
        }else {
            [self sortArray];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_tableView.header endRefreshing];
        _currentPage -= 1;
    }];

}

- (void)sortArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (BaseCellModel *model in _messageArray) {
        if ([_messageArray indexOfObject:model] == 0) {
            [array addObject:model];
            continue;
        }
        BaseCellModel *model2 = [array lastObject];
        CGFloat time1 = [model.date doubleValue] / 1000.0;
        CGFloat time2 = [model2.date doubleValue] / 1000.0;
        
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time2];
        NSTimeInterval aTimer = [date1 timeIntervalSinceDate:date2];
        
//        if (aTimer < 60 * 60 * 24) {
            //小于一天
        if (aTimer < 60 * 5) {
            [array addObject:model];
        }else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
            NSString *time = [formatter stringFromDate:date2];
            [array addObject:time];
            [array addObject:model];
        }
//        }else {
//            NSString *str = @"以上是历史消息";
//            [array addObject:str];
//            [array addObject:model];
//        }
    }
    
//    BaseCellModel *model = [array lastObject];
//    CGFloat time1 = [model.date floatValue] / 1000.0;
//    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1];
//    NSDate *date2 = [NSDate date];
//    NSTimeInterval aTimer = [date2 timeIntervalSinceDate:date1];
    
//    if (aTimer < 60 * 60 * 24) {
        //小于一天
//        if (aTimer >= 60 * 5) {
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
//            NSString *time = [formatter stringFromDate:date1];
//            [array addObject:time];
//        }
//    }else {
//        NSString *str = @"以上是历史消息";
//        [array addObject:str];
//    }
    
    if ([_reserveArray count] > 0) {
        if ([[array lastObject] isKindOfClass:[NSString class]]) {
            [array removeLastObject];
        }
        BaseCellModel *model = [_reserveArray firstObject];
        BaseCellModel *model2 = [array lastObject];
        CGFloat interval1 = [model.date floatValue] / 1000.0;
        CGFloat interval2 = [model2.date floatValue] / 1000.0;
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:interval1];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:interval2];
        NSTimeInterval Timer = [date1 timeIntervalSinceDate:date2];
//        if (Timer < 60 * 60 * 24) {
            //小于一天
        if (Timer >= 60 * 5) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
            NSString *time = [formatter stringFromDate:date2];
            [array addObject:time];
        }
//        }else {
//            NSString *str = @"以上是历史消息";
//            [array addObject:str];
//        }

    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_reserveArray];
    [_reserveArray removeAllObjects];
    [_reserveArray addObjectsFromArray:array];
    [_reserveArray addObjectsFromArray:arr];
    
    
    if ([[_reserveArray lastObject] isKindOfClass:[NSString class]]) {
        [_reserveArray removeLastObject];
    }
    BaseCellModel *lastModel = [_reserveArray lastObject];
    CGFloat lastTime = [lastModel.date doubleValue] / 1000.0;
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:lastTime];
    NSTimeInterval lastTimer = [[NSDate date] timeIntervalSinceDate:lastDate];
    if (lastTimer >= 60 * 60 * 24) {
        NSString *string = @"以上是历史消息";
        [_reserveArray addObject:string];
    }
    
    [_tableView reloadData];
    if (_currentPage == 1) {
        
        if ([_reserveArray count] > 0) {
            
            NSIndexPath *index = [NSIndexPath indexPathForRow:[_reserveArray count] - 1 inSection:0];
            [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];

        }

    }else {
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];

    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_reserveArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    id model = _reserveArray[indexPath.row];
    if ([model isKindOfClass:[NSString class]]) {
        cell.date = model;
    }else {
        cell.date = nil;
        cell.model = model;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = _reserveArray[indexPath.row];
    if ([data isKindOfClass:[NSString class]]) {
        return 40;
    }
    
    CGFloat labelMaxWidth = UI_SCREEN_WIDTH - (75 * 2.0) - 10;
    BaseCellModel *model = (BaseCellModel *)data;
    if (model.url != nil && model.url.length > 0) {
        return labelMaxWidth + 10 + 30;
    }
    
//    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//    NSMutableAttributedString *string = [MyTool textTransformEmoji:model.content];
//    
//    CGSize size = [string boundingRectWithSize:CGSizeMake(labelMaxWidth, MAXFLOAT) options:options  context:nil].size;
//    CGSize size2 = [model.content boundingRectWithSize:CGSizeMake(labelMaxWidth, MAXFLOAT) options:options attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil].size;
    
//    if (size.height > size2.height) {
//        labelSize = size;
//    }else {
//        labelSize = size2;
//    }
    
    NSMutableAttributedString *string = [MyTool textTransformEmoji:model.content];
    _CalculateheightTV.attributedText = string;
    _CalculateheightTV.font = [UIFont systemFontOfSize:17];
    CGSize labelSize = [_CalculateheightTV sizeThatFits:CGSizeMake(labelMaxWidth, MAXFLOAT)];
    return labelSize.height + 40;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGRect rect3 = _tableView.frame;
    rect3.size.height = _footView.top - 64;
    _tableView.frame = rect3;
    NSIndexPath *index = [NSIndexPath indexPathForRow:[_reserveArray count] - 1 inSection:0];
    [_tableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    _textView.inputView = nil;
    [_textView resignFirstResponder];
}

- (void)textViewDidChange:(MyTextView *)textView
{
    
}


- (void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
//    UIKeyboardAnimationCurveUserInfoKey = 7;
//    UIKeyboardAnimationDurationUserInfoKey = "0.25";
//    UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 252}}";
//    UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 559}";
//    UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 541}";
//    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 451}, {375, 216}}";
//    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 415}, {375, 252}}";
    
    [UIView animateWithDuration:[[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [UIView setAnimationCurve:[[dic objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        CGRect rect = _footView.frame;
        CGRect rect2 = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        rect.origin.y = rect2.origin.y - 50;
        _footView.frame = rect;
    }];
    
}

- (void)buildFooterView
{
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 50, UI_SCREEN_WIDTH, 50)];
    [self.view addSubview:_footView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 50)];
    [img setImage:[UIImage imageNamed:@"address_top.png"]];
    [_footView addSubview:img];
    
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBtn.frame = CGRectMake(10, 10, 30, 30);
    [faceBtn setImage:[UIImage imageNamed:@"表情按钮.png"] forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(faceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:faceBtn];
    
    UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imgBtn.frame = CGRectMake(faceBtn.right + 10, 10, 30, 30);
    [imgBtn setImage:[UIImage imageNamed:@"图片按钮.png"] forState:UIControlStateNormal];
    [imgBtn addTarget:self action:@selector(imgBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:imgBtn];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(_footView.right - 50, 10, 40, 30);
    [sendBtn setImage:[UIImage imageNamed:@"msg_03_07.png"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:sendBtn];
    
    _textView = [[MyTextView alloc] initWithFrame:CGRectMake(imgBtn.right + 5, 10, sendBtn.left - imgBtn.right - 10, 30)];
    _textView.layer.cornerRadius = 5;
    _textView.layer.masksToBounds = YES;
    _textView.font = [UIFont systemFontOfSize:15];
    [_footView addSubview:_textView];
}

- (void)sendMessage:(UIButton *)btn
{
    _textView.inputView = nil;
    [_textView resignFirstResponder];

    if (_textView.text.length <= 0) {
        return;
    }
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    [titleStr enumerateAttributesInRange:NSMakeRange(0, titleStr.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if ([[attrs objectForKey:@"NSAttachment"] isKindOfClass:[MyTextAttachment class]]) {
            MyTextAttachment *textAttachment = (MyTextAttachment *)[attrs objectForKey:@"NSAttachment"];
            [titleStr replaceCharactersInRange:range withString:textAttachment.imgName];
        }
    }];
    
    NSMutableAttributedString *contenStr = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
    [contenStr enumerateAttributesInRange:NSMakeRange(0, contenStr.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if ([[attrs objectForKey:@"NSAttachment"] isKindOfClass:[MyTextAttachment class]]) {
            MyTextAttachment *textAttachment = (MyTextAttachment *)[attrs objectForKey:@"NSAttachment"];
            [contenStr replaceCharactersInRange:range withString:textAttachment.imgName];
        }
    }];

    _textView.text = @"";
    [self sendWithContent:contenStr.string Type:1];
}

- (void)sendWithContent:(NSString *)string Type:(NSInteger)type
{
    NSString *str;
    if (type == 1) {
       str = [NSString stringWithFormat:@"mobi/dialogue/sendMessage?memberId=%@&friendId=%@&content=%@",[User shareUser].userId,self.userId,string];
    }else {
        str = [NSString stringWithFormat:@"mobi/dialogue/sendMessage?memberId=%@&friendId=%@&image=%@",[User shareUser].userId,self.userId,string];
    }
    
    [[tools shared] HUDShowText:@"发送中..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            _currentPage = 1;
            [[tools shared] HUDShowText:@"加载中..."];
            [self loadData];
        }else {
            [[tools shared] HUDShowHideText:@"发送失败" delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];

}

- (void)faceBtnClick:(UIButton *)btn
{
    if ([_textView isFirstResponder]) {
        if ([_textView.inputView isEqual:_faceBoard]) {
            _textView.inputView = nil;
            [_textView resignFirstResponder];
        }else {
            [_textView resignFirstResponder];
            _textView.inputView = _faceBoard;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_textView becomeFirstResponder];
            });
        }
    }else {
        _textView.inputView = _faceBoard;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_textView becomeFirstResponder];
        });

    }
}

- (void)imgBtnClick
{
    _textView.inputView = nil;
    [_textView resignFirstResponder];
    
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    [sheet showInView:self.view];
    
}

#pragma mark - actionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            //拍照
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            //判断相机是否可用
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                pickerImage.sourceType = sourceType;
                pickerImage.delegate = self;
//                pickerImage.allowsEditing = YES;
                [self presentViewController:pickerImage animated:YES completion:nil];
                
            }else {
                [[tools shared] HUDShowHideText:@"相机不可用" delay:1.5];
            }
            
        }
            break;
        case 1:
        {
            //从相册获取
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            //判断相册是否可用
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                
            }
            pickerImage.delegate = self;
//            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSData *data = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.1);
    [[tools shared] HUDShowText:@"正在上传..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://nzxyadmin.53xsd.com/mobi/ser/saveImage" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"Image" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0)  {
            NSDictionary *dic = nilOrJSONObjectForKey(responseObject, @"result");
            NSString *logo = nilOrJSONObjectForKey(dic, @"imageUrl");
            [self sendWithContent:logo Type:2];
        }else {
            [[tools shared] HUDShowHideText:@"上传失败" delay:1.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
