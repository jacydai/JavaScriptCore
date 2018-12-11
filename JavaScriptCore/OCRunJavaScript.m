//
//  OCRunJavaScript.m
//  JavaScriptCore
//
//  Created by zrb_dxs on 2018/11/26.
//  Copyright © 2018 jacydai. All rights reserved.
//

#import "OCRunJavaScript.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JavaScriptBridge_JS.h"
#import "MyPoint.h"

@interface OCRunJavaScript ()

@property (nonatomic, strong) JSContext       *context;

@property (nonatomic, strong) JSContext       *vmContext;

@property (nonatomic, strong) JSVirtualMachine *vm;

@end
@implementation OCRunJavaScript

- (void)dealloc {

    NSLog(@"OCRunJavaScript will destory !!!!");
}

- (instancetype)init {

    if (self =[super init]) {

        self.context = [[JSContext alloc] init];
        [self baseJSCodeLoad];// 加载本地js

        // JSVirtualMachine
        self.vm = [[JSVirtualMachine alloc] init];

        self.vmContext = [[JSContext alloc] initWithVirtualMachine:self.vm];
    }

    return self;
}

+ (void)nativeEvaluateJS {

    // OC --> JS
//    [self baseJSCode];

    // OC --> JS   function
    [self callJavaScriptFunctions];
}

// 加载基本的js代码
- (void)baseJSCodeLoad {

    NSString *jsCode = javaScriptText();
    [self.context evaluateScript:jsCode];

    // log
    __weak id weakSelf = self;
    self.context[@"ocLog"] = ^(id log) {
        __strong id strongSelf = weakSelf;
        [strongSelf ocLog:log];
    };
}

- (void)baseJSCodeLoad:(JSContext *)context {

    NSString *jsCode = javaScriptText();
    [context evaluateScript:jsCode];

    // log
    context[@"ocLog"] = ^(id log) {
        [self ocLog:log];
    };
}

#pragma mark - Objective-C ---->JavaScript
+ (void)baseJSCode {
    JSContext *context = [[JSContext alloc] init];

    NSString *jsStr = @"var a = 20; var b = 30; a+b;";

    JSValue *result = [context evaluateScript:jsStr];

    NSLog(@"a + b = %d",[result toInt32]);
    
    
    NSLog(@"a = %@", [context objectForKeyedSubscript:@"a"]);
    NSLog(@"a = %@", [context.globalObject objectForKeyedSubscript:@"a"]);
    NSLog(@"a = %@", context[@"a"]);
}


+ (void)callJavaScriptFunctions {
    
    //    NSString *functionStr = @"   var factorial = function(n) { if (n < 0) { return; } if (n === 0) { return 1;} return n * factorial(n - 1); }";
    
    //    JSManagedValue
    NSString *facttorial = javaScriptText();
    JSContext *content = [[JSContext alloc] init];
    [content evaluateScript:facttorial];
    
    JSValue *function = content[@"factorial"];
    
    JSValue *result = [function callWithArguments:@[@(5)]];
    NSLog(@"factorial(10) = %d", [result toInt32]);
}

- (void)callJavaScriptFunctions {
    
    //    NSString *functionStr = @"   var factorial = function(n) { if (n < 0) { return; } if (n === 0) { return 1;} return n * factorial(n - 1); }";
    
    //    JSManagedValue
    NSString *facttorial = javaScriptText();
    //    JSContext *content = [[JSContext alloc] init];
    [self.context evaluateScript:facttorial];
    
    JSValue *function = self.context[@"factorial"];
    
    JSValue *result = [function callWithArguments:@[@(5)]];
    NSLog(@"factorial(10) = %d", [result toInt32]);
}

#pragma mark - JavaScript ----> Objective-C

// Blocks
// 1.Easy way to expose Objective-C code to JavaScript
// 2. Automatically wraps Objective-C block inside callable JavaScript function
- (UIColor *)changeColorsWithJS:(NSString *)colorStr {
    
    self.context[@"makeUIColor"] = ^(NSDictionary *rgb) {
        
        float r = [rgb[@"red"] floatValue];
        float g = [rgb[@"green"] floatValue];
        float b = [rgb[@"blue"] floatValue];
        
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0];
    };
    
    NSString *jsCode = javaScriptText();
    [self.context evaluateScript:jsCode];
    JSValue *function = self.context[@"colorForWord"];
    
    JSValue *color = [function callWithArguments:@[colorStr]];
    id ocColor = [color toObject];
    NSLog(@"OC Color %@",ocColor);
    
    return ocColor;
}

// Waring: Caveats
// Avoid capturing JSValues
// Prefer passing as arguments
// Avoid capturing JSContexts
//    Use + [JSContext currentContext]

//    Bad
//    JSContext *context = [[JSContext alloc] init];
//    context[@"callback"] = ^{
//        JSValue *object = [JSValue valueWithNewObjectInContext:context];
//        object[@"x"] = 2;
//        object[@"y"] = 3;
//        return object;
//    };
- (void)badCallbackDemo {

    //    JSContext *context = [[JSContext alloc] init];
    self.context[@"callback"] = ^{
        JSValue *object = [JSValue valueWithNewObjectInContext:self.context];
        object[@"x"] = @(2);
        object[@"y"] = @(3);
        return object;
    };

//    NSString *jsCode = javaScriptText();
//    [self.context evaluateScript:jsCode];
    [self baseJSCodeLoad];
    JSValue *function = self.context[@"jscallback"];

    JSValue *jsResult = [function callWithArguments:nil];
    id result = [jsResult toObject];
    NSLog(@"OC jsResult %@",result);

}

//    Good
//    JSContext *context = [[JSContext alloc] init];
//    context[@"callback"] = ^{
//        JSValue *object = [JSValue valueWithNewObjectInContext:
//                           [JSContext currentContext]];
//        object[@"x"] = 2;
//        object[@"y"] = 3;
//        return object;
//    };
- (void)goodCallbackDemo {


    //    JSContext *context = [[JSContext alloc] init];
    self.context[@"callback"] = ^{
        JSValue *object = [JSValue valueWithNewObjectInContext:[JSContext currentContext]];
        object[@"x"] = @(2);
        object[@"y"] = @(3);
        return object;
    };

//    NSString *jsCode = javaScriptText();
//    [self.context evaluateScript:jsCode];
    [self baseJSCodeLoad];

    JSValue *function = self.context[@"jscallback"];

    JSValue *jsResult = [function callWithArguments:nil];
    id result = [jsResult toObject];
    NSLog(@"OC jsResult %@",result);
}



/*
    <pre>
    @textblock
    Objective-C type  |   JavaScript type
    --------------------+---------------------
    nil         |     undefined
    NSNull       |        null
    NSString      |       string
    NSNumber      |   number, boolean
    NSDictionary    |   Object object
    NSArray       |    Array object
    NSDate       |     Date object
    NSBlock (1)   |   Function object (1)
    id (2)     |   Wrapper object (2)
    Class (3)    | Constructor object (3)
    @/textblock
    </pre>
 */


- (void)runJSCode {

//    [self callJavaScriptFunctions];
//    NSLog(@"JS Vitrual Machine %@", self.context.virtualMachine);
//
//    NSLog(@"JS Virtual Machine %@ vmContext vm %@", self.vm, self.vmContext.virtualMachine);
//
//
//    [self creatingJSValues];

    // OC Color
//    [self changeColorsWithJS];
    
    // JSValue Type
    [self convertOCTypeValues];
}


#pragma mark - JSValue

// 1. Creating JavaScript values
- (void)creatingJSValues {

    JSValue *boolValue = [JSValue valueWithBool:YES inContext:self.vmContext];
    JSValue *doubleValue = [JSValue valueWithDouble:30.8 inContext:self.vmContext];
    JSValue *intValue = [JSValue valueWithInt32:55 inContext:self.vmContext];

    NSLog(@"boolValue %d, doubleValue %f ,intValue %d", [boolValue toBool], [doubleValue toDouble], [intValue toInt32]);

    NSLog(@"vmContext %@ vmContext name %@",self.vmContext.globalObject, self.vmContext.name);

}

// 2. Converting to Objective-C Types
- (void)convertOCTypeValues {

    [self baseJSCodeLoad];
////    __weak id weakSelf; typeof(self);
//    self.context[@"ocLog"] = ^(id log) {
////        __strong id strongSelf typeof(self);
//        [self ocLog:log];
//    };
//
    [self.context evaluateScript:@"var color = {red:230, green:90, blue:100}"];

    //js->native
    JSValue *colorValue = self.context[@"color"];
    NSLog(@"r=%@, g=%@, b=%@", colorValue[@"red"], colorValue[@"green"], colorValue[@"blue"]);

    NSDictionary *colorDic = [colorValue toDictionary];
    NSLog(@"r=%@, g=%@, b=%@", colorDic[@"red"], colorDic[@"green"], colorDic[@"blue"]);
    
    //native->js
    self.context[@"color"] = @{@"red":@(2), @"green":@(2), @"blue":@(3)};
//   JSValue *jsValue =
    // 疑问，为什么不能打印？？？？？
    [self.context evaluateScript:@"log('jsr:'+color.red+'jsg:'+color.green+' jsb:'+color.blue)"];
    
//    NSLog(@"jsValue %@",jsValue);
    JSValue *jsValue = [self.context.globalObject objectForKeyedSubscript:@"color"];
     NSLog(@"color = %@", [jsValue toDictionary]);
    
}
// 3. Accessing properties

// 4. Checking javaScript types

// 5. Calling Functions and constructors

// 6. Category (structSupport)

#pragma mark - JSContext
// 1. Creating new JSContext
    /*!
     @methodgroup Creating New JSContexts
     */
    /*!
     @method
     @abstract Create a JSContext.
     @result The new context.
     */
//- (instancetype)init;

    /*!
     @method
     @abstract Create a JSContext in the specified virtual machine.
     @param virtualMachine The JSVirtualMachine in which the context will be created.
     @result The new context.
     */
//- (instancetype)initWithVirtualMachine:(JSVirtualMachine *)virtualMachine;


// 2. Evaluating Scripts
    /*!
     @methodgroup Evaluating Scripts
     */
    /*!
     @method
     @abstract Evaluate a string of JavaScript code.
     @param script A string containing the JavaScript code to evaluate.
     @result The last value generated by the script.
     */
//- (JSValue *)evaluateScript:(NSString *)script;

    /*!
     @method
     @abstract Evaluate a string of JavaScript code, with a URL for the script's source file.
     @param script A string containing the JavaScript code to evaluate.
     @param sourceURL A URL for the script's source file. Used by debuggers and when reporting exceptions. This parameter is informative only: it does not change the behavior of the script.
     @result The last value generated by the script.
     */
//- (JSValue *)evaluateScript:(NSString *)script withSourceURL:(NSURL *)sourceURL NS_AVAILABLE(10_10, 8_0);

// 3. Callback accessors
    /*!
     @methodgroup Callback Accessors
     */
    /*!
     @method
     @abstract Get the JSContext that is currently executing.
     @discussion This method may be called from within an Objective-C block or method invoked
     as a callback from JavaScript to retrieve the callback's context. Outside of
     a callback from JavaScript this method will return nil.
     @result The currently executing JSContext or nil if there isn't one.
     */
//+ (JSContext *)currentContext;

    /*!
     @method
     @abstract Get the JavaScript function that is currently executing.
     @discussion This method may be called from within an Objective-C block or method invoked
     as a callback from JavaScript to retrieve the callback's context. Outside of
     a callback from JavaScript this method will return nil.
     @result The currently executing JavaScript function or nil if there isn't one.
     */
//+ (JSValue *)currentCallee NS_AVAILABLE(10_10, 8_0);

    /*!
     @method
     @abstract Get the <code>this</code> value of the currently executing method.
     @discussion This method may be called from within an Objective-C block or method invoked
     as a callback from JavaScript to retrieve the callback's this value. Outside
     of a callback from JavaScript this method will return nil.
     @result The current <code>this</code> value or nil if there isn't one.
     */
//+ (JSValue *)currentThis;

    /*!
     @method
     @abstract Get the arguments to the current callback.
     @discussion This method may be called from within an Objective-C block or method invoked
     as a callback from JavaScript to retrieve the callback's arguments, objects
     in the returned array are instances of JSValue. Outside of a callback from
     JavaScript this method will return nil.
     @result An NSArray of the arguments nil if there is no current callback.
     */
//+ (NSArray *)currentArguments;

// 3. Global Properties
    /*!
     @functiongroup Global Properties
     */

    /*!
     @property
     @abstract Get the global object of the context.
     @discussion This method retrieves the global object of the JavaScript execution context.
     Instances of JSContext originating from WebKit will return a reference to the
     WindowProxy object.
     @result The global object.
     */
//    @property (readonly, strong) JSValue *globalObject;

    /*!
     @property
     @discussion The <code>exception</code> property may be used to throw an exception to JavaScript.

     Before a callback is made from JavaScript to an Objective-C block or method,
     the prior value of the exception property will be preserved and the property
     will be set to nil. After the callback has completed the new value of the
     exception property will be read, and prior value restored. If the new value
     of exception is not nil, the callback will result in that value being thrown.

     This property may also be used to check for uncaught exceptions arising from
     API function calls (since the default behaviour of <code>exceptionHandler</code> is to
     assign an uncaught exception to this property).
     */
//    @property (strong) JSValue *exception;

    /*!
     @property
     @discussion If a call to an API function results in an uncaught JavaScript exception, the
     <code>exceptionHandler</code> block will be invoked. The default implementation for the
     exception handler will store the exception to the exception property on
     context. As a consequence the default behaviour is for uncaught exceptions
     occurring within a callback from JavaScript to be rethrown upon return.
     Setting this value to nil will cause all exceptions occurring
     within a callback from JavaScript to be silently caught.
     */
//    @property (copy) void(^exceptionHandler)(JSContext *context, JSValue *exception);

    /*!
     @property
     @discussion All instances of JSContext are associated with a JSVirtualMachine.
     */
//    @property (readonly, strong) JSVirtualMachine *virtualMachine;

    /*!
     @property
     @discussion Name of the JSContext. Exposed when remote debugging the context.
     */
//    @property (copy) NSString *name NS_AVAILABLE(10_10, 8_0);


#pragma mark - JSExport

// JSExport
// Easy way for JavaScript to interact with Objective-C objects
    
- (void)runJSExportObject {

//    NSString *jsCode = javaScriptText();
//    JSValue *evalValue = [self.context evaluateScript:jsCode];

//    [self baseJSCodeLoad];
    MyPoint *point1 = [MyPoint makePointWithX:0 y:0];
    MyPoint *point2 = [MyPoint makePointWithX:1.0 y:1.0];

    // 1. 对象方法
    JSValue *function = self.context[@"euclideanDistance"];
    JSValue *result = [function callWithArguments:@[point1,point2]];

    NSLog(@"euclideanDistance JS result %@",result);

    // 2. 静态方法
    self.context[@"MyPoint"] = [MyPoint class];
    JSValue *function2 = self.context[@"midpoint"];
    JSValue *jsResult = [function2 callWithArguments:@[point1, point2]];
    MyPoint *midpoint = [jsResult toObject];
    NSLog(@"midpoint JS result %@",midpoint);


}

- (void)runJSExportObject2 {

    MyPoint *point = [MyPoint makePointWithX:10 y:20];
    self.context[@"mypoint"] = point;

//    [self.context evaluateScript:@"log(mypoint.description())"];

   JSValue *result = [self.context evaluateScript:@"log(mypoint.pointDesc())"];
//    JSValue *result = [self.context evaluateScript:@"mypoint.descExport()"];
    NSLog(@"result %@",[result toObject]);
}

// Enumeration of methods and properties to export to javaScript

    // @property --> JavaScript getter/setter
    // Instance method --> JavaScript function
    // Class methods --> JavaScript functions on global class object

#pragma mark - JSVirtual Machine
- (void)virtualMachineDemo {

//    JSContext *context = [[CustomJSContext alloc] init];
//    JSContext *context1 = [[CustomJSContext alloc] init];
    JSContext *context3 = [[JSContext alloc] initWithVirtualMachine:self.vmContext.virtualMachine];

    // 加载log
    [self baseJSCodeLoad:context3];
    [self baseJSCodeLoad:self.vmContext];

    NSLog(@"start");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        sleep(1);
        [self.context evaluateScript:@"log('track1 context')"];
    });

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        sleep(3);
        [self.vmContext evaluateScript:@"log('track2 vmContext')"];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        sleep(1);
        [context3 evaluateScript:@"log('track3 vmContext3')"];
    });


    [self.vmContext evaluateScript:@"sleep(5)"];

    NSLog(@"end");
}
#pragma mark - Log 方法

- (void)ocLog:(id)word {

    NSLog(@"\n==========JS===========\n %@ \n==========JS===========\n",word);
}


@end
