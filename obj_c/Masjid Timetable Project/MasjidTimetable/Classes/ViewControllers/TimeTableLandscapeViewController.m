//
//  TimeTableLandscapeViewController.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/16/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "TimeTableLandscapeViewController.h"
#import "TimeTableLanscapeContainerView.h"
#import "timeTable.h"

#define NAVIGATIONHEIGHT          55.0

@interface TimeTableLandscapeViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *timeTableData;
    NSMutableArray *mounthsData;
    NSMutableArray *mounthView;
    BOOL isScrollItemsSetted;
    BOOL isOtherTablesCreated;
}
@end

@implementation TimeTableLandscapeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mounthsData = [NSMutableArray array];
    mounthView = [NSMutableArray array];
    
    timeTableData = [[MTDBHelper sharedDBHelper] getMasjidTimeTablesWithMasjidId:(int)self.masjidId];
    isScrollItemsSetted = NO;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!isScrollItemsSetted) {
        [self getInfoForScrollViewItems];
        isScrollItemsSetted = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.scrollView = nil;
    
    [super viewWillDisappear:animated];
}

- (void)getInfoForScrollViewItems
{
    NSDate *today = [Utils today];
    
    if ([timeTableData count] > 0) {
        for (int i =  0; i < [timeTableData count]; i++) {
            NSPredicate *predicate;
            if (i != 0) {
                predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", [Utils startOfMonth:i], [Utils endOfMonth:i+1]];
            } else {
                predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", today, [Utils endOfMonth:1]];
            }
            NSArray *mountlyData = [timeTableData filteredArrayUsingPredicate:predicate];
            if ([mountlyData count] > 0) {
                [mounthsData addObject:mountlyData];
            }
            if ([mounthsData count] == 12) {
                break;
            }
        }
    }
    
    if ([mounthsData count] > 0) {
        [self setPageInfo];
        [self setScrollViewItems];
    } else {
        [self showEmptyTable];
    }
}

- (void)setPageInfo
{
    NSDate *today = [Utils today];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d MMM yyyy"];
    NSString *todayDateString = [dateFormatter stringFromDate:today];
    
    MasjidTimetable *firstTimetable = [mounthsData[0] objectAtIndex:0];
    MasjidTimetable *secondTimetable  = [[mounthsData lastObject] objectAtIndex:0];
    
    [dateFormatter setDateFormat:@"MMM yyyy"];
    NSString *interval;
    if (firstTimetable && secondTimetable) {
        interval = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:firstTimetable.date], [dateFormatter stringFromDate:secondTimetable.date]];
    }
    NSString *month = [[firstTimetable parsedDate] componentsSeparatedByString:@" "][1];
    
    [self.masjidNameLabel setText:self.masjidName];
    [self.navigationRightLabel setText:todayDateString];
    [self.navigationLeftLabel setText:interval];
    [self.navigationCenterLabel setText:[NSString stringWithFormat:@"Viewing %@", month]];
}

- (void)setScrollViewItems
{
    [self.scrollView setContentSize:CGSizeMake(ScreenSizeWidth* [mounthsData count], ScreenSizeHeight)];
    [self.scrollView setPagingEnabled:YES];
    [self.pageController setNumberOfPages:[mounthsData count]];
    
    CGRect pageControllRect = self.pageController.frame;
    pageControllRect.origin.x = pageControllRect.origin.x - 5 * [mounthsData count];
    self.pageController.frame = pageControllRect;
    CGRect masjidNameFrame = self.masjidNameLabel.frame;
    masjidNameFrame.size.width = pageControllRect.origin.x - 20;
    self.masjidNameLabel.frame = masjidNameFrame;
    if (IS_IPAD) {
     [self.customNavigationBar setFrame:CGRectMake(self.customNavigationBar.frame.origin.x, self.customNavigationBar.frame.origin.y, self.customNavigationBar.frame.size.width,NAVIGATIONHEIGHT)];
        [self.navigationLeftLabel setFrame:CGRectMake(self.navigationLeftLabel.frame.origin.x, self.navigationLeftLabel.frame.origin.y + 8, self.navigationLeftLabel.frame.size.width,self.navigationLeftLabel.frame.size.height)];
        [self.navigationCenterLabel setFrame:CGRectMake(self.navigationCenterLabel.frame.origin.x, self.navigationCenterLabel.frame.origin.y + 8, self.navigationCenterLabel.frame.size.width,self.navigationCenterLabel.frame.size.height)];
        [self.navigationRightLabel setFrame:CGRectMake(self.navigationRightLabel.frame.origin.x, self.navigationRightLabel.frame.origin.y + 8, self.navigationRightLabel.frame.size.width,self.navigationRightLabel.frame.size.height)];
        [self.masjidNameLabel setFrame:CGRectMake(self.masjidNameLabel.frame.origin.x, self.masjidNameLabel.frame.origin.y + 10, self.masjidNameLabel.frame.size.width,self.masjidNameLabel.frame.size.height)];
        [self.pageController setFrame:CGRectMake(self.pageController.frame.origin.x, self.pageController.frame.origin.y + 10, self.pageController.frame.size.width, self.pageController.frame.size.height)];
        [self.scrollView setFrame:CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y + 10 , self.scrollView.frame.size.width, self.scrollView.frame.size.height - 15)];
        [self.scrollView setContentSize:CGSizeMake(ScreenSizeWidth* [mounthsData count], ScreenSizeHeight - 15)];
    }
    for (int i = 0 ; i < [mounthsData count]; i++) {
        if (i == 2 ) break;
        TimeTableLanscapeContainerView *view = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableLanscapeContainerView" owner:nil options:nil] lastObject];
        float count = IS_IPAD ? 86 : 76;
        [view setFrame:CGRectMake(15 + self.view.bounds.size.width * i, 70, self.view.bounds.size.width - 30, self.view.bounds.size.height - count )];
        [view.tableView setTag:i];
        [view.tableView setDelegate:self];
        [view.tableView setDataSource:self];

        [self.scrollView addSubview:view];
        [mounthView addObject:view];
    }
}

- (void)showEmptyTable
{
    TimeTableLanscapeContainerView *view = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableLanscapeContainerView" owner:nil options:nil] lastObject];
    [view setFrame:CGRectMake(15, 70, self.view.bounds.size.width - 30, self.view.bounds.size.height - 76 )];
    view.noDataLabel.text = self.masjidId ? @"There is no data available for this masjid" : @"";
    [self.scrollView addSubview:view];
    [self.pageController setNumberOfPages:0];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[mounthsData objectAtIndex:tableView.tag] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simple = @"timeTableLandscape";
    timeTable *cell = (timeTable *)[tableView dequeueReusableCellWithIdentifier:simple];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"timeTable" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == 0 && tableView.tag == 0) {
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
    
    MasjidTimetable *timetable = [[mounthsData objectAtIndex:tableView.tag] objectAtIndex:indexPath.row];
    cell.date.frame = CGRectMake(cell.date.frame.origin.x + 5, cell.date.frame.origin.y , cell.date.frame.size.width - 10, cell.date.frame.size.height);
    
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
}

#pragma mark - ScrollView Delegates

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    int pageNumber = (int)lround(fractionalPage);
    [self.pageController setCurrentPage:pageNumber];
    
    MasjidTimetable *firstTimetableItem;
    NSArray *mounthData = [mounthsData objectAtIndex:pageNumber];
    if ([mounthsData count] > 0) {
        firstTimetableItem = mounthData[0];
        NSString *month = [[firstTimetableItem parsedDate] componentsSeparatedByString:@" "][1];
        [self.navigationCenterLabel setText:[NSString stringWithFormat:@"Viewing %@", month]];
        
        if (!isOtherTablesCreated && mounthsData.count > 2) {
            for (int i = 2; i < [mounthsData count]; i ++) {
                TimeTableLanscapeContainerView *view = [[[NSBundle mainBundle]loadNibNamed:@"TimeTableLanscapeContainerView" owner:nil options:nil] lastObject];
                [view setFrame:CGRectMake(15 + self.view.bounds.size.width * i, 70, self.view.bounds.size.width - 30, self.view.bounds.size.height - 76 )];
                [view.tableView setTag:i];
                [view.tableView setDelegate:self];
                [view.tableView setDataSource:self];
                
                [self.scrollView addSubview:view];
                [mounthView addObject:view];
            }
        }
        isOtherTablesCreated = YES;
    }
}

@end
