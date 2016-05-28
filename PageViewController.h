//
//  PageViewController.h
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property NSString *imageFile;

@end
