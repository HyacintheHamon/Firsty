//
//  MainViewController.h
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MainViewController : UIViewController<MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *PlaceInfo;

@end
