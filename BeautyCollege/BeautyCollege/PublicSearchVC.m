//
//  PublicSearchVC.m
//  BeautyCollege
//
//  Created by 于洲 on 15/6/3.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "PublicSearchVC.h"
#import "SearchResultVC.h"

@interface PublicSearchVC ()

@property (nonatomic, strong) UITextField   *searchTF;

@end

@implementation PublicSearchVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"搜索";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 64 + 30 * UI_scaleY, UI_SCREEN_WIDTH - 30, 35)];
    [img setImage:[UIImage imageNamed:@"07-超市_11.png"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    //    img.clipsToBounds = YES;
    [self.view addSubview:img];
    
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(img.left + 30 * UI_scaleX, img.top, img.width - 30 * UI_scaleX - 10, 35)];
//    _searchTF.text = _cateTitle;
    _searchTF.placeholder = @"搜索";
    _searchTF.delegate = self;
    _searchTF.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:_searchTF];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField.text.length > 0) {
        SearchResultVC *vc = [[SearchResultVC alloc] init];
        vc.searchtype = self.searchtype;
        vc.keyword = textField.text;
        [self.navigationController pushViewController:vc animated:YES];
    }

    return YES;
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
