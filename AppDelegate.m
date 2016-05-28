//
//  AppDelegate.m
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "AppDelegate.h"
#import "StartViewController.h"
#import "MainViewController.h"
#import "Define.h"
#import "TheSidebarController.h"
#import "LeftSidebarViewController.h"
#import <Braintree/Braintree.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "GlobalRequest.h"
#import "Constants.h"
#import <Stripe/Stripe.h>


NSString *const BFTaskMultipleExceptionsException = @"BFMultipleExceptionsException";
//NSString * const StripePublishableKey = @"pk_test_Ci5PKHY3zD0OFque2s5ho6zG";
@interface AppDelegate ()<TheSidebarControllerDelegate>

@property (nonatomic, strong) MBProgressHUD* HUD;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize finish;
@synthesize mUserCurrentLocation, str_Place, str_Description, str_PlaceLogo, str_ProductImage, str_PlaceCity, str_UserPic, str_PaymentType, array_Order;
@synthesize str_OpenTime, str_CloseTime, popupController;



static AppDelegate* sharedDelegate = nil;

+(AppDelegate*)sharedAppDelegate
{
    if (sharedDelegate == nil)
        sharedDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    return sharedDelegate;
}

#pragma mark - Showing / Hiding the loading view

- (void)showProgressHUD:(NSString*)title
{
    if (self.HUD != nil){
        [self hideProgressHUD];
    }
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:self.HUD];
    
    self.HUD.delegate = self;
    self.HUD.labelText = title;
    self.HUD.square = YES;
    
    [self.HUD show:YES];
}

- (void)hideProgressHUD
{
    [self.HUD hide:NO];
    [self.HUD removeFromSuperview];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    sleep(3);

    
     [Stripe setDefaultPublishableKey:StripePublishableKey];
    
    
    str_PaymentType=@"Paypal";
    
   // [Parse enableLocalDatastore];
    [Parse setApplicationId:@"4gDi7gfisEOQcKymkYpFLvJSlMmpehVakom7SLup"
                  clientKey:@"LrNvrtfE033nqxcHf2Aujvy7E4OPwpy1sjSSJ8al"];
    
  
    if (StripePublishableKey) {
        [Stripe setDefaultPublishableKey:StripePublishableKey];
       
    }

    
    
    [PFFacebookUtils initializeFacebook];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation saveInBackground];
    
    
    
    
    if ([PFUser currentUser] == nil) {
       [self initRun];
        return YES;
    }
    else{
        MainViewController *mainViewController = [[MainViewController alloc] init];
        UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        LeftSidebarViewController *leftSidebarViewController = [[LeftSidebarViewController alloc] init];
        leftSidebarViewController.view.backgroundColor = [UIColor colorWithRed:56.0/255.0 green:63.0/255.0 blue:69.0/255.0 alpha:1.0];
        leftSidebarViewController.view.alpha = 0.8f;
        
        TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                    leftSidebarViewController:leftSidebarViewController
                                                                                   rightSidebarViewController:nil];
        sidebarController.view.backgroundColor = [UIColor blackColor];
        sidebarController.delegate = self;
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = sidebarController;
        [self.window makeKeyAndVisible];
        return YES;
    }
    
    return NO;
}

-(void)initRun
{
   

    StartViewController *startViewController = [[StartViewController alloc] init];
    UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:startViewController];
    LeftSidebarViewController *leftSidebarViewController = [[LeftSidebarViewController alloc] init];
    leftSidebarViewController.view.backgroundColor = [UIColor colorWithRed:56.0/255.0 green:63.0/255.0 blue:69.0/255.0 alpha:1.0];
    leftSidebarViewController.view.alpha = 0.8f;
    
    TheSidebarController *sidebarController = [[TheSidebarController alloc] initWithContentViewController:contentNavigationController
                                                                                leftSidebarViewController:leftSidebarViewController
                                                                               rightSidebarViewController:nil];
    sidebarController.view.backgroundColor = [UIColor blackColor];
    sidebarController.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = sidebarController;
    [self.window makeKeyAndVisible];
}

#pragma mark - Get User Current Location

- (void)updateCurrentLocation {
    
    //CLLocationManager Object
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestWhenInUseAuthorization];
        //[self.locationManager requestAlwaysAuthorization];
    }
#endif
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    //CLLocation Object
    mUserCurrentLocation = [[CLLocation alloc]init];
    mUserCurrentLocation = [locationManager location];
    
}

-(CLLocation *) getCurrentLocation{
    return mUserCurrentLocation;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    NSLog(@" updated (%f , %f)", newLocation.coordinate.latitude, newLocation.coordinate.longitude) ;
    
    if (currentLocation != nil) {
        mUserCurrentLocation = newLocation;
    }
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    // Creates PFObject with token information
    PFUser *user = [PFUser currentUser];
    user[@"deviceToken"] = deviceToken;
    [user saveInBackground];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation

{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
    
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

@end
