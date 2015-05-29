//
//  GoodsVC.h
//  BeautyCollege
//
//  Created by 于洲 on 15/5/15.
//  Copyright (c) 2015年 张雨生. All rights reserved.
//

#import "MyCustomVC.h"

@interface GoodsVC : MyCustomVC<UIWebViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSString          *goodsId;
@property (nonatomic, strong) NSString          *catId;
@property (nonatomic, strong) UIScrollView      *shufflingScroll;
@property (nonatomic, strong) UIScrollView      *bgScroll;
@end
