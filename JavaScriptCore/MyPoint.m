//
//  MyPoint.m
//  JavaScriptCore
//
//  Created by zrb_dxs on 2018/11/29.
//  Copyright © 2018 jacydai. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint
@synthesize x;

@synthesize y;

- (NSString *)description {

    NSString *description = [NSString stringWithFormat:@"x %f, y %f",self.x, self.y];
    return description;
}

+ (MyPoint *)makePointWithX:(double)x y:(double)y {

    MyPoint *point = [[MyPoint alloc] init];

    point.x = x;
    point.y = y;

    return point;
}

- (void)myPointWithX:(double)x y:(double)y {

    self.x = x;
    self.y = y;
}

- (NSString *)pointDesc {

    return [NSString stringWithFormat:@"x = %f y = %f",self.x, self.y];
}

- (NSString *)descExport {

    return [self pointDesc];
}

@end
