//
//  RunJSViewController.m
//  JavaScriptCore
//
//  Created by zrb_dxs on 2018/11/29.
//  Copyright © 2018 jacydai. All rights reserved.
//

#import "RunJSViewController.h"
#import "OCRunJavaScript.h"

@interface RunJSViewController ()
@property (nonatomic, strong) OCRunJavaScript              *javaScript;

@property (nonatomic, strong) UILabel                      *textLab;
@end

@implementation RunJSViewController

- (void)dealloc {

    NSLog(@"RunJSViewController will destroy !!!!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Run JavaScript Code";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupUI];

    self.javaScript = [[OCRunJavaScript alloc] init];
}

- (void)setupUI {

    UIButton *redBtn = [[UIButton alloc] initWithFrame:CGRectMake(100,100,200,50)];
    redBtn.backgroundColor = [UIColor orangeColor];
    [redBtn setTitle:@"Red Color" forState:UIControlStateNormal];
    [redBtn addTarget:self action:@selector(changeRedColor) forControlEvents:UIControlEventTouchUpInside];

    UIButton *blueBtn = [[UIButton alloc] initWithFrame:CGRectMake(100,200,200,50)];
    blueBtn.backgroundColor = [UIColor magentaColor];
    [blueBtn setTitle:@"Blue Color" forState:UIControlStateNormal];
    [blueBtn addTarget:self action:@selector(changeBlueColor) forControlEvents:UIControlEventTouchUpInside];

    UIButton *otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(100,320,200,50)];
    otherBtn.backgroundColor = [UIColor purpleColor];
    [otherBtn setTitle:@"Other Color" forState:UIControlStateNormal];
    [otherBtn addTarget:self action:@selector(changeOtherColor) forControlEvents:UIControlEventTouchUpInside];

    self.textLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 420, self.view.bounds.size.width, 50)];

    self.textLab.text = @"Make different and think differet.----st.jobs";
    self.textLab.textAlignment = NSTextAlignmentCenter;

    [self.view addSubview:redBtn];
    [self.view addSubview:blueBtn];
    [self.view addSubview:otherBtn];
    [self.view addSubview:self.textLab];

}


- (void)changeRedColor {

    [self changeColor:@"red"];
}

- (void)changeBlueColor {

    [self changeColor:@"blue"];
//    [self.javaScript  goodCallbackDemo];
}

- (void)changeOtherColor {

    [self changeColor:@"random"];

//    [self.javaScript badCallbackDemo];

    [self.javaScript runJSExportObject];
}

- (void)changeColor:(NSString *)colorStr {
   UIColor *color = [self.javaScript changeColorsWithJS:colorStr];
//    self.view.backgroundColor = color;
    self.textLab.textColor = color;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
