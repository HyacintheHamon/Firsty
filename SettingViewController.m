//
//  SettingViewController.m
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "SettingViewController.h"
#import "Define.h"
#import "TheSidebarController.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CNPPopupController.h"
#import "EmailViewController.h"
#import "TermsViewController.h"
#import "LogInViewController.h"
#import "CNPPopupController.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CNPPopupControllerDelegate>
{
    UITableView *settingTable;
    NSMutableArray *settingsArray;
    
    UIButton *btnUserProfile;
    NSData *imgData;
    AppDelegate *delegate;
}

@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation SettingViewController
@synthesize isEdit;
@synthesize emailAddress;
@synthesize userNameLbl;
@synthesize userImgView;
@synthesize circleImgView;
@synthesize facebookLbl;
@synthesize twitterLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 70)];
    [barImageView setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:barImageView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 80, 30, 160, 30)];
    titleLbl.text = @"Settings";
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
    
    userImgView = [[UIImageView alloc] initWithFrame:CGRectMake(Width/2 - 60, list_btn.frame.origin.y + list_btn.frame.size.height + 40, 120, 120)];
    userImgView.layer.borderWidth = 1;
    userImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    userImgView.layer.cornerRadius = userImgView.frame.size.width / 2;
    userImgView.layer.masksToBounds = YES;
    [self.view addSubview:userImgView];
    
    if ([PFUser currentUser] == nil) {
        userImgView.image = [UIImage imageNamed:@"avatarIcon.png"];
    }
    else{
        PFUser *user = [PFUser currentUser];
        
        PFFile *imageFile = [user objectForKey:@"profilePicture"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                userImgView.image = [UIImage imageWithData:data];
            }
        }];
    }
    
    UIButton *profile_btn = [[UIButton alloc] initWithFrame:CGRectMake(Width/2 - 60, list_btn.frame.origin.y + list_btn.frame.size.height + 40, 120, 120)];
    [profile_btn setTitle:@"" forState:UIControlStateNormal];
    [profile_btn addTarget:self action:@selector(profileBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [profile_btn setTintColor:[UIColor lightGrayColor]];
    profile_btn.alpha = 1.0;
    profile_btn.transform = CGAffineTransformMakeTranslation(10, 0);
    [self.view addSubview:profile_btn];
    
    userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 150, userImgView.frame.origin.y + userImgView.frame.size.height + 8, 300, 30)];
    userNameLbl.font = [UIFont fontWithName:KFontUsed size:18.0];
    userNameLbl.textAlignment = NSTextAlignmentCenter;
    userNameLbl.textColor = [UIColor blackColor];
    [self.view addSubview:userNameLbl];
    
    if ([PFUser currentUser] == nil) {
        
        userNameLbl.hidden = YES;
    }
    else{
        userNameLbl.hidden = NO;
        userNameLbl.text = [[PFUser currentUser] username];
        emailAddress = [[PFUser currentUser] email];
        
    }
    
    UILabel *myEmail = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 150, userImgView.frame.origin.y + userImgView.frame.size.height + 8, 300, 80)];
    myEmail.backgroundColor = [UIColor clearColor];
    myEmail.textColor = [UIColor blackColor];
    myEmail.font = [UIFont fontWithName:KFontUsed size:18.0];
    myEmail.text = self.emailAddress;
    myEmail.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myEmail];
    
    settingsArray = [NSMutableArray arrayWithObjects:@"Change Email/Address", @"Terms & Conditions", nil];
    settingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, userNameLbl.frame.origin.y + userNameLbl.frame.size.height + 40, self.view.frame.size.width, 90)];
    settingTable.delegate = self;
    settingTable.dataSource = self;
    settingTable.backgroundColor = [UIColor clearColor];
    settingTable.separatorInset = UIEdgeInsetsZero;
    [settingTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:settingTable];
    
    UIImageView *backImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(Width/3 - 40, settingTable.frame.origin.y + settingTable.frame.size.height + 50, 80, 32)];
    backImageView1.backgroundColor = [UIColor whiteColor];
    backImageView1.layer.borderWidth = 1;
    backImageView1.layer.cornerRadius = 5;
    backImageView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:backImageView1];
    
    UIImageView *facebookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Width/3 - 40, settingTable.frame.origin.y + settingTable.frame.size.height + 50, 40, 32)];
    facebookImageView.image = [UIImage imageNamed:@"facebookIcon.png"];
    facebookImageView.layer.borderWidth = 1;
    facebookImageView.layer.cornerRadius = 5;
    facebookImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:facebookImageView];
    
    facebookLbl = [[UILabel alloc] initWithFrame:CGRectMake(facebookImageView.frame.origin.x + facebookImageView.frame.size.width, facebookImageView.frame.origin.y, 40, 32)];
    facebookLbl.text = @"12";
    facebookLbl.font = [UIFont systemFontOfSize:17];
    facebookLbl.textAlignment = NSTextAlignmentCenter;
    facebookLbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:facebookLbl];
    
    UIImageView *backImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(Width/3*2 - 20, facebookImageView.frame.origin.y, 80, 32)];
    backImageView2.backgroundColor = [UIColor whiteColor];
    backImageView2.layer.borderWidth = 1;
    backImageView2.layer.cornerRadius = 5;
    backImageView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:backImageView2];
    
    UIImageView *twitterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Width/3*2 - 20, facebookImageView.frame.origin.y, 40, 32)];
    twitterImageView.image = [UIImage imageNamed:@"twitterIcon.png"];
    twitterImageView.layer.borderWidth = 1;
    twitterImageView.layer.cornerRadius = 5;
    twitterImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:twitterImageView];
    
    twitterLbl = [[UILabel alloc] initWithFrame:CGRectMake(twitterImageView.frame.origin.x + twitterImageView.frame.size.width, twitterImageView.frame.origin.y, 40, 32)];
    twitterLbl.text = @"24";
    twitterLbl.font = [UIFont systemFontOfSize:17];
    twitterLbl.textAlignment = NSTextAlignmentCenter;
    twitterLbl.textColor = [UIColor lightGrayColor];
    [self.view addSubview:twitterLbl];
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

- (void)profileBtnClicked{
    UIActionSheet *actionSheet_popupQuery = [[UIActionSheet alloc] initWithTitle:@"Select a picture from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Library", @"Camera", nil];
    actionSheet_popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet_popupQuery showInView:self.view];
}

#pragma mark - ACTION SHEET DELEGATE
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {
            UIImagePickerController*imgPicker = [[UIImagePickerController alloc] init];
            UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
            [imgPicker.navigationBar setTintColor:color];
            imgPicker.delegate = self;
            imgPicker.allowsEditing = YES;
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:imgPicker animated:NO completion:Nil];
        }
    }
    else if(buttonIndex == 1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController*imgPicker = [[UIImagePickerController alloc] init];
            UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
            [imgPicker.navigationBar setTintColor:color];
            imgPicker.delegate = self;
            imgPicker.allowsEditing = YES;
            imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imgPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:imgPicker animated:NO completion:Nil];
            
        }
        else
        {
            [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Device does not support camera"];
            
        }
    }
}

-(void)ParseSavePic{
    if ([PFUser currentUser] == nil) {
    }
    else{
        PFFile *imageFile = [PFFile fileWithName:@"Profileimage.png" data:imgData];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                if (succeeded) {
                    PFUser *user = [PFUser currentUser];
                    user[@"profilePicture"] = imageFile;
                    [user saveInBackground];
                    [[NSNotificationCenter defaultCenter] postNotificationName:menuViewDelegate object:nil];
                }
            } else {
                
                // Handle error
                
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"We couldn't save your picture"];

            }
        }];
    }
}

#pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *imageOriginal =  [info objectForKey:UIImagePickerControllerEditedImage];
    
    userImgView.image = imageOriginal;
    imgData = UIImageJPEGRepresentation(imageOriginal,0.5);
    
    if(imgData != nil){
        [self ParseSavePic];
    }
    [picker dismissViewControllerAnimated:YES completion:Nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    userImgView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return settingsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [settingsArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
         return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([PFUser currentUser] == nil)
    {
        LogInViewController *signup_view = [[LogInViewController alloc] init];
        signup_view.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:signup_view animated:YES completion:nil];

    }
    else{
        if (indexPath.row == 0) {
            EmailViewController *email_view = [[EmailViewController alloc] init];
            email_view.emailAddress = [[PFUser currentUser] email];
            [self.navigationController pushViewController:email_view animated:YES];
        }
               
        if (indexPath.row == 1) {
            TermsViewController *term_view = [[TermsViewController alloc] init];
            [self.navigationController pushViewController:term_view animated:YES];
        }
    }
    
}


- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andText:(NSString*)str{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Oops!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = TRUE;
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
