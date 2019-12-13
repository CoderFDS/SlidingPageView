
#import "RHNavTabBarController.h"
#import "ViewController.h"
#import "RHNavTabBarView.h"
@interface RHNavTabBarController ()<UIScrollViewDelegate, RHNavTabBarDelegate>
{
    NSInteger       _currentIndex;
    NSMutableArray  *_titles;
    RHNavTabBarView *_navTabBarView;
    UIScrollView    *_mainView;
}
@end

@implementation RHNavTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.title = @"分类滑动页";
    
    [self initControl];
    [self initConfig];
    [self viewConfig];
}

-(void)initControl{

    NSArray *nameArr = [NSArray array];
    NSArray *contentArr = [NSArray array];
    nameArr = @[@"全国",@"军事",@"财经",@"推荐",@"图片",@"汽车",@"体育",@"娱乐",@"时尚",@"科技"];
    contentArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    
    NSMutableArray *viewArray = [NSMutableArray array];
    for(int i = 0; i < nameArr.count; i++)
    {
        ViewController *vc = [[ViewController alloc] init];
        vc.title = nameArr[i];
        vc.colorStr = contentArr[i];
        [viewArray addObject:vc];
    }
    _subViewControllers = [NSArray array];
    _subViewControllers = viewArray;
}

- (void)initConfig{
    _currentIndex = 0;
    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
    for (UIViewController *viewController in _subViewControllers){
        [_titles addObject:viewController.title];
    }
}

- (void)viewConfig
{
    [self viewInit];
    
    _navTabBarView.currentItemIndex = 0;
    
    //首先加载第一个视图
    UIViewController *viewController = (UIViewController *)_subViewControllers[0];
    viewController.view.frame = CGRectMake(0 , 0, ScreentW, ScreentH);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    
    // 设置scrollView的滚动偏移量
    _mainView.contentOffset = CGPointMake(0, 0);
}

//顶部视图滑动
- (void)viewInit
{
    _navTabBarView = [[RHNavTabBarView alloc] initWithFrame:CGRectMake(0, 88, ScreentW , 44)];
    _navTabBarView.delegate = self;
    _navTabBarView.backgroundColor = [UIColor clearColor];
    _navTabBarView.lineColor = _navTabBarLineColor;
    _navTabBarView.itemTitles = _titles;
    [_navTabBarView updateData];
    [self.view addSubview:_navTabBarView];
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 88+44, ScreentW, ScreentH-44-88)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = NO;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.showsVerticalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(ScreentW * _subViewControllers.count, 0);
    [self.view addSubview:_mainView];
    
}

#pragma mark - Scroll View Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / ScreentW;
    _navTabBarView.currentItemIndex = _currentIndex;
    /** 当scrollview滚动的时候加载当前视图 */
    UIViewController *viewController = (UIViewController *)_subViewControllers[_currentIndex];
    viewController.view.frame = CGRectMake(_currentIndex * ScreentW, 0, ScreentW, _mainView.frame.size.height);
    [_mainView addSubview:viewController.view];
    [self addChildViewController:viewController];
    
}

//  currentIndex 点击前      index 点击后
- (void)itemDidSelectedWithIndex:(NSInteger)index withCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex-index>=2 || currentIndex-index<=-2) {
        [_mainView setContentOffset:CGPointMake(index * ScreentW, 0) animated:NO];
    }else{
        [_mainView setContentOffset:CGPointMake(index * ScreentW, 0) animated:YES];
    }
}

@end
