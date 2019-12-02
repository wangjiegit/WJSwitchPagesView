//
//  ViewController.m
//  WJSwitchPagesView
//
//  Created by wangjie on 2019/11/29.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "ViewController.h"
#import "WJSwitchPagesView.h"
#import "PageBarItem.h"
#import "TwoViewController.h"

@interface ViewController ()<WJSwitchPagesBarDataSource>

@property (nonatomic, strong) WJSwitchPagesView *switchPagesView;

@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, strong) NSMutableArray *vcList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.switchPagesView];
    self.vcList = [NSMutableArray array];
    for (int i = 0; i < self.titleArray.count; i++) {
        TwoViewController *vc = [TwoViewController new];
        [self.vcList addObject:vc];
    }
    self.switchPagesView.controllers = self.vcList;
    [self.switchPagesView completeWithSelectedIndex:3];
}

#pragma mark WJSwitchPagesBarDataSource

- (UIView *)indexViewInswitchPagesBar:(WJSwitchPagesBar *)switchPagesBar {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, switchPagesBar.height - 3, 20, 3);
    view.backgroundColor = [UIColor yellowColor];
    return view;
}

//每个item的大小
- (CGFloat)switchPagesBar:(WJSwitchPagesBar *)switchPagesBar widthForIndex:(NSUInteger)index {
    return [PageBarItem getWidthByText:self.titleArray[index] height:switchPagesBar.height];
}

//item总数
- (NSInteger)numberOfSwitchPagesBarItem:(WJSwitchPagesBar *)switchPagesBar {
    return self.titleArray.count;
}

//item
- (UIView<WJSwitchPagesBarItemProtocol> *)switchPagesBar:(WJSwitchPagesBar *)switchPagesBar itemForIndex:(NSUInteger)index {
    PageBarItem *item = [[PageBarItem alloc] init];
    item.textLabel.text = self.titleArray[index];
    return item;
}


- (WJSwitchPagesView *)switchPagesView {
    if (!_switchPagesView) {
        _switchPagesView = [[WJSwitchPagesView alloc] init];
        _switchPagesView.frame = self.view.bounds;
        _switchPagesView.barHeight = 100;
        _switchPagesView.dataSource = self;
    }
    return _switchPagesView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"本地", @"浙江", @"绍兴", @"杭州", @"宁波", @"衢州", @"温州", @"金华", @"舟山", @"嘉兴", @"湖州"];
    }
    return _titleArray;
}

@end
