//
//  ViewController.h
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolVC.h"
#import "SchoolmateVC.h"
#import "ClassroomVC.h"
#import "SupermarketVC.h"
#import "DormVC.h"

@interface ViewController : UITabBarController
@property (nonatomic ,strong) SchoolVC      *school;
@property (nonatomic ,strong) SchoolmateVC  *schoolmate;
@property (nonatomic ,strong) ClassroomVC   *classroom;
@property (nonatomic ,strong) SupermarketVC *supermarket;
@property (nonatomic ,strong) DormVC        *dorm;


@end

