//
//  MasjidDetailView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "MasjidDetailView.h"
#import "ViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "MasjidDetailTableCell.h"
#import "timeTable.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "ArabicConverter.h"
#import "MTDBHelper.h"
#import "MasjidTimetable.h"
#import "Event.h"
#import "Donation.h"

#define FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define METERS_PER_MILE 1609.344
#define kPayPalEnvironment PayPalEnvironmentNoNetwork

@interface MasjidDetailView ()
{
    int p,q,r,o;
    UISwipeGestureRecognizer *recognizer,*recognizer1;
    NSString *paypalCode;
    NSArray *timeTables;
    NSArray *tempTimeTables;
    NSArray *donations;
    NSArray *events;
    int completedRequestCount;
    BOOL isPriorityButtonClicked;
}

@end

@implementation MasjidDetailView

@synthesize map;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Masjid Details";
    UIImage *buttonImage = [UIImage imageNamed:@"back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:@"      Masjid List" forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:9];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/2, buttonImage.size.height/2-3);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    UIImage *buttonImage1 = [UIImage imageNamed:@"reload.png"];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:buttonImage1 forState:UIControlStateNormal];
    [button1 setTitle:@"Dashboard" forState:UIControlStateNormal];
    button1.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:9];
    button1.frame = CGRectMake(0, 0, buttonImage1.size.width/2, buttonImage1.size.height/2);
    [button1 addTarget:self action:@selector(showDashBoard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = customBarItem1;
    
    p = 1; q = 1; r = 1;
    self.eventDonationLabel.hidden = YES;
    self.timetableLabel.hidden = YES;
    self.footerTable.delegate = self;
    self.footerTable.dataSource = self;
    self.footerView.hidden = NO;
    self.textView.editable = NO;
    self.callButton.layer.borderColor=[[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0]CGColor];
    self.callButton.layer.borderWidth=3.0f;
    self.callLabel.textColor=[UIColor colorWithRed:5.0/255.0 green:225.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.detailView.hidden=YES;
    map.hidden=YES;
    [self designBtns];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeleft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.footerTable addGestureRecognizer:recognizer];
    recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiperight:)];
    [recognizer1 setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.footerTable addGestureRecognizer:recognizer1];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.donationBtn.bounds
                                                   byRoundingCorners:UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.donationBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    self.donationBtn.layer.mask = maskLayer;
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.mapBtn.bounds
                                                    byRoundingCorners:UIRectCornerBottomLeft
                                                          cornerRadii:CGSizeMake(5.0, 5.0)];
    CAShapeLayer *maskLayer1 = [CAShapeLayer layer];
    maskLayer1.frame = self.mapBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.mapBtn.layer.mask = maskLayer1;
    
    self.timetableLabel.hidden = YES;
    self.pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.pageControl.currentPage = 0;
    completedRequestCount = 0;
    isPriorityButtonClicked = NO;
    [self loadMasjidInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (IS_IPAD) {
        [self.masjidNameLabel setFrame:CGRectMake(self.masjidNameLabel.frame.origin.x, self.masjidNameLabel.frame.origin.y - 50, self.masjidNameLabel.frame.size.width, self.masjidNameLabel.frame.size.height + 10)];
        [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y - 30, self.textView.frame.size.width, self.textView.frame.size.height)];
        [self.pleaseSelect setFrame:CGRectMake(self.pleaseSelect.frame.origin.x + 110, self.pleaseSelect.frame.origin.y, self.pleaseSelect.frame.size.width - 220, self.pleaseSelect.frame.size.height)];
        self.navLeft.titleLabel.font=[UIFont systemFontOfSize:18];
        self.navCenter.font = [UIFont fontWithName:@"Helvetica Bold" size:17.0];
        self.mapLabel.font=[UIFont systemFontOfSize:22];
        self.donationLabel.font=[UIFont systemFontOfSize:22];
        self.eventlabel.font=[UIFont systemFontOfSize:22];
        self.pri.font=[UIFont systemFontOfSize:22];
        self.quat.font=[UIFont systemFontOfSize:22];
        self.s.font=[UIFont systemFontOfSize:22];
        self.t.font=[UIFont systemFontOfSize:22];
        self.textView.font=[UIFont systemFontOfSize:22];
        self.masjidNameLabel.font = [UIFont systemFontOfSize:25];
        self.callLabel.font=[UIFont systemFontOfSize:22];
        self.Label2.font=[UIFont systemFontOfSize:22];
        self.label3.font=[UIFont systemFontOfSize:22];
        self.label4.font=[UIFont systemFontOfSize:22];
        self.lable1.font=[UIFont systemFontOfSize:22];
        self.pleaseSelect.font=[UIFont systemFontOfSize:20];
        self.dLabel.font=[UIFont systemFontOfSize:18];
        self.mLabl.font=[UIFont systemFontOfSize:18];
        self.eLabl.font=[UIFont systemFontOfSize:18];
        self.sLabl.font=[UIFont systemFontOfSize:18];
        self.fLabl.font=[UIFont systemFontOfSize:18];
        self.aLabl.font=[UIFont systemFontOfSize:18];
        self.zLbl.font=[UIFont systemFontOfSize:18];
        self.bj.font=[UIFont systemFontOfSize:18];
        self.timetableLabel.font=[UIFont systemFontOfSize:18];
        self.eventDonationLabel.font=[UIFont systemFontOfSize:18];
        self.headingLabel.font=[UIFont systemFontOfSize:18];
        self.pageControl.frame=CGRectMake(470,self.pageControl.frame.origin.y,self.pageControl.frame.size.width,40);
        [self.frontView1 setFrame:CGRectMake(self.frontView1.frame.origin.x, self.frontView1.frame.origin.y - 50, self.frontView1.frame.size.width,  self.frontView1.frame.size.height + 50)];
        [self.eventImage setFrame:CGRectMake(self.eventImage.frame.origin.x + 10, self.eventImage.frame.origin.y, self.eventImage.frame.size.width, self.eventImage.frame.size.height)];
        [self.eventlabel setFrame:CGRectMake(self.eventlabel.frame.origin.x - 6, self.eventlabel.frame.origin.y, self.eventlabel.frame.size.width, self.eventlabel.frame.size.height)];
        [self.map setFrame:CGRectMake(self.map.frame.origin.x + 16, self.map.frame.origin.y, self.map.frame.size.width, self.map.frame.size.height)];
        [self.mapLabel setFrame:CGRectMake(self.mapLabel.frame.origin.x - 3, self.mapLabel.frame.origin.y, self.mapLabel.frame.size.width, self.mapLabel.frame.size.height)];
        [self.donationImage setFrame:CGRectMake(self.donationImage.frame.origin.x + 23, self.donationImage.frame.origin.y - 5, self.donationImage.frame.size.width, self.donationImage.frame.size.height)];
        [self.donationLabel setFrame:CGRectMake(self.donationLabel.frame.origin.x, self.donationLabel.frame.origin.y, self.donationLabel.frame.size.width, self.donationLabel.frame.size.height)];
    } else {
        self.navCenter.font =[UIFont fontWithName:@"Helvetica Bold" size:17.0];
        if (IS_IPHONE_6P) {
            [self.frontView1 setFrame:CGRectMake(self.frontView1.frame.origin.x, self.frontView1.frame.origin.y - 20, self.frontView1.frame.size.width,  self.frontView1.frame.size.height + 20)];
            [self.masjidNameLabel setFrame:CGRectMake(self.masjidNameLabel.frame.origin.x, self.masjidNameLabel.frame.origin.y - 30, self.masjidNameLabel.frame.size.width, self.masjidNameLabel.frame.size.height)];
            [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y - 30, self.textView.frame.size.width, self.textView.frame.size.height+20)];
            [self.eventImage setFrame:CGRectMake(self.eventImage.frame.origin.x + 5, self.eventImage.frame.origin.y, self.eventImage.frame.size.width, self.eventImage.frame.size.height)];
            [self.donationImage setFrame:CGRectMake(self.donationImage.frame.origin.x + 8, self.donationImage.frame.origin.y - 5, self.donationImage.frame.size.width, self.donationImage.frame.size.height)];
            [self.donationLabel setFrame:CGRectMake(self.donationLabel.frame.origin.x, self.donationLabel.frame.origin.y, self.donationLabel.frame.size.width, self.donationLabel.frame.size.height)];
            self.textView.font=[UIFont systemFontOfSize:15];
        } else if(IS_IPHONE_6) {
            self.textView.font=[UIFont systemFontOfSize:15];
            self.eventTable.frame=CGRectMake(self.eventTable.frame.origin.x,4,self.eventTable.frame.size.width,344);
            self.donationTable.frame=CGRectMake(self.donationTable.frame.origin.x,4,self.donationTable.frame.size.width,344);
            self.pleaseSelect.font=[UIFont systemFontOfSize:13];
            [self.frontView1 setFrame:CGRectMake(self.frontView1.frame.origin.x, self.frontView1.frame.origin.y - 15, self.frontView1.frame.size.width,  self.frontView1.frame.size.height + 15)];
            [self.masjidNameLabel setFrame:CGRectMake(self.masjidNameLabel.frame.origin.x, self.masjidNameLabel.frame.origin.y - 20, self.masjidNameLabel.frame.size.width, self.masjidNameLabel.frame.size.height)];
            [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y - 20, self.textView.frame.size.width, self.textView.frame.size.height+20)];
        } else if(IS_IPHONE_5) {
            self.eventTable.frame=CGRectMake(self.eventTable.frame.origin.x, self.eventTable.frame.origin.y,self.eventTable.frame.size.width,300);
            [self.frontView1 setFrame:CGRectMake(self.frontView1.frame.origin.x, self.frontView1.frame.origin.y - 3 , self.frontView1.frame.size.width,  self.frontView1.frame.size.height + 3)];
        } else {
            [self.frontView1 setFrame:CGRectMake(self.frontView1.frame.origin.x, self.frontView1.frame.origin.y + 10, self.frontView1.frame.size.width,  self.frontView1.frame.size.height - 10)];
            [self.masjidNameLabel setFrame:CGRectMake(self.masjidNameLabel.frame.origin.x, self.masjidNameLabel.frame.origin.y + 8, self.masjidNameLabel.frame.size.width, self.masjidNameLabel.frame.size.height)];
            [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y + 8, self.textView.frame.size.width, self.textView.frame.size.height)];
        }
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
    
    self.mapBtn.backgroundColor=[UIColor clearColor];
    [self.mapImage setImage:[UIImage imageNamed:@"map.png"]];
    self.eventBtn.backgroundColor=[UIColor clearColor];
    [self.eventImage setImage:[UIImage imageNamed:@"event.png"]];
    self.donationBtn.backgroundColor=[UIColor clearColor];
    [self.donationImage setImage:[UIImage imageNamed:@"donation.png"]];
    self.mapLabel.textColor=[UIColor whiteColor];
    self.donationLabel.textColor=[UIColor whiteColor];
    self.eventlabel.textColor=[UIColor whiteColor];
}

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

- (void)loadMasjidInfo
{
    [self showMasjidInfo];
    
    if ([self.masjid.favorite intValue] > 0) {
        BOOL alreadyLoaded = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%i", self.masjid.masjidId]];
        if (!alreadyLoaded) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%i", self.masjid.masjidId]];
            [self refreshAllData];
        }
        
        events = [[MTDBHelper sharedDBHelper] getEvents:self.masjid.masjidId];
        donations = [[MTDBHelper sharedDBHelper] getDonations:self.masjid.masjidId];
        timeTables = [[MTDBHelper sharedDBHelper] getMasjidTimeTablesWithMasjidId:self.masjid.masjidId];
        
        [self showTimetableInfo];
    } else {
        [self refreshAllData];
    }
}

- (void)showMasjidInfo
{
    [self.masjidNameLabel setText:self.masjid.name];
    [self.textView setText:[NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@",self.masjid.add_1,self.masjid.localArea,self.masjid.largerArea,self.masjid.postCode,self.masjid.country]];
}

- (void)showTimetableInfo
{
    [self configureTimetable];
    [self.footerTable reloadData];
}

- (NSDate *)endOfNextMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *months = [[NSDateComponents alloc] init];
    [months setMonth:2];
    NSDate *plusOneMonthDate = [calendar dateByAddingComponents:months toDate:[NSDate date] options:0];
    
    NSDateComponents *plusOneMonthDateComponents = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth
                                                               fromDate: plusOneMonthDate];
    
    return [[calendar dateFromComponents:plusOneMonthDateComponents] dateByAddingTimeInterval:-1];
}

- (NSDate *)startOfNextMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday fromDate:[NSDate date]];
    [components setMonth:[components month] + 1];
    [components setDay:1];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)endOfCurrentMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday
                                               fromDate:[NSDate date]];
    [components setMonth:[components month] + 1];
    [components setDay:0];
    
    return [calendar dateFromComponents:components];
}

- (void)configureTimetable
{
    if ([timeTables count] == 0) {
        self.timetableLabel.hidden = NO;
        self.timetableLabel.text = @"No valid timetable is currently available for this masjid";
        [self.timetableLabel setTextAlignment:NSTextAlignmentCenter];
        self.pageControl.numberOfPages = 0;
    } else {
        self.timetableLabel.hidden = YES;
        recognizer.enabled = YES;
        recognizer1.enabled = YES;
        self.timetableLabel.hidden = YES;
        self.pageControl.numberOfPages = 2;
        if (self.pageControl.currentPage == 0) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [Utils today], [self endOfCurrentMonth]];
            tempTimeTables = [timeTables filteredArrayUsingPredicate:predicate];
        } else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [self startOfNextMonth], [self endOfNextMonth]];
            tempTimeTables = [timeTables filteredArrayUsingPredicate:predicate];
        }
        [self.footerTable reloadData];
        
        if (tempTimeTables.count > 0) {
            MasjidTimetable *timetableFirst = [self getFirstTimeTable];
            MasjidTimetable *timetable = tempTimeTables[0];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormatter setDateFormat:@"MMMM yyyy"];
            
            NSString *currentMonthYear = [dateFormatter stringFromDate:timetableFirst.date];
            NSArray *components = [[timetable parsedDate] componentsSeparatedByString:@" "];
            NSString *currentMonth = [NSString stringWithFormat:@"%@",  components[1]];
            MasjidTimetable *lastestTimetable;
            if ([self.masjid.favorite intValue] > 0) {
                lastestTimetable = [[MTDBHelper sharedDBHelper] getLatestTimeTablewithID:self.masjid.masjidId];
            } else {
                lastestTimetable = [timeTables lastObject];
            }
            
            components = [[lastestTimetable parsedDate] componentsSeparatedByString:@" "];
            NSString *toMonthYear = [NSString stringWithFormat:@"%@ %@",  components[1], components[2]];
            
            self.headingLabel.text = [NSString stringWithFormat:@"%@ to %@ (%@)", currentMonthYear, toMonthYear, currentMonth];
        } else {
            MasjidTimetable *timetableFirst = [self getFirstTimeTable];
            self.timetableLabel.hidden = NO;
            self.timetableLabel.text = @"A timetable for this month has not been uploaded";
            [self.timetableLabel setTextAlignment:NSTextAlignmentCenter];
            
            if ([timeTables count] > 0) {
                MasjidTimetable *timetable = [timeTables objectAtIndex:0];
                
                NSCalendar* calendar = [NSCalendar currentCalendar];
                NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                           fromDate:[NSDate date]];
                NSDateFormatter *formate = [NSDateFormatter new];
                [formate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                NSString *mounthName;
                if (self.pageControl.currentPage == 0) {
                    mounthName = [[formate standaloneMonthSymbols] objectAtIndex:([components month] - 1)];
                } else {
                    mounthName = [[formate standaloneMonthSymbols] objectAtIndex:([components month])];
                }
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
                [dateFormatter setDateFormat:@"MMMM yyyy"];
                
                NSString *currentMonthYear = [dateFormatter stringFromDate:timetableFirst.date];
                NSArray *components1 = [[timetable parsedDate] componentsSeparatedByString:@" "];
                MasjidTimetable *lastestTimetable;
                if ([self.masjid.favorite intValue] > 0) {
                    lastestTimetable = [[MTDBHelper sharedDBHelper] getLatestTimeTablewithID:self.masjid.masjidId];
                } else {
                    lastestTimetable = [timeTables lastObject];
                }
                
                components1 = [[lastestTimetable parsedDate] componentsSeparatedByString:@" "];
                NSString *toMonthYear = [NSString stringWithFormat:@"%@ %@",  components1[1], components1[2]];
                self.headingLabel.text = [NSString stringWithFormat:@"%@ to %@ (%@)", currentMonthYear, toMonthYear, mounthName];
            } else {
                self.headingLabel.text = @"";
            }
        }
    }
}

- (void)updateTimetableInfo
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/timetable.php?masjid_id=%i", self.masjid.masjidId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[MTDBHelper sharedDBHelper] removeMasjidAllTimeTablesForMasjidId:self.masjid.masjidId];
                                                                                            if ([self.masjid.favorite intValue] > 0) {
                                                                                                [[MTDBHelper sharedDBHelper] updateTimetables:JSON forMasjid:self.masjid.masjidId];
                                                                                                self.masjid.timeTableUpdateDate = [Utils today];
                                                                                                [[MTDBHelper sharedDBHelper] saveContext];
                                                                                                
                                                                                                timeTables = [[MTDBHelper sharedDBHelper] getMasjidTimetablesToDate:[self endOfNextMonth] forMasjid:self.masjid.masjidId];
                                                                                            } else {
                                                                                                NSMutableArray *temp = [NSMutableArray array];
                                                                                                for (NSDictionary *attributes in JSON) {
                                                                                                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MasjidTimetable" inManagedObjectContext:[[MTDBHelper sharedDBHelper] managedObjectContext]];
                                                                                                    MasjidTimetable *timetable = [[MasjidTimetable alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
                                                                                                    [timetable setAttributes:attributes];
                                                                                                    [temp addObject:timetable];
                                                                                                }
                                                                                                
                                                                                                timeTables = [NSArray array];
                                                                                                timeTables = [NSArray arrayWithArray:temp];
                                                                                            }
                                                                                            
                                                                                            [self showTimetableInfo];
                                                                                            
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)JSON forKey:@"globalTimeTable"];
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)JSON forKey:@"globalTimeTable1"];
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)JSON forKey:@"globalTimeTable2"];
                                                                                            
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }
                                         
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD popActivity];
                                                                                            self.timetableLabel.hidden = NO;
                                                                                            self.timetableLabel.text = @"No valid timetable is currently available for this masjid";
                                                                                            [self.timetableLabel setTextAlignment:NSTextAlignmentCenter];
                                                                                            self.pageControl.numberOfPages = 0;                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }];
    [operation start];
    
}

- (void)updateMasjid
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/masjids.php?masjid_id=%i", self.masjid.masjidId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            if ([self.masjid.favorite intValue] > 0) {
                                                                                                [[MTDBHelper sharedDBHelper] updateMasjidWithAttributes:JSON[0]];
                                                                                            } else {
                                                                                                NSString *favorie = self.masjid.favorite;
                                                                                                [self.masjid setAttributes:JSON[0]];
                                                                                                [self.masjid setFavorite:favorie];
                                                                                            }
                                                                                            [self showMasjidInfo];
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            completedRequestCount += 1;
                                                                                            [SVProgressHUD popActivity];
                                                                                            [self popBack];
                                                                                        }];
    [operation start];
}

- (void)updateTimetableFormat
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"text/html"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/data/timetabledetails.php?masjid_id=%i", self.masjid.masjidId] parameters:nil];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
                                                                                            [[MTDBHelper sharedDBHelper] removeAllTimeTablesFormatForMasjidId:self.masjid.masjidId];
                                                                                            if ([self.masjid.favorite intValue] > 0) {
                                                                                                [[MTDBHelper sharedDBHelper] updateTimeTableFormats:JSON];
                                                                                            }
                                                                                            
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)JSON forKey:@"globalTimeTableFormat"];
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)JSON forKey:@"globalTimeTableFormat1"];
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)JSON forKey:@"globalTimeTableFormat2"];
                                                                                            
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }];
    [operation start];
}

- (void)updateDonations
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/data/donations.php?masjid_id=%i",self.masjid.masjidId] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            [[MTDBHelper sharedDBHelper] removeAllDonationsForMasjidId:self.masjid.masjidId];
                                                                                            if ([self.masjid.favorite intValue] > 0) {
                                                                                                [[MTDBHelper sharedDBHelper] updateDonations:responseObjct];
                                                                                                donations = [[MTDBHelper sharedDBHelper] getDonations:self.masjid.masjidId];
                                                                                            } else {
                                                                                                NSMutableArray *temp = [NSMutableArray array];
                                                                                                for (NSDictionary *attributes in responseObjct) {
                                                                                                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Donation" inManagedObjectContext:[[MTDBHelper sharedDBHelper] managedObjectContext]];
                                                                                                    Donation *donation = [[Donation alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
                                                                                                    [donation setAttributes:attributes];
                                                                                                    [temp addObject:donation];
                                                                                                }
                                                                                                
                                                                                                donations = [NSArray array];
                                                                                                donations = [NSArray arrayWithArray:temp];
                                                                                            }
                                                                                            
                                                                                            if (donations.count == 0) {
                                                                                                if (r == 0 && q == 1) {
                                                                                                    self.eventDonationLabel.hidden = NO;
                                                                                                    self.eventDonationLabel.text = @"There is no donation information for this masjid at this time";
                                                                                                }
                                                                                            } else {
                                                                                                self.eventDonationLabel.hidden = YES;
                                                                                                
                                                                                                [self.donationTable reloadData];
                                                                                            }
                                                                                            completedRequestCount += 1;
                                                                                            [SVProgressHUD popActivity];
                                                                                            [self popBack];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }];
    [operation start];
}

- (void)updateEvents
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com" ]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/data/events.php?masjid_id=%i",self.masjid.masjidId] parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            [[MTDBHelper sharedDBHelper] removeAllEventsForMasjidId:self.masjid.masjidId];
                                                                                            if ([self.masjid.favorite intValue] > 0) {
                                                                                                [[MTDBHelper sharedDBHelper] updateEvents:responseObjct];
                                                                                                events = [[MTDBHelper sharedDBHelper] getEvents:self.masjid.masjidId];
                                                                                            } else {
                                                                                                NSMutableArray *temp = [NSMutableArray array];
                                                                                                for (NSDictionary *attributes in responseObjct) {
                                                                                                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[[MTDBHelper sharedDBHelper] managedObjectContext]];
                                                                                                    Event *event = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
                                                                                                    [event setAttributes:attributes];
                                                                                                    [temp addObject:event];
                                                                                                }
                                                                                                
                                                                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"longDate >= %@", [Utils today]];
                                                                                                
                                                                                                events = [NSArray array];
                                                                                                events = [temp filteredArrayUsingPredicate:predicate];
                                                                                            }
                                                                                            
                                                                                            if (events.count == 0) {
                                                                                                if (q == 0 && r == 1) {
                                                                                                    self.eventDonationLabel.hidden = NO;
                                                                                                    self.eventDonationLabel.text = @"There are no events listed for this masjid at this time";
                                                                                                }
                                                                                            } else {
                                                                                                self.eventDonationLabel.hidden = YES;
                                                                                                [self.eventTable reloadData];
                                                                                            }
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }];
    [operation start];
    
}

- (void)updateNotes
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:[NSString stringWithFormat:@"/data/notes.php?masjid_id=%i", self.masjid.masjidId]  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[MTDBHelper sharedDBHelper] removeAllNotesForMasjidId:self.masjid.masjidId];
                                                                                            if ([self.masjid.favorite intValue] > 0) {
                                                                                                [[MTDBHelper sharedDBHelper] updateNotes:JSON];
                                                                                            }
                                                                                            
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)JSON forKey:@"globalMasjidNotes"];
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)JSON forKey:@"globalMasjidNotes1"];
                                                                                            [[NSUserDefaults standardUserDefaults] setObject:(NSArray*)JSON forKey:@"globalMasjidNotes2"];
                                                                                            
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                        }];
    [operation start];
}

- (void)updateRamadhanInfo
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [httpClient setDefaultHeader:@"Accept" value:@"text/html"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[NSString stringWithFormat:@"/data/ramadhantimetable.php?masjid_id=%i", self.masjid.masjidId] parameters:nil];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            [[MTDBHelper sharedDBHelper] removeAllRamadhansForMasjidId:self.masjid.masjidId];
                                                                                            if ([self.masjid.favorite intValue] > 0) {
                                                                                                [[MTDBHelper sharedDBHelper] updateRamadhans:JSON forMasjid:self.masjid.masjidId];
                                                                                            }
                                                                                            
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD popActivity];
                                                                                            completedRequestCount += 1;
                                                                                            [self popBack];
                                                                                        }];
    
    
    [operation start];
}


- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    self.pageControl.currentPage = 1;
    [self configureTimetable];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    self.pageControl.currentPage = 0;
    [self configureTimetable];
}

- (void)showDashBoard
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[ViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)designBtns
{
    self.primaryBtn.layer.borderColor = [[UIColor colorWithRed:112.0/255.0 green:249.0/255.0 blue:93.0/255.0 alpha:1.0]CGColor];
    self.scndBtn.layer.borderColor = [[UIColor colorWithRed:163.0/255.0 green:206.0/255.0 blue:246.0/255.0 alpha:1.0]CGColor];
    self.thrdBtn.layer.borderColor = [[UIColor colorWithRed:249.0/255.0 green:167.0/255.0 blue:112.0/255.0 alpha:1.0]CGColor];
    self.fourthBtn.layer.borderColor = [[UIColor colorWithRed:242.0/255.0 green:138.0/255.0 blue:199.0/255.0 alpha:1.0]CGColor];
    
    self.Label2.backgroundColor=[UIColor colorWithRed:163.0/255.0 green:206.0/255.0 blue:246.0/255.0 alpha:1.0];
    self.lable1.backgroundColor=[UIColor colorWithRed:112.0/255.0 green:249.0/255.0 blue:93.0/255.0 alpha:1.0];
    self.label3.backgroundColor=[UIColor colorWithRed:249.0/255.0 green:167.0/255.0 blue:112.0/255.0 alpha:1.0];
    self.label4.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:138.0/255.0 blue:199.0/255.0 alpha:1.0];
    
    float borderWidth = IS_IPAD ? 3.0f : 2.0f;
    self.primaryBtn.layer.borderWidth = borderWidth;
    self.scndBtn.layer.borderWidth = borderWidth;
    self.thrdBtn.layer.borderWidth = borderWidth;
    self.fourthBtn.layer.borderWidth = borderWidth;
}

- (void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)mapView
{
    if (p==0) {
        p=1;
        q=1;
        r=1;
        map.hidden=YES;
        self.line1.hidden=NO;
        self.line2.hidden=NO;
        [SVProgressHUD dismiss];
        self.left.hidden=NO;
        self.right.hidden=NO;
        self.footerView.hidden=NO;
        self.detailView.hidden=YES;
        self.mapLabel.textColor=[UIColor whiteColor];
        self.donationLabel.textColor=[UIColor whiteColor];
        self.eventlabel.textColor=[UIColor whiteColor];
        self.mapBtn.backgroundColor=[UIColor clearColor];
        [self.mapImage setImage:[UIImage imageNamed:@"map.png"]];
        
        self.eventBtn.backgroundColor=[UIColor clearColor];
        [self.eventImage setImage:[UIImage imageNamed:@"event.png"]];
        
        self.donationBtn.backgroundColor=[UIColor clearColor];
        [self.donationImage setImage:[UIImage imageNamed:@"donation.png"]];
    } else if (p==1) {
        p=0;
        q=1;
        r=1;
        self.line1.hidden=YES;
        self.line2.hidden=NO;
        self.left.hidden=YES;
        self.right.hidden=YES;
        self.footerView.hidden=YES;
        self.detailView.hidden=YES;
        map.hidden=NO;
        self.mapLabel.textColor=[UIColor lightGrayColor];
        self.donationLabel.textColor=[UIColor whiteColor];
        self.eventlabel.textColor=[UIColor whiteColor];
        self.mapBtn.backgroundColor=[UIColor darkGrayColor];
        [self.mapImage setImage:[UIImage imageNamed:@"map2nd.png"]];
        
        self.eventBtn.backgroundColor=[UIColor clearColor];
        [self.eventImage setImage:[UIImage imageNamed:@"event.png"]];
        
        self.donationBtn.backgroundColor=[UIColor clearColor];
        [self.donationImage setImage:[UIImage imageNamed:@"donation.png"]];
        NSString *location=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",self.masjid.add_1,self.masjid.localArea,self.masjid.largerArea,self.masjid.postCode,self.masjid.country];
        if (o==0) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:location
                         completionHandler:^(NSArray* placemarks, NSError* error){
                             if (placemarks && placemarks.count > 0) {
                                 CLPlacemark *topResult = [placemarks objectAtIndex:0];
                                 MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                                 
                                 MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(placemark.location.coordinate ,METERS_PER_MILE, METERS_PER_MILE);
                                 
                                 [map setRegion:viewRegion animated:YES];
                                 [map addAnnotation:placemark];
                                 o=1;
                             } else {
                                 o=1;

                                 UIAlertController *timeLimitAlert = [UIAlertController alertControllerWithTitle:@"Error " message:@"Error resolving address check you address and try again" preferredStyle:UIAlertControllerStyleAlert];
                                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                 [timeLimitAlert addAction:ok];
                                 [self presentViewController:timeLimitAlert animated:YES completion:nil];

                             }
                         }
             ];
        }
    }
}

- (IBAction)eventView
{
    if (q==0) {
        p=1;
        q=1;
        r=1;
        self.line1.hidden=NO;
        self.line2.hidden=NO;
        map.hidden=YES;
        self.left.hidden=NO;
        self.right.hidden=NO;
        self.footerView.hidden=NO;
        self.detailView.hidden=YES;
        self.mapLabel.textColor=[UIColor whiteColor];
        self.donationLabel.textColor=[UIColor whiteColor];
        self.eventlabel.textColor=[UIColor whiteColor];
        self.mapBtn.backgroundColor=[UIColor clearColor];
        [self.mapImage setImage:[UIImage imageNamed:@"map.png"]];
        
        self.eventBtn.backgroundColor=[UIColor clearColor];
        [self.eventImage setImage:[UIImage imageNamed:@"event.png"]];
        
        self.donationBtn.backgroundColor=[UIColor clearColor];
        [self.donationImage setImage:[UIImage imageNamed:@"donation.png"]];
    } else if (q==1) {
        p=1;
        q=0;
        r=1;
        self.line1.hidden=YES;
        self.line2.hidden=YES;
        self.left.hidden=YES;
        self.right.hidden=YES;
        self.footerView.hidden=YES;
        self.detailView.hidden=NO;
        self.map.hidden=YES;
        self.eventTable.hidden=NO;
        self.donationTable.hidden=YES;
        self.titleLabel.text=@"Events";
        self.mapLabel.textColor=[UIColor whiteColor];
        self.donationLabel.textColor=[UIColor whiteColor];
        self.eventlabel.textColor=[UIColor lightGrayColor];
        self.eventBtn.backgroundColor=[UIColor darkGrayColor];
        [self.eventImage setImage:[UIImage imageNamed:@"event2nd.png"]];
        self.mapBtn.backgroundColor=[UIColor clearColor];
        [self.mapImage setImage:[UIImage imageNamed:@"map.png"]];
        self.donationBtn.backgroundColor=[UIColor clearColor];
        [self.donationImage setImage:[UIImage imageNamed:@"donation.png"]];
        [self.eventTable reloadData];
        if ([events count] == 0) {
            self.eventDonationLabel.hidden = NO;
            self.eventDonationLabel.text = @"There are no events listed for this masjid at this time";
            [self.eventDonationLabel setTextAlignment:NSTextAlignmentCenter];
            [self.eventTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        }  else {
            self.eventDonationLabel.hidden = YES;
        }
    }
}

- (IBAction)donationView
{
    if (r==0) {
        p=1;
        q=1;
        r=1;
        map.hidden=YES;
        self.line1.hidden=NO;
        self.line2.hidden=NO;
        self.left.hidden=NO;
        self.right.hidden=NO;
        self.footerView.hidden=NO;
        self.detailView.hidden=YES;
        self.mapLabel.textColor=[UIColor whiteColor];
        self.donationLabel.textColor=[UIColor whiteColor];
        self.eventlabel.textColor=[UIColor whiteColor];
        self.mapBtn.backgroundColor=[UIColor clearColor];
        [self.mapImage setImage:[UIImage imageNamed:@"map.png"]];
        self.eventBtn.backgroundColor=[UIColor clearColor];
        [self.eventImage setImage:[UIImage imageNamed:@"event.png"]];
        self.donationBtn.backgroundColor=[UIColor clearColor];
        [self.donationImage setImage:[UIImage imageNamed:@"donation.png"]];
    } else if (r==1) {
        p=1;
        q=1;
        r=0;
        self.line1.hidden=NO;
        self.line2.hidden=YES;
        self.footerView.hidden=YES;
        self.map.hidden=YES;
        self.left.hidden=YES;
        self.right.hidden=YES;
        self.eventTable.hidden=YES;
        self.donationTable.hidden=NO;
        self.detailView.hidden=NO;
        self.titleLabel.text=@"Donations";
        
        self.mapLabel.textColor=[UIColor whiteColor];
        self.donationLabel.textColor=[UIColor lightGrayColor];
        self.eventlabel.textColor=[UIColor whiteColor];
        
        self.mapBtn.backgroundColor=[UIColor clearColor];
        [self.mapImage setImage:[UIImage imageNamed:@"map.png"]];
        
        self.eventBtn.backgroundColor=[UIColor clearColor];
        [self.eventImage setImage:[UIImage imageNamed:@"event.png"]];
        
        self.donationBtn.backgroundColor=[UIColor darkGrayColor];
        [self.donationImage setImage:[UIImage imageNamed:@"donation2nd.png"]];
        [self.donationTable reloadData];
        
        if ([donations count] == 0) {
            self.eventDonationLabel.hidden = NO;
            self.eventDonationLabel.text = @"There is no donation information for this masjid at this time";
            [self.donationTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.eventDonationLabel setTextAlignment:NSTextAlignmentCenter];
        } else {
            self.eventDonationLabel.hidden = YES;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.donationTable) {
        return [donations count];
    } else if (tableView == self.footerTable) {
        return [tempTimeTables count];
    } else {
        return [events count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableViews==self.footerTable) {
        static NSString *simple = @"SimpleTableItem";
        timeTable *cell = (timeTable *)[tableViews dequeueReusableCellWithIdentifier:simple];
        MasjidTimetable *timetable = [tempTimeTables objectAtIndex:indexPath.row];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"timeTable" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0 && self.pageControl.currentPage == 0 && [[NSCalendar currentCalendar] isDateInToday:timetable.date]) {
            UIColor *setingColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
            cell.date.textColor = setingColor;
            cell.fezarB.textColor = setingColor;
            cell.fazarJ.textColor = setingColor;
            cell.sunrise.textColor = setingColor;
            cell.zoharB.textColor = setingColor;
            cell.zoharJ.textColor = setingColor;
            cell.asarB.textColor = setingColor;
            cell.asarJ.textColor = setingColor;
            cell.magribB.textColor = setingColor;
            cell.magribJ.textColor = setingColor;
            cell.eshaB.textColor = setingColor;
            cell.eshaJ.textColor = setingColor;
            cell.bStart.textColor = setingColor;
            cell.bEnd.textColor = setingColor;
        }
        
        cell.date.text = [timetable parsedShortDate];
        cell.fezarB.text = timetable.subahsadiq;
        cell.fazarJ.text = timetable.fajar;
        cell.sunrise.text = timetable.sunrise;
        cell.zoharB.text = timetable.zohar;
        cell.zoharJ.text = timetable.zoharj;
        cell.asarB.text = timetable.asar;
        cell.asarJ.text = timetable.asarj;
        cell.magribB.text = timetable.sunset;
        cell.magribJ.text = timetable.maghrib;
        cell.eshaB.text = timetable.esha;
        cell.eshaJ.text = timetable.eshaj;
        
        return cell;
    } else {
        static NSString *simple = @"SimpleTableItem";
        NSString *text;
        MasjidDetailTableCell *cell = (MasjidDetailTableCell *)[tableViews dequeueReusableCellWithIdentifier:simple];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MasjidDetailTableCell" owner:self options:nil];
            
            cell = [nib objectAtIndex:0];
            [cell.donationText setLineBreakMode:NSLineBreakByWordWrapping];
            [cell.donationText setMinimumScaleFactor:FONT_SIZE];
            
            [cell.donationText setNumberOfLines:0];
            [cell.donationText setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [cell.donationText setTag:1];
            cell.donationText.textColor=[UIColor whiteColor];
        }
        if (tableViews == self.donationTable) {
            float fontSize = IS_IPAD ? 18 : 12;
            Donation *donation = [donations objectAtIndex:indexPath.row];
            cell.seperatorView.hidden = indexPath.row == 0 ? YES : NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dateTimeLabel.hidden=YES;
            cell.donationLabel.hidden=YES;
            cell.timeLabel.hidden=YES;
            if (donation.live == 0) {
                cell.bankDetails.hidden=YES;
                cell.donationButton.hidden=YES;
                cell.donationImage.hidden=YES;
                self.donationTable.separatorColor=[UIColor clearColor];
                self.eventDonationLabel.hidden = NO;
                self.eventDonationLabel.text = @"There is no donation information for this masjid at this time";
            } else if(donation.live == 1) {
                cell.bankDetails.hidden=NO;
                cell.donationButton.hidden=NO;
                cell.donationImage.hidden=NO;
                cell.donationText.hidden=NO;
                cell.bankDetails.text = donation.bankDetails;
                text = donation.encouragementText;
                if (text.length==0 || cell.bankDetails.text==0) {
                    cell.donationImage.hidden=YES;
                    cell.donationButton.hidden=YES;
                }
                cell.bankDetails.textColor = [UIColor colorWithRed:168/255.0 green:217/255.0 blue:231/255.0 alpha:1.0];
                cell.donationText.textColor = [UIColor colorWithRed:244/255.0 green:233/255.0 blue:212/255.0 alpha:1.0];
                cell.bankDetails.font=[UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
                cell.donationText.font=[UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
                UIFont *cellFont = cell.donationText.font;
                CGSize constraintSize;
                if (IS_IPAD) {
                    constraintSize = CGSizeMake(700, MAXFLOAT);
                } else if(IS_IPHONE_6P) {
                    constraintSize = CGSizeMake(340, MAXFLOAT);
                } else if(IS_IPHONE_6) {
                    constraintSize = CGSizeMake(340, MAXFLOAT);
                } else {
                    constraintSize = CGSizeMake(280, MAXFLOAT);
                }
                
                NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: cellFont}];
                NSAttributedString *attributedText1 = [[NSAttributedString alloc] initWithString:donation.bankDetails attributes:@{NSFontAttributeName: cellFont}];
                
                CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                           context:nil];
                
                CGRect rect1 = [attributedText1 boundingRectWithSize:constraintSize
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                             context:nil];
                
                CGRect frame = cell.donationText.frame;
                frame.size = rect.size;
                frame.origin.y = cell.donationText.frame.origin.y;
                frame.size.height = rect.size.height+5;
                cell.donationText.frame = frame;
                [cell.donationText setText:text];
                cell.bankDetails.frame = CGRectMake(frame.origin.x, frame.size.height+8, rect1.size.width, rect1.size.height);
                
                paypalCode = donation.paypalCode;
                if (paypalCode.length > 0) {
                    [cell.donationButton setHidden:NO];
                    [cell.donationImage setHidden:NO];
                    
                    [cell.donationImage setImage:[UIImage imageNamed:@"donate-online-6-plus.png"]];
                    cell.donationButton.frame = CGRectMake((cell.contentView.frame.size.width - self.view.frame.size.width*3/4)/2,cell.contentView.frame.size.height - self.view.frame.size.width*0.19*3/4 - 10, self.view.frame.size.width*3/4, self.view.frame.size.width*0.19*3/4 );
                    cell.donationImage.frame = CGRectMake((cell.contentView.frame.size.width - self.view.frame.size.width*3/4)/2,cell.contentView.frame.size.height - self.view.frame.size.width*0.19*3/4 - 10,self.view.frame.size.width*3/4,self.view.frame.size.width*0.19*3/4 );
                    
                    cell.bankDetails.textColor=[UIColor colorWithRed:168/255.0 green:217/255.0 blue:231/255.0 alpha:1.0];
                    cell.donationText.textColor=[UIColor colorWithRed:244/255.0 green:233/255.0 blue:212/255.0 alpha:1.0];
                    cell.donationText.textAlignment = NSTextAlignmentJustified;
                    cell.donationButton.tag=indexPath.row;
                    
                    NSRange range = [paypalCode rangeOfString:@"<input" options:NSBackwardsSearch];
                    NSRange range1 = [paypalCode rangeOfString:@"value=" options:NSBackwardsSearch];
                    NSRange range2 = [paypalCode rangeOfString:@"border="];
                    
                    int firstCharacterPosition1 = (int)range1.location+7;
//                    int firstCharacterPosition2 = (int)range2.location-14; // @ivan
                    int firstCharacterPosition = (int)range.location-3;
                    //if (firstCharacterPosition2 < 0 || firstCharacterPosition1 < 0 || firstCharacterPosition < 0  ) {
                    if (range1.location == NSNotFound || range2.location == NSNotFound || range.location == NSNotFound  ) {
                        [cell.donationButton addTarget:self action:@selector(btnprev:) forControlEvents:UIControlEventTouchUpInside];
                    } else {
                        NSString *subString = [paypalCode substringWithRange: NSMakeRange([paypalCode rangeOfString: @"value="options:NSBackwardsSearch].location+7,firstCharacterPosition-firstCharacterPosition1)];
                        NSString *url=[NSString stringWithFormat:@"%@%@",@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=",subString];
                        paypalCode=url;
                        [cell.donationButton addTarget:self action:@selector(btnprev:) forControlEvents:UIControlEventTouchUpInside];
                    }
                } else {
                    [cell.donationButton setHidden:YES];
                    [cell.donationImage setHidden:YES];
                }
            }
        } else  {
            Event *event = [events objectAtIndex:indexPath.row];
            float fontSize = IS_IPAD ? 18.0 : 12.0;
            cell.seperatorView.hidden = indexPath.row == 0 ? YES : NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.donationButton.hidden=YES;
            cell.donationImage.hidden=YES;
            cell.bankDetails.hidden=YES;
            cell.dateTimeLabel.text = [NSString stringWithFormat:@"%@", event.date];
            cell.timeLabel.text = event.time;
            cell.donationLabel.text = event.title;
            cell.donationLabel.textColor=[UIColor colorWithRed:168/255.0 green:217/255.0 blue:231/255.0 alpha:1.0];
            text = event.details;
            cell.donationText.font=[UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
            UIFont *cellFont =[UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
            CGSize constraintSize;
            if (IS_IPAD) {
                constraintSize = CGSizeMake(700, MAXFLOAT);
            } else if(IS_IPHONE_6P) {
                constraintSize = CGSizeMake(340, MAXFLOAT);
            } else if(IS_IPHONE_6) {
                constraintSize = CGSizeMake(340, MAXFLOAT);
            } else {
                constraintSize = CGSizeMake(280, MAXFLOAT);
            }
            
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: cellFont}];
            CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            CGRect frame = cell.donationText.frame;
            frame.size = rect.size;
            frame.origin.y=cell.donationText.frame.origin.y+45;
            frame.size.height = rect.size.height + 5;
            cell.donationText.frame = frame;
            [cell.donationText setText:text];
            cell.donationText.textColor=[UIColor colorWithRed:244/255.0 green:233/255.0 blue:212/255.0 alpha:1.0];
            cell.donationText.textAlignment=NSTextAlignmentJustified;
        }
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat row = 0.0;
    if (tableView==self.footerTable) {
        row=56;
    } else if(tableView==self.eventTable) {
        float fontSize = IS_IPAD ? 18.0 : 12.0;
        Event *event = [events objectAtIndex:indexPath.row];
        CGSize constraintSize ;
        if (IS_IPAD) {
            constraintSize = CGSizeMake(700, MAXFLOAT);
        } else if(IS_IPHONE_6P) {
            constraintSize = CGSizeMake(340, MAXFLOAT);
        } else if(IS_IPHONE_6) {
            constraintSize = CGSizeMake(340, MAXFLOAT);
        } else {
            constraintSize = CGSizeMake(280, MAXFLOAT);
        }
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:event.details attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:fontSize]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        row = rect.size.height + 60;
        
    } else if (tableView==self.donationTable) {
        Donation *donation = [donations objectAtIndex:indexPath.row];
        if (donation.live == 0) {
            row=40;
        } else if (donation.live == 1) {
            float fontSize = IS_IPAD ? 18.0 : 12.0;
            CGSize constraintSize;
            if (IS_IPAD) {
                constraintSize = CGSizeMake(700, MAXFLOAT);
            }else if(IS_IPHONE_6P) {
                constraintSize = CGSizeMake(340, MAXFLOAT);
            } else if(IS_IPHONE_6) {
                constraintSize = CGSizeMake(340, MAXFLOAT);
            } else  {
                constraintSize = CGSizeMake(290, MAXFLOAT);
            }
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:donation.encouragementText attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:fontSize]}];
            CGRect rect = [attributedText boundingRectWithSize:constraintSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
            
            NSAttributedString *attributedText1 = [[NSAttributedString alloc] initWithString:donation.bankDetails attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Arial-BoldMT" size:fontSize]}];
            CGRect rect1 = [attributedText1 boundingRectWithSize:constraintSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil];
            
            int addedCount = IS_IPAD ? 250 : 160;
            row = rect.size.height + rect1.size.height + addedCount;
        }
    }
    
    return row;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

-(void)btnprev:(UIButton*)sender
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:paypalCode]];
    
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:paypalCode];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

- (IBAction)setPriority:(UIButton *)sender
{
    @try {
        int priority = (int)sender.tag + 1;
        NSString *favorite = @"0";
        Masjid *oldMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:[NSString stringWithFormat:@"%i", priority]];
        if (oldMasjid != nil) {
            [oldMasjid setFavorite:favorite];
            [[MTDBHelper sharedDBHelper] updateMasjidWithAttributes:[oldMasjid getAttributes]];
            if (oldMasjid.masjidId != self.masjid.masjidId) {
                favorite = [NSString stringWithFormat:@"%i", priority];
            }
        } else {
            favorite = [NSString stringWithFormat:@"%i", priority];
        }
        
        [self.masjid setFavorite:favorite];
        [[MTDBHelper sharedDBHelper] updateMasjidWithAttributes:[self.masjid getAttributes]];
        
        self.masjidList.needUpdateLocalNotifications = YES;
        
        if ([self.masjid.favorite intValue] > 0) {
            isPriorityButtonClicked = YES;
            completedRequestCount = 0;
            [self refreshAllData];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%i", self.masjid.masjidId]];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    @catch (NSException *exception) {
        
    }
}

- (IBAction)callAction {
    NSString *phNo = self.masjid.telephone;
    if (phNo.length==0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"A phone number has not been stored for this masjid yet" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else
    {
        NSURL *URL = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:URL])
        {
            [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"Opened url");
                }
            }];
        }
        else
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Call facility is not available on your device!!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (IBAction)goLeft
{
    self.pageControl.currentPage = 0;
    [self configureTimetable];
}

- (IBAction)goRight
{
    self.pageControl.currentPage = 1;
    [self configureTimetable];
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)refreshAllData
{
    [self updateMasjid];
    [self updateTimetableInfo];
    [self updateTimetableFormat];
    [self updateEvents];
    [self updateDonations];
    if ([self.masjid.favorite intValue] > 0) {
        [self updateRamadhanInfo];
        [self updateNotes];
    }
}

- (void)popBack
{
    if (completedRequestCount == 7 && isPriorityButtonClicked ) {
        if (self.masjidList) {
            [self.navigationController popToViewController:self.masjidList animated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (MasjidTimetable *)getFirstTimeTable
{
    MasjidTimetable *currentTimetable;
    NSDate *today = [Utils today];
    
    if ([timeTables count] > 0) {
        for (int i =  0; i < [timeTables count]; i++) {
            NSPredicate *predicate;
            if (i != 0) {
                predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [Utils startOfMonth:i], [Utils endOfMonth:i+1]];
            } else {
                predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", today, [Utils endOfMonth:1]];
            }
            NSArray *mountlyData = [timeTables filteredArrayUsingPredicate:predicate];
            if ([mountlyData count] > 0 && !currentTimetable) {
                currentTimetable = mountlyData[0];
                break;
            }
        }
    }
    
    return currentTimetable;
}

@end
