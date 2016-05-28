//
//  SignupViewController.m
//  Firsty
//
//  Created by iOS on 14/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "Define.h"
#import "AppDelegate.h"
#import "CNPPopupController.h"

@interface SignupViewController ()<UITextFieldDelegate ,CNPPopupControllerDelegate>

@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) CNPPopupController *popupController;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = TRUE;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 70)];
    [barImageView setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:barImageView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 80, 30, 160, 30)];
    titleLbl.text = @"Sign Up";
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
    
    UIImageView *textBack3 = [[UIImageView alloc] initWithFrame:CGRectMake(40, logoImage.frame.origin.y + logoImage.frame.size.height + 60, Width - 80, 1)];
    textBack3.backgroundColor = [UIColor whiteColor];
    textBack3.layer.borderWidth = 1;
    textBack3.layer.borderColor = [UIColor grayColor].CGColor;
    textBack3.layer.cornerRadius = 5;
    textBack3.layer.masksToBounds = YES;
    [self.view addSubview:textBack3];
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, textBack3.frame.origin.y - 24, 20, 20)];
    userImage.image = [UIImage imageNamed:@"avatarIconF.png"];
    [self.view addSubview:userImage];
    
    _usernameField = [[UITextField alloc] initWithFrame:CGRectMake(50 + userImage.frame.size.width + 10, userImage.frame.origin.y + 2, Width - 120, 14)];
    _usernameField.backgroundColor = [UIColor clearColor];
    _usernameField.textColor = [UIColor grayColor];
    _usernameField.font = [UIFont systemFontOfSize:13];
    _usernameField.placeholder = @"UserName";
    _usernameField.keyboardType = UIKeyboardTypeDefault;
    _usernameField.delegate = self;
    [_usernameField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_usernameField];
    
    UIImageView *textBack1 = [[UIImageView alloc] initWithFrame:CGRectMake(40, textBack3.frame.origin.y + textBack3.frame.size.height + 40, Width - 80, 1)];
    textBack1.backgroundColor = [UIColor whiteColor];
    textBack1.layer.borderWidth = 1;
    textBack1.layer.borderColor = [UIColor grayColor].CGColor;
    textBack1.layer.cornerRadius = 5;
    textBack1.layer.masksToBounds = YES;
    [self.view addSubview:textBack1];
    
    UIImageView *mailImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, textBack1.frame.origin.y - 24, 20, 20)];
    mailImage.image = [UIImage imageNamed:@"mailIcon.png"];
    [self.view addSubview:mailImage];
    
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(50 + mailImage.frame.size.width + 10, mailImage.frame.origin.y + 2, Width - 120, 14)];
    _emailField.backgroundColor = [UIColor clearColor];
    _emailField.textColor = [UIColor grayColor];
    _emailField.font = [UIFont systemFontOfSize:13];
    _emailField.placeholder = @"Email";
    _emailField.keyboardType = UIKeyboardTypeDefault;
    _emailField.delegate = self;
    [_emailField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_emailField];
    
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
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50 + keyImg.frame.size.width + 10, keyImg.frame.origin.y + 2, Width - 120, 14)];
    _passwordField.backgroundColor = [UIColor clearColor];
    _passwordField.textColor = [UIColor grayColor];
    _passwordField.font = [UIFont systemFontOfSize:13];
    _passwordField.secureTextEntry = YES;
    _passwordField.placeholder = @"Password";
    _passwordField.delegate = self;
    [_passwordField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_passwordField];
    
    UIButton *signupBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, textBack2.frame.origin.y + textBack2.frame.size.height + 30, Width - 100, 45)];
    [signupBtn setImage:[UIImage imageNamed:@"signinIcon.png"] forState:UIControlStateNormal];
    [signupBtn addTarget:self action:@selector(signUpBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [signupBtn setTintColor:[UIColor lightGrayColor]];
    signupBtn.alpha = 1.0;
    signupBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:signupBtn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [_emailField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_usernameField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)signUpBtnClicked{
    NSString *userString = _usernameField.text;
    NSString *mailString = _emailField.text;
    NSString *passString = _passwordField.text;
    
    if ((mailString.length != 0) && (passString.length != 0) && (userString.length != 0))
    {
        PFUser *user = [PFUser user];
        user.username = _usernameField.text;
        user.password = _passwordField.text;
        user.email = _emailField.text;
        
       [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [[AppDelegate sharedAppDelegate]initRun];
                [[NSNotificationCenter defaultCenter] postNotificationName:menuViewDelegate object:nil];
            } else {
                
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"SignUp Failed!" ];


            }
        }];
    }
    else{
        [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Please enter your username and password" ];

    }
    
}

- (void)listBtnClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andText:(NSString*)str{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Error"  attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
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
