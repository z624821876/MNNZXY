//
//  ReturncardVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/22.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"
#import "FaceBoard.h"
#import "CustomScrollView.h"

@interface ReturncardVC : MyCustomVC<FaceBoardDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSString          *homeworkId;
@property (strong, nonatomic) FaceBoard         *faceBoard;
@property (strong, nonatomic) CustomScrollView  *scrollView;

@end
