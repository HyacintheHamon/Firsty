//
//  CartViewController.h
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Braintree/Braintree.h>
#import <PassKit/PassKit.h>
#import <Stripe/Stripe.h>
#import "AFNetworking.h"
#import "PayViewController.h"
static NSString *MYGlobalVariable;
@protocol STPBackendCharging <NSObject>

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion;

@end
@interface CartViewController : UIViewController <UIPickerViewDelegate, BTDropInViewControllerDelegate ,STPBackendCharging>
{
    NSMutableArray *imageFilesArray;
    NSMutableArray *imagesArray;
    PayViewController *payView;
      NSString *chars;
    }
@property (nonatomic, strong) UIView   *customView;
-(void)generateRandomString:(int) string_length;
@end
