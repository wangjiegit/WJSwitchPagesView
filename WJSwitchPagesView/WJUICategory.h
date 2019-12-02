//
//  WJUICategory.h
//  Category
//
//  Created by wangjie on 2019/11/21.
//  Copyright © 2019 wangjie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//方法交换
void swizzleMethod(Class cls, SEL originalSelector, SEL swizzledSelector);

#pragma mark UIViewController
@interface UIViewController (WJPlugin)

@end

#pragma mark UIView
@interface UIView (WJPlugin)
//frame
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;

//渐变
@property (nonatomic, copy) NSArray *wj_gradientColors;
@property (nonatomic) CGPoint wj_gradientStartPoint;
@property (nonatomic) CGPoint wj_gradientEndPoint;

/**<删除所有子视图*/
- (void)removeAllSubviews;

/**点击事件*/
- (void)wj_setTapActionWithBlock:(void (^)(UIView *view))block;

/**长按事件*/
- (void)wj_setLongPressActionWithBlock:(void (^)(UIView *view))block;

@end

#pragma mark UIControl
@interface UIControl (WJPlugin)

/**<给重复点击加间隔*/
@property (nonatomic) NSTimeInterval wj_repeatEventInterval;

@end

#pragma mark UIButton
@interface UIButton (WJPlugin)
//设置背景颜色
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end

#pragma mark UIImage
@interface UIImage (WJPlugin)

/**<颜色转图片  */
+ (UIImage *)wj_imageWithColor:(UIColor *)color;

@end

#pragma mark UILabel
@interface UILabel (WJPlugin)

@property (nonatomic) BOOL wj_copy;//复制

@end

#pragma mark UITextField
@interface UITextField (WJPlugin)

@property (nonatomic) BOOL wj_prohibitPerformAction;//禁止弹出菜单

/**< UITextField限制字数 */
- (void)wj_limitTextFieldLength:(NSUInteger)maxLength;

@end

#pragma mark UITextView
@interface UITextView (WJPlugin)
/**< UITextView限制字数 */
- (void)wj_limitTextViewLength:(NSUInteger)maxLength;

@end

#pragma mark UIColor
@interface UIColor (WJPlugin)
+ (nullable UIColor *)wj_colorWithHexString:(NSString *)hexStr;
+ (nullable UIColor *)wj_colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
+ (nullable UIColor *)colorTransformFrom:(UIColor*)fromColor to:(UIColor *)toColor progress:(CGFloat)progress;
@end;

NS_ASSUME_NONNULL_END

