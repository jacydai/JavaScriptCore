//
//  ViewController.m
//  JavaScriptCore
//
//  Created by zrb_dxs on 2018/11/26.
//  Copyright © 2018 jacydai. All rights reserved.
//

#import "ViewController.h"

#import "RunJSViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"Home";
}

- (IBAction)jumpToNextVC:(id)sender {

   RunJSViewController *vc = [[RunJSViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
