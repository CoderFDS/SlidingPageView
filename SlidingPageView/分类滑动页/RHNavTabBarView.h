
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ScreentW [UIScreen mainScreen].bounds.size.width
#define ScreentH [UIScreen mainScreen].bounds.size.height

@protocol RHNavTabBarDelegate <NSObject>
@optional
- (void)itemDidSelectedWithIndex:(NSInteger)index;
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex;
@end

@interface RHNavTabBarView : UIView

@property (nonatomic, weak)    id<RHNavTabBarDelegate>delegate;
@property (nonatomic, assign)  NSInteger currentItemIndex;
@property (nonatomic, strong)  NSArray *itemTitles;
@property (nonatomic, strong)  UIColor *lineColor;
@property (nonatomic, strong)  NSMutableArray *items;

- (id)initWithFrame:(CGRect)frame;
- (void)updateData;

@end

NS_ASSUME_NONNULL_END
