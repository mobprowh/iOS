//
//  ScrollViewWithPaging.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface ScrollViewWithPaging : UIViewController<UIScrollViewDelegate>
{
    BOOL canRotateToAllOrientations;
    NSMutableArray *viewControllers;
    BOOL pageControlUsed;
    int pageNumber,pValue;
    NSArray *date,*bTime,*jTime,*fazar,*fazarJ,*sunrise,*zohar,*zoharJ,*asar,*asarJ,*maghrib,*maghribJ,*esha,*eshaJ;
    NSInteger month,month1,get,year,day;
    NSMutableArray *currentMonthData;
    NSString *myMonthString;
    NSString *monthStringVal;
    int setPriority;
    NSMutableArray *currentDateArray;
    NSUInteger kNumberOfPages;

}

@property (strong, nonatomic) IBOutlet UIButton *dashboardBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *navBar;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (strong, nonatomic) IBOutlet UIView *landscapeView;
@property (strong, nonatomic) IBOutlet UIImageView *backVIew;
@property (strong, nonatomic) IBOutlet UITableView *timeTable;
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (strong, nonatomic) IBOutlet UIImageView *outline;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *backImage1;
@property (strong, nonatomic) IBOutlet UIPageControl *landscapePage;

- (IBAction)cancelView;
- (IBAction)moveRight;
- (IBAction)moveLeft;
- (IBAction)backbtn;

@end
