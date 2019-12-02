//
//  WJSwitchPagesBarItemProtocol.h
//  WJSwitchPagesView
//
//  Created by wangjie on 2019/12/2.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WJSwitchPagesBarItemProtocol <NSObject>

@required

- (UIColor *)normalColor;//正常颜色

- (UIColor *)selectedColor;//选中的颜色

- (void)setCurrentColor:(UIColor *)color;//给Label设置颜色

@end

NS_ASSUME_NONNULL_END
