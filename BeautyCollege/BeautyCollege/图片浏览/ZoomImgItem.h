//
//  ZoomImgItem.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KL_ImageZoomView.h"

@interface ZoomImgItem : UITableViewCell
{
    KL_ImageZoomView *imageView;
}

@property (nonatomic, retain)NSString *imgName;
@property (nonatomic, assign)CGSize size;

@end
