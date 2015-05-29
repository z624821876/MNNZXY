//
//  tools.h
//  mlh
//
//  Created by qd on 13-5-9.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface tools : NSObject <MBProgressHUDDelegate>

+ (tools*) shared;

-(void)HUDShowHideText:(NSString *)text delay:(NSTimeInterval)delay;    //只显示text，几秒后隐藏，适合用于显示弹出信息。

//不带Hide的Show方法，必须跟HUDHide方法配合使用，或者再新开一个show方法（会自动hide之前的HUD）
-(void)HUDShowText:(NSString *)text;    //显示indicator+文本,不自动隐藏。

-(void)HUDHide;                         //隐藏，跟上面的方法配合，在任务完成后使用，适合用于显示任务开始和结束

+(NSMutableString *) getServiceUrl:(NSString *)methodUrl;
+(NSMutableString *) getCompleteServiceUrl:(NSString *)methodUrl;
+(NSMutableString *) getCompleteServiceUrlWeb:(NSString *)methodUrl;
+(UIColor*)getNavTitleColor;

//延迟读图片用HUD圈圈显示进度,适合用在图片宽高比例固定的场景
+(void)imageViewHUD:(UIImageView *)imageView setImageWithURL:(NSURL *)imageUrl;

//延迟读图片并显示读图片指示器
+(void) imageView:(UIImageView *)imageView setImageWithURL:(NSURL *)imageUrl indicatorStyle:(UIActivityIndicatorViewStyle) activityIndicatorViewStyle;

//延迟读图片并显示读图片指示器,并从block得到UIImage
+(void)imageView:(UIImageView *)imageView  setImageWithURL:(NSURL *)imageUrl indicatorStyle:(UIActivityIndicatorViewStyle) activityIndicatorViewStyle ReturnBlock:(void (^)(UIImage *image,NSError *error)) block;



@end
