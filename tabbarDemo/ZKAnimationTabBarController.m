//
//  ZKAnimationTabBarController.m
//  publicObject
//
//  Created by jack on 2019/12/13.
//  Copyright © 2019 DAQSoft-BaseObject. All rights reserved.
//

#import "ZKAnimationTabBarController.h"

@interface ZKAnimationTabBarController ()<UITabBarControllerDelegate>
/// 弧形视图
@property (nonatomic, strong) UIImageView *radianView;
/// 按钮宽度
@property (nonatomic, assign) CGFloat tabbarButtonWidth;
@end

@implementation ZKAnimationTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 首页
    UINavigationController *homeViewController = [self createTabBarVCClassName:@"ViewController" vcTitle:@"首页" defaultImage:@"home_bar_sy" selectedImage:@"home_bar_sy_hover"];
    // 活动
    UINavigationController *activityViewController = [self createTabBarVCClassName:@"ViewController" vcTitle:@"活动" defaultImage:@"home_bar_hd" selectedImage:@"home_bar_hd_hover"];

    self.viewControllers = @[homeViewController,
                             activityViewController];
    self.delegate = self;
    
    [self customizeTabBarAppearance];
    [self hideTabBarShadowImageView];
    [self createRadianView];
    [self tabBarSelectedWithIndex:0];
    
    // 注册监听button的enabled状态
    [self addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
    
}

/// 监听
/// @param keyPath keyPath description
/// @param object object description
/// @param change change description
/// @param context context description
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
   [self tabBarSelectedWithIndex:self.selectedIndex];
}
#pragma mark --- UITabBarControllerDelegate ---
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
    
    
}
#pragma mark --- UITabBarDelegate ----
/// 第一种方法：通过接收点击事件对每个tabbar item的点击都执行动画
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (self.selectedIndex == index) {
        return;
    }
    [self tabBarSelectedWithIndex:index];

}
#pragma mark --- fun ---
/// TabBar设置
- (void)customizeTabBarAppearance {
    // Customize UITabBar height
    // 自定义 TabBar 高度
    // tabBarController.tabBarHeight = CYL_IS_IPHONE_X ? 65 : 40;
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    UIOffset titlePositionAdjustment = UIOffsetMake(0, -3.5);
    tabBar.titlePositionAdjustment = titlePositionAdjustment;
    
    self.tabBar.tintColor = [UIColor blackColor];
    
}
/// 隐藏线条
- (void)hideTabBarShadowImageView {
    
    if (@available(iOS 13, *)) {
#ifdef __IPHONE_13_0
        UITabBarAppearance *appearance = [self.tabBar.standardAppearance copy];
        appearance.backgroundImage = [UIImage new];
        appearance.backgroundColor = [UIColor clearColor];
        appearance.shadowImage = [UIImage new];
        appearance.shadowColor = [UIColor clearColor];
        self.tabBar.standardAppearance = appearance;
#endif
    } else {
        self.tabBar.backgroundImage = [[UIImage alloc] init];
        // 去除 TabBar 自带的顶部阴影
        [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    }
}
/// 创建弧形视图
- (void)createRadianView
{
    [UITabBar appearance].translucent = NO;
    // 设置背景色
    UIView *tabBarView = [[UIView alloc] init];
    tabBarView.backgroundColor = [UIColor whiteColor];
    tabBarView.frame = self.tabBar.bounds;
    [[UITabBar appearance] insertSubview:tabBarView atIndex:0];
    // 弧形视图
    UIImage *image = [UIImage imageNamed:@"tab_select_bg"];
    self.radianView = [[UIImageView alloc] initWithImage:image];
    self.radianView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [[UITabBar appearance] insertSubview:self.radianView atIndex:0];
    // 顶部线条
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, -0.4, CGRectGetWidth(self.tabBar.bounds), 0.4)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [[UITabBar appearance] insertSubview:lineView atIndex:0];
    
    self.tabbarButtonWidth = ([UIScreen mainScreen].bounds.size.width)/self.viewControllers.count;
}
/**
 返回视图
 
 @param className 界面类名
 @param title 界面名称
 @param defaultImage 默认图片
 @param selectedImage 选中的图片
 @return vc
 */
- (UINavigationController *)createTabBarVCClassName:(NSString *)className vcTitle:(NSString *)title  defaultImage:(NSString *)defaultImage selectedImage:(NSString *)selectedImage{
    
    UIViewController *vc = [NSClassFromString(className) new];
    vc.navigationItem.title = title;
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:defaultImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    return navVC;
}
/// 动画更新选中
/// @param index 第几个
- (void)tabBarSelectedWithIndex:(NSInteger)index
{
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            obj.imageInsets = UIEdgeInsetsMake(-6, 0, 6, 0);
            UIControl *tabBarButton = [obj valueForKey:@"view"];
            for (UIView *view in tabBarButton.subviews) {
                
                if ([view isKindOfClass:[UIImageView class]]) {
                    CGFloat buttonW = self.tabbarButtonWidth;
                    CGFloat x = buttonW*index+buttonW/2;
                    self.radianView.center = CGPointMake(x, -5);
                    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
                    // 通过初中物理重力公式计算出的位移y值数组
                    animation.values = @[@0.0, @-4, @0.0];
                    animation.duration = 0.3;
                    [view.layer addAnimation:animation forKey:nil];
                    [self.radianView.layer addAnimation:animation forKey:nil];
                }
            }
        }else
        {
            obj.imageInsets = UIEdgeInsetsZero;
        }
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
