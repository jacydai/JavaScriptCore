//
//  OCRunJavaScript.h
//  JavaScriptCore
//
//  Created by zrb_dxs on 2018/11/26.
//  Copyright © 2018 jacydai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCRunJavaScript : NSObject

// OC -- JS
+ (void)nativeEvaluateJS;

// 执行JS代码
- (void)runJSCode;


/**
 JS 修改OC中 对象的颜色

 @param colorStr 颜色类型      red 红色 blue 蓝色 other 随机色
 @return         对应的颜色值
 */
- (UIColor *)changeColorsWithJS:(NSString *)colorStr;

/**
 Block 使用不当的例子

 */
- (void)badCallbackDemo;

/**
 Block 恰当使用的栗子

 */
- (void)goodCallbackDemo;


/**
 JSExport 协议做对象互传
 */
- (void)runJSExportObject;
@end

NS_ASSUME_NONNULL_END
