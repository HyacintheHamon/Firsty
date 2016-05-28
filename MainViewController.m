//
//  MainViewController.m
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//
#import "Define.h"
#import "MainViewController.h"
#import "RestTableViewCell.h"
#import "GlobalModel.h"
#import "TheSidebarController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MyLocation.h"
#import "CNPPopupController.h"
#import "MapDetailVC.h"
#import "MapVC.h"
#import "UIImageView+WebCache.h"

#import "CLLocationManager+blocks.h"
#import "MBProgressHUD.h"


#define METERS_PER_MILE 1609.344
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define Width self.view.frame.size.width
#define Height self.view.frame.size.height

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, CNPPopupControllerDelegate>
{
    AppDelegate *delegate;
    UITableView *tableForMainSetting;
    UIActivityIndicatorView *activityIndicator;
    UIButton *btn_Map;
    UIButton *btn_Search;
    UILabel *lbl_Map;
    UISearchBar *searchBar1;
    
    NSMutableArray *array_Search;
    NSMutableArray *array_Distance;
    NSMutableArray *array_Status;
    
    CGFloat latitude;
    CGFloat longitude;
    UIImageView *holdPhoto;
    UIImageView *holdPhoto1;
    UILabel *lbl_Place;
    UITextView *description;
    UILabel *lbl_City;
    UILabel *lbl_Opening;
    BOOL *hasZoomedAtStartUp;
    UIButton* btn_CL;
    UIView *bgView;
    
    NSMutableArray *favIds;

    CLLocation *mylocation;
    
    BOOL like;
    MBProgressHUD *HUD;

}

@property (nonatomic, strong) CLLocationManager *currentManager;

@property (nonatomic, strong) NSArray *placeArray;
@property (nonatomic, strong) NSMutableArray *nearbyPlaceArray;
@property (nonatomic, strong) NSMutableArray *distanceArray;
@property (nonatomic, strong) NSMutableArray *statusArray;
@property (nonatomic, strong) NSMutableArray *nearbyPlaceArrayFav;
@property (nonatomic, strong) NSMutableArray *distanceArrayFav;
@property (nonatomic, strong) NSMutableArray *statusArrayFav;
@property (nonatomic, strong) NSMutableArray *favoriteArray;
@property (nonatomic, strong) NSMutableArray *favoritePlaces;

@property (nonatomic, strong) NSTimer *workTimer;
@property (nonatomic, strong) UILabel *lbl_noRows;
@property (nonatomic, strong) UIImageView *holdPhoto;
@property (nonatomic,retain)  UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL isRefreshIconsOverlap;
@property (assign) BOOL isRefreshAnimating;
@property (assign) BOOL isFavSelected;

@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation MainViewController

@synthesize placeArray,nearbyPlaceArray,distanceArray,statusArray, holdPhoto, lbl_noRows;
@synthesize PlaceInfo,nearbyPlaceArrayFav,distanceArrayFav,statusArrayFav, favoriteArray, favoritePlaces;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:UIColorFromRGB(0x23262F)];
    
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    self.currentManager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionAlways];
    
    if ([CLLocationManager isLocationUpdatesAvailable]) {
        [self.currentManager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
            NSLog(@"Our new location: %@", location);
            mylocation = location;
            *stopUpdating = YES;
        }];
    }
    
    nearbyPlaceArray =[NSMutableArray new];
    distanceArray = [NSMutableArray new];
    statusArray = [NSMutableArray new];
    favoriteArray = [NSMutableArray new];
    favoritePlaces = [NSMutableArray new];
    
    nearbyPlaceArrayFav =[NSMutableArray new];
    distanceArrayFav = [NSMutableArray new];
    statusArrayFav = [NSMutableArray new];
    
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 70)];
    [barImageView setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:barImageView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Width/2 - 20, 25, 40, 40)];
    logoImageView.image = [UIImage imageNamed:@"logoIcon.png"];
    [self.view addSubview:logoImageView];
    
    UIButton *list_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 3, self.view.frame.origin.y + 30, 30, 30)];
    [list_btn setImage:[UIImage imageNamed:@"MenuIcon.png"] forState:UIControlStateNormal];
    [list_btn addTarget:self action:@selector(listBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [list_btn setTintColor:[UIColor lightGrayColor]];
    list_btn.alpha = 1.0;
    list_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:list_btn];
    
    UIButton *location_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 50, self.view.frame.origin.y + 30, 30, 30)];
    [location_btn setImage:[UIImage imageNamed:@"Mapicon.png"] forState:UIControlStateNormal];
    [location_btn addTarget:self action:@selector(locationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [location_btn setTintColor:[UIColor lightGrayColor]];
    location_btn.alpha = 1.0;
    location_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:location_btn];
    
    tableForMainSetting = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, Width, Height-70) style:UITableViewStylePlain];
    
    tableForMainSetting.dataSource = self;
    tableForMainSetting.delegate = self;
    [tableForMainSetting setBackgroundColor:UIColorFromRGB(0x23262F)];
    tableForMainSetting.userInteractionEnabled=YES;
    [tableForMainSetting setAllowsSelection:YES];
    if ([tableForMainSetting respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [tableForMainSetting setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [tableForMainSetting setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableForMainSetting];
    
    
    if ([tableForMainSetting respondsToSelector:@selector(setBackgroundView:)]) {
        [tableForMainSetting setBackgroundView:nil];
        
    }
    
    [self ParseGetAllPlaceList];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = TRUE;
}

- (void)listBtnClicked{
    if(self.sidebarController.sidebarIsPresenting)
    {
        [self.sidebarController dismissSidebarViewController];
    }
    else
    {
        [self.sidebarController presentLeftSidebarViewController];
    }
}

- (void)locationBtnClicked{
    MapVC *vc=[MapVC new];
    vc.PlaceInfo=[array_Search mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)ParseGetAllPlaceList{
    
    if ((array_Search.count == 0) || (array_Distance.count == 0) || (array_Status.count == 0) || (favoriteArray.count == 0)) {
        [delegate updateCurrentLocation];
        CLLocation *myLocation = [delegate getCurrentLocation];
        NSString *str_lat = [NSString stringWithFormat:@"%f", myLocation.coordinate.latitude];
        NSString *str_lng = [NSString stringWithFormat:@"%f", myLocation.coordinate.longitude];
        
        //Check Internet connection
        if (![[GlobalModel sharedManager] CheckInternetConnectivity]) {
            [self showPopupWithStyle:CNPPopupStyleCentered andText:@"The connection appears to be offline. Please Connect and try again."];
            return;
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"Loading...";
        [hud show:YES];
        
        //Find All places from DB
        PFQuery *query = [PFQuery queryWithClassName:@"Places"]; //1
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
            if (!error) {
                
                self.placeArray = nil;
                self.placeArray = [[NSArray alloc] initWithArray:objects];
                [self.nearbyPlaceArray removeAllObjects];
                [self.distanceArray removeAllObjects];
                [self.statusArray removeAllObjects];
                [self.nearbyPlaceArrayFav removeAllObjects];
                [self.distanceArrayFav removeAllObjects];
                [self.statusArrayFav removeAllObjects];
                [self.favoritePlaces removeAllObjects];
                [self.favoriteArray removeAllObjects];
                
                favIds=[[[NSUserDefaults standardUserDefaults] objectForKey:@"fav"] mutableCopy];
                if([self.placeArray count]>0){
                    
                    for (int i=0; i<self.placeArray.count; i++) {
                        
                        //Get Distance between user's current location and place location
                        float Distance = [self getDistance:str_lat andCurrentLongitude:str_lng andLat:[[self.placeArray objectAtIndex:i]valueForKey:@"Latitude"] Lng:[[self.placeArray objectAtIndex:i]valueForKey:@"Longitude"]];
                        
                        NSArray *componentArray = [[[self.placeArray objectAtIndex:i]valueForKey:@"openingTime"] componentsSeparatedByString:@":"];
                        NSArray *componentArray1 = [[[self.placeArray objectAtIndex:i]valueForKey:@"closingTime"] componentsSeparatedByString:@":"];
                        
                        NSString *str_Status=   [self getRightTime:[componentArray objectAtIndex:0] andClosetime:[componentArray1 objectAtIndex:0]];
                        
                            [self.nearbyPlaceArray addObject:[self.placeArray objectAtIndex:i]];
                            [self.distanceArray addObject:[NSString stringWithFormat:@"%.2f",Distance]];
                            [self.statusArray addObject:[NSString stringWithFormat:@"%@",str_Status]];
                        [hud hide:YES];
                    }
                    
                    if (_isFavSelected) {
                        
                        array_Search=[NSMutableArray arrayWithArray:self.nearbyPlaceArrayFav];
                        array_Distance=[NSMutableArray arrayWithArray:self.distanceArrayFav];
                        array_Status=[NSMutableArray arrayWithArray:self.statusArrayFav];
                        

                    }
                    else
                    {
                        array_Search=[NSMutableArray arrayWithArray:self.nearbyPlaceArray];
                        array_Distance=[NSMutableArray arrayWithArray:self.distanceArray];
                        array_Status=[NSMutableArray arrayWithArray:self.statusArray];
                    }
                    
                    if ([PFUser currentUser] == nil) {
                       
                    }
                    else{
                        PFQuery *queryFavorite = [PFQuery queryWithClassName:@"FavoritePlaces"]; //1
                        [queryFavorite whereKey:@"user" equalTo:[[PFUser currentUser] username]];
                        
                        [queryFavorite findObjectsInBackgroundWithBlock:^(NSArray *objects2, NSError *error) {
                            if (!error) {
                                favoritePlaces = [NSMutableArray arrayWithArray:objects2];
                            }
                        }];
                        
                        for (int index = 0; index < array_Search.count; index++) {
                            PFQuery *favoriteQuery = [PFQuery queryWithClassName:@"FavoritePlaces"];
                            [favoriteQuery whereKey:@"CafeName" equalTo:[[array_Search objectAtIndex:index] objectForKey:@"Name"]];
                            [favoriteQuery whereKey:@"user" equalTo:[[PFUser currentUser] username]];
                            
                            if ([favoriteQuery findObjects].count == 0) {
                                [favoriteArray addObject:[NSNumber numberWithBool:NO]];
                            }
                            else{
                                [favoriteArray addObject:[NSNumber numberWithBool:YES]];
                            }
                        }
                        
                
                    }
                    
                    [tableForMainSetting reloadData];
                }
                else{
                    
                }
            }
            else {
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"The connection appears to be offline. Please Connect and try again."];
            }
        }];
    }
    else{
        [tableForMainSetting reloadData];
    }
}

-(void)addToFavourite:(UIButton*)btn
{
    PFObject *imageObject = [array_Search objectAtIndex:btn.tag];
    favIds=[[[NSUserDefaults standardUserDefaults] objectForKey:@"fav"] mutableCopy];
    if (favIds==nil) {
        favIds=[[NSMutableArray alloc] init];
    }
    if ([favIds containsObject:imageObject.objectId])
    {
        [favIds removeObject:imageObject.objectId];
        [self.nearbyPlaceArrayFav removeObject:[self.nearbyPlaceArray objectAtIndex:btn.tag]];
        [self.distanceArrayFav removeObject:[self.distanceArray objectAtIndex:btn.tag]];
    }
    else
    {
        [favIds addObject:imageObject.objectId];
        [self.nearbyPlaceArrayFav addObject:[self.nearbyPlaceArray objectAtIndex:btn.tag]];
        [self.distanceArrayFav addObject:[self.distanceArray objectAtIndex:btn.tag]];
        
    }
    [[NSUserDefaults standardUserDefaults] setObject:favIds forKey:@"fav"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tableForMainSetting reloadData];
}

#pragma mark - getTime

-(NSString*)getRightTime:(NSString*)open andClosetime:(NSString*)close{
    
    // For calculating the current date
    NSDate *date = [NSDate date];
    
    // Make Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh a"];
    
    // hh for hour mm for minutes and a will show you AM or PM
    [dateFormatter setLocale:[NSLocale systemLocale]];
    
    NSString *str = [dateFormatter stringFromDate:date];
    NSLog(@"%@", str);
    
    // Seperate str by space i.e. you will get time and AM/PM at index 0 and 1 respectively
    NSArray *array = [str componentsSeparatedByString:@" "];
    
    // Now you can check it by 12. If < 12 means Its morning > 12 means its evening or night
    NSString * timeInHour = array[0];
    NSString * am_pm      = array[1];
    
    NSInteger CurrentTime =[timeInHour integerValue];
    NSInteger OpenTime =[open integerValue];
    NSInteger CloseTime =[close integerValue];
    
    if(CurrentTime < 12 && [am_pm isEqualToString:@"AM"])
    {
        if (OpenTime <= CurrentTime && CurrentTime <= CloseTime) {
            return @"OPEN";
        }else{
            return @"CLOSED";
        }
        
    }
    else if (CurrentTime <= 12 && [am_pm isEqualToString:@"PM"]){
        if (CurrentTime == 12 && OpenTime == 12) {
            return @"OPEN";
        }else{
            if (OpenTime <= CurrentTime+12 && CurrentTime+12 <= CloseTime) {
                return @"OPEN";
            }else{
                return @"CLOSED";
            }
        }
        
    }
    else{
        return @"OPEN";
    }
}

#pragma mark - getDistance
-(float)getDistance:(NSString*)CLat andCurrentLongitude:(NSString*)CLng andLat:(NSString*)lat2 Lng:(NSString*)long2{
    
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:[CLat floatValue] longitude:[CLng floatValue]];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:[lat2 floatValue] longitude:[long2 floatValue]];
    NSLog(@"Distance in meters: %f", [location1 distanceFromLocation:location2]);
    
    float myInt = (float)[location1 distanceFromLocation:location2];
    return myInt;
    
    
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if([array_Search count] == 0){
        
        lbl_noRows.hidden = NO;
        holdPhoto1.hidden = NO;
        
    } else {
        
        lbl_noRows.hidden = YES;
        holdPhoto1.hidden = YES;
    }
    
    return [array_Search count];
    
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.accessoryType=UITableViewCellAccessoryNone;
        
    }
    else
    {
        UIView *subview;
        while ((subview= [[[cell contentView]subviews]lastObject])!=nil)
            [subview removeFromSuperview];
    }
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    gesture.cancelsTouchesInView = NO;
    [tableForMainSetting addGestureRecognizer:gesture];
    
    UIImageView *placeImage1 =[UIImageView new];
    placeImage1.frame=CGRectMake(0, 0, Width, 200);
    placeImage1.clipsToBounds = YES;
    placeImage1.userInteractionEnabled=YES;
    [placeImage1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholder"]]];
    placeImage1.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:placeImage1];
    
    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow.png"]];
    shadowImageView.contentMode = UIViewContentModeScaleAspectFill;
    shadowImageView.clipsToBounds = YES;
    shadowImageView.frame = CGRectMake(0,0, Width, 200);
    [cell.contentView addSubview:shadowImageView];
    
    PFObject *imageObject = [array_Search objectAtIndex:indexPath.row];
    
    PFFile *imageFile = [imageObject objectForKey:@"backgroundFile"];
    [placeImage1 sd_setImageWithURL:[NSURL URLWithString:imageFile.url]];
    
    UILabel *lbl_Name=[[UILabel alloc]init];
    [lbl_Name setFrame:CGRectMake(0, 40, Width, 35)];
    [lbl_Name setTextAlignment:NSTextAlignmentCenter];
    [lbl_Name setTextColor:[UIColor whiteColor]];
    [lbl_Name setBackgroundColor:[UIColor clearColor]];
    [lbl_Name setFont:[UIFont fontWithName:@"Arial" size:30.0]];
    [cell.contentView addSubview:lbl_Name];
    
    UILabel *lbl_Address=[[UILabel alloc]init];
    [lbl_Address setFrame:CGRectMake(0, 80, Width, 35)];
    [lbl_Address setTextAlignment:NSTextAlignmentCenter];
    [lbl_Address setTextColor:[UIColor whiteColor]];
    [lbl_Address setBackgroundColor:[UIColor clearColor]];
    [lbl_Address setFont:[UIFont fontWithName:@"Arial" size:20.0]];
    [cell.contentView addSubview:lbl_Address];
    
    UILabel *lbl_Distance=[[UILabel alloc]init];
    [lbl_Distance setFrame:CGRectMake(0, 120, Width, 20)];
    [lbl_Distance setTextAlignment:NSTextAlignmentCenter];
    [lbl_Distance setTextColor:[UIColor whiteColor]];
    [lbl_Distance setBackgroundColor:[UIColor clearColor]];
    [lbl_Distance setFont:[UIFont fontWithName:KFontUsed size:17.0]];
    [cell.contentView addSubview:lbl_Distance];
    
    UILabel *lbl_OpenHours=[[UILabel alloc]init];
    [lbl_OpenHours setFrame:CGRectMake(20, 150, 80, 20)];
    [lbl_OpenHours setTextAlignment:NSTextAlignmentCenter];
    [lbl_OpenHours setTextColor:[UIColor whiteColor]];
    [lbl_OpenHours setBackgroundColor:UIColorFromRGB(0xEE7031)];
    lbl_OpenHours.layer.borderWidth = 1.0f;
    [lbl_OpenHours setFont:[UIFont fontWithName:KFontUsed size:20.0]];
    [cell.contentView addSubview:lbl_OpenHours];
    
    if ([PFUser currentUser] == nil) {
        
    }
    else{
        if ([[favoriteArray objectAtIndex:indexPath.row] boolValue]) {
            UIButton *btn_like = [[UIButton alloc] init];
            [btn_like setFrame:CGRectMake(Width- 70, 150, 30, 30)];
            [btn_like setImage:[UIImage imageNamed:@"likeIconT.png"] forState:UIControlStateNormal];
            btn_like.tag = indexPath.row;
            [btn_like setTintColor:[UIColor lightGrayColor]];
            btn_like.alpha = 1.0;
            btn_like.transform = CGAffineTransformMakeTranslation(10, 0);
            [btn_like addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn_like];
        }
        else{
            UIButton *btn_like = [[UIButton alloc] init];
            [btn_like setFrame:CGRectMake(Width- 70, 150, 30, 30)];
            [btn_like setImage:[UIImage imageNamed:@"likeIconF.png"] forState:UIControlStateNormal];
            btn_like.tag = indexPath.row;
            [btn_like setTintColor:[UIColor lightGrayColor]];
            btn_like.alpha = 1.0;
            btn_like.transform = CGAffineTransformMakeTranslation(10, 0);
            [btn_like addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn_like];
        }
    }
    
    UITextView *description1 = [[UITextView alloc]init];
    
    NSArray *componentArray = [[[array_Search objectAtIndex:indexPath.row]valueForKey:@"openingTime"] componentsSeparatedByString:@":"];
    NSArray *componentArray1 = [[[array_Search objectAtIndex:indexPath.row]valueForKey:@"closingTime"] componentsSeparatedByString:@":"];
    
    NSString *str_Status=   [self getRightTime:[componentArray objectAtIndex:0] andClosetime:[componentArray1 objectAtIndex:0]];
    
    int distance =[[array_Distance objectAtIndex:indexPath.row] intValue];
    
    [lbl_Name setText:[[array_Search objectAtIndex:indexPath.row]valueForKey:@"Name"]];
    [lbl_Address setText:[[array_Search objectAtIndex:indexPath.row]valueForKey:@"address"]];
    [lbl_OpenHours setText:[NSString stringWithFormat:@"%@",str_Status]];
    [lbl_Distance setText:[NSString stringWithFormat:@"%@Km",[array_Distance objectAtIndex:indexPath.row]]];
    [description1 setText:[[array_Search objectAtIndex:indexPath.row]valueForKey:@"Description"]];
    
    if (distance<1000)
        [lbl_Distance setText:[NSString stringWithFormat:@"%dm",[[array_Distance objectAtIndex:indexPath.row] intValue]]];
    else
        [lbl_Distance setText:[NSString stringWithFormat:@"%.2fKm",[[array_Distance objectAtIndex:indexPath.row] floatValue]/1000]];
    
    return cell;
    
}

- (void)likeBtnClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    if ([[favoriteArray objectAtIndex:btn.tag] boolValue]) {
        [favoriteArray insertObject:[NSNumber numberWithBool:NO] atIndex:btn.tag];
        [btn setImage:[UIImage imageNamed:@"likeIconF.png"] forState:UIControlStateNormal];
        
        for (int i = 0; i < favoritePlaces.count; i++) {
            NSString *cafeName = [[array_Search objectAtIndex:btn.tag] objectForKey:@"Name"];
            if ([[[favoritePlaces objectAtIndex:i] objectForKey:@"CafeName"] isEqualToString:cafeName]) {
                PFObject *unFav = [favoritePlaces objectAtIndex:i];
                [unFav deleteInBackground];
                break;
            }
        }
    }
    else{
        [favoriteArray insertObject:[NSNumber numberWithBool:YES] atIndex:btn.tag];
        [btn setImage:[UIImage imageNamed:@"likeIconT.png"] forState:UIControlStateNormal];
        
        PFObject *fav = [PFObject objectWithClassName:@"FavoritePlaces"];
        [fav setObject:[[array_Search objectAtIndex:btn.tag] objectForKey:@"Name"] forKey:@"CafeName"];
        [fav setObject:[[array_Search objectAtIndex:btn.tag] objectForKey:@"CityOfPlace"] forKey:@"CafeCity"];
        [fav setObject:[[PFUser currentUser] username] forKey:@"user"];
        [fav setObject:[[array_Search objectAtIndex:btn.tag] objectForKey:@"PlaceLogo"] forKey:@"CafeLogo"];
        
        if (![PFUser currentUser])
            [[PFUser currentUser] fetch];
        [fav saveInBackground];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Height of the rows
    return 200;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MapDetailVC *vc =[MapDetailVC new];
    vc.str_Place=[[array_Search objectAtIndex:indexPath.row]valueForKey:@"Name"];
    vc.str_Description =[[array_Search objectAtIndex:indexPath.row]valueForKey:@"Description"];
    vc.str_PlaceAddress=[[array_Search objectAtIndex:indexPath.row]valueForKey:@"address"];
    
    NSString *strDistance;
    int distance =[[array_Distance objectAtIndex:indexPath.row] intValue];
    if (distance<1000)
        strDistance = [NSString stringWithFormat:@"%dm",[[array_Distance objectAtIndex:indexPath.row] intValue]];
    else
        strDistance = [NSString stringWithFormat:@"%.2fKm",[[array_Distance objectAtIndex:indexPath.row] floatValue]/1000];
    
    vc.str_Distance = strDistance;
    
    PFFile *a1 = [[array_Search objectAtIndex:indexPath.row]valueForKey:@"backgroundFile"];
    NSURL *url = [NSURL URLWithString:a1.url];
    
    vc.str_PlaceImage=[url absoluteString];
    vc.str_OpeningHours=[[array_Search objectAtIndex:indexPath.row]valueForKey:@"openingTime"];
    vc.str_ClosingHours=[[array_Search objectAtIndex:indexPath.row]valueForKey:@"closingTime"];
    vc.str_Status=[array_Status objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    delegate.str_OpenTime=[[array_Search objectAtIndex:indexPath.row]valueForKey:@"openingTime"];
    delegate.str_CloseTime=[[array_Search objectAtIndex:indexPath.row]valueForKey:@"closingTime"];
    delegate.str_Place=[[array_Search objectAtIndex:indexPath.row]valueForKey:@"Name"];
    delegate.str_Description =[[array_Search objectAtIndex:indexPath.row]valueForKey:@"Description"];
    delegate.str_PlaceCity=[[array_Search objectAtIndex:indexPath.row]valueForKey:@"CityOfPlace"];
    delegate.str_PlaceLogo=[[array_Search objectAtIndex:indexPath.row]valueForKey:@"PlaceLogo"];
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andText:(NSString*)str{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"Close" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
    CNPPopupButtonItem *buttonItem = [CNPPopupButtonItem defaultButtonItemWithTitle:buttonTitle backgroundColor:UIColorFromRGB(0xEE7031)];
    buttonItem.selectionHandler = ^(CNPPopupButtonItem *item){
        NSLog(@"Block for button: %@", item.buttonTitle.string);
    };
    
    self.popupController = [[CNPPopupController alloc] initWithTitle:title contents:@[lineOne] buttonItems:@[buttonItem] destructiveButtonItem:nil];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    self.popupController.theme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    [self.popupController presentPopupControllerAnimated:YES];
}

#pragma mark - CNPPopupController Delegate

- (void)popupController:(CNPPopupController *)controller didDismissWithButtonTitle:(NSString *)title {
    NSLog(@"Dismissed with button title: %@", title);
}

- (void)popupControllerDidPresent:(CNPPopupController *)controller {
    NSLog(@"Popup controller presented.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
