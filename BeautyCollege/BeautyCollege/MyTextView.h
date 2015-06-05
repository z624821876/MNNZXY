//
//  MyTextView.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/14.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTextView : UITextView

@property (nonatomic, strong) NSIndexPath *indexPath;

/*!
 * @brief 占位符文本,与UITextField的placeholder功能一致
 */
@property (nonatomic, strong) NSString *placeholder;

/*!
 * @brief 占位符文本颜色
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;

@end
