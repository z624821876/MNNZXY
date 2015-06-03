//
//  DoHomeworkVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/11.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "DoHomeworkVC.h"
#import "MyTextView.h"
#import "MyTextAttachment.h"

@interface DoHomeworkVC ()

@property (nonatomic, strong) MyTextView        *titleTV;
@property (nonatomic, strong) MyTextView        *contentTV;

@property (nonatomic, strong) MyTextView        *currentTV;
@property (nonatomic, strong) NSMutableArray    *imgArray;
@property (nonatomic, strong) UIButton          *changeImgBtn;
@property (nonatomic, strong) UIButton          *faceBtn;
@property (nonatomic, strong) UIButton          *confirmBtn;

@end

@implementation DoHomeworkVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"写作业";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_faceBoard) {
        
        _faceBoard = [[FaceBoard alloc] init];
        _faceBoard.delegate = self;
    }
    _imgArray = [NSMutableArray array];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 15, UI_SCREEN_WIDTH - 20, UI_SCREEN_HEIGHT - 64 - 30)];
    [img setImage:[[UIImage imageNamed:@"blank_num.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]];
    [self.view addSubview:img];
    
    _scrollView = [[CustomScrollView alloc] initWithFrame:img.frame];
    [self.view addSubview:_scrollView];
    
    _titleTV = [[MyTextView alloc] initWithFrame:CGRectMake(5, 5, _scrollView.width - 10, 35)];
    _titleTV.backgroundColor = [UIColor clearColor];
    _titleTV.font = [UIFont systemFontOfSize:17];
    _titleTV.placeholder = @"请输入标题";
    _titleTV.tag = 10;
    _titleTV.delegate = self;
    [_scrollView addSubview:_titleTV];
    _currentTV = _titleTV;
    _faceBoard.inputTextView = _currentTV;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleTV.bottom + 4.5, _scrollView.width, 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:line];
    
    _contentTV = [[MyTextView alloc] initWithFrame:CGRectMake(5, line.bottom + 5, _scrollView.width - 10, 17 * 7 * UI_scaleY)];
    _contentTV.backgroundColor = [UIColor clearColor];
    _contentTV.font = [UIFont systemFontOfSize:17];
    _contentTV.delegate = self;
    _contentTV.tag = 11;
    _contentTV.placeholder = @"请输入内容";
    [_scrollView addSubview:_contentTV];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, _contentTV.bottom + 4.5, _scrollView.width, 0.5)];
    line1.backgroundColor = [UIColor grayColor];
    [_scrollView addSubview:line1];

    _faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, line1.bottom + 5, 25, 25)];
    [_faceBtn setImage:[UIImage imageNamed:@"write_work1.png"] forState:UIControlStateNormal];
    [_faceBtn addTarget:self action:@selector(faceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_faceBtn];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.backgroundColor = BaseColor;
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.layer.masksToBounds = YES;
    [_confirmBtn addTarget:self action:@selector(confirmImgs) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn setTitle:@"上交" forState:UIControlStateNormal];
    [_scrollView addSubview:_confirmBtn];
    
    [self buildImgView];
}

    //提交作业
- (void)confirmImgs
{
    if (_titleTV.attributedText.length <= 0) {
        [[tools shared] HUDShowHideText:@"作业标题还是要有的哦" delay:1.5];
        return;
    }
    if (_contentTV.attributedText.length <= 0) {
        [[tools shared] HUDShowHideText:@"作业内容还是要有的哦" delay:1.5];
        return;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([_imgArray count] <= 0) {
        [[tools shared] HUDShowText:@"正在提交..."];
        [self confirmHomeworkWithImgsArr:array];
    }else {
        [[tools shared] HUDShowText:@"正在提交..."];
        for (UIImage *img in _imgArray) {
            NSData *data = UIImageJPEGRepresentation(img, 0.1);
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager POST:@"http://nzxyadmin.53xsd.com/mobi/ser/saveImage" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [formData appendPartWithFileData:data name:@"Image" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if ([[responseObject objectForKey:@"code"] integerValue] == 0) {
                    NSDictionary *resultDic = nilOrJSONObjectForKey(responseObject, @"result");
                    NSString *str = nilOrJSONObjectForKey(resultDic, @"imageUrl");
                    [array addObject:str];
                    if ([array count] == [_imgArray count]) {
                        [self confirmHomeworkWithImgsArr:array];
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                HUDShowErrorServerOrNetwork
            }];
            
        }
    }
}

- (void)confirmHomeworkWithImgsArr:(NSMutableArray *)array;
{
    NSString *imgs = [array componentsJoinedByString:@","];

    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithAttributedString:_titleTV.attributedText];
    [titleStr enumerateAttributesInRange:NSMakeRange(0, titleStr.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if ([[attrs objectForKey:@"NSAttachment"] isKindOfClass:[MyTextAttachment class]]) {
            MyTextAttachment *textAttachment = (MyTextAttachment *)[attrs objectForKey:@"NSAttachment"];
            [titleStr replaceCharactersInRange:range withString:textAttachment.imgName];
        }
    }];
    
    NSMutableAttributedString *contenStr = [[NSMutableAttributedString alloc] initWithAttributedString:_contentTV.attributedText];
    [contenStr enumerateAttributesInRange:NSMakeRange(0, contenStr.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if ([[attrs objectForKey:@"NSAttachment"] isKindOfClass:[MyTextAttachment class]]) {
            MyTextAttachment *textAttachment = (MyTextAttachment *)[attrs objectForKey:@"NSAttachment"];
            [contenStr replaceCharactersInRange:range withString:textAttachment.imgName];
        }
    }];

    NSString *urlStr = [NSString stringWithFormat:@"mobi/class/addHomework?classId=%@&title=%@&memberId=%@&content=%@&lessonId=%@&images=%@",self.classCatId,titleStr.string,[User shareUser].userId,contenStr.string,self.lessonsId,imgs];
    [[HttpManager shareManger] getWithStr:urlStr ComplentionBlock:^(AFHTTPRequestOperation *operation, id json) {
        [[tools shared] HUDHide];
        if ([[json objectForKey:@"code"] integerValue] == 0) {
            //上传成功
            _block();
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [[tools shared] HUDShowHideText:[json objectForKey:@"message"] delay:1.5];
        }
    } Failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (void)buildImgView
{
    [_changeImgBtn removeFromSuperview];
    CGFloat width = (UI_SCREEN_WIDTH - 20 - 40) / 3.0;
    for (NSInteger i = 0; i < [_imgArray count]; i ++) {
        NSInteger x = i / 3;
        NSInteger y = i % 3;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (width + 10) * y,  (_faceBtn.bottom + 20) + (width + 10) * x , width, width)];
        [imgView setImage:_imgArray[i]];
//        imgView.backgroundColor = [UIColor redColor];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [_scrollView addSubview:imgView];
    }
    
    if ([_imgArray count] < 9) {
        NSInteger x = [_imgArray count] / 3;
        NSInteger y = [_imgArray count] % 3;
        _changeImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeImgBtn.frame = CGRectMake(10 + (width + 10) * y, (_faceBtn.bottom + 20) + (width + 10) * x , width, width);
        [_changeImgBtn addTarget:self action:@selector(changeImg) forControlEvents:UIControlEventTouchUpInside];
        [_changeImgBtn setImage:[UIImage imageNamed:@"add_img2.png"] forState:UIControlStateNormal];
        [_scrollView addSubview:_changeImgBtn];
    }
    CGFloat height;
    if ([_imgArray count] == 0) {
        height = _changeImgBtn.bottom + 20;
    }else if ([_imgArray count] == 9) {
        height = _faceBtn.bottom + 20 + (width + 10) * ([_imgArray count] / 3) + 20;
    }else {
        height = _faceBtn.bottom + 20 + (width + 10) * ([_imgArray count] / 3) + width + 20;
    }
    _confirmBtn.frame = CGRectMake(_scrollView.right - 70, height, 45, 25);
    _scrollView.contentSize = CGSizeMake(_scrollView.width, _confirmBtn.bottom + 20);
}

- (void)faceBtnClick
{
    if ([_currentTV isFirstResponder]) {
        [_currentTV resignFirstResponder];
        if ([_currentTV.inputView isEqual:_faceBoard]) {
            _faceBoard.inputTextView = nil;
            _currentTV.inputView = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [_currentTV becomeFirstResponder];

            });
        }else {
            _faceBoard.inputTextView = _currentTV;
            _currentTV.inputView = _faceBoard;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [_currentTV becomeFirstResponder];
            });
        }
    }else {
        _faceBoard.inputTextView = _currentTV;
        _currentTV.inputView = _faceBoard;
        [_currentTV becomeFirstResponder];
    }

}

#pragma mark - faceboard  代理
- (void)textViewDidChange:(UITextView *)_textView {
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:_textView];
}

- (void)textViewDidBeginEditing:(MyTextView *)textView;
{
    _currentTV = textView;
    _faceBoard.inputTextView = _currentTV;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *firstResponder = (MyTextView *)[[UIApplication sharedApplication].keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder isKindOfClass:[MyTextView class]]) {
        _currentTV = (MyTextView *)firstResponder;
    }
    [self.view endEditing:YES];
}

//添加图片
- (void)changeImg
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
//    NSData *data = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.1);
    [_imgArray addObject:[info objectForKey:UIImagePickerControllerOriginalImage]];
    [self buildImgView];
        //    [[tools shared] HUDShowText:@"正在上传..."];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager POST:@"http://nzxyadmin.53xsd.com/mobi/ser/saveImage" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:@"Image" fileName:@"upload.jpg" mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([[responseObject objectForKey:@"code"] integerValue] == 0)  {
//            NSDictionary *dic = nilOrJSONObjectForKey(responseObject, @"result");
//            [User shareUser].logo = nilOrJSONObjectForKey(dic, @"imageUrl");
//            [[tools shared] HUDShowHideText:@"上传成功" delay:1.5];
//            
//            NSMutableData *data = [[NSMutableData alloc] init];
//            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//            [archiver encodeObject:[User shareUser] forKey:@"user"];
//            [archiver finishEncoding];
//            NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"MyUser"];
//            [data writeToFile:path atomically:YES];
//            
//        }else {
//            [[tools shared] HUDShowHideText:@"上传失败" delay:1.5];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        HUDShowErrorServerOrNetwork
//    }];
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
