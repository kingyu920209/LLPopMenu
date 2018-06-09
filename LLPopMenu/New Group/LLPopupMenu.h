//
//  LLPopupMenu.h
//  LLPopMenu
//
//  Created by 嘚嘚以嘚嘚 on 2018/6/4.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LLPopupMenuPath.h"
/**
 箭头方向优先级
 
 当控件超出屏幕时会自动调整成反方向
 */
typedef NS_ENUM(NSInteger , LLPopupMenuPriorityDirection) {
    LLPopupMenuPriorityDirectionTop = 0,  //Default
    LLPopupMenuPriorityDirectionBottom,
    LLPopupMenuPriorityDirectionLeft,
    LLPopupMenuPriorityDirectionRight,
    LLPopupMenuPriorityDirectionNone      //不自动调整
};
typedef void (^DidSelectRowBlock) (NSIndexPath * indexPath);

@interface LLPopupMenu : UIView
+ (LLPopupMenu *)showRelyOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth otherSettings:(void (^) (LLPopupMenu * popupMenu))otherSetting;

+ (LLPopupMenu *)showAtPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth otherSettings:(void (^) (LLPopupMenu * popupMenu))otherSetting;

@property (nonatomic, copy) DidSelectRowBlock didSelectRowBlock;

@property (nonatomic, assign)NSTextAlignment textAlignment;
/**
 圆角半径 Default is 5.0
 */
@property (nonatomic, assign) CGFloat cornerRadius;
/**
 是否显示阴影 Default is YES
 */
@property (nonatomic, assign , getter=isShadowShowing) BOOL isShowShadow;
/**
 选择菜单项后消失 Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnSelected;

/**
 点击菜单外消失  Default is YES
 */
@property (nonatomic, assign) BOOL dismissOnTouchOutside;
/**
 是否显示灰色覆盖层 Default is YES
 */
@property (nonatomic, assign) BOOL showMaskView;
/**
 设置字体大小 Default is 15
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 设置字体颜色 Default is [UIColor blackColor]
 */
@property (nonatomic, strong) UIColor * textColor;

/**
 可见的最大行数 Default is 5;
 */
@property (nonatomic, assign) NSInteger maxVisibleCount;
/**
 menu背景色 Default is WhiteColor
 */
@property (nonatomic, strong) UIColor * backColor;
/**
 item的高度 Default is 44;
 */
@property (nonatomic, assign) CGFloat itemHeight;
/**
 箭头宽度 Default is 15
 */
@property (nonatomic, assign) CGFloat arrowWidth;
/**
 箭头高度 Default is 10
 */
@property (nonatomic, assign) CGFloat arrowHeight;
/**
 设置偏移距离 (>= 0) Default is 0.0
 */
@property (nonatomic, assign) CGFloat offset;
/**
 边框宽度 Default is 0.0
 
 设置边框需 > 0
 */
@property (nonatomic, assign) CGFloat borderWidth;
/**
 边框颜色 Default is LightGrayColor
 
 borderWidth <= 0 无效
 */
@property (nonatomic, strong) UIColor * borderColor;
/**
 自定义圆角 Default is UIRectCornerAllCorners
 
 当自动调整方向时corner会自动转换至镜像方向
 */
@property (nonatomic, assign) UIRectCorner rectCorner;
/**
 箭头位置 Default is center
 
 只有箭头优先级是YBPopupMenuPriorityDirectionLeft/YBPopupMenuPriorityDirectionRight/YBPopupMenuPriorityDirectionNone时需要设置
 */
@property (nonatomic, assign) CGFloat arrowPosition;
/**
 箭头优先方向 Default is YBPopupMenuPriorityDirectionTop
 
 当控件超出屏幕时会自动调整箭头位置
 */
@property (nonatomic, assign) LLPopupMenuPriorityDirection priorityDirection;

/**
 箭头方向 Default is YBPopupMenuArrowDirectionTop
 */

@property (nonatomic, assign) LLPopupMenuArrowDirection arrowDirection;
@end
