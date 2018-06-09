//
//  LLPopupMenuCell.m
//  LLPopMenu
//
//  Created by 嘚嘚以嘚嘚 on 2018/6/4.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import "LLPopupMenuCell.h"
@interface LLPopupMenuCell ()
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIImageView * leftImageView;
@end
@implementation LLPopupMenuCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self ==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _isShowSeparator = YES;
        self.backgroundColor = [UIColor clearColor];
        _separatorColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setNeedsDisplay];
        [self setSubView];
    }
    return self;
}
- (void)setSubView
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:_leftImageView];
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
}
-(void)setTitleFont:(UIFont *)titleFont
{
    if (titleFont) {
        _titleFont = titleFont;
        self.titleLabel.font = _titleFont;
    }
}
-(void)setTitleColor:(UIColor *)titleColor
{
    if (titleColor) {
        _titleColor = titleColor;
        self.titleLabel.textColor = _titleColor;
    }

}
-(void)setTitleAlignment:(NSTextAlignment)titleAlignment
{
    if (titleAlignment) {
        _titleAlignment=titleAlignment;
        _titleLabel.textAlignment = _titleAlignment;
    }


}
-(void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    _titleLabel.text = _titleString;
}
- (void)setImagePatch:(NSString *)imagePatch
{
    _imagePatch = imagePatch;
    _leftImageView.image = [UIImage imageNamed:imagePatch];
}
- (void)setIsShowSeparator:(BOOL)isShowSeparator
{
    _isShowSeparator = isShowSeparator;
    [self setNeedsDisplay];
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    if (separatorColor) {
        _separatorColor = separatorColor;
        [self setNeedsDisplay];
    }

}
- (void)drawRect:(CGRect)rect
{
    if (!_isShowSeparator) return;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5)];
    [_separatorColor setFill];
    [bezierPath fillWithBlendMode:kCGBlendModeNormal alpha:1];
    [bezierPath closePath];
}
-(void)layoutSubviews
{
    if ([self.leftImageView.image isKindOfClass:[UIImage class]]) {
        self.leftImageView.frame = CGRectMake(10, 0, self.leftImageView.frame.size.width, self.leftImageView.frame.size.height);
        CGPoint center = self.leftImageView.center;
        center.y = self.center.y;
        self.leftImageView.center = center;
        self.titleLabel.frame = CGRectMake(20+self.leftImageView.frame.size.width, 0, self.contentView.frame.size.width-20+self.leftImageView.frame.size.width, self.contentView.frame.size.height);
    }else{
        self.titleLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }
  
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
