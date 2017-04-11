//
//  InstructionView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "InstructionView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "InstructionDetailView.h"
#import "IssueCell.h"

@interface InstructionView ()
{
    NSArray *content;
    NSArray *results;
    UITableViewCell *cells;
    UIImageView *image;
    NSMutableArray *filteredTitles,*getData,*jsonData;
    NSMutableString *searchedString;
}
@end

@implementation InstructionView

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
    searchedString=[[NSMutableString alloc]initWithString:@""];

    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.tableview.layer.cornerRadius = 4.0f;
    [self.writeText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    if (IS_IPHONE_4) {
        [self.tableview setFrame:CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y + 25, self.tableview.frame.size.width, self.tableview.frame.size.height - 25)];
        [self.writeText setFrame:CGRectMake(self.writeText.frame.origin.x, self.writeText.frame.origin.y + 17, self.writeText.frame.size.width, 29)];
        [self.cancel setFrame:CGRectMake(self.cancel.frame.origin.x, self.cancel.frame.origin.y + 19, self.cancel.frame.size.width, self.cancel.frame.size.height)];
    } else if (IS_IPHONE_6) {
        [self.tableview setFrame:CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y - 5, self.tableview.frame.size.width, self.tableview.frame.size.height + 5)];
        [self.writeText setFrame:CGRectMake(self.writeText.frame.origin.x, self.writeText.frame.origin.y - 5, self.writeText.frame.size.width, 29)];
        [self.cancel setFrame:CGRectMake(self.cancel.frame.origin.x, self.cancel.frame.origin.y - 9, self.cancel.frame.size.width, self.cancel.frame.size.height)];
    } else if (IS_IPHONE_6P) {
        [self.tableview setFrame:CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y - 10, self.tableview.frame.size.width, self.tableview.frame.size.height + 10)];
        [self.writeText setFrame:CGRectMake(self.writeText.frame.origin.x, self.writeText.frame.origin.y - 10, self.writeText.frame.size.width, 29)];
        [self.cancel setFrame:CGRectMake(self.cancel.frame.origin.x, self.cancel.frame.origin.y - 14, self.cancel.frame.size.width, self.cancel.frame.size.height)];
    } else if (IS_IPAD) {
        [self.tableview setFrame:CGRectMake(self.tableview.frame.origin.x, self.tableview.frame.origin.y - 45, self.tableview.frame.size.width, self.tableview.frame.size.height + 45)];
        [self.writeText setFrame:CGRectMake(self.writeText.frame.origin.x, self.writeText.frame.origin.y - 40, self.writeText.frame.size.width, 35)];
        [self.cancel setFrame:CGRectMake(self.cancel.frame.origin.x, self.cancel.frame.origin.y - 50, self.cancel.frame.size.width, self.cancel.frame.size.height)];
    }
    if ([[[MTDBHelper sharedDBHelper] getInstructions] count] == 0 || [Utils isInstructionupdateTimeExpired]) {
        if ([Utils isInstructionupdateTimeExpired])[Utils saveInstructionLastUpdateTime];
        [self getInstructions];
    } else {
        jsonData = [[[MTDBHelper sharedDBHelper] getInstructions] mutableCopy];
        [self filtrJsonData];
        getData = [jsonData valueForKey:@"title"];
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
    
    [super viewWillAppear:animated];
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return isSearching ? filteredTitles.count : getData.count;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InstructionDetailView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
    Instruction *instruction = isSearching ? [results objectAtIndex:indexPath.row] : [jsonData objectAtIndex:indexPath.row];

    ttView.contentInfo = @[instruction.title, instruction.content];
    [self.navigationController pushViewController:ttView animated:YES];
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

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelClicked
{
    [self.writeText setText:@""];
    [self.writeText resignFirstResponder];
    isSearching=NO;
    jsonData = [[NSMutableArray alloc] initWithArray:jsonData];
    getData = [jsonData valueForKey:@"title"];
    [self.tableview reloadData];
}

- (IBAction)updateInstructions:(id)sender
{
    [self getInstructions];
}

- (void)filtrJsonData
{
    for (NSDictionary *dic in jsonData) {
        if (![[dic valueForKey:@"status"] boolValue]) {
            [jsonData removeObject:dic];
        }
    }
}
#pragma mark - API

-(void)getInstructions
{
    [SVProgressHUD showWithStatus:@""];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/instructionpages.php" parameters:nil];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            [[MTDBHelper sharedDBHelper] removeAllInstructions];
                                                                                            jsonData = (NSMutableArray *) responseObjct;
                                                                                            [[MTDBHelper sharedDBHelper] addInstruction:jsonData];
                                                                                            jsonData = [[[MTDBHelper sharedDBHelper] getInstructions] mutableCopy];
                                                                                            [self filtrJsonData];
                                                                                            getData = [jsonData valueForKey:@"title"];
                                                                                            [self.tableview reloadData];
                                                                                            [SVProgressHUD dismiss];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
}

#pragma mark - TextField Delegate

- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        jsonData = [[[MTDBHelper sharedDBHelper] getInstructions] mutableCopy];
        getData = [jsonData valueForKey:@"title"];
        isSearching=NO;
    } else {
        isSearching= YES;
        results = [[MTDBHelper sharedDBHelper] searchInstructions:textField.text];
        filteredTitles = [results valueForKey:@"title"];
    }
    [self.tableview reloadData];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.writeText resignFirstResponder];

    return YES;
}
@end
