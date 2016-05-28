//
//  RecentViewController.m
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "RecentViewController.h"
#import "Define.h"
#import "AppDelegate.h"
#import "GlobalModel.h"
#import "CNPPopupController.h"
#import "TheSidebarController.h"
#import "MBProgressHUD.h"
@interface RecentViewController ()<UITableViewDataSource,UITableViewDelegate,CNPPopupControllerDelegate>
{
    AppDelegate *delegate;
    UITableView *tableForMainSetting;
}
@property (nonatomic, strong) NSArray *historyListArray;
@property (nonatomic, strong) UILabel *lbl_noRows;
@property (nonatomic, strong) UIImageView *holdPhoto;
@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation RecentViewController
@synthesize historyListArray, lbl_noRows, holdPhoto;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(0x23262F)];
    
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
   
    // Do any additional setup after loading the view.
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 70)];
    [barImageView setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:barImageView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 80, 30, 160, 30)];
    titleLbl.text = @"Recent Orders";
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
    
    tableForMainSetting = [[UITableView alloc] initWithFrame:CGRectMake(0,70,Width,Height-70) style:UITableViewStylePlain];
    tableForMainSetting.dataSource = self;
    tableForMainSetting.delegate = self;
    [tableForMainSetting setBackgroundColor:UIColorFromRGB(0xFEFDFA)];
    
    if ([tableForMainSetting respondsToSelector:@selector(setSeparatorInset:)])
        [tableForMainSetting setSeparatorInset:UIEdgeInsetsZero];
    
    [tableForMainSetting setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableForMainSetting];
    
    if ([tableForMainSetting respondsToSelector:@selector(setBackgroundView:)])
        [tableForMainSetting setBackgroundView:nil];
    
    
    holdPhoto = [[UIImageView alloc]initWithFrame:CGRectMake((Width/2)-50, 140, 100, 100)];
    [holdPhoto setContentMode:UIViewContentModeScaleAspectFill];
    holdPhoto.clipsToBounds = YES;
    holdPhoto.backgroundColor = [UIColor clearColor];
    holdPhoto.image = [UIImage imageNamed:@"history"];
    [self.view addSubview:holdPhoto];
    holdPhoto.hidden =YES;
    
    
    lbl_noRows=[[UILabel alloc]init];
    lbl_noRows.frame=CGRectMake(0,250,Width,20);
    lbl_noRows.backgroundColor=[UIColor clearColor];
    [lbl_noRows setTextColor:[UIColor grayColor]];
    [lbl_noRows setText:@"You don't have any order history."];
    lbl_noRows.textAlignment=NSTextAlignmentCenter;
    [lbl_noRows setFont:[UIFont fontWithName:KFontUsed size:20.0]];
    [self.view addSubview:lbl_noRows];
    lbl_noRows.hidden = YES;
    
    [self getAllHistory];
}

-(void)getAllHistory{
    
    if (![[GlobalModel sharedManager] CheckInternetConnectivity]) {
        [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Internet connection appears to be offline. Please Connect and try again."];
        return;
    }
    
    //Find All places from DB
    if ([PFUser currentUser] == nil) {
        
    }
    else{
        PFQuery *query = [PFQuery queryWithClassName:@"Order"]; //1
        [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
            if (!error) {
                
                self.historyListArray = nil;
                self.historyListArray = [[NSArray alloc] initWithArray:objects];
                if([self.historyListArray count]>0)
                    [tableForMainSetting reloadData];
                
            }
            else {
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Internet connection appears to be offline. Please Connect and try again."];
            }
        }];
    }
}


#pragma mark - tableViewDelegate


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if([self.historyListArray count]  == 0){
        
        lbl_noRows.hidden = NO;
        holdPhoto.hidden = NO;
        
    } else {
        
        lbl_noRows.hidden = YES;
        holdPhoto.hidden = YES;
    }
    
    return self.historyListArray.count;
    
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
    
    UIImageView *backgroundImg = [UIImageView new];
    backgroundImg.frame = CGRectMake(5, 5, Width - 10, 60);
    backgroundImg.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0];
    backgroundImg.layer.cornerRadius = 1;
    [cell.contentView addSubview:backgroundImg];
    
    UIImageView *backgroundImg1 = [UIImageView new];
    backgroundImg1.frame = CGRectMake(5, 45, Width - 10, 80);
    backgroundImg1.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    backgroundImg1.layer.cornerRadius = 1;
    [cell.contentView addSubview:backgroundImg1];
    
    UIImageView *placeImage1 =[UIImageView new];
    placeImage1.frame=CGRectMake(15, 10, 30, 30);
    placeImage1.clipsToBounds = YES;
    placeImage1.layer.cornerRadius=5;
    placeImage1.userInteractionEnabled=YES;
    placeImage1.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:placeImage1];
    
    PFObject *imageObject = [self.historyListArray objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"CafeLogo"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            placeImage1.image = [UIImage imageWithData:data];
        }
    }];
    
    UILabel *lbl_Name=[[UILabel alloc]init];
    [lbl_Name setFrame:CGRectMake(100, 10, 300, 20)];
    [lbl_Name setTextAlignment:NSTextAlignmentLeft];
    [lbl_Name setTextColor:[UIColor whiteColor]];
    [lbl_Name setBackgroundColor:[UIColor clearColor]];
    [lbl_Name setFont:[UIFont systemFontOfSize:15.0]];
    [cell.contentView addSubview:lbl_Name];
    
    UILabel *lbl_City=[[UILabel alloc]init];
    [lbl_City setFrame:CGRectMake(100, 30, 300, 10)];
    [lbl_City setTextAlignment:NSTextAlignmentLeft];
    [lbl_City setTextColor:[UIColor whiteColor]];
    [lbl_City setBackgroundColor:[UIColor clearColor]];
    [lbl_City setFont:[UIFont systemFontOfSize:12.0]];
    [cell.contentView addSubview:lbl_City];
    
    UILabel *lbl_Product=[[UILabel alloc]init];
    [lbl_Product setFrame:CGRectMake(100, 55, 300, 20)];
    [lbl_Product setTextAlignment:NSTextAlignmentLeft];
    [lbl_Product setTextColor:[UIColor blackColor]];
    [lbl_Product setBackgroundColor:[UIColor clearColor]];
    [lbl_Product setFont:[UIFont systemFontOfSize:15.0]];
    [cell.contentView addSubview:lbl_Product];
    
    UILabel *lbl_Num=[[UILabel alloc]init];
    [lbl_Num setFrame:CGRectMake(100, 80, 150, 20)];
    [lbl_Num setTextAlignment:NSTextAlignmentLeft];
    [lbl_Num setTextColor:[UIColor grayColor]];
    [lbl_Num setBackgroundColor:[UIColor clearColor]];
    [lbl_Num setFont:[UIFont systemFontOfSize:13.0]];
    [cell.contentView addSubview:lbl_Num];
    
    UILabel *lbl_Price=[[UILabel alloc]init];
    [lbl_Price setFrame:CGRectMake(Width - 80, 80, 300, 20)];
    [lbl_Price setTextAlignment:NSTextAlignmentLeft];
    [lbl_Price setTextColor:[UIColor grayColor]];
    [lbl_Price setBackgroundColor:[UIColor clearColor]];
    [lbl_Price setFont:[UIFont systemFontOfSize:15.0]];
    [cell.contentView addSubview:lbl_Price];
    
    [lbl_Name setText:[[self.historyListArray objectAtIndex:indexPath.row]valueForKey:@"CafeName"]];
    [lbl_City setText:[NSString stringWithFormat:@"%@",[[self.historyListArray objectAtIndex:indexPath.row]valueForKey:@"CafeCity"]]];
    [lbl_Product setText:[NSString stringWithFormat:@"%@",[[self.historyListArray objectAtIndex:indexPath.row]valueForKey:@"product"]]];
    [lbl_Num setText:[NSString stringWithFormat:@"With %@",[[self.historyListArray objectAtIndex:indexPath.row]valueForKey:@"product"]]];
    [lbl_Price setText:[NSString stringWithFormat:@"$ %@",[[self.historyListArray objectAtIndex:indexPath.row]valueForKey:@"totalPrice"]]];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150.0f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andText:(NSString*)str{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Bummer..." attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"Close" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
     CNPPopupButtonItem *buttonItem = [CNPPopupButtonItem defaultButtonItemWithTitle:buttonTitle backgroundColor:UIColorFromRGB(0xEE7031)];    buttonItem.selectionHandler = ^(CNPPopupButtonItem *item){
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
