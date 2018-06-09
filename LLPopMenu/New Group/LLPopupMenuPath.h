//
//  LLPopupMenuPath.h
//  LLPopupMenu
//
//  Created by lyb on 2017/5/9.
//  Copyright © 2017年 lyb. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LLPopupMenuArrowDirection) {
    LLPopupMenuArrowDirectionTop = 0,  //箭头朝上
    LLPopupMenuArrowDirectionBottom,   //箭头朝下
    LLPopupMenuArrowDirectionLeft,     //箭头朝左
    LLPopupMenuArrowDirectionRight,    //箭头朝右
    LLPopupMenuArrowDirectionNone      //没有箭头
};

@interface LLPopupMenuPath : NSObject

+ (CAShapeLayer *)yb_maskLayerWithRect:(CGRect)rect
                            rectCorner:(UIRectCorner)rectCorner
                          cornerRadius:(CGFloat)cornerRadius
                            arrowWidth:(CGFloat)arrowWidth
                           arrowHeight:(CGFloat)arrowHeight
                         arrowPosition:(CGFloat)arrowPosition
                        arrowDirection:(LLPopupMenuArrowDirection)arrowDirection;

+ (UIBezierPath *)yb_bezierPathWithRect:(CGRect)rect
                             rectCorner:(UIRectCorner)rectCorner
                           cornerRadius:(CGFloat)cornerRadius
                            borderWidth:(CGFloat)borderWidth
                            borderColor:(UIColor *)borderColor
                        backgroundColor:(UIColor *)backgroundColor
                             arrowWidth:(CGFloat)arrowWidth
                            arrowHeight:(CGFloat)arrowHeight
                          arrowPosition:(CGFloat)arrowPosition
                         arrowDirection:(LLPopupMenuArrowDirection)arrowDirection;
@end
