//
//  SponsorViewController.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 5/16/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import "SponsorViewController.h"
#import <MessageUI/MessageUI.h>

@interface SponsorViewController () <UITextViewDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation SponsorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (IS_IPHONE_4) {
        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y + 25, self.textView.frame.size.width, self.textView.frame.size.height - 25)];
    } else if (IS_IPHONE_5) {
        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y + 15, self.textView.frame.size.width, self.textView.frame.size.height - 15)];
    } else if (IS_IPHONE_6) {
        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y +2, self.textView.frame.size.width, self.textView.frame.size.height)];
    } else if (IS_IPHONE_6P) {
        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y , self.textView.frame.size.width, self.textView.frame.size.height)];
    } else if (IS_IPAD) {
        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y- 25 , self.textView.frame.size.width, self.textView.frame.size.height + 25)];
        [self.textView setFont:[UIFont systemFontOfSize:24.0]];
    }
    self.textView.editable = NO;
    self.textView.selectable = YES;
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    [self.textView setDelegate:self];
    
    [self getSponsorInfo];
}

 - (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if (URL && [URL.scheme isEqualToString:@"mailto"] && [MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        NSString *mail = [NSString stringWithFormat:@"%@", URL];
        mail =  [mail stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:@""];
        [controller setToRecipients:@[mail]];
        [controller setSubject:@""];
        [controller setMessageBody:@"" isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:nil];
    }
    return URL && URL.scheme && URL.host;
}

#pragma mark - API

- (void)getSponsorInfo
{
    [SVProgressHUD showWithStatus:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/sponsor.php" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            NSString *htmlString = [[responseObjct lastObject]valueForKey:@"sponsor"];
                                                                                            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                                                                                            self.textView.attributedText = attributedString;
                                                                                            [SVProgressHUD dismiss];

                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
