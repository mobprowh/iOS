//
//  InstructionDetailView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "InstructionDetailView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface InstructionDetailView ()

@end

@implementation InstructionDetailView

- (BOOL)shouldAutorotate
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000  
- (NSUInteger)supportedInterfaceOrientations  
#else  
- (UIInterfaceOrientationMask)supportedInterfaceOrientations  
#endif  
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *buttonImage1 = [UIImage imageNamed:@"reload.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    [button1 setTitle:@"Dashboard" forState:UIControlStateNormal];
    button1.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:9];
    button1.frame = CGRectMake(0, 0, buttonImage1.size.width/2, buttonImage1.size.height/2);
    [button1 addTarget:self action:@selector(showDashBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = customBarItem1;
    self.heading.textColor=[UIColor colorWithRed:121.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.detailtext.textColor=[UIColor colorWithRed:92.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    self.detailtext.editable=NO;
    self.detailView.layer.cornerRadius=7.0f;
    if (!self.contentInfo) {
        [self getIssueDetail];
        self.navTitle.text = @"Topic";
    } else {
        NSString *htmlString = [self.contentInfo lastObject];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.detailtext.attributedText = attributedString;
        [self.heading setText:[self.contentInfo objectAtIndex:0]];
        [self.heading setNumberOfLines:0];
        self.navTitle.text = @"Guide";
    }
    if (IS_IPHONE_4) [self.heading setFont:[UIFont boldSystemFontOfSize:self.heading.font.pointSize - 3]];
    if (self.isFromLearning) {
        [self.btn setBackgroundImage:[UIImage imageNamed:@"issues.png"] forState:UIControlStateNormal];
    } else {
        [self.btn setBackgroundImage:[UIImage imageNamed:@"instuctions.png"] forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
}


#pragma mark - API

- (void)getIssueDetail
{
    [SVProgressHUD showWithStatus:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString *path = [NSString stringWithFormat:@"/data/custompages.php?page_id=%@", self.issue.pageId];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            NSString *htmlString = [[responseObjct lastObject] valueForKey:@"content"];
                                                                                            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                                                                                            self.issue.content = htmlString;
                                                                                            [[MTDBHelper sharedDBHelper] saveContext];
                                                                                            self.detailtext.attributedText = attributedString;
                                                                                            [self.heading setText:[[responseObjct lastObject] valueForKey:@"page_title"]];
                                                                                            [SVProgressHUD dismiss];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showDashBoard
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
