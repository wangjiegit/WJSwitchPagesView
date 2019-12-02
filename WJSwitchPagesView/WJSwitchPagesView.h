//
//  WJSwitchPagesView.h
//  WJSwitchPagesView
//
//  Created by wangjie on 2019/11/29.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJSwitchPagesBarItemProtocol.h"

@class WJSwitchPagesBar;

NS_ASSUME_NONNULL_BEGIN

@protocol WJSwitchPagesBarDataSource <NSObject>

@optional

//bar两边的缩紧
- (CGFloat)barContentBothEdgeSpcaeOfSwitchPagesBarItem:(WJSwitchPagesBar *)switchPagesBar;

//每个item之间的间距
- (CGFloat)itemSpaceOfSwitchPagesBarItem:(WJSwitchPagesBar *)switchPagesBar;

//下标线
- (UIView *)indexViewInswitchPagesBar:(WJSwitchPagesBar *)switchPagesBar;

@required

//每个item的大小
- (CGFloat)switchPagesBar:(WJSwitchPagesBar *)switchPagesBar widthForIndex:(NSUInteger)index;

//item总数
- (NSInteger)numberOfSwitchPagesBarItem:(WJSwitchPagesBar *)switchPagesBar;

//item
- (UIView<WJSwitchPagesBarItemProtocol> *)switchPagesBar:(WJSwitchPagesBar *)switchPagesBar itemForIndex:(NSUInteger)index;

@end

@protocol WJSwitchPagesBarDelegate <NSObject>

@optional

//点击选中对应的item
- (void)switchPagesBar:(WJSwitchPagesBar *)switchPagesBar didSelectItemIndex:(NSUInteger)index;

@end

@interface WJSwitchPagesView : UIView

@property (nonatomic, weak) id<WJSwitchPagesBarDataSource> dataSource;

@property (nonatomic) CGFloat barHeight;//bar的高度

@property (nonatomic, copy) NSArray *controllers;//需要展示的controller

@property (nonatomic, strong, readonly) UIViewController *currentController;//当前的vc

- (void)completeWithSelectedIndex:(NSInteger)index;

@end

@interface WJSwitchPagesBar : UIView

@property (nonatomic, weak) id<WJSwitchPagesBarDataSource> dataSource;

@property (nonatomic, weak) id<WJSwitchPagesBarDelegate> delegate;

@property (nonatomic, readonly) NSUInteger selectedIndex;

@property (nonatomic) CGFloat animationProgress;

- (void)reloadData;

- (void)scrollToItemIndex:(NSInteger)index;//滚动到对应的index

- (UIView<WJSwitchPagesBarItemProtocol> *)itemAtIndex:(NSInteger)index;

- (void)showAnimationWithProgress:(CGFloat)progress currentIndex:(NSInteger)currentIndex nextIndex:(NSInteger)nextIndex;

@end

NS_ASSUME_NONNULL_END
