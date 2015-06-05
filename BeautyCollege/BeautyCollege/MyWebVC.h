//
//  MyWebVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/4.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWebVC : MyCustomVC<UIWebViewDelegate>

@property (nonatomic, strong) NSString          *URLStr;

@property (nonatomic, assign) NSInteger         type;

@end
