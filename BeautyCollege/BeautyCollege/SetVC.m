//
//  SetVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/5.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "SetVC.h"
#import "MyWebVC.h"
#import "ChangePswVC.h"
#import "FeedbackVC.h"

@interface SetVC ()
@property (nonatomic, strong) NSArray *array;
@end

@implementation SetVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"设置";
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _array = @[@"消息推送",@"关于美娘",@"意见反馈",@"修改密码",@"清除缓存",@"退出登录"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    UIView *view = [UIView new];
    _tableView.tableFooterView = view;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fristCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fristCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 12, 200, 20)];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"消息推送";
            [cell.contentView addSubview:label];
            
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 20 - 40, 7, 0, 30)];
            switchView.tag = 1000;
            [switchView addTarget:self action:@selector(openNotice:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:switchView];
        }
        UISwitch *switchView = (UISwitch *)[cell.contentView viewWithTag:1000];
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"messageNotice"];
        if ([str isEqualToString:@"o"]) {
            [switchView setOn:YES];
        }else {
            [switchView setOn:NO];
        }
        return cell;
    }else {
        BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dorm_b.png"]];
            
        }
        
        cell.title = [_array objectAtIndex:indexPath.row];
        cell.type = 21;
        
        if (indexPath.row == 4) {
            cell.type = 24;
        }
        if (indexPath.row == 5) {
            cell.type = 23;
        }
        
        return cell;

    }
    
}

- (void)openNotice:(UISwitch *)switchControl
{
    if (switchControl.on) {
        // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
        [[AppDelegate shareApp] startSdkWith:kGTAppId appKey:kGTAppKey appSecret:kGTAppSecret];
        [[AppDelegate shareApp] registerRemoteNotification];
        [[NSUserDefaults standardUserDefaults] setObject:@"o" forKey:@"messageNotice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else {
        [[AppDelegate shareApp] stopSdk];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [[NSUserDefaults standardUserDefaults] setObject:@"d" forKey:@"messageNotice"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
        {
            MyWebVC *vc = [[MyWebVC alloc] init];
            vc.type = 10;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            FeedbackVC *vc = [[FeedbackVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            ChangePswVC *vc = [[ChangePswVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }
            break;
        case 4:
        {
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDisk];
            [[tools shared] HUDShowHideText:@"缓存已清除" delay:1.5];
            [_tableView reloadData];

        }
            break;
        case 5:
        {
            NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
            BOOL isSucceed = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            [User shareUser].userId = nil;
            if (isSucceed) {
                LoginVC *vc = [[LoginVC alloc] init];
                vc.type = 10;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
            break;
        default:
            break;
    }
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
