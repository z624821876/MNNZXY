//
//  CreateLessonVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/22.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "CreateLessonVC.h"
#import "CustomCollectionCell.h"
@interface CreateLessonVC ()
{
    UITextField         *_titleTF;
    UITextField         *_markTF;
    UIButton            *_changeImgBtn;
    NSMutableArray      *_dataArray;
    UICollectionView    *_collection;
}
@end

@implementation CreateLessonVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"创建课堂";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self buildFootView];
    _dataArray = [[NSMutableArray alloc] init];
    _scrollView = [[CustomScrollView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 64 - 40)];
    [self.view addSubview:_scrollView];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, UI_SCREEN_WIDTH - 20, 50)];
    [img setImage:[[UIImage imageNamed:@"create1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [_scrollView addSubview:img];
    
    UILabel *Lable = [[UILabel alloc] initWithFrame:CGRectMake(20, img.top + 10, img.width - 20, 30)];
    Lable.text = [NSString stringWithFormat:@"所属课程: %@",_mark];
    [_scrollView addSubview:Lable];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, img.bottom + 15, img.width, img.height)];
    [img2 setImage:[[UIImage imageNamed:@"create1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [_scrollView addSubview:img2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Lable.left, img2.top + 10, 80, 30)];
    label2.text = @"课程名称:";
    [_scrollView addSubview:label2];
    
    _titleTF = [[UITextField alloc] initWithFrame:CGRectMake(label2.right + 5, label2.top, img.width - 10 - 80 - 15, 30)];
    _titleTF.delegate = self;
    [_scrollView addSubview:_titleTF];
    
    UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(img.left, img2.bottom + 15, img2.width, 40)];
    [img3 setImage:[UIImage imageNamed:@"create3.png"]];
    [_scrollView addSubview:img3];

    UIImageView *img4 = [[UIImageView alloc] initWithFrame:CGRectMake(img3.right - 100, img3.top, 100, 40)];
    [img4 setImage:[UIImage imageNamed:@"create2.png"]];
    [_scrollView addSubview:img4];
    
    _markTF = [[UITextField alloc] initWithFrame:CGRectMake(10 + 40 * UI_scaleX, img3.top + 5, img4.left - 10 - 40 * UI_scaleX - 5, 30)];
    _markTF.delegate = self;
    [_scrollView addSubview:_markTF];
    
    UIImageView *img5 = [[UIImageView alloc] initWithFrame:CGRectMake(10, img3.bottom + 25, UI_SCREEN_WIDTH - 20, 150)];
    [img5 setImage:[[UIImage imageNamed:@"zuoyebeijing"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [_scrollView addSubview:img5];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(10, img5.top, img5.width, 150) collectionViewLayout:layout];
    [_collection registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"cell"];
    _collection.backgroundColor = [UIColor clearColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.tag = 10;
    [_scrollView addSubview:_collection];
    
//    CGSize size1 = layout.collectionViewContentSize;
//    CGRect rect1 = collection1.frame;
//    rect1.size.height = size1.height;
//    collection1.frame = rect1;

    UIImageView *img6 = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 50, img3.bottom + 5, 20, 20)];
    [img6 setImage:[UIImage imageNamed:@"三角.png"]];
    [_scrollView addSubview:img6];
    
    UIImageView *img7 = [[UIImageView alloc] initWithFrame:CGRectMake(10, img5.bottom + 15, 20, 20)];
    [img7 setImage:[UIImage imageNamed:@"write_work2.png"]];
    [_scrollView addSubview:img7];
    
    _changeImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeImgBtn.frame = CGRectMake(img7.right + 20, img7.top, 100, 100);
    [_changeImgBtn addTarget:self action:@selector(chooseImg) forControlEvents:UIControlEventTouchUpInside];
    _changeImgBtn.tag = 10;
    [_changeImgBtn setImage:[UIImage imageNamed:@"add_img1"] forState:UIControlStateNormal];
    [_scrollView addSubview:_changeImgBtn];
    
    [_scrollView setContentSize:CGSizeMake(UI_SCREEN_WIDTH, _changeImgBtn.bottom + 20)];
    
    NSString *str = [NSString stringWithFormat:@"mobi/class/getTags?catId=%ld",self.cateId];
    [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        if ([json objectForKey:@"code"]) {
            [_dataArray removeAllObjects];
            NSArray *array = nilOrJSONObjectForKey(json, @"result");
            for (NSDictionary *dic in array) {
                BaseCellModel *model = [[BaseCellModel alloc] init];
                model.modelId = nilOrJSONObjectForKey(dic, @"id");
                model.content = nilOrJSONObjectForKey(dic, @"tag");
                model.type = 1;
                [_dataArray addObject:model];
            }
            [_collection reloadData];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)buildFootView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 40, UI_SCREEN_WIDTH, 40);
    [btn setTitle:@"确定创建" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:BaseColor forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.top, UI_SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
}

    //创建
- (void)btnClick
{
    if (_titleTF.text.length <= 0) {
        
        [[tools shared] HUDShowHideText:@"请填写课堂名字" delay:1.5];
        return;
    }
    if (_changeImgBtn.tag != 10086) {
        [[tools shared] HUDShowHideText:@"请上传图片" delay:1.5];
        return;
    }
    
        [[tools shared] HUDShowText:@"正在创建..."];
    NSData *data = UIImageJPEGRepresentation(_changeImgBtn.imageView.image, 0.1);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://nzxyadmin.53xsd.com/mobi/ser/saveImage" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data name:@"Image" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"code"] integerValue] == 0)  {
                NSDictionary *dic = nilOrJSONObjectForKey(responseObject, @"result");
                NSString *imgUrl = nilOrJSONObjectForKey(dic, @"imageUrl");
                [self creatLessonWithImgURL:imgUrl];
            }else {
                [[tools shared] HUDShowHideText:@"创建失败" delay:1.5];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            HUDShowErrorServerOrNetwork
        }];
    
}

- (void)creatLessonWithImgURL:(NSString *)url
{
    NSString *string = [NSString stringWithFormat:@"type == 2"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:string];
    NSArray *array = [_dataArray filteredArrayUsingPredicate:predicate];
    NSMutableArray *tagsArray = [NSMutableArray array];
    for (BaseCellModel *model in array) {
        [tagsArray addObject:model.content];
    }
    NSString *tag = [tagsArray componentsJoinedByString:@","];
    NSMutableString *tags = [NSMutableString stringWithString:tag];
    NSString *tagString;
    if (_markTF.text.length > 0) {
        tagString = [tags stringByAppendingFormat:@",%@",_markTF.text];
        
    }else {
        tagString = tags;
    }
    NSLog(@"%@",tagString);
        if (self.cateId == 16) {
    
            self.cityId = [[NSUserDefaults standardUserDefaults] objectForKey:@"MNlocationId"];
    
        }else {
            self.cityId = nil;
        }
    
        NSString *str = [NSString stringWithFormat:@"mobi/class/addLesson?classId=%ld&title=%@&createName=%@&tags=%@&creator=%@&cityId=%@&image=%@",self.cateId,_titleTF.text,[User shareUser].nickname,tagString,[User shareUser].userId,self.cityId,url];

        [[HttpManager shareManger] getWithStr:str ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
            if ([[json objectForKey:@"code"] integerValue] == 0) {
                [[tools shared] HUDShowHideText:@"创建成功" delay:1.5];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [[tools shared] HUDShowHideText:@"创建失败" delay:1.5];
            }
            
        } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    
}

- (void)chooseImg
{
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
    [_changeImgBtn setImage:[info objectForKey:UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
    _changeImgBtn.tag = 10086;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - collectionView 代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellModel *model = _dataArray[indexPath.row];
    CGFloat width = [model.content boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil].size.width;
    if (width <= collectionView.width) {
        return CGSizeMake(width + 10, 30);
    }else {
        return CGSizeMake(collectionView.width, 30);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    BaseCellModel *model = _dataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.frame = cell.bounds;
    cell.titleLabel.font = [UIFont systemFontOfSize:20];
    if (model.type == 1) {
        cell.titleLabel.textColor = [UIColor grayColor];
    }else {
        cell.titleLabel.textColor = BaseColor;
    }
    cell.titleLabel.text = model.content;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseCellModel *model = _dataArray[indexPath.row];
    if (model.type == 1) {
        model.type = 2;
    }else {
        model.type = 1;
    }
//    [_dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    [collectionView reloadData];
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
