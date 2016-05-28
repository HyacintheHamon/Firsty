//
//  TermsViewController.m
//  Firsty
//
//  Created by iOS on 29/05/15.
//  Copyright (c) 2015 iOS. All rights reserved.
//

#import "TermsViewController.h"
#import "Define.h"
#import <Parse/Parse.h>

@interface TermsViewController ()<UIWebViewDelegate>

@end

@implementation TermsViewController

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
    lbl_title.text = @"Terms & Conditions";
    lbl_title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl_title];
    
    UIButton* btn_Back =[UIButton buttonWithType:UIButtonTypeCustom];
    btn_Back.frame=CGRectMake(5,25,40,40);
    [btn_Back setBackgroundColor:[UIColor clearColor]];
    [btn_Back setImage:[UIImage imageNamed:@"back_arrow@2x.png"] forState:UIControlStateNormal];
    [btn_Back addTarget:self action:@selector(btn_BackClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Back];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 70, Width, Height - 70)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.lgetfirsty.com/terms/"]]];
    [self.view addSubview:webView];
}

- (void)btn_BackClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
