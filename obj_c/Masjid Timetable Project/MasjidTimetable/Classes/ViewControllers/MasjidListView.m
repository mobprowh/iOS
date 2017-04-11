//
//  MasjidListView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "MasjidListView.h"
#import "SVProgressHUD.h"
#import "MasjidDetailView.h"
#import "TimeTableView.h"
#import "MTDBHelper.h"
#import "MajidListCell.h"
#import "MasjidListTextField.h"
#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface MasjidListView ()
{
    NSArray *masjidNames,*localArea,*largerArea,*countryValue;
    NSMutableArray *masjid_values;
    NSArray *filterdMasjidName,*FilteredLocalArea,*FilteredCountry,*filteredLargerArea,*filteredMasjidID;
    NSMutableArray *jsonDict,*getIDValues;
    NSMutableArray *arrayOfCharacters;
    NSMutableArray *masjid_id,*masjid_address,*masjid_pin,*masjid_phn;
    NSMutableDictionary *objectsForCharacters,*pinObject,*phnObject,*addObject,*IdObject;
    NSInteger selectedCell;
    NSString *searchWithoutMasjid;
    NSArray *getP,*getIDs;
    NSMutableString *searchingString;
    NSMutableArray *a1,*a2,*a3,*a4;
    NSArray *results;
    NSMutableArray *arrayOfNames;
    NSString *numbericSection;
    NSString *firstLetter;
    NSMutableDictionary *objects,*largerObject,*CountryObject;
    NSMutableArray *getlocations,*MasjidLargerArea,*MasjidCountry;
    NSMutableArray *addCapitalData;
    int j,m,KeyAppearence;
    NSArray *alphabets;
    NSArray *masjids;
    int getLocale;
    BOOL isUISetted;
}

@end

@implementation MasjidListView

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
    
    self.title= @"Select Masjid";
    KeyAppearence = 1;
    alphabets = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    a1 = [NSMutableArray array];
    a2 = [NSMutableArray array];
    a3 = [NSMutableArray array];
    a4 = [NSMutableArray array];
    
    addCapitalData = [NSMutableArray array];
    MasjidLargerArea = [NSMutableArray array];
    MasjidCountry = [NSMutableArray array];
    masjid_id = [NSMutableArray array];
    masjid_phn = [NSMutableArray array];
    masjid_pin = [NSMutableArray array];
    masjid_address = [NSMutableArray array];
    
    searchingString = [[NSMutableString alloc] initWithString:@""];
    
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    UIImage *buttonImage1 = [UIImage imageNamed:@"reload.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    [button1 setTitle:@"Reload" forState:UIControlStateNormal];
    button1.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:9];
    button1.frame = CGRectMake(0, 0, buttonImage1.size.width/2, buttonImage1.size.height/2);
    [button1 addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = customBarItem1;
    self.tableView.layer.cornerRadius=3.0f;
    self.tableView.clipsToBounds=YES;
    
    [self retrievePost];
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self loadMasjids];
    [Utils setMasjidListIsOpened];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.searchtextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.navCenter.font =[UIFont fontWithName:@"Helvetica Bold" size:17.0];

    if (!IS_IPAD) {
        self.navRight.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold" size:8.0];
        self.navLeft.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold" size:8.0];
        self.searchtextField.font =[UIFont fontWithName:@"Helvetica" size:12.0];
        self.all.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:13.0];
        if (!isUISetted) {
            isUISetted = YES;
        if (IS_IPHONE_6P) {
            [self.searchtextField setFrame:CGRectMake(self.searchtextField.frame.origin.x, self.searchtextField.frame.origin.y + 15, self.searchtextField.frame.size.width, self.searchtextField.frame.size.height)];
            [self.searchImage setFrame:CGRectMake(self.searchImage.frame.origin.x, self.searchImage.frame.origin.y + 15, self.searchImage.frame.size.width, self.searchImage.frame.size.height)];
            [self.all setFrame:CGRectMake(self.all.frame.origin.x, self.all.frame.origin.y - 3, self.all.frame.size.width, self.all.frame.size.height)];
            [self.timeTableButton setFrame:CGRectMake(self.tableView.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 15, self.tableView.frame.size.width - 17, self.timeTableButton.frame.size.height)];
            [self.timiTableText setFrame:CGRectMake(self.timiTableText.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 6, self.timiTableText.frame.size.width, self.timiTableText.frame.size.height)];
            [self.timetableIcon setFrame:CGRectMake(self.timetableIcon.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 24, self.timetableIcon.frame.size.width, self.timetableIcon.frame.size.height)];
            [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x , self.tableView.frame.origin.y + 50 , self.tableView.frame.size.width, self.tableView.frame.size.height - 55)];
        } else if (IS_IPHONE_6) {
            [self.searchtextField setFrame:CGRectMake(self.searchtextField.frame.origin.x, self.searchtextField.frame.origin.y + 15, self.searchtextField.frame.size.width, self.searchtextField.frame.size.height)];
            [self.searchImage setFrame:CGRectMake(self.searchImage.frame.origin.x, self.searchImage.frame.origin.y + 15, self.searchImage.frame.size.width, self.searchImage.frame.size.height)];
            [self.all setFrame:CGRectMake(self.all.frame.origin.x, self.all.frame.origin.y + 5, self.all.frame.size.width, self.all.frame.size.height)];
            [self.timeTableButton setFrame:CGRectMake(self.tableView.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 15, self.tableView.frame.size.width - 17, self.timeTableButton.frame.size.height)];
            [self.timiTableText setFrame:CGRectMake(self.timiTableText.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 6, self.timiTableText.frame.size.width, self.timiTableText.frame.size.height)];
            [self.timetableIcon setFrame:CGRectMake(self.timetableIcon.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 24, self.timetableIcon.frame.size.width, self.timetableIcon.frame.size.height)];
            [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x , self.tableView.frame.origin.y + 35 , self.tableView.frame.size.width, self.tableView.frame.size.height - 40)];
        } else if (IS_IPHONE_5) {
            [self.searchtextField setFrame:CGRectMake(self.searchtextField.frame.origin.x, self.searchtextField.frame.origin.y + 15, self.searchtextField.frame.size.width, self.searchtextField.frame.size.height)];
            [self.searchImage setFrame:CGRectMake(self.searchImage.frame.origin.x, self.searchImage.frame.origin.y + 15, self.searchImage.frame.size.width, self.searchImage.frame.size.height)];
            [self.all setFrame:CGRectMake(self.all.frame.origin.x, self.all.frame.origin.y + 15, self.all.frame.size.width, self.all.frame.size.height)];
            [self.timeTableButton setFrame:CGRectMake(self.tableView.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 12, self.tableView.frame.size.width - 17, self.timeTableButton.frame.size.height)];
            [self.timiTableText setFrame:CGRectMake(self.timiTableText.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 5, self.timiTableText.frame.size.width, self.timiTableText.frame.size.height)];
            [self.timetableIcon setFrame:CGRectMake(self.timetableIcon.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 20, self.timetableIcon.frame.size.width, self.timetableIcon.frame.size.height)];
            [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x , self.tableView.frame.origin.y + 20 , self.tableView.frame.size.width, self.tableView.frame.size.height - 25)];
        } else {
            [self.searchtextField setFrame:CGRectMake(self.searchtextField.frame.origin.x, self.searchtextField.frame.origin.y + 15, self.searchtextField.frame.size.width, self.searchtextField.frame.size.height)];
            [self.searchImage setFrame:CGRectMake(self.searchImage.frame.origin.x, self.searchImage.frame.origin.y + 15, self.searchImage.frame.size.width, self.searchImage.frame.size.height)];
            [self.all setFrame:CGRectMake(self.all.frame.origin.x, self.all.frame.origin.y + 24, self.all.frame.size.width, self.all.frame.size.height)];
            [self.timeTableButton setFrame:CGRectMake(self.tableView.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 12, self.tableView.frame.size.width - 17, self.timeTableButton.frame.size.height)];
            [self.timiTableText setFrame:CGRectMake(self.timiTableText.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 5, self.timiTableText.frame.size.width, self.timiTableText.frame.size.height)];
            [self.timetableIcon setFrame:CGRectMake(self.timetableIcon.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 18, self.timetableIcon.frame.size.width, self.timetableIcon.frame.size.height)];
            [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x , self.tableView.frame.origin.y + 5 , self.tableView.frame.size.width, self.tableView.frame.size.height - 10)];
        }
        }
    } else {
        self.navLeft.titleLabel.font=[UIFont fontWithName:@"Helvetica Bold" size:8.0];
        if (!isUISetted) {
            isUISetted = YES;
        [self.searchtextField setFrame:CGRectMake(self.searchtextField.frame.origin.x, self.searchtextField.frame.origin.y + 20, self.searchtextField.frame.size.width, self.searchtextField.frame.size.height)];
        [self.searchImage setFrame:CGRectMake(self.searchImage.frame.origin.x, self.searchImage.frame.origin.y + 25, self.searchImage.frame.size.width, self.searchImage.frame.size.height)];
        [self.all setFrame:CGRectMake(self.all.frame.origin.x, self.all.frame.origin.y  - 30 , self.all.frame.size.width, self.all.frame.size.height)];
        [self.timeTableButton setFrame:CGRectMake(self.tableView.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 18, self.tableView.frame.size.width - 30, self.timeTableButton.frame.size.height)];
        [self.timiTableText setFrame:CGRectMake(self.timiTableText.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 8, self.timiTableText.frame.size.width, self.timiTableText.frame.size.height)];
        [self.timetableIcon setFrame:CGRectMake(self.timetableIcon.frame.origin.x, self.searchtextField.frame.origin.y + self.searchtextField.frame.size.height + 32, self.timetableIcon.frame.size.width, self.timetableIcon.frame.size.height)];
        [self.tableView setFrame:CGRectMake(self.tableView.frame.origin.x , self.tableView.frame.origin.y + 100, self.tableView.frame.size.width, self.tableView.frame.size.height - 110)];
        }
    }
    getLocale=0;
    xts=0;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.crossBtn.hidden=NO;
    self.greenDot.hidden=YES;

    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    self.crossBtn.hidden=YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfIDs = [userDefaults objectForKey:@"idValues"];
    NSArray *arrayOfpriorities = [userDefaults objectForKey:@"priorityValues"];
    addids=[NSMutableArray arrayWithArray:arrayOfIDs];
    addpri=[NSMutableArray arrayWithArray:arrayOfpriorities];
    dictData=[NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:@"idWithPriorities"]];
    [self call];
    [self getData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.needUpdateLocalNotifications) {
        if (IS_IOS_10_OR_LATER) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center removeAllPendingNotificationRequests];
        }
        else {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }

        [Appdelegate creatLocalNotificationsForJammat];
        [Appdelegate creatLocalNotificationsForEvents];
        [Appdelegate creatLocalNotificationsForJammatTimesChanged];
        [Appdelegate createPhoneMuteNotifications];
        [Appdelegate updateMasjidsInfoInServer];
        self.needUpdateLocalNotifications = NO;
   }
}

- (void)textFieldDidChange:(UITextField *) textField
{
    if ([textField.text isEqualToString:@""]) {
        masjids = [[MTDBHelper sharedDBHelper] getMasjids];
    } else {
        masjids = [[MTDBHelper sharedDBHelper] searchMasjids:textField.text];
    }
    [self.tableView reloadData];
}

-(void)call
{
    if ([dictData count]==2 || [dictData count]==3 ||[dictData count]==4) {
        getLocale=0;
        NSArray *sortedKeys2 = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSString *key2=[sortedKeys2 objectAtIndex:1];
        NSString *valueForkey2=[dictData valueForKey:key2];
        if ([key2 isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"secondKey"]]) {
            if (![valueForkey2 isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"secondValue"]]) {
                [self getTimeTable];
                [self getNotes];
                [self getDetailsOfTimeTable];
                [self getFormat];
                [self retrievePost2];
            }
        } else {
            [self getNotes];
            [self getTimeTable];
            [self getDetailsOfTimeTable];
            [self getFormat];
            [self retrievePost2];
        }
    }
}

-(void)getData
{
    for (j=0; j<[addpri count]; j++) {
        for (m=0;m<[masjidNames count];m++) {
            if ([[jsonDict valueForKey:@"masjid_id"]containsObject:addids[j]]) {
                
            }
        }
        NSUInteger val=[[jsonDict valueForKey:@"masjid_id"]indexOfObject:addids[j]];
        [get addObject:[NSString stringWithFormat:@"%lu",(unsigned long)val]];
    }
}

-(void)popview
{
    UIViewController *currentViewController;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ViewController class]]) {
            currentViewController = controller;
        }
    }
    if (currentViewController) {
        [self.navigationController popToViewController:currentViewController animated:YES];
    } else {
        ViewController *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"view"];
        [self.navigationController pushViewController:ttView animated:YES];
    }
}

-(void)reloadData
{
    [self.searchtextField resignFirstResponder];
    self.searchImage.hidden=NO;
    self.crossBtn.hidden=YES;
    isSearching=NO;
    [searchingString setString:@""];
    self.searchtextField.text=@"";
    [self retrievePost];
    [self.tableView reloadData];
    KeyAppearence=1;
}

-(void)retrievePost
{
    masjid_values = [[NSMutableArray alloc]init];
    addCapitalData = [[NSMutableArray alloc]init];
    MasjidLargerArea = [[NSMutableArray alloc]init];
    MasjidCountry = [[NSMutableArray alloc]init];
    masjid_id = [[NSMutableArray alloc]init];
    masjid_phn = [[NSMutableArray alloc]init];
    masjid_pin = [[NSMutableArray alloc]init];
    masjid_address = [[NSMutableArray alloc]init];
}

- (void)loadMasjids
{
    if ([Utils masjidsListIsOpened]) {
        masjids = [[MTDBHelper sharedDBHelper] getMasjids];
        if (masjids == nil || [masjids count] == 0) {
            [SVProgressHUD show];
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
            [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
            [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
            
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/masjids.php" parameters:nil];
            
            AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                                success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                                    [[MTDBHelper sharedDBHelper] addMasjids:responseObjct];
                                                                                                    masjids = [[MTDBHelper sharedDBHelper] getMasjids];
                                                                                                    [self.tableView reloadData];
                                                                                                    [SVProgressHUD dismiss];
                                                                                                }
                                                                                                failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                                    [SVProgressHUD dismiss];
                                                                                                }];
            [operation start];
        }
    } else {
        [self refreshMasjidsData];
    }
}

- (void)refreshMasjidsData
{
    [SVProgressHUD show];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"/data/masjids.php" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            
                                                                                            NSDictionary *favoriteInfo = [self getFavoriteMasjids];
                                                                                            [[MTDBHelper sharedDBHelper] removeAllMasjids];
                                                                                            [[MTDBHelper sharedDBHelper] addMasjids:responseObjct];
                                                                                            [self setFavorites:favoriteInfo];
                                                                                            masjids = [[MTDBHelper sharedDBHelper] getMasjids];
                                                                                            [self.tableView reloadData];
                                                                                            [SVProgressHUD dismiss];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
}

- (NSDictionary*)getFavoriteMasjids
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    Masjid *temp = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"];
    if(temp) [dict setValue:temp.favorite forKey:[NSString stringWithFormat:@"%i", temp.masjidId]];
    temp = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"2"];
    if(temp) [dict setValue:temp.favorite forKey:[NSString stringWithFormat:@"%i", temp.masjidId]];
    temp = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"3"];
    if(temp) [dict setValue:temp.favorite forKey:[NSString stringWithFormat:@"%i", temp.masjidId]];
    temp = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"4"];
    if(temp) [dict setValue:temp.favorite forKey:[NSString stringWithFormat:@"%i", temp.masjidId]];
    
    return dict;
}

- (void)setFavorites:(NSDictionary*)favoritInfo
{
    for (NSString *masjidId in [favoritInfo allKeys]) {
        Masjid *temp = [[MTDBHelper sharedDBHelper] getMasjidWithID:masjidId];
        if (temp) {
            [temp setFavorite:[favoritInfo valueForKey:masjidId]];
            [[MTDBHelper sharedDBHelper] updateMasjidWithAttributes:[temp getAttributes]];
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return alphabets;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    BOOL found = NO;
    NSInteger b = 0;
    for (Masjid *obj in masjids) {
        if ([[[obj.name substringToIndex:1] uppercaseString] isEqualToString:title])
            if (!found) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:b inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                found = YES;
            }
        b++;
    }
    return b;
}


- (void)setupIndexData
{
    arrayOfCharacters = [NSMutableArray array];
    getIDValues = [NSMutableArray array];
    objectsForCharacters = [[NSMutableDictionary alloc] init];
    objects=[[NSMutableDictionary alloc]init];
    largerObject=[[NSMutableDictionary alloc]init];
    CountryObject=[[NSMutableDictionary alloc]init];
    IdObject=[[NSMutableDictionary alloc]init];
    addObject=[[NSMutableDictionary alloc]init];
    pinObject=[[NSMutableDictionary alloc]init];
    phnObject=[[NSMutableDictionary alloc]init];
    getlocations=[[NSMutableArray alloc]init];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    arrayOfNames = [[NSMutableArray alloc] init];
    numbericSection    = @"#";
    for (int i=0;i<[addCapitalData count];i++) {
        NSString *masjidLocal,*MasjidlargerArea,*country,*address,*idValue,*postCode,*PhnNo;
        firstLetter = [[addCapitalData[i] description] substringToIndex:1];
        if([[jsonDict valueForKey:@"masjid_name"] containsObject:masjidNames[i]])
        {
            NSInteger index= [[jsonDict valueForKey:@"masjid_name"]indexOfObject:masjidNames[i]];
            masjidLocal=[[jsonDict valueForKey:@"masjid_local_area"]objectAtIndex:index];
            MasjidlargerArea=[[jsonDict valueForKey:@"masjid_larger_area"]objectAtIndex:index];
            country=[[jsonDict valueForKey:@"masjid_country"]objectAtIndex:index];
            idValue=[[jsonDict valueForKey:@"masjid_id"]objectAtIndex:index];
            address=[[jsonDict valueForKey:@"masjid_add_1"]objectAtIndex:index];
            postCode=[[jsonDict valueForKey:@"masjid_post_code"]objectAtIndex:index];
            PhnNo=[[jsonDict valueForKey:@"masjid_telephone"]objectAtIndex:index];
        }
        
        if ([formatter numberFromString:firstLetter] == nil) {
            
            if (![objectsForCharacters objectForKey:firstLetter]) {
                [getlocations removeAllObjects];
                [arrayOfNames removeAllObjects];
                [MasjidCountry removeAllObjects];
                [MasjidLargerArea removeAllObjects];
                [masjid_address removeAllObjects];
                [masjid_id removeAllObjects];
                [masjid_phn removeAllObjects];
                [masjid_pin removeAllObjects];
                [arrayOfCharacters addObject:firstLetter];
            }
            [getlocations addObject:[masjidLocal description]];
            [MasjidLargerArea addObject:[MasjidlargerArea description]];
            [MasjidCountry addObject:[country description]];
            [arrayOfNames addObject:[addCapitalData[i] description]];
            [masjid_address addObject:address];
            [masjid_id addObject:idValue];
            [masjid_phn addObject:PhnNo];
            [masjid_pin addObject:postCode];
            [CountryObject setObject:[MasjidCountry copy] forKey:firstLetter];
            [largerObject setObject:[MasjidLargerArea copy] forKey:firstLetter];
            [objects setObject:[getlocations copy] forKey:firstLetter];
            [objectsForCharacters setObject:[arrayOfNames copy] forKey:firstLetter];
            [IdObject setObject:[masjid_id copy] forKey:firstLetter];
            [addObject setObject:[masjid_address copy] forKey:firstLetter];
            [pinObject setObject:[masjid_pin copy] forKey:firstLetter];
            [phnObject setObject:[masjid_phn copy] forKey:firstLetter];
        } else {
            
            if (![objectsForCharacters objectForKey:numbericSection]) {
                [arrayOfNames removeAllObjects];
                [arrayOfCharacters addObject:numbericSection];
            }
            [arrayOfNames addObject:[addCapitalData[i] description]];
            [objectsForCharacters setObject:[arrayOfNames copy]  forKey:numbericSection];
        }
    }
    isSearching=NO;
    [self.tableView reloadData];
}

- (void)letsCheck
{
    for (int k=0;k<[alphabets count];k++) {
        {
            for (int l=0;l<[addCapitalData count];l++) {
                if (![addCapitalData containsObject:alphabets[k]]) {
                    [getlocations removeAllObjects];
                    [arrayOfNames removeAllObjects];
                    [MasjidCountry removeAllObjects];
                    [MasjidLargerArea removeAllObjects];
                    [masjid_address removeAllObjects];
                    [masjid_id removeAllObjects];
                    [masjid_phn removeAllObjects];
                    [masjid_pin removeAllObjects];
                    
                    getlocations =[[NSMutableArray alloc]initWithArray:getlocations];
                    arrayOfNames =[[NSMutableArray alloc]initWithArray:arrayOfNames];
                    masjid_address =[[NSMutableArray alloc]initWithArray:masjid_address];
                    masjid_id =[[NSMutableArray alloc]initWithArray:masjid_id];
                    masjid_phn =[[NSMutableArray alloc]initWithArray:masjid_phn];
                    MasjidCountry =[[NSMutableArray alloc]initWithArray:MasjidCountry];
                    MasjidLargerArea =[[NSMutableArray alloc]initWithArray:MasjidLargerArea];
                    masjid_pin =[[NSMutableArray alloc]initWithArray:masjid_pin];
                    
                    [CountryObject setObject:[MasjidCountry copy] forKey:firstLetter];
                    [largerObject setObject:[MasjidLargerArea copy] forKey:firstLetter];
                    [objects setObject:[getlocations copy] forKey:firstLetter];
                    [objectsForCharacters setObject:[arrayOfNames copy] forKey:firstLetter];
                    [IdObject setObject:[masjid_id copy] forKey:firstLetter];
                    [addObject setObject:[masjid_address copy] forKey:firstLetter];
                    [pinObject setObject:[masjid_pin copy] forKey:firstLetter];
                    [phnObject setObject:[masjid_phn copy] forKey:firstLetter];
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [masjids count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MajidListCell *cell = (MajidListCell*)[tableViews dequeueReusableCellWithIdentifier:@"majidListCell" forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[MajidListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"majidListCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Masjid *masjid = [masjids objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = masjid.isNameUpperCased ? [masjid.name uppercaseString] : masjid.name;
    cell.localNameLabel.text = masjid.localArea;
    [cell.nameLabel setTextColor:[UIColor blackColor]];
    [cell.mainContentView setFrame:CGRectMake(0, 0, cell.contentView.frame.size.width - 4, cell.contentView.frame.size.height-1)];
    [cell.nameLabel setFrame:CGRectMake(8, 1, cell.mainContentView.frame.size.width - 40, 30)];
    float countPadding = 65.0;
    [cell.localNameLabel setFrame:CGRectMake(26, 24, cell.mainContentView.frame.size.width - countPadding, 30)];
    [cell.countryLabel setFrame:CGRectMake(26, 47, cell.mainContentView.frame.size.width - countPadding, 29)];
    NSString *state = masjid.largerArea.length > 0 ? [NSString stringWithFormat:@"%@%@ %@",masjid.largerArea,@",",masjid.country] : masjid.country;
    cell.countryLabel.text = state;
    
    switch ([masjid.favorite intValue]) {
        case 1:
            cell.mainContentView.backgroundColor = [UIColor colorWithRed:112.0/255.0 green:249.0/255.0 blue:93.0/255.0 alpha:1.0];
            break;
        case 2:
            cell.mainContentView.backgroundColor = [UIColor colorWithRed:163.0/255.0 green:206.0/255.0 blue:246.0/255.0 alpha:1.0];
            break;
        case 3:
            cell.mainContentView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:167.0/255.0 blue:112.0/255.0 alpha:1.0];
            break;
        case 4:
            cell.mainContentView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:138.0/255.0 blue:199.0/255.0 alpha:1.0];
            break;
            
        default:
            cell.mainContentView.backgroundColor = [UIColor whiteColor];
            break;
    }
    
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MasjidDetailView *masjidView = [self.storyboard instantiateViewControllerWithIdentifier:@"masjidDetails"];
    masjidView.masjidList = self;
    [masjidView setMasjid:[masjids objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:masjidView animated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    MajidListCell * cell = (MajidListCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.mainContentView setBackgroundColor:[UIColor lightGrayColor]];
    
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    MajidListCell * cell = (MajidListCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell.mainContentView setBackgroundColor:[UIColor whiteColor]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    if ([self.searchtextField isFirstResponder]) {
    //        [self.searchtextField resignFirstResponder];
    //        KeyAppearence=0;
    //    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchtextField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    self.crossBtn.hidden=NO;
    //    KeyAppearence=0;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (IBAction)cancel:(id)sender
{
    [self.searchtextField resignFirstResponder];
    masjids = [[MTDBHelper sharedDBHelper] getMasjids];
    self.searchtextField.text=@"";
    [self.tableView reloadData];
}


-(void)alphabetSearchButtonClicked:(UIButton *)_button
{
    
}

- (IBAction)cancelTapped
{
    [self.searchtextField resignFirstResponder];
    self.searchImage.hidden=NO;
    isSearching=NO;
    [searchingString setString:@""];
    self.searchtextField.text=@"";
    [self setupIndexData];
    [self.tableView reloadData];
    KeyAppearence=1;
}

- (IBAction)timeTablePage
{
    if (KeyAppearence==0) {
        [self.searchtextField resignFirstResponder];
        KeyAppearence=1;
    }
    else if(KeyAppearence==1)
    {
        self.greenDot.hidden=YES;
        [self movet];
        KeyAppearence=1;
    }
}

-(void)movet
{
    xts=1;
    dispatch_async(dispatch_get_main_queue(), ^{
        TimeTableView *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"timeTable"];
        [self.navigationController pushViewController:ttView animated:YES];
    });
    
}

- (IBAction)popView {
    if (KeyAppearence==0) {
        [self.searchtextField resignFirstResponder];
        KeyAppearence=1;
    } else if (KeyAppearence==1) {
        [self performSelector:@selector(popMethod) withObject:self afterDelay:0.5];
        KeyAppearence=1;
    }
}

-(void)popMethod
{
    UIViewController *currentViewController;
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ViewController class]]) {
            currentViewController = controller;
        }
    }
    if (currentViewController) {
        [self.navigationController popToViewController:currentViewController animated:YES];
    } else {
        ViewController *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"view"];
        [self.navigationController pushViewController:ttView animated:YES];
    }
}

- (IBAction)reload
{
    if (KeyAppearence==0) {
        [self.searchtextField resignFirstResponder];
        KeyAppearence=1;
    } else if (KeyAppearence==1) {
        [self.searchtextField resignFirstResponder];
        self.searchImage.hidden=NO;
        self.crossBtn.hidden=YES;
        isSearching=NO;
        [searchingString setString:@""];
        self.searchtextField.text=@"";
        [self retrievePost];
        [self refreshMasjidsData];
        [self.tableView reloadData];
        KeyAppearence=1;
    }
}

-(void)getNotes
{
    NSArray *sortedKeys;
    NSString *firstKey;
    sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    firstKey=[sortedKeys objectAtIndex:1];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/notes.php?masjid_id=%@",[dictData valueForKey:firstKey]]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSArray *json = (NSArray *) JSON;
                                             globalMasjidNotes=[[NSArray alloc]init];
                                             globalMasjidNotes=json;
                                             [[NSUserDefaults standardUserDefaults] setObject:globalMasjidNotes forKey:@"globalMasjidNotes1"];
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
    
}

-(void)getDetailsOfTimeTable
{
    NSArray *sortedKeys;
    NSString *firstKey;
    sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"text/html"];
    NSString *str=[NSString stringWithFormat:@"/data/timetable.php?masjid_id=%@",[dictData valueForKey:firstKey]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:str parameters:nil];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             [SVProgressHUD dismiss];
                                             NSArray *result = (NSArray *) JSON;
                                             if ([result count]==0) {
                                                 [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"globalTimeTable1"];
                                             }
                                             else
                                             {
                                                 globalTimeTable=result;
                                                 [[NSUserDefaults standardUserDefaults] setObject:globalTimeTable forKey:@"globalTimeTable1"];
                                             }
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                        }];
    [operation start];
}

-(void)getFormat
{
    NSArray *sortedKeys;
    NSString *firstKey;
    sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    firstKey=[sortedKeys objectAtIndex:1];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"text/html"];
    NSString *str=[NSString stringWithFormat:@"/data/timetabledetails.php?masjid_id=%@",[dictData valueForKey:firstKey]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:str parameters:nil];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             globalTimeTableFormat= (NSArray *) JSON;
                                             if ([globalTimeTableFormat count]==0)
                                             {
                                                 [[NSUserDefaults standardUserDefaults] setObject:globalTimeTableFormat forKey:@"globalTimeTableFormat1"];
                                             }
                                             else
                                             {
                                                 
                                                 
                                                 [[NSUserDefaults standardUserDefaults] setObject:globalTimeTableFormat forKey:@"globalTimeTableFormat1"];
                                             }
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    
    [operation start];
}

-(void)retrievePost2
{
    NSArray *sortedKeys;
    NSString *firstKey;
    sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    firstKey=[sortedKeys objectAtIndex:1];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/masjids.php?masjid_id=%@",[dictData valueForKey:firstKey]]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             [SVProgressHUD dismiss];
                                             NSArray *getMasjid=(NSArray *) JSON;
                                             globalMasjidNames=[getMasjid objectAtIndex:0];
                                             if ([globalMasjidNames count]==0)
                                             {
                                                 [[NSUserDefaults standardUserDefaults] setObject:globalMasjidNames forKey:@"globalMasjidValues1"];
                                             }
                                             else
                                             {
                                                 NSMutableDictionary *mutableDict = [globalMasjidNames mutableCopy];
                                                 for (NSString *key in [globalMasjidNames allKeys])
                                                 {
                                                     if ([[globalMasjidNames objectForKey:key]isEqual:[NSNull null]])
                                                     {
                                                         [mutableDict setValue:@""forKey:key];
                                                     }
                                                 }
                                                 globalMasjidNames = [mutableDict copy];
                                                 NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:globalMasjidNames];
                                                 NSDictionary *myDictionary = (NSDictionary *) [NSKeyedUnarchiver unarchiveObjectWithData:myData];
                                                 [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"globalMasjidValues1"];
                                             }
                                             
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                        }];
    [operation start];
    
}

-(void)getTimeTable
{
    NSArray *sortedKeys = [[dictData allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSString *firstKey=[sortedKeys objectAtIndex:1];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/timetable.php?masjid_id=%@",[dictData valueForKey:firstKey]] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSArray *jsonObject = (NSArray *) JSON;
                                                                                            [[NSUserDefaults standardUserDefaults]setValue:jsonObject forKey:@"monthlyTimetable1"];
                                                                                            
                                                                                        }
                                         
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                            
                                                                                        }];
    
    [operation start];
}

@end
