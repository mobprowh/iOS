//
//  TodayViewController.m
//  MasjidWidget
//
//  Created by Manpreet Singh on 6/3/16.
//  Copyright © 2016 Lentrica Software. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#import "MTDBHelper.h"
#import "Utils.h"
#import "TimeTableContentView.h"
#import <CoreData/CoreData.h>
#import "Constants.h"

@interface TodayViewController () <NCWidgetProviding>
{
  BOOL isTimeFormat24;
  MasjidTimetable *page1TimeTable;
  TimeTableContentView *currentView;
  TimeTableContentView *firstView;
  TimeTableFormat *currentTimeFormat;
  TimeTableFormat *page1TimeTableFormat;
    NSString *frstPrayerText;
    NSString *secondPrayerText;
    NSString *comingEventTime;
    BOOL isEventNotStart;
    NSInteger count;
    NSString *dateString;
    int meterGour,meterMin,meterSeconds;
}
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:AppGroupsID];
  isTimeFormat24 = [[userDefault valueForKey:@"format12"] boolValue];
  //[self setMasjidsInfo];
  //NSLog(@"%@",[Utils today]);
    _backgroundView.layer.cornerRadius = _backgroundView.frame.size.width/2;
    _borderView.layer.cornerRadius = _borderView.frame.size.width/2;
    _borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _borderView.layer.borderWidth = 1;
    self.preferredContentSize = CGSizeMake(0, 160);
    int masjidID = (int)[userDefault integerForKey:@"masjidIDM"];
    page1TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjidID forDate:[Utils today]];
    page1TimeTableFormat = [[MTDBHelper sharedDBHelper]  getCurrentMontTimeTableFormat:masjidID];

  
    [self setMidleViewInfoWithPageNumber:0];
    [self getTime:page1TimeTable];
    
    if (IS_IOS_10_OR_LATER)
    {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
    
  //NSLog(@"%@",self.view.subviews);
  /*
  [self setLayerToView:self.sunriseBottomLabel];
  [self setLayerToView:self.beginingLabel];
  [self setLayerToView:self.jamatNameLabel];
  [self setLayerToView:self.fajarTitleLabel];
  [self setLayerToView:self.zoharTitleLabel];
  [self setLayerToView:self.asarTitlelabel];
  [self setLayerToView:self.maghribTitleLabel];
  [self setLayerToView:self.eshaTitleLabel];
  [self setLayerToView:self.fajarLabel];
  [self setLayerToView:self.zoharLabel];
  [self setLayerToView:self.asarlabel];
  [self setLayerToView:self.maghribLabel];
  [self setLayerToView:self.eshaLabel];
  [self setLayerToView:self.fajarJLabel];
  [self setLayerToView:self.zoharJlabel];
  [self setLayerToView:self.asarJLabel];
  [self setLayerToView:self.maghribJLabel];
  [self setLayerToView:self.eshaJLabel];
  [self setLayerToView:self.sunriselabel];

  
    [self setLayerToView:self.fajarTitleLabel];
    [self setLayerToView:self.zoharTitleLabel];
    [self setLayerToView:self.asarTitlelabel];
    [self setLayerToView:self.maghribTitleLabel];
    [self setLayerToView:self.eshaTitleLabel];
    [self setLayerToView:self.sunriseBottomLabel];
   */
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize
{
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        self.preferredContentSize = CGSizeMake(0.0, 160.0);
    } else if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = maxSize;
    }
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsZero;
}

- (void)setLayerToView:(id)view {
    
  /*
  if ([view isKindOfClass:[UILabel class]]) {
    ((UILabel*)view).layer.borderWidth = 0.5f;
    ((UILabel*)view).layer.borderColor = [[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:247.0/255.0 alpha:1.0] CGColor];
  }
  else if ([view isKindOfClass:[UITextField class]]) {
    ((UITextField*)view).layer.borderWidth = 0.5f;
    ((UITextField*)view).layer.borderColor = [[UIColor  colorWithRed:0.0/255.0 green:255.0/255.0 blue:247.0/255.0 alpha:1.0] CGColor];
  }
*/
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(2.0f, 17, ((UILabel*)view).frame.size.width-4, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithWhite:1.0f
                                                     alpha:1.0f].CGColor;
    [((UILabel*)view).layer addSublayer:bottomBorder];

}



- (void)getCurrentViewWithPageNumber:(int)number
{
      currentView = firstView;
}

- (void)getCurrentPageTimeTableFormatWithIndex:(int)Index
{
      currentTimeFormat = page1TimeTableFormat;
}


- (void)setMidleViewInfoWithPageNumber:(int)Number
{
  MasjidTimetable *timeTable = page1TimeTable;
  if (timeTable) {
    [self getCurrentViewWithPageNumber:Number];
    
    
    [self getCurrentPageTimeTableFormatWithIndex:Number];
      NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:AppGroupsID];

    if ([userDefault valueForKey:@"format12"]) {
      if (isTimeFormat24) {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [df setAMSymbol:@"AM"];
        [df setPMSymbol:@"PM"];
        
        NSString *stringAM, *stringPM;
        if (currentTimeFormat.format == 12) {
          [df setDateFormat:@"hh:mm a"];
          stringAM = @" AM";
          stringPM = @" PM";
        } else {
          [df setDateFormat:@"HH:mm"];
          stringAM = @"";
          stringPM = @"";
        }
        
        NSDate* subahsadiqDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.subahsadiq, stringAM]];
        NSDate* fajarDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.fajar, stringAM]];
        NSDate* zoharDate ;
        if ([timeTable.zohar integerValue] < 12 && ([timeTable.zohar integerValue] > 1 && [timeTable.zohar integerValue] < 7)) {
          zoharDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zohar, stringAM]];
        } else {
          zoharDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zohar, stringPM]];
        }
        NSDate* sunriseDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.sunrise, stringAM]];
        NSDate* zoharjDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zoharj, stringPM]];
        NSDate* asarDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.asar, stringPM]];
        NSDate* asarjDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.asarj, stringPM]];
        NSDate* sunsetDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.sunset, stringPM]];
        NSDate* maghribDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.maghrib, stringPM]];
        NSDate* eshaDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.esha, stringPM]];
        NSDate* eshajDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.eshaj, stringPM]];
        [df setDateFormat:@"HH:mm"];
        
        _fajarLabel.text = [df stringFromDate:subahsadiqDate];
        _fajarJLabel.text = [df stringFromDate:fajarDate];
        _zoharLabel.text = [df stringFromDate:zoharDate];
        _zoharJlabel.text = [df stringFromDate:zoharjDate];
        _asarlabel.text = [df stringFromDate:asarDate];
        _asarJLabel.text = [df stringFromDate:asarjDate];
        _maghribLabel.text = [df stringFromDate:sunsetDate];
        _maghribJLabel.text = [df stringFromDate:maghribDate];
        _eshaLabel.text = [df stringFromDate:eshaDate];
        _eshaJLabel.text = [df stringFromDate:eshajDate];
        _sunriselabel.text = [df stringFromDate:sunriseDate];
      } else {
        NSDateFormatter* df = [[NSDateFormatter alloc] init];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [df setAMSymbol:@"AM"];
        [df setPMSymbol:@"PM"];
        NSString *stringAM, *stringPM;
        if (currentTimeFormat.format == 12) {
          [df setDateFormat:@"hh:mm a"];
          stringAM = @" AM";
          stringPM = @" PM";
        } else {
          [df setDateFormat:@"HH:mm"];
          stringAM = @"";
          stringPM = @"";
        }
        
        NSDate* subahsadiqDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.subahsadiq, stringAM]];
        NSDate* fajarDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.fajar, stringAM]];
        NSDate* zoharDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zohar, stringAM]];
        NSDate* sunriseDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.sunrise, stringAM]];
        NSDate* zoharjDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.zoharj, stringPM]];
        NSDate* asarDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.asar, stringPM]];
        NSDate* asarjDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.asarj, stringPM]];
        NSDate* sunsetDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.sunset, stringPM]];
        NSDate* maghribDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.maghrib, stringPM]];
        NSDate* eshaDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.esha, stringPM]];
        NSDate* eshajDate = [df dateFromString:[NSString stringWithFormat:@"%@%@", timeTable.eshaj, stringPM]];
        [df setDateFormat:@"h:mm"];
        
        _fajarLabel.text = [df stringFromDate:subahsadiqDate];
        _fajarJLabel.text = [df stringFromDate:fajarDate];
        _zoharLabel.text = [df stringFromDate:zoharDate];
        _sunriselabel.text = [df stringFromDate:sunriseDate];
        _zoharJlabel.text = [df stringFromDate:zoharjDate];
        _asarlabel.text = [df stringFromDate:asarDate];
        _asarJLabel.text = [df stringFromDate:asarjDate];
        _maghribLabel.text = [df stringFromDate:sunsetDate];
        _maghribJLabel.text = [df stringFromDate:maghribDate];
        _eshaLabel.text = [df stringFromDate:eshaDate];
        _eshaJLabel.text = [df stringFromDate:eshajDate];
      }
    } else {
      currentView.fajarLabel.text = timeTable.subahsadiq;
      _fajarLabel.text = timeTable.subahsadiq;
      _fajarJLabel.text = timeTable.fajar;
      _zoharLabel.text = timeTable.zohar;
      _zoharJlabel.text = timeTable.zoharj;
      _asarlabel.text = timeTable.asar;
      _asarJLabel.text = timeTable.asarj;
      _maghribLabel.text = timeTable.sunset;
      _maghribJLabel.text = timeTable.maghrib;
      _eshaLabel.text = timeTable.esha;
      _eshaJLabel.text = timeTable.eshaj;
      _sunriselabel.text = timeTable.sunrise;
    }
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
    self.preferredContentSize = CGSizeMake(0, 160);
}

-(void)getTime:(MasjidTimetable*)timeTable
{
    count = 0;
    if (timeTable == nil) {
        timeTable = page1TimeTable;
    }
   // MasjidTimetable *timeTable = [self getCurrentTimeTableWithPageNumber:pageNumber];
    frstPrayerText = @"";
    secondPrayerText = @"";
    
    
    if (timeTable) {
        [self clearcolors];
        
        NSString *redLabelTime, *greenLabelTime;
        
        [self compairCurrentTimeWithTime:timeTable.subahsadiq isAMformat:YES withTimeFormat:currentTimeFormat.format] ;
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Fajar begins in";
                redLabelTime = comingEventTime;
                _fajarLabel.textColor = [UIColor greenColor];
                //_fajarTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Fajar begins in";
                _fajarLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.fajar isAMformat:YES withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Fajar Jamaat in";
                redLabelTime = comingEventTime;
                _fajarJLabel.textColor = [UIColor greenColor];;
                //_fajarTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Fajar Jaamat in";
                _fajarJLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.sunrise isAMformat:YES withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Sunrise in";
                redLabelTime = comingEventTime;
                _sunriselabel.textColor = [UIColor greenColor];;
                //_fajarTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Sunrise in";
                _sunriselabel.textColor = [UIColor yellowColor];
            }
        }
        
        BOOL isAM = [timeTable.zohar integerValue] < 12 && [timeTable.zohar integerValue] > 7;
        
        [self compairCurrentTimeWithTime:timeTable.zohar isAMformat:isAM withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Zohar begins in";
                redLabelTime = comingEventTime;
                _zoharLabel.textColor = [UIColor greenColor];
                //_zoharTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Zohar begins in";
                _zoharLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.zoharj isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Zohar Jamaat in";
                redLabelTime = comingEventTime;
                _zoharJlabel.textColor = [UIColor greenColor];
                //_zoharTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Zohar Jamaat in";
                _zoharJlabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.asar isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Asar Begins in";
                redLabelTime = comingEventTime;
                _asarlabel.textColor = [UIColor greenColor];
                //_asarTitlelabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Asar Begins in";
                _asarlabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.asarj isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Asar Jamaat in";
                redLabelTime = comingEventTime;
                _asarJLabel.textColor = [UIColor greenColor];
                //_asarTitlelabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Asar Jamaat in";
                _asarJLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.sunset isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Maghrib begins in";
                redLabelTime = comingEventTime;
                _maghribLabel.textColor = [UIColor greenColor];
                //_maghribTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Maghrib begins in";
                _maghribLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.maghrib isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart){
            if ([frstPrayerText length] == 0) {
                frstPrayerText = @"Maghrib Jamaat in";
                redLabelTime = comingEventTime;
                _maghribJLabel.textColor = [UIColor greenColor];
                //_maghribTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Maghrib Jamaat in";
                _maghribJLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.esha isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText =  @"Esha begins in";
                redLabelTime = comingEventTime;
                _eshaLabel.textColor = [UIColor greenColor];
                //_eshaTitleLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Esha begins in";
                _eshaLabel.textColor = [UIColor yellowColor];
            }
        }
        
        [self compairCurrentTimeWithTime:timeTable.eshaj isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        if (isEventNotStart) {
            if ([frstPrayerText length] == 0) {
                frstPrayerText =  @"Esha Jamaat in";
                redLabelTime = comingEventTime;
               // _eshaTitleLabel.textColor = [UIColor greenColor];
                _eshaJLabel.textColor = [UIColor greenColor];
            } else if ([secondPrayerText length] == 0) {
                greenLabelTime = comingEventTime;
                secondPrayerText = @"Esha Jamaat in";
                _eshaJLabel.textColor = [UIColor yellowColor];
            }
        }
        
        if ([frstPrayerText length] != 0 && [secondPrayerText length] == 0) {
            secondPrayerText = @"Fajar begins in";
            
            MasjidTimetable *updatedTimeTable = [self getUpdatedTimeTable];
            [self compairCurrentTimeWithTime:updatedTimeTable.subahsadiq isAMformat:YES withTimeFormat:currentTimeFormat.format] ;
            
            greenLabelTime = comingEventTime;
        }
        
        if ([frstPrayerText length] == 0 && [secondPrayerText length] == 0) {
            [self updateCurrentTimeTable];
            frstPrayerText =  @"Fajar begins in";
            secondPrayerText = @"Fajar Jamaat in";
            [self compairCurrentTimeWithTime:timeTable.subahsadiq isAMformat:YES withTimeFormat:currentTimeFormat.format] ;
            redLabelTime = comingEventTime;
            [self compairCurrentTimeWithTime:timeTable.fajar isAMformat:YES withTimeFormat:currentTimeFormat.format];
            greenLabelTime = comingEventTime;
        }
        
        [self compairCurrentTimeWithTime:timeTable.eshaj isAMformat:NO withTimeFormat:currentTimeFormat.format];
        
        [self setTimerValuesWithEndTime:redLabelTime lastEventTime:comingEventTime];
        
        count = 1;
        
        [self setTimerValuesWithEndTime:greenLabelTime lastEventTime:comingEventTime];
        
        [self performSelector:@selector(getTime:) withObject:nil afterDelay:20.0];
        
    }
}
- (void)compairCurrentTimeWithTime:(NSString*)eventStart isAMformat:(BOOL)formatAM withTimeFormat:(int)format
{
    isEventNotStart = NO;
    comingEventTime = @"";
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setTimeZone:[NSTimeZone systemTimeZone]];
    [date setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    
    if (format == 12) {
        [date setAMSymbol:@"AM"];
        [date setPMSymbol:@"PM"];
        [date setDateFormat:@"hh:mm a"];
        
        NSString *timeFormat = formatAM ? @" AM" : @" PM";
        eventStart = [eventStart stringByAppendingString:timeFormat];
        NSDate *evenStartDate = [date dateFromString:eventStart];
        [date setDateFormat:@"HH:mm"];
        
        eventStart = [date stringFromDate:evenStartDate];
        dateString = [date stringFromDate:[NSDate date]];
        
        if ([[eventStart stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue] > [[dateString stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue]) {
            isEventNotStart = YES;
        }
        comingEventTime = eventStart;
    } else {
        [date setDateFormat:@"HH:mm"];
        
        dateString = [date stringFromDate:[NSDate date]];
        if ([[eventStart stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue] > [[dateString stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue]) {
            isEventNotStart = YES;
        }
        comingEventTime = eventStart;
    }
}

-(void)clearcolors
{
    
    _maghribLabel.textColor= [UIColor whiteColor];
    _eshaLabel.textColor = [UIColor whiteColor];
    _zoharLabel.textColor = [UIColor whiteColor];
    _zoharJlabel.textColor = [UIColor whiteColor];
    //_zoharTitleLabel.textColor = [UIColor whiteColor];
    _fajarLabel.textColor = [UIColor whiteColor];
   // _asarTitlelabel.textColor = [UIColor whiteColor];
    _asarlabel.textColor = [UIColor whiteColor];
    _asarJLabel.textColor = [UIColor whiteColor];
    _maghribJLabel.textColor = [UIColor whiteColor];
    _maghribLabel.textColor = [UIColor whiteColor];
   // _maghribTitleLabel.textColor = [UIColor whiteColor];
    _eshaJLabel.textColor = [UIColor whiteColor];
   // _eshaTitleLabel.textColor = [UIColor whiteColor];
    _fajarJLabel.textColor = [UIColor whiteColor];
   // _fajarTitleLabel.textColor = [UIColor whiteColor];
    _zoharLabel.textColor = [UIColor whiteColor];
    _sunriselabel.textColor = [UIColor whiteColor];
}

- (void)updateCurrentTimeTable
{
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:AppGroupsID];
    isTimeFormat24 = [[userDefault valueForKey:@"format12"] boolValue];
    //[self setMasjidsInfo];
    NSLog(@"%@",[Utils today]);
    self.preferredContentSize = CGSizeMake(0, 160);
    int masjidID = (int)[userDefault integerForKey:@"masjidIDM"];
                page1TimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjidID forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
    
}

- (void)setTimerValuesWithEndTime:(NSString*)endDateString lastEventTime:(NSString*)lastEventTime
{
    NSDateFormatter *date = [NSDateFormatter new];
    [date setTimeZone:[NSTimeZone systemTimeZone]];
    [date setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [date setDateFormat:@"HH:mm"];
    
    NSString *currentTime = [date stringFromDate:[NSDate date]];
    
    NSDate *serDate = [date dateFromString:currentTime];
    NSDate *endDate = [date dateFromString:endDateString];
    
    currentTime = [currentTime stringByReplacingOccurrencesOfString:@":" withString:@"."];
    lastEventTime = [lastEventTime stringByReplacingOccurrencesOfString:@":" withString:@"."];
    endDateString = [endDateString stringByReplacingOccurrencesOfString:@":" withString:@"."];
    
    if ( ([currentTime floatValue] >  [lastEventTime floatValue] || [currentTime floatValue] > [endDateString  floatValue]) && [currentTime floatValue] < 23.60) {
        endDate = [endDate dateByAddingTimeInterval:60*60*24];
    }
    
    if ([currentTime floatValue] == 0.0 && count == 1) {
        [self updateCurrentTimeTable];
        [self setMidleViewInfoWithPageNumber:1];
        
    }
    
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    meterMin = timeDifference / 60;
    if (meterMin>=60) {
        meterMin=meterMin%60;
    }
    
    meterGour = timeDifference / 3600;
    meterSeconds = timeDifference;
    
    
}
- (MasjidTimetable *)getUpdatedTimeTable
{
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:AppGroupsID];
    isTimeFormat24 = [[userDefault valueForKey:@"format12"] boolValue];
    //[self setMasjidsInfo];
    NSLog(@"%@",[Utils today]);
    self.preferredContentSize = CGSizeMake(0, 160);
    int masjidID = (int)[userDefault integerForKey:@"masjidIDM"];

            return (MasjidTimetable*)[[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjidID forDate:[[Utils today] dateByAddingTimeInterval:60*60*24]];
    
}


@end
