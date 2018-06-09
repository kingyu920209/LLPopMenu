//
//  LLPopupMenuCell.h
//  LLPopMenu
//
//  Created by 嘚嘚以嘚嘚 on 2018/6/4.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLPopupMenuCell : UITableViewCell

@property (nonatomic, assign) BOOL isShowSeparator;//cell最下面的线

@property (nonatomic, strong) UIColor * separatorColor;

@property (nonatomic, strong) UIColor * titleColor;

@property (nonatomic, strong) UIFont * titleFont;

@property (nonatomic, assign)NSTextAlignment  titleAlignment;

@property (nonatomic, strong)NSString * titleString;

@property (nonatomic, strong)NSString * imagePatch;
@end
