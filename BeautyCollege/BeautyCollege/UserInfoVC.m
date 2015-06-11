//
//  UserInfoVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/5.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "UserInfoVC.h"
#import "MyCustomView.h"
#import "LocationVC.h"
#import "IQKeyboardManager.h"

@interface UserInfoVC ()
{
    NSArray         *titleArray;
    UITextField     *NameTF;
    MyCustomView    *topView;
    UIButton        *currentBtn;
    UITextView      *signatureLabel;
    UITextView      *textView;
    UILabel         *placeLabel;
}

@end

@implementation UserInfoVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"个人资料";
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    titleArray = @[@"头像",@"昵称",@"性别",@"城市"];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 15, UI_SCREEN_WIDTH - 20, 80 + 120 + 20 * UI_scaleY)];
    
    [img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [self.view addSubview:img];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64 + 15, UI_SCREEN_WIDTH - 20, 80 + 120) style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ColorWithRGBA(123, 123, 123, 0);
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, img.bottom + 10 * UI_scaleY, img.width, 150 * UI_scaleY)];
    [img2 setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [self.view addSubview:img2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, img2.top + 10, 100, 30)];
    label.textColor = [UIColor grayColor];
    label.text = @"个性签名";
    label.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:label];
    
    signatureLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, label.bottom, img2.width - 20, img2.height - 50)];
    signatureLabel.font = [UIFont systemFontOfSize:17];
    signatureLabel.text = [User shareUser].signature;
    signatureLabel.textColor = [UIColor grayColor];
    signatureLabel.backgroundColor = [UIColor clearColor];
    signatureLabel.editable = NO;
    [self.view addSubview:signatureLabel];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = img2.frame;
    [btn addTarget:self action:@selector(changeSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)changeSignature
{
    topView = [[MyCustomView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    topView.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.5);
//    [[AppDelegate shareApp].window addSubview:topView];
    [self.view addSubview:topView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, UI_SCREEN_WIDTH - 20, 200)];
    [img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [topView addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 150 + 10, 200, 30)];
    label.text = @"修改个性签名";
    [topView addSubview:label];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, label.bottom + 10, img.width, 0.5)];
    lineView1.backgroundColor = [UIColor grayColor];
    [topView addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, img.bottom - 50, img.width, 0.5)];
    lineView2.backgroundColor = [UIColor grayColor];
    [topView addSubview:lineView2];
    
#pragma mark - 未解决
    textView = [[UITextView alloc] initWithFrame:CGRectMake(20, lineView1.top + 10, img.width - 20, lineView2.top - lineView1.bottom - 20)];
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:17];
    [topView addSubview:textView];
    
    placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, lineView1.top + 10, 120, 30)];
    placeLabel.textColor = [UIColor grayColor];
    placeLabel.text = @"在此输入";
    [topView addSubview:placeLabel];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(img.right - 75, lineView2.bottom + 12.5, 40, 25);
    [btn addTarget:self action:@selector(changeNickName) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_finish.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(uploadSignature) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
}

- (void)uploadSignature
{
    if (textView.text.length > 0) {
        NSString *str = [NSString stringWithFormat:@"mobi/user/updateUserInfo?memberId=%@&signature=%@",[User shareUser].userId,textView.text];
        [self changeUserInfoWithUrlStr:str];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        placeLabel.hidden = YES;
    }else {
        placeLabel.hidden = NO;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dorm_b.png"]];
        
    }
    if (indexPath.row == 0) {
        cell.type = 25;
        cell.name = [User shareUser].logo;
    }else {
        cell.type = 26;
        switch (indexPath.row) {
            case 1:
            {
                cell.name = [User shareUser].nickname;

            }
                break;
            case 2:
            {
                cell.name = [User shareUser].sex;
            }
                break;
            case 3:
            {
                cell.name = [User shareUser].cityName;
            }
                break;

                
            default:
                break;
        }
    }
    cell.title = [titleArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }else {
        return 40;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
            [sheet showInView:self.view];
        }
            break;
        case 1:
        {
            topView = [[MyCustomView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
            topView.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.5);
//            [[AppDelegate shareApp].window addSubview:topView];
            [self.view addSubview:topView];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, UI_SCREEN_WIDTH - 20, 200)];
            [img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
            [topView addSubview:img];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 150 + 10, 100, 30)];
            label.text = @"修改昵称";
            [topView addSubview:label];
            
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, label.bottom + 10, img.width, 0.5)];
            lineView1.backgroundColor = [UIColor grayColor];
            [topView addSubview:lineView1];
            
            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, img.bottom - 50, img.width, 0.5)];
            lineView2.backgroundColor = [UIColor grayColor];
            [topView addSubview:lineView2];
            
            NameTF = [[UITextField alloc] initWithFrame:CGRectMake(15, lineView1.bottom + 10, img.width - 20, lineView2.top - lineView1.bottom - 20)];
            NameTF.placeholder = @"在此输入";
            NameTF.delegate = self;
            [topView addSubview:NameTF];

            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView2.bottom + 10, 120, 30)];
            label2.textColor = [UIColor grayColor];
            label2.text = @"取名字技能get√";
            [topView addSubview:label2];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(img.right - 75, label2.top + 2.5, 40, 25);
            [btn addTarget:self action:@selector(changeNickName) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_finish.png"] forState:UIControlStateNormal];
            [topView addSubview:btn];
            
        }
            break;
        case 2:
        {
            currentBtn = nil;
            topView = [[MyCustomView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
            topView.backgroundColor = ColorWithRGBA(30.0, 32.0, 40.0, 0.5);
            [[AppDelegate shareApp].window addSubview:topView];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 150, UI_SCREEN_WIDTH - 20, 180)];

            [img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
            [topView addSubview:img];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 150 + 10, 100, 30)];
            label.text = @"性别";
            [topView addSubview:label];
            
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            view.frame = CGRectMake(10, label.bottom + 10, img.width, 80);
            view.backgroundColor = [UIColor whiteColor];
            [topView addSubview:view];
            
            NSArray *array = @[@"girl.png",@"无性.png",@"boy.png"];
            CGFloat width = (img.width - 150) / 4.0;
            for (NSInteger i = 0; i < 3; i ++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(width + (width + 50) * i, 30, 20, 20);
                [btn setImage:[UIImage imageNamed:@"reg8.png"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"reg9.png"] forState:UIControlStateSelected];
                btn.tag = 20 + i;
                [btn addTarget:self action:@selector(changeSex:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(btn.right, 20, 25, 40)];
                [img setImage:[UIImage imageNamed:array[i]]];
                [view addSubview:img];
            }

            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, label.bottom + 10, img.width, 0.5)];
            lineView1.backgroundColor = [UIColor grayColor];
            [topView addSubview:lineView1];
            
            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(10, img.bottom - 50, img.width, 0.5)];
            lineView2.backgroundColor = [UIColor grayColor];
            [topView addSubview:lineView2];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(img.right - 75, lineView2.bottom + 12.5, 40, 25);

            [btn addTarget:self action:@selector(changeSex) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@"btn_finish.png"] forState:UIControlStateNormal];
            [topView addSubview:btn];
            
        }
            break;
        case 3:
        {
            LocationVC *location = [[LocationVC alloc] init];
            location.type = 1;
            __weak typeof(self) weakSelf = self;
            [location setBlock:^(NSString *str){
                [weakSelf changeUserInfoWithUrlStr:str];
            }];
            [self.navigationController pushViewController:location animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)changeSex:(UIButton *)btn
{
    btn.selected = YES;
    currentBtn.selected = NO;
    currentBtn = btn;
}

- (void)changeSex
{
    [topView removeFromSuperview];
    topView = nil;
    if (currentBtn.tag >= 20) {
        
//        0无性 1男 2女
        NSInteger sex;
        switch (currentBtn.tag - 20) {
            case 0:
                sex = 2;
                break;
            case 1:
                sex = 1;
                break;
            case 2:
                sex = 0;
                break;
            default:
                break;
        }
        
        NSString *str = [NSString stringWithFormat:@"mobi/user/updateUserInfo?memberId=%@&sex=%ld",[User shareUser].userId,sex];
        [self changeUserInfoWithUrlStr:str];
    }
}

- (void)changeNickName
{
    [NameTF resignFirstResponder];
    [topView removeFromSuperview];
    topView = nil;
    if (NameTF.text.length > 0) {
        NSString *str = [NSString stringWithFormat:@"mobi/user/updateUserInfo?memberId=%@&nickName=%@",[User shareUser].userId,NameTF.text];
        [self changeUserInfoWithUrlStr:str];
    }
}

- (void)changeUserInfoWithUrlStr:(NSString *)str
{
    [[tools shared] HUDShowText:@"请稍候..."];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            NSDictionary *dic = [json objectForKey:@"result"];
            User *user = [User shareUser];
            user.userId = nilOrJSONObjectForKey(dic, @"id");
            user.userName = nilOrJSONObjectForKey(dic, @"userName");
            user.nickname = nilOrJSONObjectForKey(dic, @"nickname");
            user.level = nilOrJSONObjectForKey(dic, @"level");
            user.levelName = nilOrJSONObjectForKey(dic, @"levelName");
            user.score = nilOrJSONObjectForKey(dic, @"score");
            user.logo = nilOrJSONObjectForKey(dic, @"logo");
            NSNumber *sexNum = nilOrJSONObjectForKey(dic, @"sex");
            NSString *sex;
            switch ([sexNum integerValue]) {
                case 0:
                {
                    sex = @"女";
                }
                    break;
                case 1:
                {
                    sex = @"无性";
                }
                    break;
                case 2:
                {
                    sex = @"男";
                }
                    break;
                    
                    
                default:
                    break;
            }
            user.sex = sex;
            user.regLink = nilOrJSONObjectForKey(dic, @"regLink");
            user.regLinkImg = nilOrJSONObjectForKey(dic, @"regLinkImg");
            NSString *str = nilOrJSONObjectForKey(dic, @"signature");
            user.signature = str == nil ? @"" : str;
            user.cityName = nilOrJSONObjectForKey(dic, @"cityName");
            
            signatureLabel.text = user.signature;
            NSMutableData *data = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:user forKey:@"user"];
            [archiver finishEncoding];
            NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
            [data writeToFile:path atomically:YES];
            [[tools shared] HUDShowHideText:@"信息修改成功" delay:1.5];
            [_tableView reloadData];
        }else {
            [[tools shared] HUDShowHideText:@"修改失败" delay:1.0];
        }
        
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    if (textField.text.length >= 16) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
//    CGFloat offY = UI_scaleY;
//    CGRect rect = topView.frame;
//    rect.origin.y -= (140.0 / offY);
//    topView.frame = rect;
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    CGFloat offY = UI_scaleY;
//    CGRect rect = topView.frame;
//    rect.origin.y -= (140.0 / offY);
//    topView.frame = rect;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                pickerImage.delegate = self;
                pickerImage.allowsEditing = YES;
                [self presentViewController:pickerImage animated:YES completion:nil];
            }

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
            NSString *url = [NSString stringWithFormat:@"mobi/user/updateUserInfo?memberId=%@&logo=%@",[User shareUser].userId,str];
            [self changeUserInfoWithUrlStr:url];
        }else {
            [[tools shared] HUDShowHideText:@"上传失败" delay:1.5];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HUDShowErrorServerOrNetwork
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
