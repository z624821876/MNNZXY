//
//  BaseCell.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/16.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCellModel.h"
#import "CellView.h"
#import "CateCellView.h"

typedef void(^PushBlock)(NSInteger i);
typedef void(^PushBlock2)(id model);


@interface BaseCell : UITableViewCell

@property (copy, nonatomic) PushBlock block;
@property (copy, nonatomic) PushBlock2 block2;

@property (strong, nonatomic) NSMutableArray      *btnArray;

@property (strong, nonatomic) UILabel           *label1;
@property (strong, nonatomic) UILabel           *label2;
@property (strong, nonatomic) UILabel           *label3;
@property (strong, nonatomic) UIImageView       *logoImg;

@property (strong, nonatomic) UIImageView       *img1;
@property (strong, nonatomic) UIImageView       *img2;
//@property (strong, nonatomic) UIImageView   *img3;

@property (strong, nonatomic) UIImageView   *bgView;
@property (strong, nonatomic) UIButton      *btn1;
@property (strong, nonatomic) UIButton      *btn2;
@property (strong, nonatomic) UIButton      *btn3;

@property (strong, nonatomic) NSIndexPath   *indexPath;
@property (assign, nonatomic) NSInteger     type;
@property (strong, nonatomic) BaseCellModel *model;
@property (strong, nonatomic) CellView      *cellView;
@property (strong, nonatomic) CellView      *cellView2;
@property (strong, nonatomic) BaseCellModel *model2;
@property (strong, nonatomic) CateCellView  *cellView3;
@property (strong, nonatomic) NSArray       *modelArray;

@property (strong, nonatomic) NSString      *title;
@property (strong, nonatomic) NSString      *name;

@property (strong, nonatomic) UIView        *leftView;

@end
