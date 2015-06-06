//
//  CreateLessonVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/22.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"
#import "CustomScrollView.h"

@interface CreateLessonVC : MyCustomVC<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic, assign) NSInteger         cateId;
@property (nonatomic, strong) NSString          *mark;
@property (nonatomic, strong) NSString          *cityId;

@property (nonatomic, strong) CustomScrollView      *scrollView;

@end
