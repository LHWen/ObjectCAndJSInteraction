//
//  UIWebJS_Plugin.h
//  OriginalAndJS
//
//  Created by LHWen on 2018/1/3.
//  Copyright © 2018年 LHWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol WebJSObjextProtocol <JSExport>

- (void)webReturninfo:(NSString *)info;

@end

@protocol UIWebPluginDelegate <NSObject>

- (void)webReturninfo:(NSString *)info;

@end

@interface UIWebJS_Plugin : NSObject<WebJSObjextProtocol>

@property (nonatomic, weak) id<UIWebPluginDelegate> delegate;

@end
