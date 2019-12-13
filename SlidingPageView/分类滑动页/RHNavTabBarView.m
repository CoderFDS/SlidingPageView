
#import "RHNavTabBarView.h"
#import "NSString+Extension.h"

@interface RHNavTabBarView ()
{
    UIScrollView    *_navgationTabBar;
    UIView          *_line;
    NSArray         *_itemsWidth;
}
@end

@implementation RHNavTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig
{
    _items = [@[] mutableCopy];
    [self viewConfig];
}

- (void)viewConfig
{
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreentW, 44)];
    _navgationTabBar.backgroundColor = [UIColor clearColor];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
}

- (void)updateData
{
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    if (_itemsWidth.count){
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, 0);
    }
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = 20;//当button的间距为10时，第一个button的x应为20.
    for (NSInteger index = 0; index < [_itemTitles count]; index++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        CGSize textMaxSize = CGSizeMake(ScreentW, MAXFLOAT);
        CGSize textRealSize = [_itemTitles[index] sizeWithFont:[UIFont systemFontOfSize:14] maxSize:textMaxSize ];

        textRealSize = CGSizeMake(textRealSize.width + 10*2, 44);
        button.frame = CGRectMake(buttonX, 0,textRealSize.width, 44);
        
        [button setTitleColor:[UIColor grayColor] forState: UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];

        [button addTarget:self action:@selector(itemPressed:type:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [_items addObject:button];
        buttonX += button.frame.size.width+10;//设置button的间距为10
    }
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    return buttonX;
}

#pragma mark  下划线
- (void)showLineWithButtonWidth:(CGFloat)width
{
    //第一个线的位置
    _line = [[UIView alloc] initWithFrame:CGRectMake(10, 44 - 4.0f, width, 3.0f)];
    _line.backgroundColor = [UIColor redColor];
    [_navgationTabBar addSubview:_line];
    
    UIButton *btn = _items[0];
    [self itemPressed:btn type:0];
}

- (void)itemPressed:(UIButton *)button type:(int)type
{
    button.selected =YES;
    NSInteger index = [_items indexOfObject:button];
    for (NSInteger  i = 0 ; i<_items.count; i++) {
        if (i!=index) {
            UIButton *btn = self.items[i];
            btn.selected =NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }else{
            UIButton *btn = self.items[i];
            btn.selected =YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
        }
    }
    [_delegate itemDidSelectedWithIndex:index withCurrentIndex:_currentItemIndex];
}

//计算数组内字体的宽度
- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    for (NSString *title in titles){
        CGSize textMaxSize = CGSizeMake(ScreentW, MAXFLOAT);
        CGSize textRealSize = [title sizeWithFont:[UIFont systemFontOfSize:14] maxSize:textMaxSize];
        NSNumber *width = [NSNumber numberWithFloat:textRealSize.width];
        [widths addObject:width];
    }
    return widths;
}

#pragma mark 偏移
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    CGFloat flag = ScreentW - 40;
    if (button.frame.origin.x + button.frame.size.width + 50>= flag){
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count]-1){
            offsetX = offsetX + button.frame.size.width;
        }
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
    }else{
        [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
       //下划线的偏移量
    [UIView animateWithDuration:0.1f animations:^{
        self->_line.frame = CGRectMake(button.frame.origin.x + 10, self->_line.frame.origin.y, [self->_itemsWidth[currentItemIndex] floatValue], self->_line.frame.size.height);
    }];
    
    for (NSInteger  i = 0 ; i<_items.count; i++) {
        if (i==currentItemIndex) {
            UIButton *btn = self.items[i];
            btn.selected =YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
        }else{
            UIButton *btn = self.items[i];
            btn.selected =NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}

-(void)canleSelect{
    for (NSInteger  i = 0 ; i<_items.count; i++) {
        if (i==0) {
            UIButton *btn = self.items[i];
            btn.selected =YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
        }else{
            UIButton *btn = self.items[i];
            btn.selected =NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
    }
}

@end
