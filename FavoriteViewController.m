//
//  FavorieViewController.m
//  Firsty
//
//  Created by iOS on 13/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "FavoriteViewController.h"
#import "AppDelegate.h"
#import "Define.h"
#import "TheSidebarController.h"

#import "GlobalModel.h"
#import "CNPPopupController.h"
#import "LogInViewController.h"
@interface FavoriteViewController ()<UITableViewDataSource,UITableViewDelegate, CNPPopupControllerDelegate>
{
    AppDelegate *delegate;
    UITableView *tableForMainSetting;
}
@property (nonatomic, strong) NSMutableArray *favArray;
@property (nonatomic, strong) UILabel *lbl_noRows;
@property (nonatomic, strong) UIImageView *holdPhoto;
@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation FavoriteViewController
@synthesize favArray, lbl_noRows, holdPhoto;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(0x23262F)];
    
    
    
    favArray = [[NSMutableArray alloc] init];
    
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view.
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 70)];
    [barImageView setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:barImageView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 80, 30, 160, 30)];
    titleLbl.text = @"Favorites";
    titleLbl.font = [UIFont systemFontOfSize:18];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLbl];
    
    UIButton *list_btn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 3, self.view.frame.origin.y + 30, 30, 30)];
    [list_btn setImage:[UIImage imageNamed:@"listIcon.png"] forState:UIControlStateNormal];
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
    holdPhoto.image = [UIImage imageNamed:@"star"];
    [self.view addSubview:holdPhoto];
    holdPhoto.hidden =YES;
    
    lbl_noRows=[[UILabel alloc]init];
    lbl_noRows.frame=CGRectMake(0,250,Width,20);
    lbl_noRows.backgroundColor=[UIColor clearColor];
    [lbl_noRows setTextColor:[UIColor grayColor]];
    [lbl_noRows setText:@"You don't have any Favorites yet."];
    lbl_noRows.textAlignment=NSTextAlignmentCenter;
    [lbl_noRows setFont:[UIFont fontWithName:KFontUsed size:15.0]];
    [self.view addSubview:lbl_noRows];
    lbl_noRows.hidden = YES;
    
    [self getAllFavorites];
}

-(void)getAllFavorites{
    
    if (![[GlobalModel sharedManager] CheckInternetConnectivity]) {
        
        [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Internet connection appears to be offline. Please Connect and try again."];
        return;
    }
    
    //Find All places from DB
    if ([PFUser currentUser] == nil) {
        
    }
    else{
                [favArray removeAllObjects];
        PFQuery *query = [PFQuery queryWithClassName:@"Favorite"];//1
        [query whereKey:@"user" equalTo:[[PFUser currentUser]username]];
      
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {//4
            if (!error) {
                self.favArray = [NSMutableArray arrayWithArray:objects];
                if([self.favArray count]>0){
                    [tableForMainSetting reloadData];
                }
                
            }
            else {
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Internet connection appears to be offline. Please Connect and try again."];
            }
        }];
    }
}

#pragma mark - getTime

-(NSString*)getRightTime:(NSString*)open andClosetime:(NSString*)close{
    
    // For calculating the current date
    NSDate *date = [NSDate date];
    
    // Make Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh a"];
    
    // hh for hour mm for minutes and a will show you AM or PM
    [dateFormatter setLocale:[NSLocale systemLocale]];
    
    NSString *str = [dateFormatter stringFromDate:date];
    NSLog(@"%@", str);
    
    // Seperate str by space i.e. you will get time and AM/PM at index 0 and 1 respectively
    NSArray *array = [str componentsSeparatedByString:@" "];
    
    // Now you can check it by 12. If < 12 means Its morning > 12 means its evening or night
    NSString * timeInHour = array[0];
    NSString * am_pm      = array[1];
    
    NSInteger CurrentTime =[timeInHour integerValue];
    NSInteger OpenTime =[open integerValue];
    NSInteger CloseTime =[close integerValue];
    
    if(CurrentTime < 12 && [am_pm isEqualToString:@"AM"])
    {
        if (OpenTime <= CurrentTime && CurrentTime <= CloseTime) {
            return @"OPEN";
        }else{
            return @"CLOSED";
        }
        
    }
    else if (CurrentTime <= 12 && [am_pm isEqualToString:@"PM"])
    {
        if (CurrentTime == 12 && OpenTime == 12) {
            return @"OPEN";
        }else{
            if (OpenTime <= CurrentTime+12 && CurrentTime+12 <= CloseTime) {
                return @"OPEN";
            }else{
                return @"CLOSED";
            }
        }
    }
    else
    {
        return @"Done";
    }
    
}

#pragma mark - tableViewDelegate
// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([self.favArray count] == 0 ){
        lbl_noRows.hidden = NO;
        holdPhoto.hidden = NO;
        
    } else {
        lbl_noRows.hidden = YES;
        holdPhoto.hidden = YES;
    }
    
    return self.favArray.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setBackgroundColor:UIColorFromRGB(0x23262F)];
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
    backgroundImg.frame = CGRectMake(5, 5, Width - 10, 70);
    [backgroundImg setBackgroundColor:UIColorFromRGB(0x23262F)];
    backgroundImg.layer.cornerRadius = 3;
    [cell.contentView addSubview:backgroundImg];
    
    UIImageView *placeImage1 =[UIImageView new];
    placeImage1.frame=CGRectMake(10, 10, 60, 60);
    placeImage1.clipsToBounds = YES;
    placeImage1.layer.cornerRadius=5;
    placeImage1.layer.borderColor = [UIColor blackColor].CGColor;
    placeImage1.layer.borderWidth = 1;
    placeImage1.userInteractionEnabled=YES;
    placeImage1.image=[UIImage imageNamed:@"placePlaceholder@2x"];
    [cell.contentView addSubview:placeImage1];
    
    PFObject *imageObject = [self.favArray objectAtIndex:indexPath.row];
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
    [lbl_Name setFont:[UIFont systemFontOfSize:17.0]];
    [cell.contentView addSubview:lbl_Name];
    
    UILabel *lbl_Address=[[UILabel alloc]init];
    [lbl_Address setFrame:CGRectMake(100, 30, 300, 20)];
    [lbl_Address setTextAlignment:NSTextAlignmentLeft];
    [lbl_Address setTextColor:[UIColor grayColor]];
    [lbl_Address setBackgroundColor:[UIColor clearColor]];
    [lbl_Address setFont:[UIFont systemFontOfSize:14]];
    [cell.contentView addSubview:lbl_Address];
    
    UILabel *lbl_Product=[[UILabel alloc]init];
    [lbl_Product setFrame:CGRectMake(100, 50, 300, 20)];
    [lbl_Product setTextAlignment:NSTextAlignmentLeft];
    [lbl_Product setTextColor:[UIColor grayColor]];
    [lbl_Product setBackgroundColor:[UIColor clearColor]];
    [lbl_Product setFont:[UIFont systemFontOfSize:12]];
    [cell.contentView addSubview:lbl_Product];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 50, 32, 20)];
    [addBtn setBackgroundColor:[UIColor clearColor]];
    addBtn.layer.cornerRadius = 3;
    addBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    addBtn.layer.borderWidth = 1;
    [addBtn setTitle:@"ADD" forState:UIControlStateNormal];
    addBtn.tag = indexPath.row;
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setTintColor:[UIColor lightGrayColor]];
    addBtn.alpha = 1.0;
    addBtn.transform = CGAffineTransformMakeTranslation(10, 0);
    [cell.contentView addSubview:addBtn];
    
    [lbl_Name setText:[[self.favArray objectAtIndex:indexPath.row]valueForKey:@"CafeName"]];
    [lbl_Address setText:[NSString stringWithFormat:@"%@",[[self.favArray objectAtIndex:indexPath.row]valueForKey:@"CafeCity"]]];
    [lbl_Product setText:[NSString stringWithFormat:@"%@",[[self.favArray objectAtIndex:indexPath.row]valueForKey:@"product"]]];
    
    return cell;
}

- (void)addBtnClicked: (id)sender{
    UIButton *btn = (UIButton *)sender;
    
    if ([PFUser currentUser] == nil) {
        
        LogInViewController *signup_view = [[LogInViewController alloc] init];
        signup_view.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:signup_view animated:YES completion:nil];
        
    }
    else{
        PFObject *favProduct = [self.favArray objectAtIndex:btn.tag];
        
        NSString *price = [NSString stringWithFormat:@"%@", [favProduct objectForKey:@"totalPrice"]];
        PFObject *fav = [PFObject objectWithClassName:@"Cart"];
        [fav setObject: [favProduct objectForKey:@"product"] forKey:@"product"];
        [fav setObject: [favProduct objectForKey:@"milkType"] forKey:@"milkType"];
        [fav setObject: [favProduct objectForKey:@"sugarType"] forKey:@"sugarType"];
        [fav setObject: price forKey:@"totalPrice"];
        [fav setObject: [favProduct objectForKey:@"size"] forKey:@"size"];
        [fav setObject: [favProduct objectForKey:@"CafeName"] forKey:@"CafeName"];
        [fav setObject: [favProduct objectForKey:@"CafeLogo"] forKey:@"CafeLogo"];
        [fav setObject: [favProduct objectForKey:@"productImage"] forKey:@"productImage"];
        [fav setObject: [favProduct objectForKey:@"CafeCity"] forKey:@"CafeCity"];
        [fav setObject: [favProduct objectForKey:@"OpeningTime"] forKey:@"OpeningTime"];
        [fav setObject: [favProduct objectForKey:@"ClosingTime"] forKey:@"ClosingTime"];
        
        if (![PFUser currentUser])
            [[PFUser currentUser] fetch];
        [fav setObject:[PFUser currentUser].username forKey:@"user"];
        
        // Uploads order to Parse
        [fav saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (!error) {
                
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"This favorite Order was marked as your cart order."];
                
                        } else {
                
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"The connection appears to be offline. Please Connect and try again."];

            }
            
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *componentArray = [[[self.favArray objectAtIndex:indexPath.row]valueForKey:@"OpeningTime"] componentsSeparatedByString:@":"];
    NSArray *componentArray1 = [[[self.favArray objectAtIndex:indexPath.row]valueForKey:@"ClosingTime"] componentsSeparatedByString:@":"];
    
    NSString *str_Status=   [self getRightTime:[componentArray objectAtIndex:0] andClosetime:[componentArray1 objectAtIndex:0]];
    
    if ([str_Status isEqualToString:@"OPEN"]) {

    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        PFObject *product = [self.favArray objectAtIndex:indexPath.row];
        [self.favArray removeObjectAtIndex:indexPath.row];
        [tableForMainSetting reloadData];
        [product deleteInBackground];
    }
}

- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andText:(NSString*)str{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Alert" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"Done" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
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
