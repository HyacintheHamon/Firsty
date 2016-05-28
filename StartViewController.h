//
//  StartViewController.h
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController<UIPageViewControllerDataSource>

@property (strong, nonatomic) UIButton *btnGetStarted;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageImages;

@property UIWindow *window;

@end
