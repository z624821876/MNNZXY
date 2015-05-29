//
//  UIImage+Category.h
//  mobileikaola
//
//  Created by hf zhao on 13-11-5.
//  Copyright (c) 2013年 ikaola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)
+(UIImage *)imageNamed:(NSString *)name stretchableImageWithLeftCapWidth:(float)leftCap topCapHeight:(float)topCap;
- (UIImage *)roundCorners;//圆头像
-(NSString *)saveToFile;
@end
