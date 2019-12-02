//
//  PageBarItem.m
//  WJSwitchPagesView
//
//  Created by wangjie on 2019/12/2.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import "PageBarItem.h"

@implementation PageBarItem 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [self normalColor];
        _textLabel.backgroundColor = [UIColor greenColor];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

- (UIColor *)normalColor {
    return [UIColor blackColor];
}

- (UIColor *)selectedColor {
    return [UIColor redColor];
}

- (void)setCurrentColor:(UIColor *)color {
    _textLabel.textColor = color;
}

+ (CGFloat)getWidthByText:(NSString *)text height:(CGFloat)height {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return ceilf(rect.size.width);
}

@end
