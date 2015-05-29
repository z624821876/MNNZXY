//
//  DoHomeworkVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/11.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"
#import "FaceBoard.h"
#import "CustomScrollView.h"

typedef void(^UpdateBlock)();

@interface DoHomeworkVC : MyCustomVC<FaceBoardDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) FaceBoard         *faceBoard;
@property (strong, nonatomic) NSString          *lessonsId;
@property (strong, nonatomic) NSString          *classCatId;
@property (strong, nonatomic) CustomScrollView  *scrollView;

@property (copy, nonatomic) UpdateBlock block;

@end


