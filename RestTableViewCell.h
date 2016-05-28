//
//  RestTableViewCell.h
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *restImgView;
@property (nonatomic, strong) UILabel     *restLbl;
@property (nonatomic, strong) UILabel     *restDistanceLbl;
@property (nonatomic, strong) UIButton    *stateBtn;
@property (nonatomic, strong) UIButton    *likeBtn;

@end
