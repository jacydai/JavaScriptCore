//
//  SecondViewController.m
//  JavaScriptCore
//
//  Created by zrb_dxs on 2018/11/29.
//  Copyright © 2018 jacydai. All rights reserved.
//

#import "SecondViewController.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface SecondViewController () <UIWebViewDelegate>
@property (nonatomic, strong)  UIWebView         *webView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self. title = @"Second";

    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate  = self;

    [self.view addSubview:self.webView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    NSLog(@"context %@",context);
    NSLog(@"all properties %@",[self getAllPropertiesAndVaules]);
   NSString *jsStr = [self.webView stringByEvaluatingJavaScriptFromString:@"var a = 10; var b = 20; a+b"];

//    JSContext *context2 = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//
//    context2[@"myConsole"] = @"123413";
//
//    JSValue *function = context2[@"onClickHandler"];
//
//    JSValue *color = [function callWithArguments:nil];
//
//    NSLog(@"value %@",color);
//
//    NSLog(@"context 2 %@",context2);
    NSLog(@"jsStr %@",jsStr);
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {

    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {

    NSLog(@"=========\n\n %@ ===========\n\n",[self getAllPropertiesAndVaules]);

    JSContext *context2 = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    context2[@"myConsole"] = ^(NSString *js2OC) {

        NSLog(@"This message come frome webJS%@",js2OC);
    };


//    JSValue *function = context2[@"colorForWord"];
//
////    JSValue *color = [function callWithArguments:@[colorStr]];
//    JSValue *color = [function callWithArguments:nil];

//    NSLog(@"value %@",color);

    NSLog(@"context 2 %@",context2);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {


}

#pragma mark - 打印所有方法和属性

/* 获取对象的所有属性和属性内容 */
- (NSDictionary *)getAllPropertiesAndVaules
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties =class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
        {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
        }
    free(properties);
    return props;
}
/* 获取对象的所有属性 */
- (NSArray *)getAllProperties
{
    u_int count;

    objc_property_t *properties  =class_copyPropertyList([self class], &count);

    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];

    for (int i = 0; i < count ; i++)
        {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
        }

    free(properties);

    return propertiesArray;
}
/* 获取对象的所有方法 */
-(void)getAllMethods
{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++)
        {
        Method temp_f = mothList_f[i];
        IMP imp_f = method_getImplementation(temp_f);
        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,
              [NSString stringWithUTF8String:encoding]);
        }
    free(mothList_f);
}



@end
