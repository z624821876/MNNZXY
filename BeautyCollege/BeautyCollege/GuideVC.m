//
//  GuideVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/5/27.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "GuideVC.h"

@interface GuideVC ()

@end

@implementation GuideVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _scroll.bounces = NO;
    _scroll.pagingEnabled = YES;
    NSArray *array = @[@"guide1.jpg",@"guide2.jpg",@"guide3.jpg"];
    for (NSInteger i = 0; i < 3; i ++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH * i, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        [img setImage:[UIImage imageNamed:array[i]]];
        [_scroll addSubview:img];
    }
    [_scroll setContentSize:CGSizeMake(UI_SCREEN_WIDTH * 3, UI_SCREEN_HEIGHT)];
    [self.view addSubview:_scroll];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(UI_SCREEN_WIDTH * 2 + 90 * UI_scaleX, 360 * UI_scaleY, 150 * UI_scaleX, 50 * UI_scaleY);
    [btn addTarget:self action:@selector(btnClik) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:btn];
}

- (void)btnClik
{
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH * 2, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [img setImage:[UIImage imageNamed:@"guide3x.jpg"]];
    [_scroll addSubview:img];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [[AppDelegate shareApp] showMainTabBar];
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [[AppDelegate shareApp] showMainTabBar];
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
