//
//  Shopcatcell.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/23.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Shopcatcell : UITableViewCell
@property (nonatomic, strong) BaseCellModel     *model;
@property (nonatomic, assign) NSInteger         type;

@property (nonatomic, strong) UIButton          *addBtn;
@property (nonatomic, strong) UIButton          *numBtn;
@property (nonatomic, strong) UIButton          *reduceBtn;

@end
