//
//  EmailViewController.m
//  Firsty
//
//  Created by iOS on 29/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "EmailViewController.h"
#import "Define.h"
#import <Parse/Parse.h>
#import "CNPPopupController.h"

@interface EmailViewController ()<UITextFieldDelegate,CNPPopupControllerDelegate>

@property (nonatomic, strong) UITextField *changeText;
@property (nonatomic, strong) CNPPopupController *popupController;
@end

@implementation EmailViewController

@synthesize changeText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * imageview_TopBar = [[UIImageView alloc] init];
    imageview_TopBar.frame=CGRectMake(0, 0,Width, 70);
    [imageview_TopBar setUserInteractionEnabled:YES];
    [imageview_TopBar setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:imageview_TopBar];
    
    UILabel *lbl_title = [[UILabel alloc]initWithFrame:CGRectMake(0, 30 , Width, 30)];
    lbl_title.backgroundColor = [UIColor clearColor];
    lbl_title.textColor = [UIColor whiteColor];
    lbl_title.font = [UIFont fontWithName:KFontUsed size:18.0];
    lbl_title.text = @"Email";
    lbl_title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl_title];
    
    UIButton* btn_Back =[UIButton buttonWithType:UIButtonTypeCustom];
    btn_Back.frame=CGRectMake(5,25,40,40);
    [btn_Back setBackgroundColor:[UIColor clearColor]];
    [btn_Back setImage:[UIImage imageNamed:@"back_arrow@2x.png"] forState:UIControlStateNormal];
    [btn_Back addTarget:self action:@selector(btn_BackClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Back];
    
    UILabel *email = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, Width, 30)];
    email.backgroundColor = [UIColor clearColor];
    email.textColor = [UIColor blackColor];
    email.font = [UIFont fontWithName:KFontUsed size:18.0];
    email.text = @"My Email";
    email.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:email];
    
    UILabel *myEmail = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, Width, 30)];
    myEmail.backgroundColor = [UIColor clearColor];
    myEmail.textColor = [UIColor grayColor];
    myEmail.font = [UIFont fontWithName:KFontUsed size:18.0];
    myEmail.text = self.emailAddress;
    myEmail.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myEmail];
    
    UILabel *changeEmail = [[UILabel alloc] initWithFrame:CGRectMake(0, 185, Width, 30)];
    changeEmail.backgroundColor = [UIColor clearColor];
    changeEmail.textColor = [UIColor blackColor];
    changeEmail.font = [UIFont fontWithName:KFontUsed size:18.0];
    changeEmail.text = @"Change Email Address";
    changeEmail.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:changeEmail];
    
    changeText = [[UITextField alloc] initWithFrame:CGRectMake(Width/2 - 90, 225, 180, 30)];
    changeText.backgroundColor = [UIColor clearColor];
    changeText.textColor = [UIColor blackColor];
    changeText.font = [UIFont systemFontOfSize:15];
    changeText.placeholder = @"Email";
    changeText.delegate = self;
    changeText.layer.cornerRadius = 2;
    changeText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    changeText.layer.borderWidth = 1;
    changeText.layer.masksToBounds = YES;
    [changeText setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:changeText];
    
    UIButton* changeBtn =[[UIButton alloc] initWithFrame:CGRectMake(Width/2 - 75,280,150,40)];
    [changeBtn setBackgroundColor:UIColorFromRGB(0xEE7031)];
    
    [changeBtn setTitle:@"Change Email" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    changeBtn.layer.cornerRadius = 5;
    changeBtn.layer.borderWidth = 1;
    changeBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [changeBtn addTarget:self action:@selector(changeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    [changeText resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)changeBtnClicked{
    if ([changeText.text isEqualToString:@""]) {
        
    }
    else{
        if ([PFUser currentUser] == nil) {
            
        }
        else{
            [[PFUser currentUser] setEmail:changeText.text];
            [[PFUser currentUser] saveInBackground];
            [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Email changed"];

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
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
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
