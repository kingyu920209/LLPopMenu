//
//  YBRectMake.h
//  LLPopMenu
//
//  Created by 嘚嘚以嘚嘚 on 2018/6/4.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_STATIC_INLINE CGFloat YBRectWidth(CGRect rect)
{
    return rect.size.width;
}

UIKIT_STATIC_INLINE CGFloat YBRectHeight(CGRect rect)
{
    return rect.size.height;
}

UIKIT_STATIC_INLINE CGFloat YBRectX(CGRect rect)
{
    return rect.origin.x;
}

UIKIT_STATIC_INLINE CGFloat YBRectY(CGRect rect)
{
    return rect.origin.y;
}

UIKIT_STATIC_INLINE CGFloat YBRectTop(CGRect rect)
{
    return rect.origin.y;
}

UIKIT_STATIC_INLINE CGFloat YBRectBottom(CGRect rect)
{
    return rect.origin.y + rect.size.height;
}

UIKIT_STATIC_INLINE CGFloat YBRectLeft(CGRect rect)
{
    return rect.origin.x;
}

UIKIT_STATIC_INLINE CGFloat YBRectRight(CGRect rect)
{
    return rect.origin.x + rect.size.width;
}





