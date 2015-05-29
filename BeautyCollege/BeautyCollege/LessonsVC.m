//
//  LessonsVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/11.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "LessonsVC.h"
#import "DoHomeworkVC.h"
#import "ClassmateInfoVC.h"
#import "HomeworkVC.h"

#define NUMBERS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

@interface LessonsVC ()

@property (nonatomic, assign) NSInteger     currentPage;
@property (nonatomic, strong) NSString      *title;
@property (nonatomic, strong) NSString      *todayWorkCount;
@property (nonatomic, strong) NSString      *creatName;
@property (nonatomic, strong) NSString      *level;
@property (nonatomic, strong) NSString      *logo;

@property (nonatomic, strong) NSString      *studentCount;
@property (nonatomic, strong) NSString      *homeworkCount;
@property (nonatomic, strong) NSString      *recHomeworkCount;

@property (nonatomic, strong) UIImageView   *logoImg;
@property (nonatomic, strong) UILabel       *titleLable;
@property (nonatomic, strong) UILabel       *numLable;
@property (nonatomic, strong) UIButton      *levelBtn;

@property (nonatomic, strong) NSMutableArray    *labelArray;
@property (nonatomic, strong) UIView            *lineView;
@property (nonatomic, strong) UIButton          *currentBtn;
@property (nonatomic, strong) NSMutableArray    *allDataArr;

@property (nonatomic, strong) NSMutableDictionary   *dataDic;
@property (nonatomic, strong) NSMutableArray        *allKeys;

@property (nonatomic, strong) UIButton      *defualtBtn;

@property (nonatomic, strong) UILongPressGestureRecognizer *longpressGR;

@end

@implementation LessonsVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.view.backgroundColor = ColorWithRGBA(218.0, 225.0, 227.0, 1);
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentPage = 1;
    _allDataArr = [[NSMutableArray alloc] init];
    _allKeys = [[NSMutableArray alloc] init];
    _dataDic = [[NSMutableDictionary alloc] init];
    
    [self buildTopView];
    
    [self loadLessonsInfo];
}

- (void)loadLessonsInfo
{
    NSString *type;
    if (_currentBtn.tag == 2) {
        type = @"0";
    }else {
        type = @"1";
    }
    //1  精华   2   作业
    NSString *str = [NSString stringWithFormat:@"mobi/class/getHomework?lessonId=%@&type=%@&pageNo=%ld&pageSize=20&memberId=%@",self.lessonsId,type,_currentPage,[User shareUser].userId];
    
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *resultDic = nilOrJSONObjectForKey(json, @"result");
            NSDictionary *lessonDic = nilOrJSONObjectForKey(resultDic, @"lesson");
            NSDictionary *teachDic = nilOrJSONObjectForKey(resultDic, @"teacher");
            NSDictionary *page = nilOrJSONObjectForKey(resultDic, @"page");
            self.title = nilOrJSONObjectForKey(lessonDic, @"title");
            self.creatName = nilOrJSONObjectForKey(lessonDic, @"createName");
            self.logo = nilOrJSONObjectForKey(lessonDic, @"image");
            self.classCatId = nilOrJSONObjectForKey(lessonDic, @"catId");
            NSNumber *studentNum = nilOrJSONObjectForKey(lessonDic, @"studentCount");
            self.studentCount = [studentNum stringValue];
            
            NSNumber *homeworkNum = nilOrJSONObjectForKey(lessonDic, @"homeworkCount");
            self.homeworkCount = [homeworkNum stringValue];
            
            NSNumber *todayHomeworkNum = nilOrJSONObjectForKey(lessonDic, @"todayHomeworkCount");
            self.todayWorkCount = [todayHomeworkNum stringValue];
            
            NSNumber *recHomeworkNum = nilOrJSONObjectForKey(lessonDic, @"recHomeworkCount");
            self.recHomeworkCount = [recHomeworkNum stringValue];
            
            NSNumber *levelNum = nilOrJSONObjectForKey(teachDic, @"level");
            self.level = [levelNum stringValue];
            
            if (_currentPage == 1) {
                [_allDataArr removeAllObjects];
            }
            
            NSArray *dataArr = nilOrJSONObjectForKey(page, @"data");
            for (NSDictionary *dict in dataArr) {
                NSDictionary *memberDic = nilOrJSONObjectForKey(dict, @"member");
                NSDictionary *blogDic = nilOrJSONObjectForKey(dict, @"blog");
                BaseCellModel *model = [[BaseCellModel alloc] init];
                
                model.likeId = [MyTool getValuesFor:dict key:@"likeId"];
                model.collectId = [MyTool getValuesFor:dict key:@"favouriteId"];
                NSNumber *num = nilOrJSONObjectForKey(blogDic, @"ct");
                model.date = [num stringValue];
                model.modelId = nilOrJSONObjectForKey(blogDic, @"id");
                model.name = nilOrJSONObjectForKey(memberDic, @"nickname");
                model.title = nilOrJSONObjectForKey(blogDic, @"title");
                NSNumber *sexNum = nilOrJSONObjectForKey(memberDic, @"sex");
                model.sex = [sexNum stringValue];
                NSNumber *levelNum = nilOrJSONObjectForKey(memberDic, @"level");
                model.level = [levelNum stringValue];
                model.logo = nilOrJSONObjectForKey(memberDic, @"logo");
                NSNumber *comment = nilOrJSONObjectForKey(blogDic, @"objId2");
                model.commentCount = [comment stringValue];
                NSNumber *likeCount = nilOrJSONObjectForKey(blogDic, @"objId1");
                model.likeCount = [likeCount stringValue];
                [_allDataArr addObject:model];
            }
            [self initData];
            [_tableView reloadData];

        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)buildTopView
{
    _logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 150)];
    _logoImg.clipsToBounds = YES;
    _logoImg.contentMode = UIViewContentModeScaleAspectFill;
    _logoImg.userInteractionEnabled = YES;
    _longpressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(changeImg)];
    [_logoImg addGestureRecognizer:_longpressGR];
    [self.view addSubview:_logoImg];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 32, 20, 20);
    [backBtn setImage:[UIImage imageNamed:@"back_03.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(backBtn.right + 5, backBtn.bottom + 12, UI_SCREEN_WIDTH - backBtn.right - 20, 20)];
    _titleLable.backgroundColor = BaseColor;
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:_titleLable];
    
    _numLable = [[UILabel alloc] initWithFrame:CGRectMake(_titleLable.left, _titleLable.bottom + 5, UI_SCREEN_WIDTH, 20)];
    _numLable.backgroundColor = BaseColor;
    _numLable.textColor = [UIColor whiteColor];
    _numLable.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:_numLable];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _numLable.bottom, UI_SCREEN_WIDTH, _logoImg.height - _numLable.bottom)];
    view.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.3);
    [self.view addSubview:view];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_numLable.left, 10, 40, 20)];
    label.text = @"教师:";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [view addSubview:label];
    
    _levelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _levelBtn.frame = CGRectMake(label.right + 5, 10, UI_SCREEN_WIDTH - label.right - 20, 20);
    _levelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _levelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _levelBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:_levelBtn];

    UIView *optionView = [[UIView alloc] initWithFrame:CGRectMake(0, view.bottom, UI_SCREEN_WIDTH, 55)];
    optionView.backgroundColor = [UIColor whiteColor];
    
    _labelArray = [[NSMutableArray alloc] init];
    NSArray *array = @[@"同学录",@"课堂精华",@"作业"];
    for (NSInteger i = 0; i < 3; i ++) {
        
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH / 3.0 * i, 5, UI_SCREEN_WIDTH / 3.0, 20)];
        lable1.textColor = BaseColor;
        lable1.textAlignment = NSTextAlignmentCenter;
        lable1.text = @"0";
        lable1.font = [UIFont boldSystemFontOfSize:20];
        [optionView addSubview:lable1];
        [_labelArray addObject:lable1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(lable1.left, lable1.bottom + 5, lable1.width, 20)];
        label2.text = array[i];
        label2.textAlignment = NSTextAlignmentCenter;
        [optionView addSubview:label2];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH / 3.0 * i, 0, UI_SCREEN_WIDTH / 3.0, optionView.height)];
        btn.tag = i;
        if (i == 2) {
            _currentBtn = btn;
            _defualtBtn = btn;
        }
        [btn addTarget:self action:@selector(changeOption:) forControlEvents:UIControlEventTouchUpInside];
        [optionView addSubview:btn];
    }    
    
    [self.view addSubview:optionView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH / 3.0 * 2, optionView.height - 3, UI_SCREEN_WIDTH / 3.0 , 3)];
    _lineView.backgroundColor = BaseColor;
    [optionView addSubview:_lineView];

    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - (70 * UI_SCREEN_WIDTH) / 640.0, UI_SCREEN_WIDTH, (70 * UI_SCREEN_WIDTH) / 640.0)];
    [btn setImage:[UIImage imageNamed:@"course_39.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, optionView.bottom,  UI_SCREEN_WIDTH, btn.top - optionView.bottom) style:UITableViewStyleGrouped];
    UIView *footView = [UIView new];
    _tableView.tableFooterView = footView;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.1)];
    _tableView.tableHeaderView = headerView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
//    [self initData];
}

- (void)changeOption:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    _currentBtn.selected = NO;
    btn.selected = YES;
    _currentBtn = btn;
    
    CGRect rect = _lineView.frame;
    rect.origin.x = UI_SCREEN_WIDTH / 3.0 * btn.tag;
    _lineView.frame = rect;
    
    _currentPage = 1;
    
    [_allKeys removeAllObjects];
    [_dataDic removeAllObjects];
    [_allDataArr removeAllObjects];
    [_tableView reloadData];
    
    
    if (btn.tag == 0) {
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.1)];
//        _tableView.tableHeaderView = headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self loadAlumnibook];
    }else {
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.1)];
//        _tableView.tableHeaderView = headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self loadLessonsInfo];
    }
    
}

- (void)changeImg
{
    [_logoImg removeGestureRecognizer:_longpressGR];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_logoImg addGestureRecognizer:_longpressGR];
    });
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
                pickerImage.allowsEditing = YES;
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
            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSData *data = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerEditedImage], 0.1);
    [[tools shared] HUDShowText:@"正在上传..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://nzxyadmin.53xsd.com/mobi/ser/saveImage" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"Image" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue] == 0)  {
            NSDictionary *dic = nilOrJSONObjectForKey(responseObject, @"result");
            NSString *str = nilOrJSONObjectForKey(dic, @"imageUrl");
            [self updateImgWithUrl:str];
            
        }else {
            [[tools shared] HUDShowHideText:@"上传失败" delay:1.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)updateImgWithUrl:(NSString *)str
{
    NSString *url = [NSString stringWithFormat:@"mobi/class/changeLessonBackground?lessonId=%@&image=%@",self.lessonsId,str];
    [[HttpManager shareManger] getWithStr:url ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [[tools shared] HUDShowHideText:@"上传成功" delay:1.5];
            [self loadLessonsInfo];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

    //获取同学录数据
- (void)loadAlumnibook
{
    NSString *str = [NSString stringWithFormat:@"mobi/user/getUserList?memberId=&lessonId=%@&type=classmate&sex=&pageSize=&pageNo=",self.lessonsId];

    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            [_allDataArr removeAllObjects];
            NSDictionary *dic = nilOrJSONObjectForKey(json, @"result");
            NSArray *array = nilOrJSONObjectForKey(dic, @"list");
            for (NSDictionary *dic in array) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                
                NSNumber *idNum = nilOrJSONObjectForKey(dic, @"id");
                model.modelId = [idNum stringValue];
                model.name = nilOrJSONObjectForKey(dic, @"nickname");
                model.city = nilOrJSONObjectForKey(dic, @"cityName");
                model.logo = nilOrJSONObjectForKey(dic, @"logo");
                model.modelId = nilOrJSONObjectForKey(dic, @"id");
                [_allDataArr addObject:model];
            }
            
            [self arraySort];
            [_tableView reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
    
}

- (void)arraySort
{
    [_allKeys removeAllObjects];
    [_dataDic removeAllObjects];
    for (BaseCellModel *model in _allDataArr) {
        
        CFStringRef strRef = (__bridge CFStringRef)model.name;
        CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, strRef);
        CFStringTransform(string, NULL, kCFStringTransformToLatin, NO);
        CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
        NSString *str = (__bridge NSString *)string;
        NSString *firstStr = [str substringWithRange:NSMakeRange(0, 1)];
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
        NSString *filtered = [[firstStr componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
        
        BOOL canChange = [firstStr isEqualToString:filtered];
        NSString *fristString;
        if (canChange) {
            fristString = [firstStr uppercaseString];
        }else {
            fristString = @"#";
        }
        if ([_dataDic objectForKey:fristString] == nil) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:model];
            [_dataDic setObject:array forKey:fristString];
        }else {
            NSMutableArray *array = [_dataDic objectForKey:fristString];
            [array addObject:model];
            [_dataDic setObject:array forKey:fristString];
        }
        
    }
    
    NSArray *array = [_dataDic allKeys];
    NSMutableArray *array2 = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(compare:)]];
    if ([[array2 firstObject] isEqualToString:@"#"]) {
        [array2 removeObjectAtIndex:0];
        [array2 addObject:@"#"];
    }
    
    [_allKeys addObjectsFromArray:array2];
    
}

    //写作业
- (void)btnClick
{
    DoHomeworkVC *vc = [[DoHomeworkVC alloc] init];
    vc.lessonsId = self.lessonsId;
    vc.classCatId = self.classCatId;
    __weak typeof(self) weakSelf = self;
    [vc setBlock:^{
        if (_currentBtn.tag == 2) {
            [weakSelf loadLessonsInfo];
        }else {
            [weakSelf changeOption:_defualtBtn];
        }
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        NSArray *array = [_dataDic objectForKey:_allKeys[section]];
        return [array count];
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = tableView.backgroundColor;
    }

    if (_currentBtn.tag == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dorm_b.png"]];

        cell.backgroundColor = [UIColor whiteColor];
        cell.type = 17;
        cell.model = [[_dataDic objectForKey:[_allKeys objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    }else if (_currentBtn.tag == 2) {
        cell.backgroundColor = tableView.backgroundColor;
        cell.model = _allDataArr[indexPath.section];
        cell.type = 28;
    }else {
        cell.backgroundColor = tableView.backgroundColor;
        cell.model = _allDataArr[indexPath.section];
        cell.type = 29;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 15)];
        [img setImage:[UIImage imageNamed:@"bg_down1"]];
        return img;
        
    }
    UIView *view = [UIView new];
    return view;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        UIView *bgView = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        label.text = [_allKeys objectAtIndex:section];
        label.textColor = BaseColor;
        label.font = [UIFont systemFontOfSize:25];
        [bgView addSubview:label];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, UI_SCREEN_WIDTH, 20)];
        [img setImage:[UIImage imageNamed:@"bg_class_top.png"]];
        [bgView addSubview:img];
        return bgView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        return 60;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_currentBtn.tag == 0) {
        return 15;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentBtn.tag == 0) {
        return 70;
    }
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_currentBtn.tag == 0) {
        return [_allKeys count];
    }
    return [_allDataArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (_currentBtn.tag) {
        case 0:
        {
            BaseCellModel *model = [[_dataDic objectForKey:_allKeys[indexPath.section]] objectAtIndex:indexPath.row];
            ClassmateInfoVC *vc = [[ClassmateInfoVC alloc] init];
            vc.ClassmateId = model.modelId;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 1:
        case 2:
        {
            BaseCellModel *model = _allDataArr[indexPath.section];
            HomeworkVC *vc = [[HomeworkVC alloc] init];
            vc.homworkModel = model;
            vc.homeworkId = model.modelId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

            
        default:
            break;
    }
    
    
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{
    NSString *str;
    if ([self.logo hasPrefix:@"http"]) {
        
        str = self.logo;
    }else {
        str = [NSString stringWithFormat:@"%@%@",sBaseImgUrlStr,self.logo];
    }
    [_logoImg sd_setImageWithURL:[NSURL URLWithString:str]];
    
    _titleLable.text = self.title;
    CGFloat width = [self.title boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil].size.width;
    if (width < UI_SCREEN_WIDTH - 35 - 20) {
        CGRect rect = _titleLable.frame;
        rect.size.width = width;
        _titleLable.frame = rect;
    }else {
        CGRect rect = _titleLable.frame;
        rect.size.width = UI_SCREEN_WIDTH - 35 - 20;
        _titleLable.frame = rect;
    }
    
    _numLable.text = [NSString stringWithFormat:@"学生:%@  今日作业:%@",_studentCount,_todayWorkCount];
    CGFloat width2 = [_numLable.text boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil].size.width;
    CGRect rect = _numLable.frame;
    rect.size.width = width2;
    _numLable.frame = rect;
    
    [_levelBtn setImage:[Util teacherImageWithLevel2:self.level] forState:UIControlStateNormal];
    [_levelBtn setTitle:self.creatName forState:UIControlStateNormal];
    
    UILabel *label1 = _labelArray[0];
    UILabel *label2 = _labelArray[1];
    UILabel *label3 = _labelArray[2];
    label1.text = _studentCount;
    label2.text = _recHomeworkCount;
    label3.text = _homeworkCount;
    
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
