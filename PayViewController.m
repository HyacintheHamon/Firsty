//
//  PayViewController.m
//  Firsty
//
//  Created by Harjeet Bedi on 9/7/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "PayViewController.h"
#import "OrderCompleteViewController.h"
#import "AppDelegate.h"
#import "Define.h"
#import "CartViewController.h"
#import "LogInViewController.h"
#import "CNPPopupController.h"
#import "TheSidebarController.h"
@interface PayViewController ()<CNPPopupControllerDelegate>
{
    NSMutableData *responseData1;
    NSURLConnection *myConnection;
    NSDictionary *dictionary_result;
    NSURLRequest *myRequest;
    
    UIPickerView *blockPicker;
     UIPickerView *blockPicker1;
    NSMutableArray *blockArray;
    NSMutableArray *YearArray;
      AppDelegate *delegate;
  float totalPrice;
    NSString *milkType;
    NSString *sugarType;
    NSString *sizeType;
        NSInteger tagValue;
    NSString *OrderStr;
}
@property (nonatomic, strong) CNPPopupController *popupController;

@end

@implementation PayViewController
@synthesize CardNumber,ExpMonth,ExpYear,Amount1,TotalAmountlbl,OrderView;

- (void)viewDidLoad {

       [super viewDidLoad];
    NSLog(@"TotalPay----%@",self.paymentValue);
 
    self.TotalAmountlbl.text = self.paymentValue;
    
    NSLog(@"TotalPay----%@",self.orderValue);
    
    self.OrderView.text = self.orderValue;
    self.OrderView.hidden=YES;
    
    blockArray = [NSMutableArray arrayWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
    YearArray = [NSMutableArray arrayWithObjects:@"2015", @"2016", @"2017", @"2018", @"2019", @"2020", @"2021", @"2022", @"2023", @"2024", @"2025", @"2026", @"2027", @"2028", @"2029", @"2030", @"2031", @"2032", @"2033", @"2034", @"2035", @"2036", @"2037", @"2038", @"2039", @"2040", @"2041", @"2042", @"2043", @"2044", @"2045", @"2046", @"2047", @"2048", @"2049", @"2050", nil];
    

    blockPicker = [[UIPickerView alloc] init];
    
    blockPicker.dataSource = self;
    blockPicker.delegate = self;
    blockPicker1 = [[UIPickerView alloc] init];
    
    blockPicker1.dataSource = self;
    blockPicker1.delegate = self;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.image = [UIImage imageNamed:@"background.png"];
        [self.view addSubview:backgroundView];
        
        
        
        self.view.backgroundColor = [UIColor whiteColor];
        delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        // Do any additional setup after loading the view.
        UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 70)];
        [barImageView setBackgroundColor:UIColorFromRGB(0xEE7031)];
        [self.view addSubview:barImageView];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 365, 30, 768, 30)];
        titleLbl.text = @"Payment";
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

        
    }
    else
    {
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:backgroundView];
    
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 414, 70)];
    [barImageView setBackgroundColor:UIColorFromRGB(0xEE7031)];
    [self.view addSubview:barImageView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width/2 - 70, 30, 160, 30)];
    titleLbl.text = @"Payment";
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
    }  // Do any additional setup after loading the view from its nib.
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

- (void)listBtnClicked
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([CardNumber.text length]!=16) {
     
        NSLog(@"OK");
        
      
    }
    return YES;
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
  if (textField == ExpMonth) {
        ExpMonth.inputView = blockPicker;
         }
   else if(textField == ExpYear)
    {
        ExpYear.inputView = blockPicker1;
           }
    }

-(void)postData
{
     NSString *post = [NSString stringWithFormat:@""];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
   
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://getfirsty.com/payments/stripe/payment.php?cardno=%@&exp_month=%@&exp_year=%@&amount=%@&currency=aud",self.CardNumber.text,self.ExpMonth.text,self.ExpYear.text,self.TotalAmountlbl.text]]];
    NSLog(@"===%@",request);
      [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    myConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }

#pragma mark - NSURLConnection

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData1 = [[NSMutableData alloc]init];
    NSLog(@"======%@", response);
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data2
{
    [responseData1 appendData:data2];
    NSLog(@"------%@", data2);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError * json_error = nil;
    
    id id_json_serialization = [NSJSONSerialization JSONObjectWithData:responseData1 options:NSJSONReadingMutableContainers error:&json_error];
    
    
    if(json_error == nil)
    {
        dictionary_result = (NSDictionary *) id_json_serialization;
        
        
        NSLog(@"dictionary result------%@", dictionary_result);
        
        
        if (connection == myConnection)
        {
            
            
            if([[dictionary_result valueForKey:@"status"]isEqualToString:@"Success"])
         
            {
                
                PFQuery *query = [PFQuery queryWithClassName:@"Order"];
                [query whereKey:@"ordernumber" equalTo:self.orderValue];
                
                [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error)
                {
                 if (!object)
                {
                     NSLog(@"The getFirstObject request failed.");
                 }
                 else
                 {
                     
                        NSLog(@"data insert successfully.");
                     // The find succeeded.
                   object[@"isArchived"] = @"True";
                   [object saveInBackground];
                   
                 }
                 }];
                
               [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Your Payment success....Thanks!."];
                
                
                orderVC = [[OrderCompleteViewController alloc] init];
                orderVC.orderValue=self.orderValue;
                orderVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [self presentViewController:orderVC animated:YES completion:nil];

            }
            else
            {
                        NSLog(@"%@",[json_error localizedDescription]);
                [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Invalid Credentials. Please Connect and try again."];
           
            }
        }
        }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
    [self showPopupWithStyle:CNPPopupStyleCentered andText:[error localizedDescription]];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   if (pickerView==blockPicker) {
        return [blockArray count];
    }
    else {
        return [YearArray count];
    }
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView==blockPicker) {
        return [blockArray objectAtIndex:row];
    }
    else {
        return [YearArray objectAtIndex:row];
    }
    return nil;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView==blockPicker)
    {
    [blockArray objectAtIndex:row];
    ExpMonth.text = [blockArray objectAtIndex:row];
    [[self view] endEditing:YES];
    }
    else{
    [YearArray objectAtIndex:row];
    ExpYear.text=[YearArray objectAtIndex:row];
 [[self view] endEditing:YES];
    }
}
- (IBAction)PayBttn:(UIButton *)sender
{
    if ([CardNumber hasText] && [ExpMonth hasText] && [ExpYear hasText] )
    {
        if ([CardNumber.text length]!=16)
        {
            [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Please Enter Valid card Number."];        }
        else
        {
   
        [self postData];
        }
    }
    
    else
    {
     [self showPopupWithStyle:CNPPopupStyleCentered andText:@"Please Enter All Field Data."];
    }
    
    
       
}
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle andText:(NSString*)str1{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Alert" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:str1 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
    
    NSAttributedString *buttonTitle = [[NSAttributedString alloc] initWithString:@"OK" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor], NSParagraphStyleAttributeName : paragraphStyle}];
    
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
   @end
