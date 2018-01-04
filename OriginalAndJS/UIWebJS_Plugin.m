//
//  UIWebJS_Plugin.m
//  OriginalAndJS
//
//  Created by LHWen on 2018/1/3.
//  Copyright © 2018年 LHWen. All rights reserved.
//

#import "UIWebJS_Plugin.h"

@implementation UIWebJS_Plugin

- (void)webReturninfo:(NSString *)info {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(webReturninfo:)]) {
            [self.delegate webReturninfo:info];
        }
    });
}

@end
