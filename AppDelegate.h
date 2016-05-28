//
//  AppDelegate.h
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import "CNPPopupController.h"
#import "MBProgressHUD.h"
#import "userInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, CNPPopupControllerDelegate, MBProgressHUDDelegate>
{
    CLLocationManager *locationManager;
  NSString * firstTime;
      float totalPrice;
}

- (void)showProgressHUD:(NSString*)title;
- (void)hideProgressHUD;

@property (nonatomic, strong)  userInfo *user;
@property (nonatomic, strong)  NSArray *friends;

@property (nonatomic, strong) CLLocation *mUserCurrentLocation;
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL finish;
@property (strong, nonatomic) NSString *str_Place;
@property (strong, nonatomic) NSString *str_Description;
@property (strong, nonatomic) NSString *str_PlaceCity;
@property (strong, nonatomic) NSString *str_OpenTime;
@property (strong, nonatomic) NSString *str_CloseTime;

@property (strong, nonatomic) PFFile *str_PlaceLogo;
@property (strong, nonatomic) PFFile *str_ProductImage;
@property (strong, nonatomic) PFFile *str_UserPic;

@property (strong, nonatomic) NSString *str_PaymentType;
@property (nonatomic, strong) NSString *devicestr;
@property (nonatomic,strong)  NSMutableArray *array_Order;

@property (nonatomic, strong) CNPPopupController *popupController;

@property (strong, nonatomic) NSMutableArray *cart;
@property (strong, nonatomic) NSMutableArray *favoriteOrders;

-(void) updateCurrentLocation;
-(CLLocation *) getCurrentLocation;
+(AppDelegate*)sharedAppDelegate;
-(void)initRun;
@end

