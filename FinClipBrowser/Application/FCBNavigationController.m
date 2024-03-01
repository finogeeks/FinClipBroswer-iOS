//
//  FCBNavigationController.m
//  FinClipBrowser
//
//  Created by vchan on 2023/3/16.
//

#import "FCBNavigationController.h"

@interface FCBNavigationController () <UINavigationBarDelegate>

@end

@implementation FCBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.clearColor;
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setTintColor:[UIColor blackColor]];
    UIImage *image = [UIImage imageNamed:@"login_nav_back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationBar.backIndicatorImage = image;
    navigationBar.backIndicatorTransitionMaskImage = image;
    [navigationBar setShadowImage:[UIImage new]];
    navigationBar.barTintColor = UIColor.whiteColor;
    navigationBar.translucent = NO;
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        //appearance.shadowImage = UIImage.new;
        appearance.shadowColor = UIColor.clearColor;
        [appearance setBackgroundColor:[UIColor whiteColor]];
        [navigationBar setScrollEdgeAppearance:appearance];
        [navigationBar setStandardAppearance:appearance];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] init];
    buttonItem.tintColor = UIColor.blackColor;
    viewController.navigationItem.backBarButtonItem = buttonItem;
    viewController.extendedLayoutIncludesOpaqueBars = YES;
    [super pushViewController:viewController animated:animated];
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    for (UIViewController *viewController in viewControllers) {
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] init];
        buttonItem.tintColor = UIColor.blackColor;
        viewController.navigationItem.backBarButtonItem = buttonItem;
        viewController.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    [super setViewControllers:viewControllers animated:animated];
}

#pragma mark -

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
