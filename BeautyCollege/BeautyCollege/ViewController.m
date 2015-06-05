//
//  ViewController.m
//  BeautyCollege
//
//  Created by 于洲 on 15/4/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *array = [self viewControllers];
    self.school = array[0];
    self.schoolmate = array[1];
    self.classroom = array[2];
    self.supermarket = array[3];
    self.dorm = array[4];

    _school.title=@"校园";
    _schoolmate.title=@"同学";
    _classroom.title=@"课程";
    _supermarket.title=@"超市";
    _dorm.title=@"宿舍";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
