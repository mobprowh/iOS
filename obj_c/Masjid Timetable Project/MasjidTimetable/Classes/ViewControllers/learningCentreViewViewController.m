//
//  learningCentreViewViewController.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "learningCentreViewViewController.h"
#import "InstructionDetailView.h"
#import "IssueCell.h"

@interface learningCentreViewViewController ()
{
    NSArray *results;
    BOOL isSearching;
    NSMutableArray *filteredTitles,*getData,*jsonData;
    UIImageView *image;
    NSMutableString *searchedString;
}
@end

@implementation learningCentreViewViewController

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
    
    jsonData = [NSMutableArray array];
    filteredTitles = [NSMutableArray array];
    getData = [NSMutableArray array];
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    //set the frame of the button to the size of the image (see note below)
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    searchedString=[[NSMutableString alloc]initWithString:@""];
    [self.writeText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (IS_IPHONE_4) {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 25, self.tableView.frame.size.width, self.tableView.frame.size.height - 25)];
        [self.writeText setFrame:CGRectMake(self.writeText.frame.origin.x, self.writeText.frame.origin.y + 17, self.writeText.frame.size.width, 29)];
        [self.cancel setFrame:CGRectMake(self.cancel.frame.origin.x, self.cancel.frame.origin.y + 19, self.cancel.frame.size.width, self.cancel.frame.size.height)];
    } else if (IS_IPHONE_6) {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y - 5, self.tableView.frame.size.width, self.tableView.frame.size.height + 5)];
        [self.writeText setFrame:CGRectMake(self.writeText.frame.origin.x, self.writeText.frame.origin.y - 5, self.writeText.frame.size.width, 29)];
        [self.cancel setFrame:CGRectMake(self.cancel.frame.origin.x, self.cancel.frame.origin.y - 9, self.cancel.frame.size.width, self.cancel.frame.size.height)];
    } else if (IS_IPHONE_6P) {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y - 10, self.tableView.frame.size.width, self.tableView.frame.size.height + 10)];
        [self.writeText setFrame:CGRectMake(self.writeText.frame.origin.x, self.writeText.frame.origin.y - 10, self.writeText.frame.size.width, 29)];
        [self.cancel setFrame:CGRectMake(self.cancel.frame.origin.x, self.cancel.frame.origin.y - 14, self.cancel.frame.size.width, self.cancel.frame.size.height)];
    } else if (IS_IPAD) {
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y - 45, self.tableView.frame.size.width, self.tableView.frame.size.height + 45)];
        [self.writeText setFrame:CGRectMake(self.writeText.frame.origin.x, self.writeText.frame.origin.y - 40, self.writeText.frame.size.width, 35)];
        [self.cancel setFrame:CGRectMake(self.cancel.frame.origin.x, self.cancel.frame.origin.y - 50, self.cancel.frame.size.width, self.cancel.frame.size.height)];
    }
    self.tableView.layer.cornerRadius=7.0f;
    self.tableView.clipsToBounds=YES;
    
    if ([[[MTDBHelper sharedDBHelper] getIssues] count] == 0 || [Utils isIssueupdateTimeExpired]) {
        if ([Utils isIssueupdateTimeExpired])[Utils saveTimeTableLastUpdateDate];
        [self getIssues];
    } else {
        jsonData = [[[MTDBHelper sharedDBHelper] getIssues] mutableCopy];
        getData = [jsonData valueForKey:@"title"];
    }
}

- (void)viewWillAppear:(BOOL)animated
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
    
    [super viewWillAppear:animated];
}

- (void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getIssues
{
    [SVProgressHUD showWithStatus:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/custompages.php" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            [[MTDBHelper sharedDBHelper] removeAllIssues];
                                                                                            jsonData = (NSMutableArray *) responseObjct;
                                                                                            [[MTDBHelper sharedDBHelper] addIssues:jsonData];
                                                                                            jsonData = [[[MTDBHelper sharedDBHelper] getIssues] mutableCopy];
                                                                                            getData = [jsonData valueForKey:@"title"];
                                                                                            [self.tableView reloadData];
                                                                                            [SVProgressHUD dismiss];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
}

- (void)checkForItemStatus:(Issue *)issue
{
    [SVProgressHUD showWithStatus:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSString *path = [NSString stringWithFormat:@"/data/custompages.php?page_id=%@&SELECT=status", issue.pageId];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:path parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            if ([[[responseObjct lastObject] valueForKey:@"status"] boolValue]) {
                                                                                                [self openDetailPageWithPageId:issue];
                                                                                            }
                                                                                            [SVProgressHUD dismiss];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isSearching ? filteredTitles.count : getData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simple = @"cell";
    
    IssueCell *cell = [tableViews dequeueReusableCellWithIdentifier:simple forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[IssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simple];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.mainContainerView setFrame:CGRectMake(0, 0, cell.contentView.frame.size.width - 4, cell.contentView.frame.size.height-1)];

    NSString *val1 = isSearching? filteredTitles[indexPath.row]:getData[indexPath.row];
    cell.titleLabel.text=val1;
    if (IS_IPHONE_4) [cell.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    IssueCell * cell = (IssueCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.mainContainerView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    IssueCell * cell = (IssueCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.mainContainerView setBackgroundColor:[UIColor whiteColor]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearching) {
        Issue *issue = [results objectAtIndex:indexPath.row];
        if (issue.content.length == 0) {
            [self checkForItemStatus:issue];
        } else {
            [self openDetailPageWithPageId:issue];
        }
    } else {
        Issue *issue = [jsonData objectAtIndex:indexPath.row];
        if (issue.content.length == 0) {
            [self checkForItemStatus:issue];
        } else {
            [self openDetailPageWithPageId:issue];
        }
    }
}


- (void)openDetailPageWithPageId:(Issue *)issue
{
    InstructionDetailView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
    [ttView setIssue:issue];
    if (issue.content.length > 0) {
        ttView.contentInfo = @[issue.title, issue.content];
    }
    ttView.isFromLearning = YES;
    [self.navigationController pushViewController:ttView animated:YES];
}

- (IBAction)cancelClicked
{
    [self.writeText setText:@""];
    [self.writeText resignFirstResponder];
    isSearching=NO;
    jsonData = [[NSMutableArray alloc] initWithArray:jsonData];
    getData = [jsonData valueForKey:@"title"];
    [self.tableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.writeText resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.cancel.hidden=NO;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        jsonData = [[[MTDBHelper sharedDBHelper] getIssues] mutableCopy];
        getData = [jsonData valueForKey:@"title"];
        isSearching=NO;
    } else {
        isSearching= YES;
        results = [[MTDBHelper sharedDBHelper] searchIssues:textField.text];
        filteredTitles = [results valueForKey:@"title"];
    }
    [self.tableView reloadData];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateIssues:(id)sender
{
    [self getIssues];
}

@end
