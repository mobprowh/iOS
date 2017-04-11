//
//  ScrollViewWithPaging.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "ScrollViewWithPaging.h"
#import "TimeTableView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "timeTable.h"
#import <UserNotifications/UserNotifications.h>


@interface ScrollViewWithPaging (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation ScrollViewWithPaging

@synthesize scrollView, viewControllers,pageControl;

-(void)viewWillAppear:(BOOL)animated
{
     canRotateToAllOrientations = NO;
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
         [self.backImage1 setImage:[UIImage imageNamed:@"background.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
          [self.backImage1 setImage:[UIImage imageNamed:@"theme1.png"]];
    }

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (BOOL) shouldAutorotate
{
    return canRotateToAllOrientations;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationLandscapeLeft;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    canRotateToAllOrientations = YES;
}

-(void)didRotate:(NSNotification *)notification
{
    UIInterfaceOrientation newOrientation =  [UIApplication sharedApplication].statusBarOrientation;
    if ((newOrientation == UIInterfaceOrientationLandscapeLeft || newOrientation == UIInterfaceOrientationLandscapeRight))
    {
        self.scrollView.hidden=YES;
        self.navBar.hidden=YES;
        self.landscapeView.frame=CGRectMake(0,0,480,360);
        self.landscapeView.hidden=NO;
    }
    else if (newOrientation == UIInterfaceOrientationPortrait)
    {
        self.landscapeView.hidden=YES;
        self.navBar.hidden=NO;
        self.scrollView.hidden=NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    NSArray *arrayOfIDs = [[NSUserDefaults standardUserDefaults] objectForKey:@"idValues"];
    addids=[NSMutableArray arrayWithArray:arrayOfIDs];
    NSArray *arrayOfpriorities1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"priorityValues"];
    addpri=[NSMutableArray arrayWithArray:arrayOfpriorities1];
    dictData=[[NSUserDefaults standardUserDefaults] objectForKey:@"idWithPriorities"];
    if ([addpri count]==1) {
        kNumberOfPages=1;
    } else if ([addpri count]==2) {
        kNumberOfPages=2;
    } else if ([addpri count]==3) {
        kNumberOfPages=3;
    } else  if ([addpri count]==4) {
        kNumberOfPages=4;
    } else  if ([addpri count]==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set priority of your favorite masjid to see its Time Table" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    currentDateArray=[[NSMutableArray alloc]init];
    self.landscapeView.hidden=YES;
    self.title=@"Time Table";
    self.outline.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    self.outline.layer.borderWidth=1.0f;
    self.outline.layer.cornerRadius=2.0;
    self.outline.clipsToBounds=YES;
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++) {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize=CGSizeMake(325 * kNumberOfPages, 410);
    [scrollView setScrollEnabled:YES];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    [self loadScrollViewWithPage:0];
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.timeTable addGestureRecognizer:recognizer];
    UISwipeGestureRecognizer * recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiperight:)];
    [recognizer1 setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.timeTable addGestureRecognizer:recognizer1];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    day=[components day];
    month = [components month];
    year = [components year];
    month1=month;
    get=12-month;
    self.landscapePage.numberOfPages=get+1;
    NSDateFormatter *istDateFormatter = [[NSDateFormatter alloc] init];
    [istDateFormatter setDateFormat:@"MMM yyyy"];
    myMonthString = [istDateFormatter stringFromDate:[NSDate date]];
    self.headingLabel.text=[NSString stringWithFormat:@"%@ %@ %@ %ld",myMonthString,@"to",@"Dec",(long)year];
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLayoutSubviews
{
    scrollView.contentSize=CGSizeMake(325 * kNumberOfPages, 410);
}

- (void)loadScrollViewWithPage:(int)page
{
    pageNumber=page;
    if (page < 0) return;
    if (page >=kNumberOfPages) return;
    
    TimeTableView *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [self.storyboard instantiateViewControllerWithIdentifier:@"timeTable"];
        [self changePageDetails];
    }
    if (nil == controller.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
    }
}

-(void)changePageDetails
{
    if ([addpri count]==1) {
        if (pageNumber==0)
        {
            for (NSString *getKey in [dictData allKeys])
            {
                globalMasjidID=[dictData valueForKey:getKey];
                self.pageControl.currentPage=0;
                [self getDetails];
                self.pageControl.numberOfPages=1;
            }
        }
    }
    if ([addpri count]==2) {
        self.pageControl.numberOfPages=2;
        if (pageNumber==0)
        {
            NSArray *keys = [dictData allKeys];
            NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
            id aKey = [sortedKeys objectAtIndex:0];
            id anObject = [dictData valueForKey:aKey];
            globalMasjidID=anObject;
            self.pageControl.currentPage=0;
            [self getDetails];
            self.pageControl.numberOfPages=1;
        }
        else if (pageNumber==1)
        {
            NSArray *keys = [dictData allKeys];
            NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
            id aKey = [sortedKeys objectAtIndex:1];
            id anObject = [dictData valueForKey:aKey];
            globalMasjidID=anObject;
            self.pageControl.currentPage=0;
            [self getDetails];
            self.pageControl.numberOfPages=1;
        }
    }
    if ([addpri count]==3) {
        self.pageControl.numberOfPages=3;
        if (pageNumber==0)
        {
            NSArray *keys = [dictData allKeys];
            NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
            id aKey = [sortedKeys objectAtIndex:0];
            id anObject = [dictData valueForKey:aKey];
            globalMasjidID=anObject;
            self.pageControl.currentPage=0;
            [self getDetails];
            self.pageControl.numberOfPages=1;
        }
        if (pageNumber==1)
        {
            NSArray *keys = [dictData allKeys];
            NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
            id aKey = [sortedKeys objectAtIndex:1];
            id anObject = [dictData valueForKey:aKey];
            globalMasjidID=anObject;
            self.pageControl.currentPage=0;
            [self getDetails];
            self.pageControl.numberOfPages=1;
        }
        else if (pageNumber==2)
        {
            NSArray *keys = [dictData allKeys];
            NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
            id aKey = [sortedKeys objectAtIndex:2];
            id anObject = [dictData valueForKey:aKey];
            globalMasjidID=anObject;
            self.pageControl.currentPage=0;
            [self getDetails];
            self.pageControl.numberOfPages=1;
        }
    }
    if ([addpri count]==4) {
        self.pageControl.numberOfPages=4;
        if (pageNumber==0)
        {
            globalMasjidID=[dictData valueForKey:@"1"];
            self.pageControl.currentPage=0;
            [self getDetails];
        }
        else if (pageNumber==1)
        {
            pValue=2;
            self.pageControl.currentPage=1;
            globalMasjidID=[dictData valueForKey:@"2"];
            [self getDetails];
        }
        if (pageNumber==2)
        {
            pValue=3;
            self.pageControl.currentPage=2;
            globalMasjidID=[dictData valueForKey:@"3"];
            [self getDetails];
        }
        else if (pageNumber==3)
        {
            pValue=4;
            self.pageControl.currentPage=3;
            globalMasjidID=[dictData valueForKey:@"4"];
            [self getDetails];
        }
    }
}

-(void)newData
{
    if (pValue==1) {
        for (int x=0;x<[addpri count];x++)
        {
            if ([[addpri objectAtIndex:x]isEqual:[NSString stringWithFormat:@"%d",pValue]])
            {
                globalMasjidID=[addids objectAtIndex:x];
            }
        }
    }
    if (pValue==2) {
        for (int x=0;x<[addpri count];x++)
        {
            if ([[addpri objectAtIndex:x]isEqual:[NSString stringWithFormat:@"%d",pValue]])
            {
                globalMasjidID=[addids objectAtIndex:x];
            }
        }
    }
    if (pValue==3) {
        for (int x=0;x<[addpri count];x++)
        {
            if ([[addpri objectAtIndex:x]isEqual:[NSString stringWithFormat:@"%d",pValue]])
            {
                globalMasjidID=[addids objectAtIndex:x];
            }
        }
    }
    if (pValue==4) {
        for (int x=0;x<[addpri count];x++)
        {
            if ([[addpri objectAtIndex:x]isEqual:[NSString stringWithFormat:@"%d",pValue]])
            {
                globalMasjidID=[addids objectAtIndex:x];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (pageControlUsed) {
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
   [self loadScrollViewWithPage:page];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    NSInteger page = pageControl.currentPage;
    [self loadScrollViewWithPage:(int)page];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlUsed = YES;
}

- (void)viewDidUnload {
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    month=month+1;
    if (month>12) {
        self.landscapePage.currentPage=get+1;
      
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No more data available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (month==12) {
        self.landscapePage.currentPage=get+1;
        [self getDetails];
    }
    else if (month<month1)
    {
        self.landscapePage.currentPage=0;
        
    }
    else if (month==month1)
    {
        self.landscapePage.currentPage=0;
        [self getDetails];
    }
    else
    {
        self.landscapePage.currentPage=self.landscapePage.currentPage+1;
        [self getDetails];
    }
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    month=month-1;
    if (month>12) {
        self.landscapePage.currentPage=get+1;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No more data available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (month==12) {
        self.landscapePage.currentPage=get+1;
        [self getDetails];
    }
    else if (month<month1)
    {
        self.landscapePage.currentPage=0;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No data available for previous month" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if (month==month1)
    {
        self.landscapePage.currentPage=0;
        [self getDetails];
        
    }
    else
    {
        self.landscapePage.currentPage=self.landscapePage.currentPage-1;
        [self getDetails];
    }
}

-(void)getMonths
{
    switch (month) {
        case 1:
            monthStringVal=@"Jan";
            break;
        case 2:
            monthStringVal=@"Feb";
            break;
        case 3:
            monthStringVal=@"March";
            break;
        case 4:
            monthStringVal=@"April";
            break;
        case 5:
            monthStringVal=@"May";
            break;
        case 6:
            monthStringVal=@"June";
            break;
        case 7:
            monthStringVal=@"July";
            break;
        case 8:
            monthStringVal=@"August";
            break;
        case 9:
            monthStringVal=@"Sept";
            break;
        case 10:
            monthStringVal=@"Oct";
            break;
        case 11:
            monthStringVal=@"Nov";
            break;
        case 12:
            monthStringVal=@"Dec";
            break;
        default:
            break;
    }
}

-(void)getDetails
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/timetable.php?masjid_id=%@",globalMasjidID]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
            success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSArray *jsonObject = (NSArray *) JSON;
                [SVProgressHUD dismiss];
                if ([jsonObject count]==0) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No Data to show" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    self.headingLabel.text=[NSString stringWithFormat:@"%@",myMonthString];
                    [currentMonthData removeAllObjects];
                    [self.timeTable reloadData];
                }
                else
                {
                    [self getMonths];
                    date=[jsonObject valueForKey:@"DATE"];
                    NSString *dateString=[NSString stringWithFormat:@"%ld%@%ld",(long)month,@"-",(long)year];
                    if (month==12) {
                        self.headingLabel.text=[NSString stringWithFormat:@"%@ %ld ",monthStringVal,(long)year];
                    }
                    else
                    {
                        self.headingLabel.text=[NSString stringWithFormat:@"%@ %ld %@ %@ %ld",monthStringVal,(long)year,@"to",@"Dec",(long)year];
                    }
                    if (month==9) {
                        dateString=@"09";
                    }
                    else if (month==8)
                    {
                        dateString=@"08";
                    }
                    
                    currentMonthData=[[NSMutableArray alloc]init];
                    for (int k=0;k<jsonObject.count;k++) {
                        if ([[[[jsonObject valueForKey:@"DATE" ] objectAtIndex:k] substringWithRange: NSMakeRange([[date objectAtIndex:k] rangeOfString: @"-"].location+1, 7)]isEqual:dateString]) {
                            [currentMonthData addObject:jsonObject[k]];
                        }
                    }
                    if (month<month1)
                    {
                    }
                    else if (month>12)
                    {
                    }
                    else if ([currentMonthData count]==0) {
                        
                        [currentMonthData removeAllObjects];
                        [currentDateArray removeAllObjects];
                        [self.timeTable reloadData];
                        
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No Data for this month" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alertController addAction:ok];
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                    }
                    else
                    {
                        NSInteger index;
                        if ([[currentMonthData valueForKey:@"DATE"]containsObject:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)day,(long)month,(long)year]]) {
                            index=[[currentMonthData valueForKey:@"DATE"]indexOfObject:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)day,(long)month,(long)year]];
                        }
                        currentDateArray=[[NSMutableArray alloc]init];
                        for (NSInteger ab=index;ab<[currentMonthData count];ab++) {
                            [currentDateArray addObject:[currentMonthData objectAtIndex:ab]];
                        }
                        date=[currentDateArray valueForKey:@"DATE"];
                        fazar=[currentDateArray valueForKey:@"Subah Sadiq"];
                        fazarJ=[currentDateArray valueForKey:@"Fajar"];
                        sunrise=[currentDateArray valueForKey:@"Sunrise"];
                        zohar=[currentDateArray valueForKey:@"Zohar"];
                        zoharJ=[currentDateArray valueForKey:@"Zohar-j"];
                        asar=[currentDateArray valueForKey:@"Asar"];
                        asarJ=[currentDateArray valueForKey:@"Asar-j"];
                        maghrib=[currentDateArray valueForKey:@"Maghrib"];
                        maghribJ=[currentDateArray valueForKey:@"Sunset"];
                        esha=[currentDateArray valueForKey:@"Esha"];
                        eshaJ=[currentDateArray valueForKey:@"Esha-j"];
                        [self.timeTable reloadData];
                    }
                }
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
    return [currentDateArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simple = @"SimpleTableItem";
    
    timeTable *cell = (timeTable *)[tableViews dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"timeTable" owner:self options:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.date.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.fezarB.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.fazarJ.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.sunrise.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.zoharB.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.zoharJ.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.asarB.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.asarJ.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.magribB.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.magribJ.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.eshaB.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.eshaJ.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.bStart.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.bEnd.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
    
    cell.date.text=[date objectAtIndex:indexPath.row];
    cell.fezarB.text=[fazar objectAtIndex:indexPath.row];
    cell.fazarJ.text=[fazarJ objectAtIndex:indexPath.row];
    cell.sunrise.text=[sunrise objectAtIndex:indexPath.row];
    cell.zoharB.text=[zohar objectAtIndex:indexPath.row];
    cell.zoharJ.text=[zoharJ objectAtIndex:indexPath.row];
    cell.asarB.text=[asar objectAtIndex:indexPath.row];
    cell.asarJ.text=[asarJ objectAtIndex:indexPath.row];
    cell.magribB.text=[maghrib objectAtIndex:indexPath.row];
    cell.magribJ.text=[maghribJ objectAtIndex:indexPath.row];
    cell.eshaB.text=[esha objectAtIndex:indexPath.row];
    cell.eshaJ.text=[eshaJ objectAtIndex:indexPath.row];
    return cell;
    
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor=[UIColor clearColor];
}

- (IBAction)backbtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)cancelView
{
        [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)moveRight
{
    month=month+1;

    if (month>12) {
        self.landscapePage.currentPage=get+1;

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No more data available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if (month==12) {
        self.landscapePage.currentPage=get+1;
        [self getDetails];
    }
    else if (month<month1)
    {
        self.landscapePage.currentPage=0;
    }
    else if (month==month1)
    {
        self.landscapePage.currentPage=0;
        [self getDetails];
    }
    else
    {
        self.landscapePage.currentPage=self.landscapePage.currentPage+1;
        [self getDetails];
    }
}

- (IBAction)moveLeft
{
    month=month-1;
    if (month>12) {
        self.landscapePage.currentPage=get+1;

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No more data available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if (month==12) {
        self.landscapePage.currentPage=get+1;
        [self getDetails];
    }
    else if (month<month1)
    {
        self.landscapePage.currentPage=0;

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"No data available for previous month" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if (month==month1)
    {
        self.landscapePage.currentPage=0;
        [self getDetails];
    }
    else
    {
        self.landscapePage.currentPage=self.landscapePage.currentPage-1;
        [self getDetails];
    }
}

@end
