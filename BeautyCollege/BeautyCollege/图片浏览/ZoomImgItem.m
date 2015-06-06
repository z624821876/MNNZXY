//
//  ZoomImgItem.m
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "ZoomImgItem.h"
@implementation ZoomImgItem

- (void)dealloc {
    self.imgName = nil;
    if (imageView) {
        [imageView release];
        imageView = nil;
    }
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}


- (void)_initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    imageView = [[KL_ImageZoomView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:imageView];
}

- (void)setImgName:(NSString *)imgName {
    if (_imgName != imgName) {
        [_imgName release];
        _imgName = [imgName retain];
    }
    [imageView resetViewFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    [imageView uddateImageWithUrl:imgName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [imageView sd]
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
