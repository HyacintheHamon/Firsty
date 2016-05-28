//
//  ProductViewController.h
//  Firsty
//
//  Created by iOS on 17/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProductViewController : UIViewController

@property (nonatomic, strong) PFObject *product;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIView   *customView;
@property (nonatomic, strong) UIView   *customView1;
@property(nonatomic,  strong) UIView *customView2;


@end

