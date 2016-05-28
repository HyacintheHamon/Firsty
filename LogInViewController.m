//
//  LogInViewController.m
//  Firsty
//
//  Created by iOS on 14/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import "Define.h"
#import "TheSidebarController.h"
#import "AppDelegate.h"
#import "SignupViewController.h"
#import "MBProgressHUD.h"
#import "MainViewController.h"
#import "LeftSidebarViewController.h"
#import "StartViewController.h"
#import "AFNetworking.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "CNPPopupController.h"
@interface LogInViewController ()<UITextFieldDelegate, TheSidebarControllerDelegate,CNPPopupControllerDelegate>
{
MBProgressHUD *hud;
}
@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation LogInViewController

@synthesize mailTxt;
@synthesize passwordTxt;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = TRUE;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 70)];
    [barImageView setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:barImageView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 80, 30, 160, 30)];
    titleLbl.text = @"Log In";
    titleLbl.font = [UIFont systemFontOfSize:18];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLbl];
    
    UIButton *list_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 3, self.view.frame.origin.y + 20, 50, 50)];
    [list_btn setImage:[UIImage imageNamed:@"BtnCrossLogin"] forState:UIControlStateNormal];
    [list_btn addTarget:self action:@selector(listBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    list_btn.alpha = 1.0;
    list_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:list_btn];
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(Width/2 - 40, Height/4 - 30, 80, 90)];
    logoImage.image = [UIImage imageNamed:@"loginSplash.png"];
    [self.view addSubview:logoImage];
    
    UIImageView *textBack1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, logoImage.frame.origin.y + logoImage.frame.size.height + 60, Width - 80, 1)];
    textBack1.backgroundColor = [UIColor whiteColor];
    textBack1.layer.borderWidth = 1;
    textBack1.layer.borderColor = [UIColor grayColor].CGColor;
    textBack1.layer.cornerRadius = 5;
    textBack1.layer.masksToBounds = YES;
    [self.view addSubview:textBack1];
    
    UIImageView *mailImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, textBack1.frame.origin.y - 24, 20, 20)];
    mailImage.image = [UIImage imageNamed:@"avatarIconF.png"];
    [self.view addSubview:mailImage];
    
    mailTxt = [[UITextField alloc] initWithFrame:CGRectMake(50 + mailImage.frame.size.width + 10, mailImage.frame.origin.y -4, Width - 120, 28)];
    mailTxt.backgroundColor = [UIColor clearColor];
    mailTxt.textColor = [UIColor grayColor];
    mailTxt.font = [UIFont systemFontOfSize:13];
    mailTxt.placeholder = @"Username";
    mailTxt.keyboardType = UIKeyboardTypeDefault;
    mailTxt.delegate = self;
    [mailTxt setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:mailTxt];
    
    UIImageView *textBack2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, textBack1.frame.origin.y + textBack1.frame.size.height + 40, Width - 80, 1)];
    textBack2.backgroundColor = [UIColor whiteColor];
    textBack2.layer.borderWidth = 1;
    textBack2.layer.borderColor = [UIColor grayColor].CGColor;
    textBack2.layer.cornerRadius = 5;
    textBack2.layer.masksToBounds = YES;
    [self.view addSubview:textBack2];
    
    UIImageView *keyImg = [[UIImageView alloc] initWithFrame:CGRectMake(50, textBack2.frame.origin.y - 24, 20, 20)];
    keyImg.image = [UIImage imageNamed:@"securityIcon.png"];
    [self.view addSubview:keyImg];
    
    passwordTxt = [[UITextField alloc] initWithFrame:CGRectMake(50 + keyImg.frame.size.width + 10, keyImg.frame.origin.y -4, Width - 120, 28)];
    passwordTxt.backgroundColor = [UIColor clearColor];
    passwordTxt.textColor = [UIColor grayColor];
    passwordTxt.font = [UIFont systemFontOfSize:13];
    passwordTxt.secureTextEntry = YES;
    passwordTxt.placeholder = @"Password";
    passwordTxt.delegate = self;
   [passwordTxt setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:passwordTxt];
    
    UIButton *signinBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, textBack2.frame.origin.y + textBack2.frame.size.height + 30, Width - 100, 45)];
    [signinBtn setImage:[UIImage imageNamed:@"signupIcon.png"] forState:UIControlStateNormal];
    [signinBtn addTarget:self action:@selector(signinBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [signinBtn setTintColor:[UIColor lightGrayColor]];
    signinBtn.alpha = 1.0;
    signinBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:signinBtn];
    
    UIButton *facebookBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, signinBtn.frame.origin.y + signinBtn.frame.size.height + 20, Width - 100, 45)];
    [facebookBtn setImage:[UIImage imageNamed:@"facebookSingIcon.png"] forState:UIControlStateNormal];
    [facebookBtn addTarget:self action:@selector(facebookBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [facebookBtn setTintColor:[UIColor lightGrayColor]];
    facebookBtn.alpha = 1.0;
    facebookBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:facebookBtn];
    
    UIButton *forgotBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, facebookBtn.frame.origin.y + facebookBtn.frame.size.height + 30, facebookBtn.frame.size.width/2 - 10, 10)];
    [forgotBtn setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    forgotBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [forgotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgotBtn addTarget:self action:@selector(forgotBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [forgotBtn setTintColor:[UIColor lightGrayColor]];
    forgotBtn.alpha = 1.0;
    forgotBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:forgotBtn];
    
    UIButton *signupBtn = [[UIButton alloc] initWithFrame:CGRectMake(40 + facebookBtn.frame.size.width/2, facebookBtn.frame.origin.y + facebookBtn.frame.size.height + 30, facebookBtn.frame.size.width/2 - 10, 10)];
    [signupBtn setTitle:@"New here? Sign Up" forState:UIControlStateNormal];
    signupBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [signupBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [signupBtn addTarget:self action:@selector(signupBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [signupBtn setTintColor:[UIColor lightGrayColor]];
    signupBtn.alpha = 1.0;
    signupBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:signupBtn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [mailTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
}

- (void)signinBtnClicked{
    NSString *mailString = mailTxt.text;
    NSString *passString = passwordTxt.text;
    
    if ((mailString.length != 0) && (passString.length != 0))
    {
        [[AppDelegate sharedAppDelegate] showProgressHUD:@"Signing in..."];
        
        [PFUser logInWithUsernameInBackground:mailString password:passString block:^(PFUser *user, NSError *error)
         {
             [[AppDelegate sharedAppDelegate] hideProgressHUD];
             if (user != nil){
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 [self dismissViewControllerAnimated:YES completion:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:menuViewDelegate object:nil];
             }
             else{
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
             }
         }];
    }
    else{
            [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Please enter your username and password" ];
    }
}

- (void)signupBtnClicked{
    SignupViewController *signup_view = [[SignupViewController alloc] init];
    signup_view.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:signup_view animated:YES completion:nil];
}

- (void)forgotBtnClicked
{
    UIAlertView *forgotPassword = [[UIAlertView alloc] initWithTitle:@"Reset Password" message:@"Enter email address to reset password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    forgotPassword.alertViewStyle = UIAlertViewStylePlainTextInput;
    [forgotPassword textFieldAtIndex:0].placeholder = @"e.g. abc@example.com";
    [forgotPassword show];
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
                hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"Sending Request. Please Wait";
                [hud show:YES];
        
        NSString *email = [alertView textFieldAtIndex:0].text;
        [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
            
            [hud hide:YES];
            
            if (!error) {
                
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"An email with Password reset link has been sent to your email address" ];

                LogInViewController *obj=[[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil
                                          ];
                [self.navigationController pushViewController:obj animated:YES];
            }
            else
            {
                NSString *errMessage = [[[error userInfo] objectForKey:@"error"] capitalizedString];
                
                [self showPopupWithStyle:CNPPopupStyleCentered andText:errMessage];
                
            }
        }];
    }
}

- (void)facebookBtnClicked{
    [PFFacebookUtils logInWithPermissions:@[@"public_profile", @"email", @"user_friends"] block:^(PFUser *user, NSError *error)
     {
         if (user != nil)
         {
             NSLog(@"%@",user);
             if (user[@"facebookId"] == nil)
             {
                 [self requestFacebook:user];
             }
         }
         else{
             NSLog(@"error");
         }
     }];
}

//Facebook by Parse
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)requestFacebook:(PFUser *)user
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if (error == nil)
         {
             NSDictionary *userData = (NSDictionary *)result;
             NSLog(@"%@",userData);
             [self processFacebook:user UserData:userData];
         }
         else
         {
         
         }
     }];
}

- (void)processFacebook:(PFUser *)user UserData:(NSDictionary *)userData
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    NSString *link = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", userData[@"id"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [[AppDelegate sharedAppDelegate] showProgressHUD:@"Signing in..."];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         UIImage *image = (UIImage *)responseObject;
         
         PFFile *fileThumbnail = [PFFile fileWithName:@"thumbnail.jpg" data:UIImageJPEGRepresentation(image, 0.6)];
         [fileThumbnail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
          {
              if (error != nil){
                  
              }
          }];
         //-----------------------------------------------------------------------------------------------------------------------------------------
         user[@"email"] = userData[@"email"];
         user[@"username"] = userData[@"name"];
         user[@"authData"] = userData[@"id"];
         user[@"profilePicture"] = fileThumbnail;
         user[@"firstName"] = [userData objectForKey:@"first_name"];
         user[@"lastName"] = [userData objectForKey:@"last_name"];
         
         [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
          {
              if (error == nil)
              {
                               }
              else
              {
              }
          }];
         [AppDelegate sharedAppDelegate].user.profileImg = image;
         [AppDelegate sharedAppDelegate].user.firstName = [userData objectForKey:@"first_name"];
         [AppDelegate sharedAppDelegate].user.lastName = [userData objectForKey:@"last_name"];
         [AppDelegate sharedAppDelegate].user.email = [userData objectForKey:@"email"];
         [self dismissViewControllerAnimated:YES completion:nil];
         [[AppDelegate sharedAppDelegate] hideProgressHUD];
         [[NSNotificationCenter defaultCenter] postNotificationName:menuViewDelegate object:nil];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //[PFUser logOut];
     }];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [[NSOperationQueue mainQueue] addOperation:operation];
}

- (void)listBtnClicked
{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}


- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andText:(NSString*)str{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Alert"  attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
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
