//
//  LLPopupMenu.m
//  LLPopMenu
//
//  Created by 嘚嘚以嘚嘚 on 2018/6/4.
//  Copyright © 2018年 嘚嘚以嘚嘚. All rights reserved.
//

#import "LLPopupMenu.h"
#import "LLPopupMenuCell.h"
#import "LLPopupMenuPath.h"
#define LLMainWindow  [UIApplication sharedApplication].keyWindow
#define LLScreenWidth [UIScreen mainScreen].bounds.size.width
#define LLScreenHeight [UIScreen mainScreen].bounds.size.height
static NSString * const LLPopupMenuCellID = @"LLPopupMenuCellID";

@interface LLPopupMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSArray * titles;
@property (nonatomic, strong)UIView  * menuBackView;
@property (nonatomic, strong)NSArray * imagePath;
@property (nonatomic, assign)BOOL isChangeDirection;
@property (nonatomic) CGPoint               point;
@property (nonatomic, assign) CGFloat       minSpace;
@property (nonatomic, assign) CGFloat       itemWidth;
@property (nonatomic) CGRect                relyRect;
@property (nonatomic, assign) BOOL          isCornerChanged;
@property (nonatomic, strong) NSArray     * images;
@property (nonatomic, strong) UIColor     * separatorColor;

@end

@implementation LLPopupMenu
+ (LLPopupMenu *)showRelyOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth otherSettings:(void (^) (LLPopupMenu * popupMenu))otherSetting
{
    CGRect absoluteRect = [view convertRect:view.bounds toView:LLMainWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width/2, absoluteRect.origin.y + absoluteRect.size.height);
    LLPopupMenu * popupMenu = [[LLPopupMenu alloc] init];
    popupMenu.point = relyPoint;
    popupMenu.relyRect = absoluteRect;
    popupMenu.titles = titles;
    popupMenu.imagePath = icons;
    popupMenu.itemWidth = itemWidth;
    if (otherSetting) otherSetting(popupMenu);
    
    [popupMenu show];
    
    return popupMenu;
}
+ (LLPopupMenu *)showAtPoint:(CGPoint)point titles:(NSArray *)titles icons:(NSArray *)icons menuWidth:(CGFloat)itemWidth otherSettings:(void (^) (LLPopupMenu * popupMenu))otherSetting
{
    LLPopupMenu *popupMenu = [[LLPopupMenu alloc] init];
    popupMenu.point = point;
    popupMenu.titles = titles;
    popupMenu.imagePath = icons;
    popupMenu.itemWidth = itemWidth;
    if (otherSetting) otherSetting(popupMenu);
    [popupMenu show];
    return popupMenu;
}
- (void)show
{
    [LLMainWindow addSubview:_menuBackView];
    [LLMainWindow addSubview:self];
    LLPopupMenuCell * cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
        self.menuBackView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        self.menuBackView.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (instancetype)init
{
    if (self == [super init]) {
        [self setDefaultSettings];
    }
    return self;
}

-(void)setDefaultSettings
{
    _cornerRadius = 5.0;
    _rectCorner = UIRectCornerAllCorners;
    self.isShowShadow = YES;
    _dismissOnSelected = YES;
    _dismissOnTouchOutside = YES;
    _fontSize = 15;
    _textColor = [UIColor blackColor];
    _offset = 0.0;
    _relyRect = CGRectZero;
    _point = CGPointZero;
    _borderWidth = 0.0;
    _borderColor = [UIColor lightGrayColor];
    _arrowWidth = 15.0;
    _arrowHeight = 10.0;
    _backColor = [UIColor whiteColor];
    self.arrowDirection = LLPopupMenuArrowDirectionTop;
    _priorityDirection = LLPopupMenuPriorityDirectionTop;
    _minSpace = 10.0;
    _maxVisibleCount = 5;
    _itemHeight = 44;
    _isCornerChanged = NO;
    _showMaskView = YES;
    _menuBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LLScreenWidth, LLScreenHeight)];
    _menuBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    _menuBackView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(touchOutSide)];
    [_menuBackView addGestureRecognizer: tap];
    self.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.tableView];

}
-(UIView *)menuBackView
{
    if (!_menuBackView) {
        _menuBackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _menuBackView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
        _menuBackView.alpha = 0;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tochOutSide)];
        [_menuBackView addGestureRecognizer:tap];
    }
    return _menuBackView;
}
- (void)tochOutSide
{
    [self dismiss];
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
- (LLPopupMenuCell *)getLastVisibleCell
{
    NSArray <NSIndexPath *>*indexPaths = [self.tableView indexPathsForVisibleRows];
    indexPaths = [indexPaths sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
        return obj1.row < obj2.row;
    }];
    NSIndexPath *indexPath = indexPaths.firstObject;
    return [self.tableView cellForRowAtIndexPath:indexPath];
}
- (void)updateUI
{
    CGFloat height;
    if (_titles.count > _maxVisibleCount) {
        height = _itemHeight * _maxVisibleCount + _borderWidth * 2;
        self.tableView.bounces = YES;
    }else {
        height = _itemHeight * _titles.count + _borderWidth * 2;
        self.tableView.bounces = NO;
    }
    _isChangeDirection = NO;
    if (_priorityDirection == LLPopupMenuPriorityDirectionTop) {
        if (_point.y + height + _arrowHeight > LLScreenHeight - _minSpace) {
            _arrowDirection = LLPopupMenuArrowDirectionBottom;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = LLPopupMenuArrowDirectionTop;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == LLPopupMenuPriorityDirectionBottom) {
        if (_point.y - height - _arrowHeight < _minSpace) {
            _arrowDirection = LLPopupMenuArrowDirectionTop;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = LLPopupMenuArrowDirectionBottom;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == LLPopupMenuPriorityDirectionLeft) {
        if (_point.x + _itemWidth + _arrowHeight > LLScreenWidth - _minSpace) {
            _arrowDirection = LLPopupMenuArrowDirectionRight;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = LLPopupMenuArrowDirectionLeft;
            _isChangeDirection = NO;
        }
    }else if (_priorityDirection == LLPopupMenuPriorityDirectionRight) {
        if (_point.x - _itemWidth - _arrowHeight < _minSpace) {
            _arrowDirection = LLPopupMenuArrowDirectionLeft;
            _isChangeDirection = YES;
        }else {
            _arrowDirection = LLPopupMenuArrowDirectionRight;
            _isChangeDirection = NO;
        }
    }
    [self setArrowPosition];
    [self setRelyRect];
    if (_arrowDirection == LLPopupMenuArrowDirectionTop) {
        CGFloat y = _isChangeDirection ? _point.y  : _point.y;
        if (_arrowPosition > _itemWidth / 2) {
            self.frame = CGRectMake(LLScreenWidth - _minSpace - _itemWidth, y, _itemWidth, height + _arrowHeight);
        }else if (_arrowPosition < _itemWidth / 2) {
            self.frame = CGRectMake(_minSpace, y, _itemWidth, height + _arrowHeight);
        }else {
            self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, height + _arrowHeight);
        }
    }else if (_arrowDirection == LLPopupMenuArrowDirectionBottom) {
        CGFloat y = _isChangeDirection ? _point.y - _arrowHeight - height : _point.y - _arrowHeight - height;
        if (_arrowPosition > _itemWidth / 2) {
            self.frame = CGRectMake(LLScreenWidth - _minSpace - _itemWidth, y, _itemWidth, height + _arrowHeight);
        }else if (_arrowPosition < _itemWidth / 2) {
            self.frame = CGRectMake(_minSpace, y, _itemWidth, height + _arrowHeight);
        }else {
            self.frame = CGRectMake(_point.x - _itemWidth / 2, y, _itemWidth, height + _arrowHeight);
        }
    }else if (_arrowDirection == LLPopupMenuArrowDirectionLeft) {
        CGFloat x = _isChangeDirection ? _point.x : _point.x;
        if (_arrowPosition < _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else if (_arrowPosition > _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }
    }else if (_arrowDirection == LLPopupMenuArrowDirectionRight) {
        CGFloat x = _isChangeDirection ? _point.x - _itemWidth - _arrowHeight : _point.x - _itemWidth - _arrowHeight;
        if (_arrowPosition < _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else if (_arrowPosition > _itemHeight / 2) {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }else {
            self.frame = CGRectMake(x, _point.y - _arrowPosition, _itemWidth + _arrowHeight, height);
        }
    }else if (_arrowDirection == LLPopupMenuArrowDirectionNone) {
        
    }
    
    if (_isChangeDirection) {
        [self changeRectCorner];
    }
    [self setAnchorPoint];
    [self setOffset];
    [self.tableView reloadData];
    [self setNeedsDisplay];
}
-(void)setArrowPosition
{
    if (_priorityDirection == LLPopupMenuPriorityDirectionNone) {
        return;
    }
    if (_arrowDirection == LLPopupMenuArrowDirectionTop || _arrowDirection == LLPopupMenuArrowDirectionBottom) {
        if (_point.x + _itemWidth / 2>LLScreenWidth - _minSpace) {
            _arrowPosition = _itemWidth - (LLScreenWidth - _minSpace - _point.x);
        }else if (_point.x < _itemWidth/2 + _minSpace){
            _arrowPosition = _point.x - _minSpace;
        }else{
            _arrowPosition = _itemWidth/2;
        }
    }else if (_arrowDirection == LLPopupMenuArrowDirectionLeft || _arrowDirection == LLPopupMenuArrowDirectionRight){
        if (_point.y + _itemHeight / 2 > LLScreenHeight - _minSpace) {
            _arrowPosition = _itemHeight - (LLScreenHeight - _minSpace - _point.y);
        }else if (_point.y < _itemHeight / 2 + _minSpace) {
            _arrowPosition = _point.y - _minSpace;
        }else {
            _arrowPosition = _itemHeight / 2;
        }
    }
}
- (void)setRelyRect
{
    if (CGRectEqualToRect(_relyRect, CGRectZero)) {
        return;
    }
    if (_arrowDirection == LLPopupMenuArrowDirectionTop) {
        _point.y = _relyRect.size.height + _relyRect.origin.y;
    }else if (_arrowDirection == LLPopupMenuArrowDirectionBottom) {
        _point.y = _relyRect.origin.y;
    }else if (_arrowDirection == LLPopupMenuArrowDirectionLeft) {
        _point = CGPointMake(_relyRect.origin.x + _relyRect.size.width, _relyRect.origin.y + _relyRect.size.height / 2);
    }else {
        _point = CGPointMake(_relyRect.origin.x, _relyRect.origin.y + _relyRect.size.height / 2);
    }
}
- (void)changeRectCorner
{
    if (_isCornerChanged || _rectCorner == UIRectCornerAllCorners) {
        return;
    }
    BOOL haveTopLeftCorner = NO, haveTopRightCorner = NO, haveBottomLeftCorner = NO, haveBottomRightCorner = NO;
    if (_rectCorner & UIRectCornerTopLeft) {
        haveTopLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerTopRight) {
        haveTopRightCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomLeft) {
        haveBottomLeftCorner = YES;
    }
    if (_rectCorner & UIRectCornerBottomRight) {
        haveBottomRightCorner = YES;
    }
    
    if (_arrowDirection == LLPopupMenuArrowDirectionTop || _arrowDirection == LLPopupMenuArrowDirectionBottom) {
        
        if (haveTopLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
        }
        if (haveTopRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
        }
        if (haveBottomLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
        }
        if (haveBottomRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopRight);
        }
        
    }else if (_arrowDirection == LLPopupMenuArrowDirectionLeft || _arrowDirection == LLPopupMenuArrowDirectionRight) {
        if (haveTopLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopRight);
        }
        if (haveTopRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerTopLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerTopLeft);
        }
        if (haveBottomLeftCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomRight;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomRight);
        }
        if (haveBottomRightCorner) {
            _rectCorner = _rectCorner | UIRectCornerBottomLeft;
        }else {
            _rectCorner = _rectCorner & (~UIRectCornerBottomLeft);
        }
    }
    
    _isCornerChanged = YES;
}
- (void)setAnchorPoint
{
    if (_itemWidth == 0) return;
    
    CGPoint point = CGPointMake(0.5, 0.5);
    if (_arrowDirection == LLPopupMenuArrowDirectionTop) {
        point = CGPointMake(_arrowPosition / _itemWidth, 0);
    }else if (_arrowDirection == LLPopupMenuArrowDirectionBottom) {
        point = CGPointMake(_arrowPosition / _itemWidth, 1);
    }else if (_arrowDirection == LLPopupMenuArrowDirectionLeft) {
        point = CGPointMake(0, (_itemHeight - _arrowPosition) / _itemHeight);
    }else if (_arrowDirection == LLPopupMenuArrowDirectionRight) {
        point = CGPointMake(1, (_itemHeight - _arrowPosition) / _itemHeight);
    }
    CGRect originRect = self.frame;
    self.layer.anchorPoint = point;
    self.frame = originRect;
}
- (void)setOffset
{
    if (_itemWidth == 0) return;
    
    CGRect originRect = self.frame;
    
    if (_arrowDirection == LLPopupMenuArrowDirectionTop) {
        originRect.origin.y += _offset;
    }else if (_arrowDirection == LLPopupMenuArrowDirectionBottom) {
        originRect.origin.y -= _offset;
    }else if (_arrowDirection == LLPopupMenuArrowDirectionLeft) {
        originRect.origin.x += _offset;
    }else if (_arrowDirection == LLPopupMenuArrowDirectionRight) {
        originRect.origin.x -= _offset;
    }
    self.frame = originRect;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_arrowDirection == LLPopupMenuArrowDirectionTop) {
        self.tableView.frame = CGRectMake(_borderWidth, _borderWidth + _arrowHeight, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
    }else if (_arrowDirection == LLPopupMenuArrowDirectionBottom) {
        self.tableView.frame = CGRectMake(_borderWidth, _borderWidth, frame.size.width - _borderWidth * 2, frame.size.height - _arrowHeight);
    }else if (_arrowDirection == LLPopupMenuArrowDirectionLeft) {
        self.tableView.frame = CGRectMake(_borderWidth + _arrowHeight, _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
    }else if (_arrowDirection == LLPopupMenuArrowDirectionRight) {
        self.tableView.frame = CGRectMake(_borderWidth , _borderWidth , frame.size.width - _borderWidth * 2 - _arrowHeight, frame.size.height);
    }
}
- (void)touchOutSide
{
    if (_dismissOnTouchOutside) {
        [self dismiss];
    }
}

#pragma mark - setter
- (void)setIsShowShadow:(BOOL)isShowShadow
{
    _isShowShadow = isShowShadow;
    self.layer.shadowOpacity = isShowShadow ? 0.5 : 0;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = isShowShadow ? 2.0 : 0;
}

- (void)setShowMaskView:(BOOL)showMaskView
{
    _showMaskView = showMaskView;
    _menuBackView.backgroundColor = showMaskView ? [[UIColor blackColor] colorWithAlphaComponent:0.1] : [UIColor clearColor];
}
- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    [self.tableView reloadData];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    [self.tableView reloadData];
}

- (void)setPoint:(CGPoint)point
{
    _point = point;
    [self updateUI];
}

- (void)setItemWidth:(CGFloat)itemWidth
{
    _itemWidth = itemWidth;
    [self updateUI];
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    self.tableView.rowHeight = itemHeight;
    [self updateUI];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateUI];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    [self updateUI];
}

- (void)setArrowPosition:(CGFloat)arrowPosition
{
    _arrowPosition = arrowPosition;
    [self updateUI];
}

- (void)setArrowWidth:(CGFloat)arrowWidth
{
    _arrowWidth = arrowWidth;
    [self updateUI];
}

- (void)setArrowHeight:(CGFloat)arrowHeight
{
    _arrowHeight = arrowHeight;
    [self updateUI];
}

- (void)setArrowDirection:(LLPopupMenuArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self updateUI];
}

- (void)setMaxVisibleCount:(NSInteger)maxVisibleCount
{
    _maxVisibleCount = maxVisibleCount;
    [self updateUI];
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    [self updateUI];
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    [self updateUI];
}
-(void)setImagePath:(NSArray *)imagePath
{
    _imagePath = imagePath;
    [self updateUI];
}
- (void)setImages:(NSArray *)images
{
    _images = images;
    [self updateUI];
}

- (void)setPriorityDirection:(LLPopupMenuPriorityDirection)priorityDirection
{
    _priorityDirection = priorityDirection;
    [self updateUI];
}

- (void)setRectCorner:(UIRectCorner)rectCorner
{
    _rectCorner = rectCorner;
    [self updateUI];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateUI];
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    [self updateUI];
}
-(void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    [self.tableView reloadData];
}

#pragma  mark - tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLPopupMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:LLPopupMenuCellID];
    if (!cell) {
        cell = [[LLPopupMenuCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:LLPopupMenuCellID];
    }
//    cell.titleString = self.titles[indexPath.row];
//    cell.imagePatch = self.images[indexPath.row];
    cell.separatorColor = self.separatorColor;
    cell.titleColor = self.textColor;
    cell.titleFont = [UIFont systemFontOfSize:self.fontSize];
    cell.titleAlignment = self.textAlignment;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    LLPopupMenuCell * menuCell  = (LLPopupMenuCell *)cell;
    
    menuCell.imagePatch = self.imagePath[indexPath.row];
    menuCell.titleString = self.titles[indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_dismissOnSelected) [self dismiss];
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(indexPath);
    }
}

#pragma mark - scrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    LLPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    LLPopupMenuCell *cell = [self getLastVisibleCell];
    cell.isShowSeparator = NO;
}
-(void)drawRect:(CGRect)rect
{
    UIBezierPath *bezierPath = [LLPopupMenuPath yb_bezierPathWithRect:rect rectCorner:_rectCorner cornerRadius:_cornerRadius borderWidth:_borderWidth borderColor:_borderColor backgroundColor:_backColor arrowWidth:_arrowWidth arrowHeight:_arrowHeight arrowPosition:_arrowPosition arrowDirection:_arrowDirection];
    [bezierPath fill];
    [bezierPath stroke];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
