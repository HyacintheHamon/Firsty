//
//  ProductViewController.m
//  Firsty
//
//  Created by iOS on 17/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "ProductViewController.h"
#import "Define.h"
#import "AppDelegate.h"
#import "LogInViewController.h"
#import "CNPPopupController.h"

@interface ProductViewController ()<UIPickerViewDataSource, UIPickerViewDelegate,CNPPopupControllerDelegate>
{
    UIImageView *productImg;
    UILabel     *productName;
    UILabel     *productPlace;
    UILabel     *productPrice;
    BOOL        like;
    UIPickerView *sizePicker;
    NSMutableArray *sizeArray;
    AppDelegate *delegate;
    NSString *sizeType;
    NSInteger tagValue;
}
@property (nonatomic, strong) CNPPopupController *popupController;
@end

@implementation ProductViewController

@synthesize likeBtn, customView,customView1;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];

    sizeType = @"Small";
    
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIImageView * imageview_TopBar = [[UIImageView alloc] init];
    imageview_TopBar.frame=CGRectMake(0, 0,Width, 70);
    [imageview_TopBar setUserInteractionEnabled:YES];
    [imageview_TopBar setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:imageview_TopBar];
    
    UILabel *lbl_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 , Width, 25)];
    lbl_title.backgroundColor = [UIColor clearColor];
    lbl_title.textColor = [UIColor whiteColor];
    lbl_title.font = [UIFont fontWithName:KFontUsed size:18.0];
    lbl_title.text = @"Product Details";
    lbl_title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl_title];
    
    UIButton* btn_Back =[UIButton buttonWithType:UIButtonTypeCustom];
    btn_Back.frame=CGRectMake(5,25,40,40);
    [btn_Back setBackgroundColor:[UIColor clearColor]];
    [[btn_Back layer] setCornerRadius:0.0f];
    [btn_Back setImage:[UIImage imageNamed:@"back_arrow@2x.png"] forState:UIControlStateNormal];
    [btn_Back addTarget:self action:@selector(btn_BackClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Back];
    
    UIImageView *back1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90, Width - 30, (Height-150)/2)];
    back1.backgroundColor = [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0];
    [self.view addSubview:back1];
    
    UIImageView *back2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, back1.frame.origin.y+back1.frame.size.height, Width - 30, (Height-150)/2)];
    back2.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    [self.view addSubview:back2];
    
    productImg = [[UIImageView alloc] initWithFrame:CGRectMake(Width/2 - back1.frame.size.height/2, back1.frame.origin.y, back1.frame.size.height, back1.frame.size.height)];
    PFFile *imageFile = [_product objectForKey:@"imageFile"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            productImg.image = [UIImage imageWithData:data];
        }
    }];
    productImg.backgroundColor = [UIColor clearColor];
    productImg.layer.cornerRadius = 5;
    [self.view addSubview:productImg];
    
    productName = [[UILabel alloc] initWithFrame:CGRectMake(back2.frame.origin.x+20, back2.frame.origin.y+20, 200, 20)];
    productName.text = [_product objectForKey:@"name"];
    productName.font = [UIFont systemFontOfSize:20.0];
    productName.textColor = [UIColor blackColor];
    [self.view addSubview:productName];
    
    productPrice = [[UILabel alloc] initWithFrame:CGRectMake(back2.frame.size.width - 70, productName.frame.origin.y, 80, 20)];
    productPrice.text = [NSString stringWithFormat:@"$%@", [_product objectForKey:@"price"]];
    productPrice.font = [UIFont boldSystemFontOfSize:18.0];
    productPrice.textColor = [UIColor blackColor];
    [self.view addSubview:productPrice];
    
    UILabel *lbl_productDetail = [[UILabel alloc] initWithFrame:CGRectMake(productName.frame.origin.x, productName.frame.origin.y + productName.frame.size.height + 20, Width - 60, 70)];
    lbl_productDetail.text = [_product objectForKey:@"description"];
    lbl_productDetail.font = [UIFont systemFontOfSize:15.0];
    lbl_productDetail.textColor = [UIColor lightGrayColor];
    lbl_productDetail.numberOfLines = 5;
    [self.view addSubview:lbl_productDetail];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(Width/2 - 40, back2.frame.origin.y + back2.frame.size.height - 50, 80, 36)];
    [addBtn setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [addBtn setTitle:@"ADD" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClicked1:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTintColor:[UIColor lightGrayColor]];
    addBtn.alpha = 1.0;
    addBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:addBtn];
    
    if ([PFUser currentUser] == nil) {
        likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(back2.frame.origin.x + 30, addBtn.frame.origin.y+55, 40, 40)];
        [likeBtn setImage:[UIImage imageNamed:@"Heart_nofull.png"] forState:UIControlStateNormal];
        [likeBtn addTarget:self action:@selector(likeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [likeBtn setTintColor:[UIColor lightGrayColor]];
        likeBtn.alpha = 1.0;
        likeBtn.transform = CGAffineTransformMakeTranslation(10, 0);
        [self.view addSubview:likeBtn];
    }
    else{
        PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
        [query whereKey:@"CafeName" equalTo:delegate.str_Place];
        [query whereKey:@"CafeCity" equalTo:delegate.str_PlaceCity];
        [query whereKey:@"product" equalTo:[_product objectForKey:@"name"]];
        [query whereKey:@"user" equalTo:[PFUser currentUser].username];
        
        if ([query findObjects].count == 0){
            like = FALSE;
            likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(back2.frame.origin.x + 30, addBtn.frame.origin.y+55, 40, 40)];
            [likeBtn setImage:[UIImage imageNamed:@"Heart_nofull.png"] forState:UIControlStateNormal];
            [likeBtn addTarget:self action:@selector(likeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [likeBtn setTintColor:[UIColor lightGrayColor]];
            likeBtn.alpha = 1.0;
            likeBtn.transform = CGAffineTransformMakeTranslation(10, 0);
            [self.view addSubview:likeBtn];
        }
        else{
            like = TRUE;
            likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(back2.frame.origin.x + 30, addBtn.frame.origin.y+55, 40, 40)];
            [likeBtn setImage:[UIImage imageNamed:@"Heart_full.png"] forState:UIControlStateNormal];
            [likeBtn addTarget:self action:@selector(likeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [likeBtn setTintColor:[UIColor lightGrayColor]];
            likeBtn.alpha = 1.0;
            likeBtn.transform = CGAffineTransformMakeTranslation(10, 0);
            [self.view addSubview:likeBtn];
        }
    }
    customView1 = [[UIView alloc] initWithFrame:CGRectMake(25, Height, Width - 50, 200)];
    customView1.backgroundColor = [UIColor whiteColor];
    
    UIImageView * customView_topBar1 = [[UIImageView alloc] init];
    customView_topBar1.frame=CGRectMake(0, 0,customView1.frame.size.width, 45);
    [customView_topBar1 setUserInteractionEnabled:YES];
    [customView_topBar1 setBackgroundColor:[UIColor blackColor]];
    customView_topBar1.alpha = 0.8;
    [customView1 addSubview:customView_topBar1];
    
    UIButton *SizeProduct = [[UIButton alloc] initWithFrame:CGRectMake(40,80,60,90)];
    UIImage *buttonImage1 = [UIImage imageNamed:@"icon_cup_29x50.png"];
    [SizeProduct setImage:buttonImage1 forState:UIControlStateNormal];
    [SizeProduct setBackgroundColor:[UIColor clearColor]];
    
    [SizeProduct addTarget:self action:@selector(sizeBtnClicked1:) forControlEvents:UIControlEventTouchUpInside];
    [customView1 addSubview:SizeProduct];
    
    UILabel *small = [[UILabel alloc]initWithFrame:CGRectMake(30, 150 , 80, 20)];
    small.backgroundColor = [UIColor clearColor];
    small.textColor = [UIColor blackColor];
    small.font = [UIFont fontWithName:KFontUsed size:10];
    small.text = @"Small";
    small.textAlignment = NSTextAlignmentCenter;
    [customView1 addSubview:small];
    
    UIButton *SizeProduct1 = [[UIButton alloc] initWithFrame:CGRectMake(200,60,60,120)];
    UIImage *buttonImage = [UIImage imageNamed:@"icon_cup_56x96.png"];
    [SizeProduct1 setImage:buttonImage forState:UIControlStateNormal];
    [SizeProduct1 setBackgroundColor:[UIColor clearColor]];
    
    [SizeProduct1 addTarget:self action:@selector(sizeBtnClicked2:) forControlEvents:UIControlEventTouchUpInside];
    [customView1 addSubview:SizeProduct1];
    
    UILabel *Large = [[UILabel alloc]initWithFrame:CGRectMake(190, 170 , 80, 20)];
    Large.backgroundColor = [UIColor clearColor];
    Large.textColor = [UIColor blackColor];
    Large.font = [UIFont fontWithName:KFontUsed size:12.0];
    Large.text = @"Large";
    Large.textAlignment = NSTextAlignmentCenter;
    [customView1 addSubview:Large];
    
    UILabel *Drink = [[UILabel alloc]initWithFrame:CGRectMake(customView1.frame.size.width/2 - 70, 0, 160, 45)];
    Drink.backgroundColor = [UIColor clearColor];
    Drink.textColor = [UIColor whiteColor];
    Drink.font = [UIFont fontWithName:KFontUsed size:12.0];
    Drink.text = @"Drink Size?";
    Drink.textAlignment = NSTextAlignmentCenter;
    [customView1 addSubview:Drink];
    
    UIButton *cancelBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 60, 36)];
    [cancelBtn1 setBackgroundColor:[UIColor clearColor]];
    [cancelBtn1 setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn1 addTarget:self action:@selector(cancelBtnClicked1) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn1 setTintColor:[UIColor lightGrayColor]];
    cancelBtn1.alpha = 1.0;
    cancelBtn1.transform = CGAffineTransformMakeTranslation(10, 0);
    [customView1 addSubview:cancelBtn1];

    [self.view addSubview:customView1];
    
    
    /*********************************/
}

- (void)cancelBtnClicked{
    [UIView animateWithDuration:0.2 animations:^{
        customView1.frame = CGRectMake(25, Height, Width - 50, 200);
    }completion:^(BOOL finished){
        
    }];
}
- (void)cancelBtnClicked1{
    [UIView animateWithDuration:0.2 animations:^{
        customView1.frame = CGRectMake(25, Height, Width - 50, 200);
    }completion:^(BOOL finished){
        
    }];
}

- (void)doneBtnClicked
{
    [UIView animateWithDuration:0.2 animations:^{
        customView1.frame = CGRectMake(25, Height, Width - 50, 200);
    }completion:^(BOOL finished){
        
    }];
    
       [UIView animateWithDuration:0.4 animations:^{
        customView1.frame = CGRectMake(25, Height/2-30, Width - 50, 200);
        
    }completion:^(BOOL finished){
        
    }];
    
}

- (void)sizeBtnClicked1:(id)sender
{
    
    if ([PFUser currentUser] == nil) {
        
        LogInViewController *signup_view = [[LogInViewController alloc] init];
        signup_view.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:signup_view animated:YES completion:nil];

    }
    else{
        NSString *price = [NSString stringWithFormat:@"%@", [_product objectForKey:@"price"]];
        PFObject *fav = [PFObject objectWithClassName:@"Cart"];
        [fav setObject: productName.text forKey:@"product"];
        [fav setObject: price forKey:@"totalPrice"];
        [fav setObject: @"Small" forKey:@"size"];
        [fav setObject: delegate.str_Place forKey:@"CafeName"];
        [fav setObject: delegate.str_PlaceLogo forKey:@"CafeLogo"];
        [fav setObject: delegate.str_ProductImage forKey:@"productImage"];
        [fav setObject: delegate.str_PlaceCity forKey:@"CafeCity"];
        [fav setObject: delegate.str_OpenTime forKey:@"OpeningTime"];
        [fav setObject: delegate.str_CloseTime forKey:@"ClosingTime"];
        
        if (![PFUser currentUser])
            [[PFUser currentUser] fetch];
        [fav setObject:[PFUser currentUser].username forKey:@"user"];
        
        // Uploads order to Parse
        [fav saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (!error) {
                
                 }
            else
            {
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"The connection appears to be offline. Please Connect and try again." ];
            }
            
        }];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        customView1.frame = CGRectMake(25, Height, Width - 50, 200);
    }completion:^(BOOL finished){
        
    }];
}
- (void)sizeBtnClicked2:(id)sender
{
    
    if ([PFUser currentUser] == nil) {
        
        LogInViewController *signup_view = [[LogInViewController alloc] init];
        signup_view.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:signup_view animated:YES completion:nil];
    }
    else{
        NSString *price = [NSString stringWithFormat:@"%@", [_product objectForKey:@"price"]];
        PFObject *fav = [PFObject objectWithClassName:@"Cart"];
        [fav setObject: productName.text forKey:@"product"];
        [fav setObject: price forKey:@"totalPrice"];
        [fav setObject: @"Large" forKey:@"size"];
        [fav setObject: delegate.str_Place forKey:@"CafeName"];
        [fav setObject: delegate.str_PlaceLogo forKey:@"CafeLogo"];
        [fav setObject: delegate.str_ProductImage forKey:@"productImage"];
        [fav setObject: delegate.str_PlaceCity forKey:@"CafeCity"];
        [fav setObject: delegate.str_OpenTime forKey:@"OpeningTime"];
        [fav setObject: delegate.str_CloseTime forKey:@"ClosingTime"];
        
        if (![PFUser currentUser])
            [[PFUser currentUser] fetch];
        [fav setObject:[PFUser currentUser].username forKey:@"user"];
        
        // Uploads order to Parse
        [fav saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (!error) {

            }
            else
            {
               [self showPopupWithStyle:CNPPopupStyleCentered andText:@"The connection appears to be offline. Please Connect and try again." ];
            }
            
        }];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        customView1.frame = CGRectMake(25, Height, Width - 50, 200);
    }completion:^(BOOL finished){
        
    }];
}
- (void)addBtnClicked1:(UIImage*)sender

{
    UIButton *btn = (UIButton *)sender;
    
        [UIView animateWithDuration:0.4 animations:^{
        customView1.frame = CGRectMake(25, Height/2-30, Width - 50, 200);
        customView1.tag = btn.tag;
    }completion:^(BOOL finished){
        
    }];
    
    tagValue = btn.tag;
    
   }

- (void)likeBtnClicked{
    
    if ([PFUser currentUser] == nil) {
        
        LogInViewController *signup_view = [[LogInViewController alloc] init];
        signup_view.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:signup_view animated:YES completion:nil];
    }
    else{
        if (like == FALSE) {
            like = TRUE;
            NSString *price = [NSString stringWithFormat:@"%@", [_product objectForKey:@"price"]];
            PFObject *fav = [PFObject objectWithClassName:@"Favorite"];
            [fav setObject: productName.text forKey:@"product"];
            [fav setObject: price forKey:@"totalPrice"];
            [fav setObject: sizeType forKey:@"size"];
            [fav setObject: delegate.str_Place forKey:@"CafeName"];
            [fav setObject: delegate.str_PlaceLogo forKey:@"CafeLogo"];
            [fav setObject: delegate.str_ProductImage forKey:@"productImage"];
            [fav setObject: delegate.str_PlaceCity forKey:@"CafeCity"];
            [fav setObject: delegate.str_OpenTime forKey:@"OpeningTime"];
            [fav setObject: delegate.str_CloseTime forKey:@"ClosingTime"];
            
            if (![PFUser currentUser])
                [[PFUser currentUser] fetch];
            [fav setObject:[PFUser currentUser].username forKey:@"user"];
            
            // Uploads order to Parse
            [fav saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (!error) {
                    
                    
                    [self showPopupWithStyle:CNPPopupStyleCentered andText:@"This Order was marked as your favorite order."];
                 
                    [likeBtn setImage:[UIImage imageNamed:@"Heart_full.png"] forState:UIControlStateNormal];

                } else {
                   [self showPopupWithStyle:CNPPopupStyleCentered andText:@"The connection appears to be offline. Please Connect and try again." ];
                }
                
            }];
            
        }
        else{
            like = FALSE;
            PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];
            [query whereKey:@"CafeName" equalTo:delegate.str_Place];
            [query whereKey:@"CafeCity" equalTo:delegate.str_PlaceCity];
            [query whereKey:@"product" equalTo:[_product objectForKey:@"name"]];
            [query whereKey:@"user" equalTo:[PFUser currentUser].username];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    PFObject *object = [objects objectAtIndex:0];
                    [object deleteInBackground];
                    [likeBtn setImage:[UIImage imageNamed:@"Heart_nofull.png"] forState:UIControlStateNormal];
                }
            }];
        }
        
    }
}

- (void)btn_BackClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andText:(NSString*)str{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Alert" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"OK" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
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
