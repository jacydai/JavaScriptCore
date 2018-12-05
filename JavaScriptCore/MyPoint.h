//
//  MyPoint.h
//  JavaScriptCore
//
//  Created by zrb_dxs on 2018/11/29.
//  Copyright © 2018 jacydai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@class MyPoint;
@protocol MyPointExports <JSExport>

@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;

- (NSString *)description;

+ (MyPoint *)makePointWithX:(double)x y:(double)y;

@end

@interface MyPoint : NSObject <MyPointExports>

@end

NS_ASSUME_NONNULL_END
