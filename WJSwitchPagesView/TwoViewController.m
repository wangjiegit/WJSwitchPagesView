//
//  TwoViewController.m
//  WJSwitchPagesView
//
//  Created by wangjie on 2019/12/2.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:((arc4random() % 255) + 1)/255.0 green:((arc4random() % 255) + 1) / 255.0 blue:(arc4random() % 255) + 1 alpha:1];
    // Do any additional setup after loading the view.
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
