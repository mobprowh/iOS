//
//  TimeTableView.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "AFNetworking.h"
//#import "PayPalMobile.h"

@class TimeTableContentView;

@interface TimeTableView : BaseViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    UIImageView *needleImageView;
    float speedometerCurrentValue;
    float prevAngleFactor;
    float angle;
    NSTimer *speedometer_Timer;
    UILabel *speedometerReading;
    NSString *maxVal;
}

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIButton *dashbrdBtn;
@property (strong, nonatomic) IBOutlet UIImageView *arabicTimeTabel;
@property (strong, nonatomic) IBOutlet UILabel *navTimeTable;
@property (strong, nonatomic) IBOutlet UILabel *navDate;
@property (strong, nonatomic) IBOutlet UIImageView *navImage;

@property (strong, nonatomic) IBOutlet UIButton *leftbtn;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;

-(void)setSpeedometerCurrentValue;
- (void)checkForMasjidsTimeTablesUpdate;
- (IBAction)popView;

@end
