//
//  JavaScriptBridge_JS.m
//  JavaScriptCore
//
//  Created by zrb_dxs on 2018/11/27.
//  Copyright © 2018 jacydai. All rights reserved.
//

#import "JavaScriptBridge_JS.h"


NSString *javaScriptText(void) {

#define __java_script_func__(x) #x
    static NSString *processJSCode = @__java_script_func__ (
    ;
// 1. JS递归
 var factorial = function(n) {

     if (n < 0) {
         return;
     }

     if (n == 0) {
         return 1;
     }

     return n * factorial(n - 1);
 };


// 2. 颜色选择
function colorMap(word) {

    var color = new Array();
    if (word == "red") {

        color["red"] = 255;
        color["green"] = 0;
        color["blue"] = 0;

    }
    else if (word == "blue") {

        color["red"] = 0;
        color["green"] = 0;
        color["blue"] = 255;

    } else {
        // 随机颜色
        color["red"]   = (Math.random() *255 + 1);// % 256;
        color["green"] = (Math.random() * 255 + 1);// % 256;
        color["blue"]  = (Math.random() * 255 + 1);
    }

    return color;
};


// 3.改变颜色
var colorForWord = function(word) {

    if (!colorMap(word)) {

        return;
    }

    return makeUIColor(colorMap(word));
};

// 4. 坐标计算

var euclideanDistance = function(p1, p2) {

    var xDelta = p2.x - p1.x;
    var yDelta = p2.y - p1.y;

    return Math.sqrt(xDelta * xDelta + yDelta * yDelta);
};

// 5. 中心点
var midpoint = function(p1, p2) {

    var xDelta = (p2.x - p1.x) / 2;
    var yDelta = (p2.y - p1.y) / 2;

    return MyPoint.makePointWithXY(p1.x + xDelta, p1.y + yDelta);
};

// 6. JS 会调用OC
var jscallback = function() {

    //
    return callback();
};

);

    return processJSCode;
};
