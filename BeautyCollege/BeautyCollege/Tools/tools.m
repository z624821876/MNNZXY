//
//  tools.m
//  mlh
//
//  Created by qd on 13-5-9.
//  Copyright (c) 2013年 sunday. All rights reserved.
//


#import "Util.h"
#import "AppDelegate.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"


@interface tools()
{
    MBProgressHUD *HUD;
}

@end

@implementation tools

+ (tools*) shared
{
    static tools *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[tools alloc] init];
    });
    return _shared;
}

#pragma mark - HUD show and shide

-(void)HUDShowHideText:(NSString *)text delay:(NSTimeInterval)delay{
    [HUD hide:YES];
    HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	HUD.mode = MBProgressHUDModeText;
	HUD.labelText = text;
    HUD.yOffset = -35.f;
	HUD.margin = 10.f;
	HUD.removeFromSuperViewOnHide = YES;
	[HUD hide:YES afterDelay:delay];
}

//不带Hide的show方法，必须跟HUDHide方法配合使用，或者再新开一个show方法（会自动hide之前的HUD）
-(void)HUDShowText:(NSString *)text{
    [HUD hide:YES];
    HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	HUD.labelText = text;
    HUD.yOffset = -35.f;
	HUD.margin = 10.f;
	HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:60];
}

-(void)HUDHide{
    [HUD hide:YES];
}

#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
	HUD = nil;
}

//延迟读图片用HUD圈圈显示进度,适合用在图片宽高比例固定的场景
+(void)imageViewHUD:(UIImageView *)imageView setImageWithURL:(NSURL *)imageUrl {
    
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:imageView];
    HUD.margin = 5.f;
    [imageView addSubview:HUD];
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [HUD show:YES];

    [imageView sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        HUD.progress = receivedSize/expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [HUD hide:YES];

    }];
}

//延迟读图片并显示读图片指示器,适合用在图片宽高比例固定的场景
+(void)imageView:(UIImageView *)imageView setImageWithURL:(NSURL *)imageUrl indicatorStyle:(UIActivityIndicatorViewStyle) activityIndicatorViewStyle
{
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = imageView.bounds;
    [imageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [activityIndicator removeFromSuperview];

    }];
    
}

//延迟读图片并显示读图片指示器,并从block得到UIImage,适合用在图片宽高比例不定的场景
+(void)imageView:(UIImageView *)imageView setImageWithURL:(NSURL *)imageUrl indicatorStyle:(UIActivityIndicatorViewStyle) activityIndicatorViewStyle ReturnBlock:(void (^)(UIImage *image,NSError *error)) block {
    
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = imageView.bounds;
    [imageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [activityIndicator removeFromSuperview];
        if (block) {
            block(image,error);
        }
    }];
}

/** 为methodUrl拼接其他的参数,组成url（除baseUrl)
  * 参数methodUrl格式为：
  *  item?itemid=109&itemtype=3&iosview=infs 或 schedule_delete?1=1
  * 返回url格式为：
  *  item?itemid=109&itemtype=3&iosview=infs&uucode=ios&appcode=SUNDAY&uuid=(null)&uuname=(null)&uutype=1&uuversion=(null)
 */
+(NSString *) getServiceUrl:(NSString *)methodUrl{
    NSMutableString * serviceUrl=[NSMutableString  stringWithCapacity:100];
    if(methodUrl!=nil&&![methodUrl isEqualToString:@""])
    {
        [serviceUrl appendString:methodUrl];
        [serviceUrl appendString:[NSString stringWithFormat:@"&uucode=ios&appcode=%@", sAppName]] ;// [tools getUserUrl]]];
        return [Util getWebViewUrlStr:serviceUrl];  //url可能有中文，所以需要转一下
    }
    else
    {
        return nil;
    }
}

/**完整版的serurl
 *加上了baseUrl
 */
+(NSMutableString *) getCompleteServiceUrl:(NSString *)methodUrl{
    NSMutableString * serviceUrl=[NSMutableString  stringWithCapacity:150];
    [serviceUrl appendFormat:@"%@%@",sBaseJsonURLStr,[tools getServiceUrl:methodUrl]];
    return serviceUrl;
}
+(NSMutableString *) getCompleteServiceUrlWeb:(NSString *)methodUrl{
    NSMutableString * serviceUrl=[NSMutableString  stringWithCapacity:150];
    [serviceUrl appendFormat:@"%@%@",sBaseJsonURLStrWeb,[tools getServiceUrl:methodUrl]];
    return serviceUrl;
}

//
////AFNetworking在真机测试时uuid=(null)这种格式似乎处理有问题，所以屏蔽了这种格式的url产生
//+(NSString *) getUserUrl{
//    if([AppDelegate sharedAppDelegate].user.id==nil){
//        if([AppDelegate sharedAppDelegate].devices_token==nil){
//            return @"";
//        }else{
//            return [[NSString alloc]initWithFormat:@"&uuid=%@&uuname=%@&uutype=%@&uuversion=%@",[[Util stringByRemoveTrim:[AppDelegate sharedAppDelegate].devices_token ] substringWithRange: NSMakeRange(1, 71)],[AppDelegate sharedAppDelegate].devices_name,[AppDelegate sharedAppDelegate].devices_type,[AppDelegate sharedAppDelegate].devices_version];
//        }
//    }else {
//        if([AppDelegate sharedAppDelegate].devices_token==nil){
//            return [[NSString alloc]initWithFormat:@"&userid=%@",[AppDelegate sharedAppDelegate].user.id];
//        }else{
//            return [[NSString alloc]initWithFormat:@"&userid=%@&uuid=%@&uuname=%@&uutype=%@&uuversion=%@",[AppDelegate sharedAppDelegate].user.id,[[Util stringByRemoveTrim:[AppDelegate sharedAppDelegate].devices_token ] substringWithRange: NSMakeRange(1, 71)],[AppDelegate sharedAppDelegate].devices_name,[AppDelegate sharedAppDelegate].devices_type,[AppDelegate sharedAppDelegate].devices_version];
//        }
//        
//    }
//}



+ (UIColor*)getNavTitleColor{
    return [Util colorWithHexString:@"#FFFFFF"];
}



@end
