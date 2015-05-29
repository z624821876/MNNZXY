//
//  LocationVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/6.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "LocationVC.h"
#define NUMBERS @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

@interface LocationVC ()

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableDictionary   *dataDict;
@property (nonatomic, strong) NSMutableArray        *keyArr;


@end

@implementation LocationVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"选择城市";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"locaitonMar.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(location)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)location
{
    _loctionManager = [[CLLocationManager alloc] init];
//    _loctionManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _loctionManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [_loctionManager requestWhenInUseAuthorization];
    }
    [_loctionManager startUpdatingLocation];
    
    [[tools shared] HUDShowText:@"正在定位..."];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [[tools shared] HUDHide];
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        
        CLGeocoder *geocoder=[[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:currentLocation
                       completionHandler:^(NSArray *placemarks,
                                           NSError *error)
         {
             if (error == nil && [placemarks count] > 0)
             {
                 [manager stopUpdatingLocation];
                 CLPlacemark *placemark = [placemarks firstObject];
                 NSMutableString *cityName = [NSMutableString stringWithString:placemark.locality];
                 NSRange range = [cityName rangeOfString:@"市"];
                 if (range.location != NSNotFound) {
                     [cityName deleteCharactersInRange:NSMakeRange(cityName.length - 1, 1)];
                 }
                 
                     [self getCityID:cityName];
//                 NSString *string = [NSString stringWithFormat:@"name == '%@'",cityName];
                 
//                 NSPredicate *predicate = [NSPredicate predicateWithFormat:string];
    
//                 BaseCellModel *model = [[_array filteredArrayUsingPredicate:predicate] firstObject];
//                 NSLog(@"-----%@-----%@-----%@",model.name,model.modelId,cityName);
//                 NSString *str = [NSString stringWithFormat:@"mobi/user/updateUserInfo?memberId=%@&cityId=%@",[User shareUser].userId,model.modelId];
//                 _block(str);
//                 [self.navigationController popViewControllerAnimated:YES];
             }
         }];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[tools shared] HUDShowHideText:@"定位失败" delay:1.5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _keyArr = [[NSMutableArray alloc] init];
    _array = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    _tableView.tableHeaderView = view2;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

    NSString *string = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:string];
    _dataDict = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSArray *arr = [_dataDict allKeys];
    NSMutableArray *array2 = [NSMutableArray arrayWithArray:[arr sortedArrayUsingSelector:@selector(compare:)]];
    if ([[array2 firstObject] isEqualToString:@"#"]) {
        [array2 removeObjectAtIndex:0];
        [array2 addObject:@"#"];
    }
    [_keyArr addObjectsFromArray:array2];
    [_tableView reloadData];
    
//    [self loadData];
}

- (void)loadData
{
    [[tools shared] HUDShowText:@"请稍候"];
    NSString *str = @"mobi/ser/getCity?level=2";
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSArray *result = nilOrJSONObjectForKey(json, @"result");
            for (NSDictionary *dic in result) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.name = nilOrJSONObjectForKey(dic, @"name");
                model.modelId = nilOrJSONObjectForKey(dic, @"id");
                [_array addObject:model];
            }
            [self arraySort];
        }else {
            [[tools shared] HUDShowHideText:@"暂无数据" delay:1.5];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[_dataDict objectForKey:[_keyArr objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [self getCityID:[dic objectForKey:@"name"]];
}

- (void)arraySort
{
    for (BaseCellModel *model in _array) {
        
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
        if ([_dataDict objectForKey:fristString] == nil) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSDictionary *dic = @{@"name":model.name,@"modelId":model.modelId};
            [array addObject:dic];
            [_dataDict setObject:array forKey:fristString];
        }else {
            NSMutableArray *array = [_dataDict objectForKey:fristString];
            NSDictionary *dic = @{@"name":model.name,@"modelId":model.modelId};
            [array addObject:dic];
            [_dataDict setObject:array forKey:fristString];
        }
    }
    
    NSArray *arr = [_dataDict allKeys];
    NSMutableArray *array2 = [NSMutableArray arrayWithArray:[arr sortedArrayUsingSelector:@selector(compare:)]];
    if ([[array2 firstObject] isEqualToString:@"#"]) {
        [array2 removeObjectAtIndex:0];
        [array2 addObject:@"#"];
    }
    [_keyArr addObjectsFromArray:array2];
    
    BOOL isOk = [_dataDict writeToFile:[PATH_OF_DOCUMENT stringByAppendingPathComponent:@"cityList.plist"] atomically:YES];
    NSLog(@"%@---%d ",PATH_OF_DOCUMENT,isOk);
    [_tableView reloadData];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSArray *array = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    return array;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view= [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 80, 30)];
    label.textColor = BaseColor;
    label.text = [_keyArr objectAtIndex:section];
    label.font = [UIFont systemFontOfSize:20];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [_dataDict objectForKey:_keyArr[section]];
    return [arr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_keyArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *dic = [[_dataDict objectForKey:_keyArr[indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    return cell;
}

    //通过城市名字获取ID
- (void)getCityID:(NSString *)cityName
{
    CFStringRef strRef = (__bridge CFStringRef)cityName;
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, strRef);
    CFStringTransform(string, NULL, kCFStringTransformToLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *str = (__bridge NSString *)string;
    NSString *firstStr = [str substringWithRange:NSMakeRange(0, 1)];
    NSArray *array = [_dataDict objectForKey:[firstStr uppercaseString]];
    NSString *predicateString = [NSString stringWithFormat:@"name == '%@'",cityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSDictionary *dict = [[array filteredArrayUsingPredicate:predicate] firstObject];
    NSString *idString = [dict objectForKey:@"modelId"];
    
    
    if (_type == 2) {
        [[NSUserDefaults standardUserDefaults] setObject:cityName forKey:@"MNlocation"];
        [[NSUserDefaults standardUserDefaults] setObject:idString forKey:@"MNlocationId"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"mobi/user/updateUserInfo?memberId=%@&cityId=%@",[User shareUser].userId,idString];
    _block(urlStr);
    [self.navigationController popViewControllerAnimated:YES];
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
