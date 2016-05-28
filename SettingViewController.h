//
//  SettingViewController.h
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SettingViewController : UIViewController

@property (nonatomic, strong) UIImageView *userImgView;
@property (nonatomic, strong) UIImageView *circleImgView;
@property (nonatomic, strong) UILabel     *userNameLbl;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) UILabel     *facebookLbl;
@property (nonatomic, strong) UILabel     *twitterLbl;

@property (assign, nonatomic) BOOL isEdit;

@end
