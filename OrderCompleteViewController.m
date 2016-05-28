//
//  OrderCompleteViewController.m
//  Firsty
//
//  Created by Hyacinthe Hamon on 10/11/2014.
//  Copyright (c) 2015 Kick Labs Co. All rights reserved.
//

#import "OrderCompleteViewController.h"
#import <Parse/Parse.h>
#import "SendGrid.h"
#import "SendGridEmail.h"
#import "AppDelegate.h"
#import "Define.h"
#import "TheSidebarController.h"
#import "Define.h"
#import "GlobalModel.h"
#import "MainViewController.h"
#import "LogInViewController.h"
#import "LeftSidebarViewController.h"
@interface OrderCompleteViewController (){
    NSString *drinkName;
    NSString *drinkSize;
    NSString *drinkType;
    NSString *drinkTime;
    NSString *totalPrice;
    int ordernumber;
    AppDelegate *delegate;
    UILabel *lbl_ThankYou;
    UILabel *lbl_OrderNo;
    UILabel *lbl_OrderNoText;
    UILabel *lbl_Description;
    float totalPrice1;
    NSString *priceValue;
    UIScrollView * scroll;
      NSMutableArray * arr;

}
@property (nonatomic, strong) NSArray *ordersArray;
@property (nonatomic, strong) UILabel *totalPriceLbl;
@property (nonatomic, strong) UILabel *ProductLbl;

@end

@implementation OrderCompleteViewController
@synthesize  ordersArray,totalPriceLbl,ProductLbl ;

- (void)viewDidLoad {
    
[super viewDidLoad];
    
    arr=[[NSMutableArray alloc]init];
   
    //Uses Sendgrid to send the receipt by email
    self.view.backgroundColor = [UIColor whiteColor];
    delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    [self queryParseMethod];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    drinkName   =   [defaults valueForKey:@"drinkName"];
    drinkSize   =   [defaults valueForKey:@"drinkSize"];
    drinkType   =   [defaults valueForKey:@"drinkType"];
    drinkTime   =   [defaults valueForKey:@"drinkTime"];
    totalPrice  =   [defaults valueForKey:@"totalPrice"];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(goToHome:)];
    [self.navigationItem setRightBarButtonItem:item animated:NO];
    
    
    UIImageView * imageview_TopBar = [[UIImageView alloc] init];
    imageview_TopBar.frame=CGRectMake(0, 0,Width, 70);
    [imageview_TopBar setUserInteractionEnabled:YES];
    [imageview_TopBar setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:imageview_TopBar];
    
    ProductLbl = [[UILabel alloc]init];
    
    ProductLbl.font = [UIFont systemFontOfSize:18];
    ProductLbl.textAlignment = NSTextAlignmentCenter;
    ProductLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:ProductLbl];
    
    UIButton *list_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 3, self.view.frame.origin.y + 20, 50, 50)];
    [list_btn setImage:[UIImage imageNamed:@"BtnCrossLogin"] forState:UIControlStateNormal];
    [list_btn addTarget:self action:@selector(listBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    list_btn.alpha = 1.0;
    list_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:list_btn];
    
    UILabel *lbl_title = [[UILabel alloc]initWithFrame:CGRectMake(Width/2 - 80, 30, 160, 30)];
    lbl_title.backgroundColor = [UIColor clearColor];
    lbl_title.textColor = [UIColor whiteColor];
    lbl_title.font = [UIFont fontWithName:KFontUsed size:18.0];
    lbl_title.text = @"Order";
    lbl_title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl_title];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            
            totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 300,320, 40)];
            NSString *frTotalPrice = [NSString stringWithFormat:@"%0.02f", totalPrice1];
            totalPriceLbl.text = [NSString stringWithFormat:@"TOTAL  $ %@", frTotalPrice];
            totalPriceLbl.font = [UIFont systemFontOfSize:25];
            totalPriceLbl.textAlignment = NSTextAlignmentCenter;
            totalPriceLbl.backgroundColor = [UIColor lightGrayColor];
            totalPriceLbl.textColor = [UIColor whiteColor];
            [self.view addSubview:totalPriceLbl];
                 }
        else  if(result.height == 568)
        {
            totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 320,370, 40)];
            NSString *frTotalPrice = [NSString stringWithFormat:@"%0.02f", totalPrice1];
            totalPriceLbl.text = [NSString stringWithFormat:@"TOTAL  $ %@", frTotalPrice];
            totalPriceLbl.font = [UIFont systemFontOfSize:25];
            totalPriceLbl.textAlignment = NSTextAlignmentCenter;
            totalPriceLbl.backgroundColor = [UIColor lightGrayColor];
            totalPriceLbl.textColor = [UIColor whiteColor];
            [self.view addSubview:totalPriceLbl];
                }
      else  if(result.height == 667)
        {
            totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 350,370, 40)];
            NSString *frTotalPrice = [NSString stringWithFormat:@"%0.02f", totalPrice1];
            totalPriceLbl.text = [NSString stringWithFormat:@"TOTAL  $ %@", frTotalPrice];
            totalPriceLbl.font = [UIFont systemFontOfSize:25];
            totalPriceLbl.textAlignment = NSTextAlignmentCenter;
            totalPriceLbl.backgroundColor = [UIColor lightGrayColor];
            totalPriceLbl.textColor = [UIColor whiteColor];
            [self.view addSubview:totalPriceLbl];
        
        }
        else
        {
            totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 370,414, 40)];
            NSString *frTotalPrice = [NSString stringWithFormat:@"%0.02f", totalPrice1];
            totalPriceLbl.text = [NSString stringWithFormat:@"TOTAL  $ %@", frTotalPrice];
            totalPriceLbl.font = [UIFont systemFontOfSize:25];
            totalPriceLbl.textAlignment = NSTextAlignmentCenter;
            totalPriceLbl.backgroundColor = [UIColor lightGrayColor];
            totalPriceLbl.textColor = [UIColor whiteColor];
            [self.view addSubview:totalPriceLbl];
            
        }
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 350,768, 40)];
        NSString *frTotalPrice = [NSString stringWithFormat:@"%0.02f", totalPrice1];
        totalPriceLbl.text = [NSString stringWithFormat:@"TOTAL  $ %@", frTotalPrice];
        totalPriceLbl.font = [UIFont systemFontOfSize:25];
        totalPriceLbl.textAlignment = NSTextAlignmentCenter;
        totalPriceLbl.backgroundColor = [UIColor lightGrayColor];
        totalPriceLbl.textColor = [UIColor whiteColor];
        [self.view addSubview:totalPriceLbl];

    
    }
    
    UIButton* btn_End =[UIButton buttonWithType:UIButtonTypeCustom];
    btn_End.frame=CGRectMake(Width-60,20,40,40);
    [btn_End setBackgroundColor:[UIColor clearColor]];
    [[btn_End layer] setCornerRadius:0.0f];
    [btn_End setImage:[UIImage imageNamed:@"BtnCrossLogin@2x.png"] forState:UIControlStateNormal];
    [btn_End addTarget:self action:@selector(btn_EndClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_End];
    
    UIImageView *img_Order;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            img_Order = [[UIImageView alloc]initWithFrame:CGRectMake(0,138,Width-10, 150)];
        }
        else     if(result.height == 568)
        {
            img_Order = [[UIImageView alloc]initWithFrame:CGRectMake(0, 145,Width-20, 170)];
        }
        else
        {
        img_Order = [[UIImageView alloc]initWithFrame:CGRectMake(0, (Width/2.5),Width-20, 190)];
        }
    }
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
     {
       img_Order = [[UIImageView alloc]initWithFrame:CGRectMake(0, 140,Width-20, 190)];
     
     }
    
    lbl_ThankYou=[[UILabel alloc]init];
    lbl_ThankYou.frame=CGRectMake(5,90,Width-10,20);
    lbl_ThankYou.backgroundColor=[UIColor clearColor];
    [lbl_ThankYou setTextColor:[UIColor grayColor]];
    [lbl_ThankYou setText:@"Thank You for your order!"];
    lbl_ThankYou.textAlignment=NSTextAlignmentCenter;
    [lbl_ThankYou setFont:[UIFont fontWithName:KFontUsed size:20.0]];
    [self.view addSubview:lbl_ThankYou];
    
    
    lbl_OrderNoText=[[UILabel alloc]init];
    lbl_OrderNoText.frame=CGRectMake(5,120,Width-10,20);
    lbl_OrderNoText.backgroundColor=[UIColor clearColor];
    [lbl_OrderNoText setTextColor:[UIColor grayColor]];
    [lbl_OrderNoText setText:@"Your Order No is :"];
    lbl_OrderNoText.textAlignment=NSTextAlignmentCenter;
    [lbl_OrderNoText setFont:[UIFont fontWithName:KFontUsed size:15.0]];
    [self.view addSubview:lbl_OrderNoText];
    
    [img_Order setContentMode:UIViewContentModeScaleAspectFit];
    img_Order.clipsToBounds = YES;
    img_Order.image=[UIImage imageNamed:@"orderBtn"];
    [self.view addSubview:img_Order];
    
    
    lbl_OrderNo=[[UILabel alloc]init];
    lbl_OrderNo.frame=CGRectMake(0,(img_Order.frame.size.height/2)-30,img_Order.frame.size.width,55);
    lbl_OrderNo.backgroundColor=[UIColor clearColor];
    [lbl_OrderNo setTextColor:[UIColor whiteColor]];
   
    NSLog(@"TotalPay----%@",self.orderValue);
    
    lbl_OrderNo.text = self.orderValue;
    lbl_OrderNo.textAlignment=NSTextAlignmentCenter;
    [lbl_OrderNo setFont:[UIFont boldSystemFontOfSize:30]];
      [img_Order addSubview:lbl_OrderNo];
    
    
    lbl_Description=[[UILabel alloc]init];
    lbl_Description.frame=CGRectMake(5,420,Width-10,100);
    lbl_Description.backgroundColor=[UIColor clearColor];
    [lbl_Description setTextColor:[UIColor grayColor]];
    [lbl_Description setText:delegate.str_Place];
    lbl_Description.textAlignment=NSTextAlignmentCenter;
    lbl_Description.lineBreakMode = NSLineBreakByWordWrapping;
    lbl_Description.numberOfLines = 0;
    [lbl_Description setFont:[UIFont fontWithName:KFontUsed size:20.0]];
    [self.view addSubview:lbl_Description];
    
    
}

- (void)listBtnClicked
{
    
    MainViewController *step_view = [[MainViewController alloc] init];
    step_view.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:step_view animated:YES completion:nil];
   }
-(void)btn_EndClicked{
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFromTop;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:NO];
    
}

- (void)queryParseMethod {
    
    //fetch products
    if ([PFUser currentUser] == nil)
    {
        LogInViewController *signup_view = [[LogInViewController alloc] init];
        signup_view.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:signup_view animated:YES completion:nil];
            }
    else
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Order"];
        
  [query whereKey:@"ordernumber" equalTo:self.orderValue];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (!error) {
                 if (objects.count == 0)
                 {
                     
                 }
                 else{
                     
                     imageFilesArray = [NSMutableArray arrayWithArray:objects];
                     
                     NSLog(@"image------%@",imageFilesArray);
                    [self customScroll];
                     totalPrice1 = 0;
                     for (int index = 0; index < objects.count; index++)
                     {
                         totalPrice1 = totalPrice1 + [[[objects objectAtIndex:index] objectForKey:@"totalPrice"] floatValue];
                         PFQuery *query = [PFQuery queryWithClassName:@"Order"];
                         
                         [query getObjectInBackgroundWithId:[[objects objectAtIndex:index] objectForKey:@"objectId"]                                                       block:^(PFObject *object, NSError *error) {

                             object[@"isArchived"] = @"True";
                             [object saveInBackground];
                             
                         }];
                     }
                     
                     NSString *fmtStr = [NSString stringWithFormat:@"%0.02F", totalPrice1];
                     totalPriceLbl.text = [NSString stringWithFormat:@"TOTAL  $ %@", fmtStr];
                     priceValue = [NSString stringWithFormat:@"%@", fmtStr];
                     
                 }
             }
             
         }];
    }
}

-(void)goToNext:(NSString*)time{
    
    // Creates PFObject with order information
    PFObject *order = [PFObject objectWithClassName:@"Order"];
    [order setObject: drinkName forKey:@"product"];
    [order setObject: drinkSize forKey:@"size"];
    [order setObject: drinkType forKey:@"milkType"];
    [order setObject: time forKey:@"time"];
    [order setObject: totalPrice forKey:@"totalPrice"];
    [order setObject: delegate.str_Place forKey:@"CafeName"];
    [order setObject: delegate.str_PlaceLogo forKey:@"CafeLogo"];
    
    if(![PFUser currentUser])
        [[PFUser currentUser] fetch];
    
    [order setObject:[PFUser currentUser].username forKey:@"user"];
    [order setObject:[NSString stringWithFormat:@"%d",ordernumber] forKey:@"ordernumber"];
    
    // Uploads order to Parse
    [order saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            lbl_OrderNo.text =  [NSString stringWithFormat:@"%d",ordernumber];
            
            if(![[PFUser currentUser]email]){
                lbl_Description.text=@"Your order has been sent and is in preparation. We couldn't send receipt because you have not linked your email address with your account. Have a nice day!";
            }
            else{
                lbl_Description.text=@"Your order has been sent and is in preparation. The receipt has been sent to your email address. Have a nice day!";
                
                SendGrid *sendgrid = [SendGrid apiUser:@"kicklabs" apiKey:@"Katoomba1"];
                SendGridEmail *email = [[SendGridEmail alloc] init];
                email.to = [[PFUser currentUser]email];
                email.from = @"hello@getfirsty.com";
                email.subject = @"Your Firsty receipt";
                email.inlinePhoto = true;
                email.html =   [NSString stringWithFormat:@"<p><span></span></p><p>%@</span></p><img src =\"cid:annotation.png\"> %@ <p><span style=\"font-family: 'Helvetica', times;\">Order No: # %@</p><p>Drink: %@</p><p>Size: %@</p><p>Milk: %@</p><p>Time: %@</p><p><h4>TOTAL: %@</h4></p>",@"<h1>Your Firsty receipt</h1>",delegate.str_Place,lbl_OrderNo.text,drinkName,drinkSize,drinkType,drinkTime,[NSString stringWithFormat:@"$ %@",totalPrice]];
                email.text = @"Here is your receipt. Thank you for ordering with Firsty. Enjoy your drink!";
                
                NSURL *imageURL = [NSURL URLWithString:delegate.str_PlaceLogo.url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:imageData];
                
                [email attachImage:image];
                
                [sendgrid sendWithWeb:email];
                
            }
            
            
        } else {
            
            lbl_OrderNo.text =  @"Order not processed";
            lbl_Description.text=@"Sorry ! Due to some technical reason we can't process your order.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"The connection appears to be offline. Please Connect and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
}

-(void)customScroll
{
    UIImageView * image ;
    UIImageView *shadowImageView ;
    UIImageView *imageView_Item;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 350, 375, 150)];
            scroll.contentSize = CGSizeMake(225*imageFilesArray.count, 100);
        }
        else if(result.height == 568)
        {
            
            scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 360, 375, 200)];
            scroll.contentSize = CGSizeMake(225*imageFilesArray.count, 150);
            
        }

      else if(result.height == 667)
        {  scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 420, 375, 220)];
            scroll.contentSize = CGSizeMake(210*imageFilesArray.count, 200);
        }
        else
        {  scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 450, 412, 220)];
            scroll.contentSize = CGSizeMake(210*imageFilesArray.count, 200);
        }

    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 550, 768, 220)];
        scroll.contentSize = CGSizeMake(210*imageFilesArray.count, 200);

    
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
            
            UILabel *lbl_title = [[UILabel alloc]initWithFrame:CGRectMake(x, imageView_Item.frame.size.height , shadowImageView.frame.size.width, 30)];
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
            
            x+=210;
            

        }
         if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         {
             shadowImageView = [[UIImageView alloc] init];
             shadowImageView.contentMode = UIViewContentModeCenter;
             shadowImageView.frame = CGRectMake(x, 10, 200.0f, 200.0f);
             [scroll addSubview:shadowImageView];
             
             image = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, 200.0f, 200.0f)];
             image.image = [UIImage imageNamed:@"page.png"];
             image.contentMode = UIViewContentModeCenter;
             [scroll addSubview:image];
             
             imageView_Item=[[UIImageView alloc] initWithFrame:CGRectMake(x+10, 10, 180, 170)];
             [imageView_Item setBackgroundColor:[UIColor clearColor]];
             [imageView_Item setContentMode:UIViewContentModeScaleAspectFill];
             [imageView_Item setClipsToBounds:YES];
             [imageView_Item setUserInteractionEnabled:YES];
             [scroll addSubview:imageView_Item];
             
            
             
             

             UILabel *lbl_title = [[UILabel alloc]initWithFrame:CGRectMake(x, imageView_Item.frame.size.height , shadowImageView.frame.size.width, 30)];
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
             
             x+=210;
             

         }
           }
}
-(IBAction)goToHome:(id)sender{
    
    delegate.finish=YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
