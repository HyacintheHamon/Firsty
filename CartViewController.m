//
//  CartViewController.m
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "CartViewController.h"

#import "Define.h"
#import "TheSidebarController.h"
#import "ProductViewController.h"
#import "ImageCell.h"
#import "GlobalModel.h"
#import "AppDelegate.h"

#import "OrderCompleteViewController.h"
#import "AFNetworking.h"

#import "Constants.h"
#import "LogInViewController.h"
#import "PayViewController.h"

#define TAG_NoInternet @"Internet Connection is required."

@interface CartViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDataSource, UIPickerViewDelegate, PKPaymentAuthorizationViewControllerDelegate, PKPaymentAuthorizationViewControllerDelegate>
{
    UICollectionView *_collectionView;
    NSArray *drinks;
    AppDelegate *delegate;
    
    UILabel *lbl_PaymentType;
    
    UIPickerView *sizePicker;
    UIPickerView *timePicker;
    NSMutableArray *timeArray;
    NSMutableArray *sizeArray;
    NSMutableArray *milkArray;
    
    NSString *sizeType;
    NSString *timeType;
    
    float totalPrice;
    
    UILabel *timeLbl;
    UIButton *btn_Order;
    
    UIScrollView * scroll;
    NSString *orderNumber;
      NSInteger tagValue;
    NSString * priceValue;
    int randomNumber;
    int random1;
      NSString *objectNumber;
    
    NSMutableArray * arr;
   
}

@property (nonatomic, strong) NSMutableArray *items;


@property (nonatomic, strong) NSTimer *workTimer;
@property (nonatomic,retain)  UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *refreshLoadingView;
@property (nonatomic, strong) UIView *refreshColorView;
@property (nonatomic, strong) UIImageView *compass_background;
@property (nonatomic, strong) UIImageView *compass_spinner;
@property (assign) BOOL       isRefreshIconsOverlap;
@property (assign) BOOL       isRefreshAnimating;

@property (nonatomic, strong) UILabel *totalPriceLbl;
@property (nonatomic, strong) UILabel *ProductLbl;

@property (nonatomic, strong) NSString *clientToken;
@property (nonatomic, strong) Braintree *braintree;
@property (nonatomic, strong) BTPaymentButton *button;
@property (nonatomic, strong) BTPayPalPaymentMethod *applePayPaymentMethod;
@property (nonatomic, copy)   void (^completionBlock)(NSString *nonce);
@property (nonatomic, strong) NSMutableArray *array_Data;
@property (nonatomic, strong) NSMutableArray *array_Order;
@property (nonatomic, strong) UITableView *tableForMainSetting;

@property (nonatomic, strong) UILabel *lbl_noRows;
@property (nonatomic, strong) UIImageView *holdPhoto;

@end

@implementation CartViewController
@synthesize customView;
@synthesize totalPriceLbl;
@synthesize  clientToken;
@synthesize lbl_noRows;
@synthesize holdPhoto;
@synthesize ProductLbl;
- (instancetype)initWithBraintree:(Braintree *)braintree completion:(void (^)(NSString *nonce))completion {
    self = [super init];
    if (self) {
        self.braintree = braintree;
        self.completionBlock = completion;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    timeType=@"ASAP!";
    arr = [[NSMutableArray alloc]init];
    
    if([imageFilesArray count]  == 0){
        
        lbl_noRows.hidden = NO;
        holdPhoto.hidden = NO;
    }
    else {
        lbl_noRows.hidden = YES;
        holdPhoto.hidden = YES;
    }
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:backgroundView];
    
    imageFilesArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 70)];
    [barImageView setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:barImageView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 80, 30, 160, 30)];
    titleLbl.text = @"Cart";
    titleLbl.font = [UIFont systemFontOfSize:18];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLbl];
    
    UIButton *list_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 3, self.view.frame.origin.y + 30, 30, 30)];
    [list_btn setImage:[UIImage imageNamed:@"MenuIcon.png"] forState:UIControlStateNormal];
    [list_btn addTarget:self action:@selector(listBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [list_btn setTintColor:[UIColor lightGrayColor]];
    list_btn.alpha = 1.0;
    list_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:list_btn];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, scroll.frame.origin.y+scroll.frame.size.height+230, Width-0, 40)];
            timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(5, timeLbl.frame.origin.y+timeLbl.frame.size.height-30, Width-10, 80)];
            totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, timePicker.frame.origin.y+timePicker.frame.size.height-20, Width-0, 40)];

        }
        else  if(result.height == 568)
        {
            timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, scroll.frame.origin.y+scroll.frame.size.height+273, Width-0, 40)];
            timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(5, timeLbl.frame.origin.y+timeLbl.frame.size.height-15, Width-10, 80)];
            totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, timePicker.frame.origin.y+timePicker.frame.size.height+15, Width-0, 40)];
            

        }
        
        
        else
        {
            timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, scroll.frame.origin.y+scroll.frame.size.height+290, Width-0, 40)];
            timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(5, timeLbl.frame.origin.y+timeLbl.frame.size.height, Width-10, 80)];
            totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, timePicker.frame.origin.y+timePicker.frame.size.height+20, Width-0, 40)];


        }
    }
    
    else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, scroll.frame.origin.y+scroll.frame.size.height+290, Width-0, 40)];
        timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(5, timeLbl.frame.origin.y+timeLbl.frame.size.height, Width-10, 80)];
        totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, timePicker.frame.origin.y+timePicker.frame.size.height+20, Width-0, 40)];
    }
    
    
    timeLbl.text = @"Time";
    timeLbl.backgroundColor = UIColorFromRGB(0xEE7031);
    timeLbl.font = [UIFont systemFontOfSize:18];
    timeLbl.textAlignment = NSTextAlignmentCenter;
    timeLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:timeLbl];
    
    timeArray = [NSMutableArray arrayWithObjects:@"ASAP!", @"5 min", @"10 min", @"30 min", nil];
    
    timePicker.delegate = self;
    timePicker.dataSource = self;
    timePicker.backgroundColor = [UIColor clearColor];
    [self.view addSubview:timePicker];
    
       NSString *frTotalPrice = [NSString stringWithFormat:@"%0.02f", totalPrice];
    totalPriceLbl.text = [NSString stringWithFormat:@"TOTAL  $ %@", frTotalPrice];
    totalPriceLbl.font = [UIFont systemFontOfSize:25];
    totalPriceLbl.textAlignment = NSTextAlignmentCenter;
    totalPriceLbl.backgroundColor = [UIColor lightGrayColor];
    totalPriceLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:totalPriceLbl];
    
    ProductLbl.hidden=YES;
    ProductLbl = [[UILabel alloc]init];
    
    
    ProductLbl.font = [UIFont systemFontOfSize:18];
    ProductLbl.textAlignment = NSTextAlignmentCenter;
    ProductLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:ProductLbl];
    
    btn_Order =[UIButton buttonWithType:UIButtonTypeCustom];
    btn_Order.frame=CGRectMake(0,Height-50,Width,50);
    [btn_Order setTitle:@"Order Now" forState:UIControlStateNormal];
    [btn_Order.titleLabel setFont:[UIFont fontWithName:KFontUsed size:14.0]];
    [btn_Order setTitleColor:[UIColor whiteColor ] forState:UIControlStateNormal];
    [btn_Order setTitleColor:[UIColor whiteColor ] forState:UIControlStateHighlighted];
    [btn_Order setBackgroundColor:UIColorFromRGB(0xEE7031)];
    btn_Order.layer.borderColor =[[UIColor grayColor] CGColor];
     [btn_Order addTarget:self action:@selector(paypalBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Order];
    
    /********  Picker View  ********/
    totalPriceLbl.hidden = TRUE;
    timeLbl.hidden = TRUE;
    timePicker.hidden = TRUE;
    _collectionView.hidden = TRUE;
    btn_Order.hidden=TRUE;
    
    holdPhoto = [[UIImageView alloc]initWithFrame:CGRectMake((Width/2)-50, 140, 100, 100)];
    [holdPhoto setContentMode:UIViewContentModeScaleAspectFill];
    holdPhoto.clipsToBounds = YES;
    holdPhoto.backgroundColor = [UIColor clearColor];
    holdPhoto.image = [UIImage imageNamed:@"cart"];
    [self.view addSubview:holdPhoto];
    holdPhoto.hidden =NO;
    
    lbl_noRows=[[UILabel alloc]init];
    lbl_noRows.frame=CGRectMake(0,250,Width,20);
    lbl_noRows.backgroundColor=[UIColor clearColor];
    [lbl_noRows setTextColor:[UIColor grayColor]];
    [lbl_noRows setText:@"You don't have any items in Cart."];
    lbl_noRows.textAlignment=NSTextAlignmentCenter;
    [lbl_noRows setFont:[UIFont fontWithName:KFontUsed size:20.0]];
    [self.view addSubview:lbl_noRows];
    lbl_noRows.hidden = NO;
    
    [self setupRefreshControl];
    
    if ([PFUser currentUser] == nil) {
    }
    else{
        if (![PKPaymentAuthorizationViewController class]) {
            
            UIAlertView *applePayAlertView = [[UIAlertView alloc] initWithTitle:@"ApplePay Error"
                                                                        message:@"ApplePay is not available with this version of IOS"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles: nil];
            
            [applePayAlertView show];
            
        }
        else{
            
        }
    }
}

-(void)customScroll
{
    UIImageView * image ;
    UIImageView *shadowImageView ;
    UIImageView *imageView_Item;
    holdPhoto.hidden =YES;
    lbl_noRows.hidden = YES;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 72, 375, 150)];
            scroll.contentSize = CGSizeMake(225*imageFilesArray.count, 100);
        }
        else if(result.height == 568)
        {
        
            scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 72, 375, 200)];
            scroll.contentSize = CGSizeMake(225*imageFilesArray.count, 150);
        
        }
        
            else if(result.height == 667)
                
        {   scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 72, 375, 220)];
            scroll.contentSize = CGSizeMake(220*imageFilesArray.count, 200);
        }
        
        else
        
            {   scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 72, 412, 220)];
                scroll.contentSize = CGSizeMake(220*imageFilesArray.count, 200);
            }
        
    }
    
       else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
       {
           scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 72, 768, 220)];
           scroll.contentSize = CGSizeMake(220*imageFilesArray.count, 200);
       }
    
    
    [self.view addSubview:scroll];
    int x=0;
   
    for(int i=0; i<[imageFilesArray count];i++)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
       image = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, 200.0f, 150.0f)];
        image.image = [UIImage imageNamed:@"page.png"];
        image.contentMode = UIViewContentModeCenter;
        [scroll addSubview:image];
        }
        else
        {
             image = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, 200.0f, 200.0f)];
            image.image = [UIImage imageNamed:@"page.png"];
            image.contentMode = UIViewContentModeCenter;
            [scroll addSubview:image];
        }
        }
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
                shadowImageView = [[UIImageView alloc] init];
                shadowImageView.contentMode = UIViewContentModeCenter;
                shadowImageView.frame = CGRectMake(x, 10, 200.0f, 150.0f);
                [scroll addSubview:shadowImageView];
            }
            else
            {
               shadowImageView = [[UIImageView alloc] init];
                shadowImageView.contentMode = UIViewContentModeCenter;
                shadowImageView.frame = CGRectMake(x, 10, 200.0f, 200.0f);
                [scroll addSubview:shadowImageView];
            }
        }
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            if(result.height == 480)
            {
               imageView_Item=[[UIImageView alloc] initWithFrame:CGRectMake(x+10, 10, 180, 100)];
                [imageView_Item setBackgroundColor:[UIColor clearColor]];
                [imageView_Item setContentMode:UIViewContentModeScaleAspectFill];
                [imageView_Item setClipsToBounds:YES];
                [imageView_Item setUserInteractionEnabled:YES];
                [scroll addSubview:imageView_Item];            }
            else
            {
                imageView_Item=[[UIImageView alloc] initWithFrame:CGRectMake(x+10, 10, 180, 170)];
                [imageView_Item setBackgroundColor:[UIColor clearColor]];
                [imageView_Item setContentMode:UIViewContentModeScaleAspectFill];
                [imageView_Item setClipsToBounds:YES];
                [imageView_Item setUserInteractionEnabled:YES];
                [scroll addSubview:imageView_Item];
            }
        }
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            
            image = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, 200.0f, 200.0f)];
            image.image = [UIImage imageNamed:@"page.png"];
            image.contentMode = UIViewContentModeCenter;
            [scroll addSubview:image];
            
            shadowImageView = [[UIImageView alloc] init];
            shadowImageView.contentMode = UIViewContentModeCenter;
            shadowImageView.frame = CGRectMake(x, 10, 200.0f, 200.0f);
            [scroll addSubview:shadowImageView];
            
            imageView_Item=[[UIImageView alloc] initWithFrame:CGRectMake(x+10, 10, 180, 170)];
            [imageView_Item setBackgroundColor:[UIColor clearColor]];
            [imageView_Item setContentMode:UIViewContentModeScaleAspectFill];
            [imageView_Item setClipsToBounds:YES];
            [imageView_Item setUserInteractionEnabled:YES];
            [scroll addSubview:imageView_Item];
        }
        

        UILabel *lbl_title = [[UILabel alloc]initWithFrame:CGRectMake(x, imageView_Item.frame.size.height-30 , shadowImageView.frame.size.width, 30)];
        [lbl_title setTextColor:[UIColor blackColor]];
        [lbl_title setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.5]];
        [lbl_title setFont:[UIFont systemFontOfSize:17.0]];
        [lbl_title setTextAlignment:NSTextAlignmentLeft];
        [scroll addSubview:lbl_title];
        
        
        UILabel *lbl_price = [[UILabel alloc]initWithFrame:CGRectMake(x+image.frame.size.width - 50, lbl_title.frame.origin.y , 50, 30)];
        [lbl_price setTextColor:[UIColor blackColor]];
        [lbl_price setBackgroundColor:[UIColor clearColor]];
        [lbl_price setFont:[UIFont boldSystemFontOfSize:14.0]];
        [lbl_price setTextAlignment:NSTextAlignmentLeft];
        [scroll addSubview:lbl_price];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(x+shadowImageView.frame.size.width-60, shadowImageView.frame.size.height - 24, 36, 20)];
        deleteBtn.tag = i;
        
        [deleteBtn setBackgroundColor:[UIColor orangeColor]];
        [deleteBtn setTitle:@"Delete" forState:UIControlStateNormal];
        deleteBtn.layer.cornerRadius = 3;
        deleteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        deleteBtn.layer.borderWidth = 1;
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTintColor:[UIColor lightGrayColor]];
        deleteBtn.alpha = 1.0;
        deleteBtn.transform = CGAffineTransformMakeTranslation(10, 0);
        [scroll addSubview:deleteBtn];
        
        NSLog(@"imageArray--------%@", imageFilesArray);
        PFObject *imageObject = [imageFilesArray objectAtIndex:i];
        
        [arr addObject:imageObject];
        
        NSLog(@"arr--------%@",[arr objectAtIndex:0]);
        
        PFFile *imageFile = [imageObject objectForKey:@"productImage"];
        
        ProductLbl.text=[[imageFilesArray objectAtIndex:i] objectForKey:@"product"];
        
        lbl_title.text = [[imageFilesArray objectAtIndex:i] objectForKey:@"product"];
        lbl_price.text = [NSString stringWithFormat:@"$%@", [[imageFilesArray objectAtIndex:i] objectForKey:@"totalPrice"]];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                imageView_Item.image = [UIImage imageWithData:data];
            }
        }];
        
        x+=220;
        
    }
      }

- (void)presentError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
   [message show];
}

- (void)paymentSucceeded {
    [[[UIAlertView alloc] initWithTitle:@"Success!"
                                message:@"Payment successfully created!"
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)countTotalPrice{
    totalPrice = 0;
    for (int index = 0; index < imageFilesArray.count; index++) {
        totalPrice = totalPrice + [[[imageFilesArray objectAtIndex:index] objectForKey:@"totalPrice"] floatValue];
    }
    
    NSString *fmtStr = [NSString stringWithFormat:@"%0.2F",totalPrice];
   totalPriceLbl.text = [NSString stringWithFormat:@"TOTAL  $ %@", fmtStr];
    
    priceValue = [NSString stringWithFormat:@"%@", fmtStr];
    
    NSLog(@"dollor------%@", totalPriceLbl.text);
    
    }


#pragma mark - Private method implementation

- (NSArray *)supportedNetworks {
    return @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
}

- (void)paypalBtnClicked
{

    randomNumber=arc4random()%9999999;
    orderNumber=[[NSString alloc]initWithFormat:@"%d",randomNumber];
    
    for(int i =0 ; i<[imageFilesArray count];i++)
    {
        
         PFObject *fav = [PFObject objectWithClassName:@"Order"];

        [fav setObject: orderNumber forKey:@"ordernumber"];
        [fav setObject: timeType forKey:@"time"];
       [fav setObject: @"false" forKey:@"isArchived"];
        
        [fav setObject: [[imageFilesArray objectAtIndex:i]valueForKey:@"size"] forKey:@"size"];
     
        [fav setObject: [[imageFilesArray objectAtIndex:i]valueForKey:@"CafeName"] forKey:@"CafeName"];
        [fav setObject: [[imageFilesArray objectAtIndex:i]valueForKey:@"CafeCity"] forKey:@"CafeCity"];
        [fav setObject: [[imageFilesArray objectAtIndex:i]valueForKey:@"CafeLogo"] forKey:@"CafeLogo"];
        [fav setObject: [[imageFilesArray objectAtIndex:i]valueForKey:@"productImage"] forKey:@"productImage"];
              [fav setObject: [[imageFilesArray objectAtIndex:i]valueForKey:@"product"] forKey:@"product"];
        [fav setObject: [[imageFilesArray objectAtIndex:i]valueForKey:@"totalPrice"] forKey:@"totalPrice"];
      
        if (![PFUser currentUser])
            [[PFUser currentUser] fetch];
        [fav setObject:[PFUser currentUser].username forKey:@"user"];
     
        [fav saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (!error)
             {
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                 {
                     payView = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
                     payView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                     payView.paymentValue =   priceValue;
                     payView.orderValue  =orderNumber;
                     [self presentViewController:payView animated:YES completion:nil];

                 }
                 
                 else
                 {
                 payView = [[PayViewController alloc]initWithNibName:@"PayViewControllerIpad" bundle:nil];
                 payView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                 payView.paymentValue =   priceValue;
                 payView.orderValue  =orderNumber;
                 [self presentViewController:payView animated:YES completion:nil];
                 }
                 
                     
                    }
             else
             {
        
             }
             
         }];
        
    }
    
    
    
    
    
    
    
    
 }

#pragma MARK Braintree

- (void)userDidCancelPayment {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Setup the loading view, which will hold the moving graphics
    self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshLoadingView.backgroundColor = [UIColor clearColor];
    
    // Setup the color view, which will display the rainbowed background
    self.refreshColorView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshColorView.backgroundColor = [UIColor clearColor];
    self.refreshColorView.alpha = 0.30;
    
    // Create the graphic image views
    self.compass_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_background.png"]];
    self.compass_spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compass_spinner.png"]];
    
    // Add the graphics to the loading view
    [self.refreshLoadingView addSubview:self.compass_background];
    [self.refreshLoadingView addSubview:self.compass_spinner];
    
    // Clip so the graphics don't stick out
    self.refreshLoadingView.clipsToBounds = YES;
    
    // Hide the original spinner icon
    self.refreshControl.tintColor = [UIColor clearColor];
    
    // Add the loading and colors views to our refresh control
    [self.refreshControl addSubview:self.refreshColorView];
    [self.refreshControl addSubview:self.refreshLoadingView];
    
    // Initalize flags
    self.isRefreshIconsOverlap = NO;
    self.isRefreshAnimating = NO;
    
    // When activated, invoke our refresh function
    [self.refreshControl addTarget:self action:@selector(refreshTriggered) forControlEvents:UIControlEventValueChanged];
    
    [_collectionView addSubview:self.refreshControl];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get the current size of the refresh controller
    CGRect refreshBounds = self.refreshControl.bounds;
    
    // Distance the table has been pulled >= 0
    CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
    
    // Half the width of the table
    CGFloat midX = _collectionView.frame.size.width / 2.0;
    
    // Calculate the width and height of our graphics
    CGFloat compassHeight = self.compass_background.bounds.size.height;
    CGFloat compassHeightHalf = compassHeight / 2.0;
    
    CGFloat compassWidth = self.compass_background.bounds.size.width;
    CGFloat compassWidthHalf = compassWidth / 2.0;
    
    CGFloat spinnerHeight = self.compass_spinner.bounds.size.height;
    CGFloat spinnerHeightHalf = spinnerHeight / 2.0;
    
    CGFloat spinnerWidth = self.compass_spinner.bounds.size.width;
    CGFloat spinnerWidthHalf = spinnerWidth / 2.0;
    
    // Calculate the pull ratio, between 0.0-1.0
    CGFloat pullRatio = MIN( MAX(pullDistance, 0.0), 100.0) / 100.0;
    
    // Set the Y coord of the graphics, based on pull distance
    CGFloat compassY = pullDistance / 2.0 - compassHeightHalf;
    CGFloat spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
    
    // Calculate the X coord of the graphics, adjust based on pull ratio
    CGFloat compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
    CGFloat spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
    
    // When the compass and spinner overlap, keep them together
    if (fabs(compassX - spinnerX) < 1.0) {
        self.isRefreshIconsOverlap = YES;
    }
    
    // If the graphics have overlapped or we are refreshing, keep them together
    if (self.isRefreshIconsOverlap || self.refreshControl.isRefreshing) {
        compassX = midX - compassWidthHalf;
        spinnerX = midX - spinnerWidthHalf;
    }
    
    // Set the graphic's frames
    CGRect compassFrame = self.compass_background.frame;
    compassFrame.origin.x = compassX;
    compassFrame.origin.y = compassY;
    
    CGRect spinnerFrame = self.compass_spinner.frame;
    spinnerFrame.origin.x = spinnerX;
    spinnerFrame.origin.y = spinnerY;
    
    self.compass_background.frame = compassFrame;
    self.compass_spinner.frame = spinnerFrame;
    
    // Set the encompassing view's frames
    refreshBounds.size.height = pullDistance;
    
    self.refreshColorView.frame = refreshBounds;
    self.refreshLoadingView.frame = refreshBounds;
    
    // If we're refreshing and the animation is not playing, then play the animation
    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating) {
        [self animateRefreshView];
    }
}
- (void)animateRefreshView
{
    // Flag that we are animating
    self.isRefreshAnimating = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                         [self.compass_spinner setTransform:CGAffineTransformRotate(self.compass_spinner.transform, M_PI_2)];
                         
                     }
                     completion:^(BOOL finished) {
                         // If still refreshing, keep spinning, else reset
                         if (self.refreshControl.isRefreshing) {
                             [self animateRefreshView];
                         }else{
                             [self resetAnimation];
                         }
                     }];
}


- (void)resetAnimation
{
    // Reset our flags and background color
    self.isRefreshAnimating = NO;
    self.isRefreshIconsOverlap = NO;
    self.refreshColorView.backgroundColor = [UIColor clearColor];
}


- (void)refreshTriggered {
    [self startTodoSomething];
}

- (void)startTodoSomething {
    
    [self.workTimer invalidate];
    
    self.workTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onAllworkDoneTimer) userInfo:nil repeats:NO];
    
    [self queryParseMethod];
    
}

- (void)onAllworkDoneTimer {
    [self.workTimer invalidate];
    self.workTimer = nil;
    
    [self.refreshControl endRefreshing];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)queryParseMethod {
    
    //fetch products
    if ([PFUser currentUser] == nil)
    {
        LogInViewController *signup_view = [[LogInViewController alloc] init];
        signup_view.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:signup_view animated:YES completion:nil];
 
    }
    else{
        [imageFilesArray removeAllObjects];
        PFQuery *query = [PFQuery queryWithClassName:@"Cart"];
        
        [query whereKey:@"user" equalTo:[[PFUser currentUser] username]];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (!error) {
                 if (objects.count == 0)
                 {
                     
                 }
                 else{
                     totalPriceLbl.hidden = FALSE;
                   
                     timeLbl.hidden = FALSE;
                     timePicker.hidden = FALSE;
                     btn_Order.hidden=FALSE;
                     
                     
                     imageFilesArray = [NSMutableArray arrayWithArray:objects];
                     
                     NSLog(@"image------%@",imageFilesArray);
                     
                     [self customScroll];
                    
                     
                     totalPrice = 0;
                     for (int index = 0; index < objects.count; index++) {
                         totalPrice = totalPrice + [[[objects objectAtIndex:index] objectForKey:@"totalPrice"] floatValue];
                     }
                     
                     NSString *fmtStr = [NSString stringWithFormat:@"%0.02F", totalPrice];
                     totalPriceLbl.text = [NSString stringWithFormat:@"TOTAL  $ %@", fmtStr];
                      priceValue = [NSString stringWithFormat:@"%@", fmtStr];
                     
                     
                     if (![[GlobalModel sharedManager] CheckInternetConnectivity]) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"The connection appears to be offline. Please Connect and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                         [alert show];
                         
                     }
                     else{
                         [PFObject pinAllInBackground:objects];
                     }
                 }
             }
             
         }];
    }
}
- (void)cancelBtnClicked{
    [UIView animateWithDuration:0.2 animations:^{
        customView.frame = CGRectMake(25, Height, Width - 50, 200);
    }completion:^(BOOL finished){
        
    }];
}

- (void)doneBtnClicked{
    [UIView animateWithDuration:0.2 animations:^{
        customView.frame = CGRectMake(25, Height, Width - 50, 200);
    }completion:^(BOOL finished){
        
    }];
}

- (void)deleteBtnClicked:(UIButton*)sender
{
    
    if (imageFilesArray.count == 1)
    {
        totalPriceLbl.hidden = TRUE;
               timeLbl.hidden = TRUE;
        timePicker.hidden = TRUE;
        holdPhoto.hidden =NO;
        lbl_noRows.hidden = NO;
        btn_Order.hidden=TRUE;
           }
    
    PFObject *object = [imageFilesArray objectAtIndex:[sender tag]];
    [imageFilesArray removeObjectAtIndex:[sender tag]];
    [self countTotalPrice];
      [object deleteInBackground];
    
    
   
    [scroll removeFromSuperview];
    [self customScroll];

    holdPhoto.hidden =NO;
    lbl_noRows.hidden = NO;
  
}

- (void)addBtnClicked:(id)sender{
    [UIView animateWithDuration:0.4 animations:^{
        customView.frame = CGRectMake(25, 100, Width - 50, 200);
    }completion:^(BOOL finished){
        
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//Picker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;//Or return whatever as you intend
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int size;
    if (pickerView == sizePicker) {
        size = 2;
    }
    else{
        size = 4;
    }
    
    return size;//Or, return as suitable for you...normally we use array for dynamic
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (pickerView == sizePicker) {
        label.text = [sizeArray objectAtIndex:row];
    }
    else{
        label.text = [timeArray objectAtIndex:row];
    }
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == sizePicker) {
        sizeType = [sizeArray objectAtIndex:row];
    }
    else{
        timeType = [timeArray objectAtIndex:row];
    }
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = TRUE;
    
    if ([PFUser currentUser] == nil) {
    }
    else{
        lbl_PaymentType.text=delegate.str_PaymentType;
        [self queryParseMethod];
    }
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
