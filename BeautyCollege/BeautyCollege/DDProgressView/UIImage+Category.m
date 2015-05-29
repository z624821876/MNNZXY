//
//  UIImage+Category.m
//  mobileikaola
//
//  Created by hf zhao on 13-11-5.
//  Copyright (c) 2013年 ikaola. All rights reserved.
//

#import "UIImage+Category.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UIImage (Category)
+(UIImage *)imageNamed:(NSString *)name stretchableImageWithLeftCapWidth:(float)leftCap topCapHeight:(float)topCap
{
    return [[UIImage imageNamed:name] stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}
- (UIImage *)roundCorners
{
    int w = self.size.width;
    int h = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    addRoundedRectToPath(context, rect, w/2, h/2);
    CGContextClosePath(context);
    CGContextClip(context);

    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *tmpImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    return tmpImage;
}
//这是静态方法
static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect),
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
-(NSString *)saveToFile
{
    int rand = arc4random();
    NSString *name = [NSString stringWithFormat:@"%.0f%d",[[NSDate date] timeIntervalSince1970],rand];
    const char *str = [name UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5 = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *savedImagePath = [docsDir
                               stringByAppendingPathComponent:[NSString stringWithFormat:@"Caches/%@.jpg",md5]];
    NSData *imagedata = UIImageJPEGRepresentation(self, 1.0);
    [imagedata writeToFile:savedImagePath atomically:YES];
    return savedImagePath;
}
@end
