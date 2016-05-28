//
//  StartViewController.m
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "StartViewController.h"
#import "MainViewController.h"
#import "PageViewController.h"


#import "AppDelegate.h"
#import "Define.h"

@interface StartViewController ()
{
    AppDelegate *delegate;
}
@end

@implementation StartViewController
@synthesize btnGetStarted;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _pageImages = @[@"page1", @"page2", @"page3", @"page4"];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    PageViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
        btnGetStarted = [[UIButton alloc] initWithFrame:CGRectMake(Width - 90, 40, 60, 30)];
        btnGetStarted.layer.cornerRadius = 5;
        [btnGetStarted setTitle:@"Skip" forState:UIControlStateNormal];
        btnGetStarted.layer.masksToBounds =YES;
        [btnGetStarted setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btnGetStarted.tintColor = [UIColor lightGrayColor];
        [btnGetStarted addTarget:self action:@selector(getStartedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        btnGetStarted.alpha = 1.0;
        btnGetStarted.transform = CGAffineTransformMakeTranslation(10,0);
        [self.view addSubview:btnGetStarted];
    
}

- (PageViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.pageImages count] == 0) || (index > [self.pageImages count])) {
        return nil;
    }
    
    PageViewController *childViewController = [[PageViewController alloc] init];
    childViewController.index = index;
    childViewController.imageFile = self.pageImages[index];
    
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PageViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(PageViewController *)viewController index];
    
    index++;
    
    if (index == 4) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 4;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)getStartedBtnClicked{
    MainViewController *mainView = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mainView animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Check for app update if app is not on first launch
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = TRUE;
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
