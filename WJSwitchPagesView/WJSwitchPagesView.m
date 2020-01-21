//
//  WJSwitchPagesView.m
//  WJSwitchPagesView
//
//  Created by wangjie on 2019/11/29.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "WJSwitchPagesView.h"

typedef NS_ENUM(NSInteger, WJSwitchPagesDirection) {
    WJSwitchPagesDirectionNone = 0,//点击item滑动
    WJSwitchPagesDirectionLeft = 1,//内容向左滑动
    WJSwitchPagesDirectionRight = 2,//内容向右滑动
};

@interface WJSwitchPagesView ()<UIScrollViewDelegate, WJSwitchPagesBarDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WJSwitchPagesBar *pagesBar;

@property (nonatomic) WJSwitchPagesDirection direction;

@end

@implementation WJSwitchPagesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.pagesBar];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutPlaceSubviews];
}

- (void)layoutPlaceSubviews {
    self.pagesBar.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), self.barHeight);
    self.scrollView.frame = CGRectMake(0, self.barHeight, CGRectGetWidth(self.pagesBar.bounds), CGRectGetHeight(self.bounds) - self.barHeight);
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) [self.controllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
}

- (void)showCurrentController {
    if (self.pagesBar.selectedIndex >= self.controllers.count) return;
    self.scrollView.contentOffset = CGPointMake(self.pagesBar.selectedIndex * CGRectGetWidth(self.scrollView.frame), 0);
    UIViewController *controller = self.controllers[self.pagesBar.selectedIndex];
    if (!controller.parentViewController) {
        controller.view.frame = CGRectMake(self.pagesBar.selectedIndex * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        [self.scrollView addSubview:controller.view];
        if ([self.dataSource isKindOfClass:[UIViewController class]]) {
            [((UIViewController *)self.dataSource) addChildViewController:controller];
        }
    }
}

- (void)completeWithSelectedIndex:(NSInteger)index {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.controllers.count, CGRectGetHeight(self.scrollView.frame));
    [self.pagesBar reloadData];
    [self.pagesBar scrollToItemIndex:index];
}

#pragma mark WJSwitchPagesBarDelegate

- (void)switchPagesBar:(WJSwitchPagesBar *)switchPagesBar didSelectItemIndex:(NSUInteger)index {
    [self showCurrentController];
}

#pragma mark UIScrollViewDelegate

//判断展示左边的视图还是右边的视图
- (void)scrollViewPan:(UIPanGestureRecognizer *)pgr {
    if (pgr.state == UIGestureRecognizerStateBegan) {
        CGPoint velocity = [pgr velocityInView:pgr.view];
        if (velocity.x > 0) {
            self.direction = WJSwitchPagesDirectionLeft;
        } else if (velocity.x == 0) {
            self.direction = WJSwitchPagesDirectionNone;
        } else {
            self.direction = WJSwitchPagesDirectionRight;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.direction == WJSwitchPagesDirectionNone || scrollView.contentOffset.x < 0) return;
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    //currentIndex 不等于_tabBarView.selectedIndex的原因是 防止一次触摸左右滑动出现bug
    NSInteger currentIndex = self.direction == WJSwitchPagesDirectionLeft ? index + 1 : index;//当前index
    NSInteger nextIndex = self.direction == WJSwitchPagesDirectionLeft ? index : index + 1;//下一个index
    CGFloat progress = (scrollView.contentOffset.x - scrollView.frame.size.width * currentIndex) / scrollView.frame.size.width;
    [self.pagesBar showAnimationWithProgress:progress currentIndex:currentIndex nextIndex:nextIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self.pagesBar scrollToItemIndex:index];
}

#pragma mark Getter and Setter

- (WJSwitchPagesBar *)pagesBar {
    if (!_pagesBar) {
        _pagesBar = [[WJSwitchPagesBar alloc] init];
        _pagesBar.delegate = self;
        _pagesBar.backgroundColor = [UIColor whiteColor];
    }
    return _pagesBar;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [_scrollView.panGestureRecognizer addTarget:self action:@selector(scrollViewPan:)];
    }
    return _scrollView;
}

- (void)setDataSource:(id<WJSwitchPagesBarDataSource>)dataSource {
    _dataSource = dataSource;
    self.pagesBar.dataSource = dataSource;
}

- (void)setControllers:(NSArray *)controllers {
    for (UIViewController *vc in _controllers) {
        if (vc.parentViewController) {
            [vc removeFromParentViewController];
            [vc.view removeFromSuperview];
        }
    }
    _controllers = [controllers copy];
}

- (UIViewController *)currentController {
    if (self.pagesBar.selectedIndex < self.controllers.count) {
        return self.controllers[self.pagesBar.selectedIndex];
    }
    return nil;
}

@end

#pragma mark Class
#pragma mark WJSwitchPagesBar

@interface WJSwitchPagesBar ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, strong) UIView *indexView;

@property (nonatomic) CGFloat indexViewWidth;

@property (nonatomic) NSUInteger selectedIndex;

@end

@implementation WJSwitchPagesBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.bounds));
}

- (void)reloadData {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self.itemArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.itemArray removeAllObjects];
    NSInteger num = [self.dataSource numberOfSwitchPagesBarItem:self];
    if (num == 0) return;
    CGFloat itemSpace = 10;
    CGFloat egde = itemSpace / 2.0;
    if ([self.dataSource respondsToSelector:@selector(itemSpaceOfSwitchPagesBarItem:)]) {
        itemSpace = [self.dataSource itemSpaceOfSwitchPagesBarItem:self];
    }
    if ([self.dataSource respondsToSelector:@selector(barContentBothEdgeSpcaeOfSwitchPagesBarItem:)]) {
        egde = [self.dataSource barContentBothEdgeSpcaeOfSwitchPagesBarItem:self];
    }
    CGFloat x = egde;
    for (int i = 0; i < num; i++) {
        UIView *item = [self.dataSource switchPagesBar:self itemForIndex:i];
        CGFloat width = [self.dataSource switchPagesBar:self widthForIndex:i];
        if (width > 0) {
            item.frame = CGRectMake(x, 0, width, self.frame.size.height);
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchSelectEvent:)];
            [item addGestureRecognizer:tgr];
            [self.scrollView addSubview:item];
            [self.itemArray addObject:item];
            if (i == num - 1) {
                x += width;
            } else {
                x += width + itemSpace;
            }
        }
    }
    x += egde;
    
    //如果scrollView内容小于scrollView的宽重新布局
    if (x < self.frame.size.width) {
        itemSpace += (self.frame.size.width - x) / num;
        CGFloat egde = itemSpace / 2.0;
        x = egde;
        for (int i = 0; i < num; i++) {
            UIView *item = self.itemArray[i];
            item.frame = CGRectMake(x, item.frame.origin.y, item.frame.size.width, item.frame.size.height);
            if (i == num - 1) {
                x += CGRectGetWidth(item.bounds);
            } else {
                x += CGRectGetWidth(item.bounds) + itemSpace;
            }
        }
        x += egde;
    }
    self.scrollView.contentSize = CGSizeMake(x, CGRectGetHeight(self.bounds));
    self.selectedIndex = -1;
}

- (void)touchSelectEvent:(UITapGestureRecognizer *)tgr {
    UIView *item = tgr.view;
    NSInteger index = [self.itemArray indexOfObject:item];
    if (index == NSNotFound || index == self.selectedIndex) return;
    [self handleSelectItemIndex:index];
}

- (void)handleSelectItemIndex:(NSInteger)index {
    self.selectedIndex = index;
    UIView<WJSwitchPagesBarItemProtocol> *newItem = self.itemArray[self.selectedIndex];
    for (UIView<WJSwitchPagesBarItemProtocol> *item in self.itemArray) {
        [item setCurrentColor:item == newItem ? [item selectedColor] : [item normalColor]];
    }
    if ([self.delegate respondsToSelector:@selector(switchPagesBar:didSelectItemIndex:)]) {
        [self.delegate switchPagesBar:self didSelectItemIndex:index];
    }
    
    if (self.indexView) {
        CGRect frame = self.indexView.frame;
        frame.origin.x = CGRectGetMinX(newItem.frame) + (CGRectGetWidth(newItem.frame) - self.indexViewWidth) / 2.0;
        frame.size.width = self.indexViewWidth;
        if (self.indexView.superview) {
            [UIView animateWithDuration:0.25 animations:^{
                self.indexView.frame = frame;
            }];
        } else {
            self.indexView.frame = frame;
            [self.scrollView addSubview:self.indexView];
        }
    }
    
    if (self.scrollView.contentSize.width <= self.scrollView.frame.size.width) return;
    //让item在scrollView中居中显示
    CGFloat offsetX = newItem.center.x - self.frame.size.width / 2.0;
    if (offsetX < 0) offsetX = 0;
    CGFloat offsetMax = self.scrollView.contentSize.width - self.frame.size.width;
    if (offsetX > offsetMax && offsetMax > 0) offsetX = offsetMax;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

- (void)scrollToItemIndex:(NSInteger)index {
    if (index == self.selectedIndex || index >= self.itemArray.count) return;
    [self handleSelectItemIndex:index];
}

- (void)showAnimationWithProgress:(CGFloat)progress currentIndex:(NSInteger)currentIndex nextIndex:(NSInteger)nextIndex {
    if (progress == 0) return;
    UIView<WJSwitchPagesBarItemProtocol> *currentItem = [self itemAtIndex:currentIndex];
    UIView<WJSwitchPagesBarItemProtocol> *targetItem = [self itemAtIndex:nextIndex];
    [currentItem setCurrentColor:[UIColor colorTransformFrom:currentItem.selectedColor to:currentItem.normalColor progress:fabs(progress)]];
    [targetItem setCurrentColor:[UIColor colorTransformFrom:currentItem.normalColor to:currentItem.selectedColor progress:fabs(progress)]];
    [self showAnimationToShadowWithProgress:progress fromItemRect:currentItem.frame toItemRect:targetItem.frame];
}

#pragma mark Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (UIView *)indexView {
    if (!_indexView && [self.dataSource respondsToSelector:@selector(indexViewInswitchPagesBar:)]) {
        _indexView = [self.dataSource indexViewInswitchPagesBar:self];
        _indexViewWidth = CGRectGetWidth(_indexView.frame);
    }
    return _indexView;
}

- (UIView<WJSwitchPagesBarItemProtocol> *)itemAtIndex:(NSInteger)index {
    if (index < self.itemArray.count) {
        return self.itemArray[index];
    }
    return nil;
}

- (void)showAnimationToShadowWithProgress:(CGFloat)progress fromItemRect:(CGRect)fromItemRect toItemRect:(CGRect)toItemRect {
    CGFloat distance = fabs(CGRectGetMidX(toItemRect) - CGRectGetMidX(fromItemRect));
    CGFloat fromX = CGRectGetMidX(fromItemRect) - self.indexViewWidth/2.0f;
    CGFloat toX = CGRectGetMidX(toItemRect) - self.indexViewWidth/2.0f;
    if (progress > 0) {//向右移动
        //前半段0~0.5，x不变 w变大
        if (progress <= 0.5) {
            //让过程变成0~1
            CGFloat newProgress = 2*fabs(progress);
            CGFloat newWidth = self.indexViewWidth + newProgress*distance;
            CGRect shadowFrame = self.indexView.frame;
            shadowFrame.size.width = newWidth;
            shadowFrame.origin.x = fromX;
            self.indexView.frame = shadowFrame;
        }else if (progress >= 0.5) { //后半段0.5~1，x变大 w变小
            //让过程变成1~0
            CGFloat newProgress = 2*(1-fabs(progress));
            CGFloat newWidth = self.indexViewWidth + newProgress*distance;
            CGFloat newX = toX - newProgress*distance;
            CGRect shadowFrame = self.indexView.frame;
            shadowFrame.size.width = newWidth;
            shadowFrame.origin.x = newX;
            self.indexView.frame = shadowFrame;
        }
    }else {//向左移动
        //前半段0~-0.5，x变小 w变大
        if (progress >= -0.5) {
            //让过程变成0~1
            CGFloat newProgress = 2*fabs(progress);
            CGFloat newWidth = self.indexViewWidth + newProgress*distance;
            CGFloat newX = fromX - newProgress*distance;
            CGRect shadowFrame = self.indexView.frame;
            shadowFrame.size.width = newWidth;
            shadowFrame.origin.x = newX;
            self.indexView.frame = shadowFrame;
        }else if (progress <= -0.5) { //后半段-0.5~-1，x变大 w变小
            //让过程变成1~0
            CGFloat newProgress = 2*(1-fabs(progress));
            CGFloat newWidth = self.indexViewWidth + newProgress*distance;
            CGRect shadowFrame = self.indexView.frame;
            shadowFrame.size.width = newWidth;
            shadowFrame.origin.x = toX;
            self.indexView.frame = shadowFrame;
        }
    }
}


@end
