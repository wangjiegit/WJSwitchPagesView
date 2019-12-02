//
//  PageBarItem.h
//  WJSwitchPagesView
//
//  Created by wangjie on 2019/12/2.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJSwitchPagesBarItemProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageBarItem : UIView<WJSwitchPagesBarItemProtocol>

@property (nonatomic, strong) UILabel *textLabel;

+ (CGFloat)getWidthByText:(NSString *)text height:(CGFloat)height;

@end


NS_ASSUME_NONNULL_END
