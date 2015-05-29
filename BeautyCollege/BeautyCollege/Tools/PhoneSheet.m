//
//  PhoneSheet.m
//  mlh
//
//  Created by qd on 13-5-14.
//  Copyright (c) 2013年 sunday. All rights reserved.
//

#import "PhoneSheet.h"

@interface PhoneSheet()
{
    NSString *_phoneNumber;
}

@end

@implementation PhoneSheet

- (id)initWithPhoneNumber:(NSString *)phoneNumber{
    self = 	[super initWithTitle:phoneNumber
                        delegate:self
               cancelButtonTitle:@"取消"
          destructiveButtonTitle:@"拔打"
               otherButtonTitles:nil,nil];
    if (!self) {
        return nil;
    }
    
    _phoneNumber = phoneNumber;
    
    self.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    return self;
}

//本来应该是delegate方法，但是为了简化业务模块页面的编写，就写在这里了。这样业务模块页面只需要init这个actionsheet就可以，不用再重复写delegate方法。
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [actionSheet cancelButtonIndex]) {
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneNumber]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}

@end
