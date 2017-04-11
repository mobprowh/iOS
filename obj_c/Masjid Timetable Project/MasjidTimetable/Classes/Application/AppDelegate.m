//
//  AppDelegate.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "AppDelegate.h"
//#import "PayPalMobile.h"
#import "TimeTableView.h"
#import "ViewController.h"
#import "MTDBHelper.h"
#import "MasjidListView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Chameleon.h"
#import <UserNotifications/UserNotifications.h>

@import UserNotifications;

int masjidTurn;
int val,val1,val2,val3,val4,val5,val6,alert,mSound;
int xts,l,localDataFetched;
BOOL changeFormat;
BOOL isSearching;
BOOL isColored;
BOOL localDataForSecond;
BOOL localDataForThird;
BOOL localDataForFourth;
NSArray *jsonCalled;
NSArray *globalMasjidNotes,*globalTimeTable,*globalTimeTableFormat,*globalTimeTableValues;
NSMutableArray *globalMasjidBasicValues;
NSMutableArray *arrayList,*newArrayList,*get,*addids,*addpri,*fetchResults;
NSDictionary *checking;
NSMutableDictionary *dictData,*thirdMasjidDictionary;
NSMutableDictionary *globalMasjidNames;
NSString *globalMasjidID;
NSString *fPrayer,*zPrayer,*aPrayer,*mPrayer,*ePrayer,*timetableFormat;
NSString *fajarFormat,*zoharFormat,*asarFormat,*maghribFormat,*eshaFormat,*fajarJFormat,*zoharJFormat,*asarJFormat,*maghribJFormat,*eshaJFormat,*sunsetFormat;
NSString *fajarPrayer,*zoharPrayer,*asarPrayer,*maghribPrayer,*eshaPrayer;
NSString *previousFajar,*previousZohar,*previousAsar,*previousMaghrib,*previousEsha;
NSString *getID,*address,*city,*state,*pin,*country,*telephoneNo;
NSString *fajarJammat,*zoharJammat,*asarJammat,*maghribJammat,*eshaJammat,*fajarBegin,*zoharBegin,*asarBegin,*maghribBegin,*eshaBegin;
NSString *myMonthString,*dVal,*prayerID,*JsonDate,*interval;
NSString *currentEventTime;
// TODO: notification upgrade
//UILocalNotification *localNotification;
UIImage *themeImage;
Masjid *primaryMasjid;
MasjidTimetable *primaryTimeTable;
JammatSoundSettings *jammatSoundSettings;
BeginnerSoundSettings *beginnnerSoundSettings;
PhoneMuteSettings *phoneMuteSettings;
NSDate *currentDatefortest;

@interface AppDelegate () <AVAudioPlayerDelegate>
{
  NSInteger badgeNumber;
  NSTimer *alarmTimer;
  NSDate *alarmDate;
  AVAudioPlayer *player;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"LastUpdateMonth"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LastUpdateMonth"];
    }

    [self redirectNSLogToDocumentFolder];
    [Utils setMasjidListOpenCountZero];
    changeFormat = NO;
    isSearching = NO;
    isColored = NO;
    masjidTurn=1;
    localDataFetched=0;
    interval = @"30";
    localDataForFourth = NO;
    localDataForThird = NO;
    localDataForSecond = NO;
    thirdMasjidDictionary=[[NSMutableDictionary alloc]init];
    arrayList= [NSMutableArray array];
    checking= [NSDictionary dictionary];
    fetchResults = [NSMutableArray array];
    globalMasjidBasicValues = [NSMutableArray array];
    globalMasjidNames = [NSMutableDictionary dictionary];
//    localNotification = [UILocalNotification new]; // TODO: notification upgrade
    newArrayList = [NSMutableArray array];
    val=1,val1=1,val2=1,val3=1,val4=1,val5=1,val6=1,alert=0;
    get = [NSMutableArray array];
    addids = [NSMutableArray array];
    addpri = [NSMutableArray array];
    application.applicationSupportsShakeToEdit = YES;
    
    jammatSoundSettings = [[MTDBHelper sharedDBHelper] getJammatSoundSettings];
    if (!jammatSoundSettings) {
        jammatSoundSettings =  [[MTDBHelper sharedDBHelper] createJammatSoundSettings];
    }
    
    beginnnerSoundSettings = [[MTDBHelper sharedDBHelper] getBeginnerSoundSettings];
    if (!beginnnerSoundSettings) {
        beginnnerSoundSettings =  [[MTDBHelper sharedDBHelper] createBeginnerSoundSettings];
    }
    
    [self checkForTimeTableSpeakersState];

    if ([[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"] || [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"2"] || [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"3"] || [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"4"]) {
        
        TimeTableView *timeTableViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"timeTable"];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:timeTableViewController];
        self.window.rootViewController = navController;
        
    } else {
        MasjidListView *masjidViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"selectMasjid"];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:masjidViewController];
        self.window.rootViewController = navController;
    }
    xts=0;
  
    // remote notification setup
    [self registerForPushNotifications:application];
    
    // local notification setup
    [self requestForUserNotifications:application];
    
    // app was launched from push notification, handling it
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        [self handleRemoteNotificationForApplication:application
                                                with:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    }

    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:32.0/255.0 green:32.0/255.0 blue:32.0/255.0 alpha:1.0]];
  
    [NSTimer scheduledTimerWithTimeInterval:31.0 target:self selector:@selector(updateDateForNextDay) userInfo:nil repeats:YES];
    
    return YES;
}

//Changes by Hassan Bhatti 2-Oct-2016
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
//{
//  
//}

//- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//{
//    if (notificationSettings.types != UIUserNotificationTypeNone)
//    { // user granted the permission
//        
//        [application registerForRemoteNotifications];
////        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
////        [center removeAllPendingNotificationRequests];
//
//    }
//}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    if (completionHandler) {
        completionHandler();
    }
}

//-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
//{
//  if (completionHandler) {
//    completionHandler();
//  }
//}
//end changes

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
  badgeNumber += [[[userInfo objectForKey:@"aps"] objectForKey: @"badge"] intValue];
  
  [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
  
  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
  NSString *_deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
  if (_deviceToken) {
    [Utils setDeviceToken:_deviceToken];
    [self sendDeviceToken:_deviceToken];
  }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
  UIViewController *visibleController = [navigationController visibleViewController];
  if ([visibleController isKindOfClass:[TimeTableView class]] && [Utils isTimeTableUpdateExpired]) {
    [Utils saveTimeTableLastUpdateDate];
    [(TimeTableView *)visibleController checkForMasjidsTimeTablesUpdate];
  }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (IS_IOS_10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllDeliveredNotifications];
        [center removeAllPendingNotificationRequests];
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    [self creatLocalNotificationsForJammat];
    [self creatLocalNotificationsForEvents];
    [self creatLocalNotificationsForJammatTimesChanged];
    [self createPhoneMuteNotifications];
    [Utils checkIsUserCountTimeToPast];
    [self redirectNSLogToDocumentFolder];

    badgeNumber = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
}

- (void)redirectNSLogToDocumentFolder
{
  //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
  //                                                         NSUserDomainMask, YES);
  //    NSString *documentsDirectory = [paths objectAtIndex:0];
  //    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
  //    freopen([logPath fileSystemRepresentation],"a+", stderr);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  [[MTDBHelper sharedDBHelper] saveContext];
}

#pragma mark - Helper


/**
 Handle remote notification

 @param application application
 @param userInfo    userinfo dictionary
 */
- (void)handleRemoteNotificationForApplication:(UIApplication *)application
                                          with:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0;
    
    NSLog(@">>>> didReceiveRemoteNotification userInfo=%@", userInfo);
    
}

/**
 register for push notification and get users permission

 @param application application to register for push notification
 */
- (void)registerForPushNotifications:(UIApplication *)application {
    
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    

    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    
    [application registerUserNotificationSettings:settings];
    
}


/**
 request authorization for local notification

 @param application application to request
 */
- (void)requestForUserNotifications:(UIApplication *)application {
    if (IS_IOS_10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if (!error) {
                                      NSLog(@"request authorization succeeded!");
                                  }
                              }];
    }
    else {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil]];
    }
}

#pragma mark - Mute settings

- (void)createPhoneMuteNotifications
{
  primaryMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"];
  phoneMuteSettings = [[MTDBHelper sharedDBHelper] getPhoneMuteSettings];
  
  @try {
    if (primaryMasjid && phoneMuteSettings) {
      
      if (phoneMuteSettings.fajarOn && phoneMuteSettings.fajarMuteTime.length > 0) {
        [self generateNotificationForMutePhone:@[phoneMuteSettings.fajarMuteTime, phoneMuteSettings.fajarUnMuteTime, @"1"]];
      }
      
      if (phoneMuteSettings.zoharOn && phoneMuteSettings.zoharMuteTime.length > 0) {
        [self generateNotificationForMutePhone:@[phoneMuteSettings.zoharMuteTime, phoneMuteSettings.zoharUnMuteTime, @"2"]];
      }
      
      if (phoneMuteSettings.asarOn && phoneMuteSettings.asarMuteTime.length > 0) {
        [self generateNotificationForMutePhone:@[phoneMuteSettings.asarMuteTime, phoneMuteSettings.asarUnMuteTime, @"3"]];
      }
      
      if (phoneMuteSettings.maghribOn && phoneMuteSettings.maghribMuteTime.length > 0) {
        [self generateNotificationForMutePhone:@[phoneMuteSettings.maghribMuteTime, phoneMuteSettings.maghribUnMuteTime, @"4"]];
      }
      
      if (phoneMuteSettings.eshaOn && phoneMuteSettings.eshaMuteTime.length > 0) {
        [self generateNotificationForMutePhone:@[phoneMuteSettings.eshaMuteTime, phoneMuteSettings.eshaUnMuteTime, @"5"]];
      }
    }
    
  }
  @catch (NSException *exception) {
    
  }
}

- (void)generateNotificationForMutePhone:(NSArray *)notificationInfo
{
  for (int i = 0; i < 5 ; i++) {
    NSDate *currentDate = [[Utils today] dateByAddingTimeInterval:60*60*24*i];
    MasjidTimetable *currentTimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:primaryMasjid.masjidId forDate:currentDate];
    TimeTableFormat *currentTimeTableFormat = [[MTDBHelper sharedDBHelper] getTimeTableFormat:primaryMasjid.masjidId forDate:currentDate];
    if (currentTimeTable && currentTimeTableFormat) {
      NSString  *jamaatTime;
      switch ([notificationInfo[2] intValue]) {
        case 1:
          jamaatTime = [Utils reformatTimeTo24timeFormat:currentTimeTable.fajar isAMformat:YES withTimeFormat:currentTimeTableFormat.format];
          break;
        case 2:
          jamaatTime = [Utils reformatTimeTo24timeFormat:currentTimeTable.zoharj isAMformat:NO withTimeFormat:currentTimeTableFormat.format];
          break;
        case 3:
          jamaatTime = [Utils reformatTimeTo24timeFormat:currentTimeTable.asarj isAMformat:NO withTimeFormat:currentTimeTableFormat.format];
          break;
        case 4:
          jamaatTime = [Utils reformatTimeTo24timeFormat:currentTimeTable.maghrib isAMformat:NO withTimeFormat:currentTimeTableFormat.format];
          break;
        case 5:
          jamaatTime = [Utils reformatTimeTo24timeFormat:currentTimeTable.eshaj isAMformat:NO withTimeFormat:currentTimeTableFormat.format];
          break;
      }
      
      NSDate *currenDate = [[Utils today] dateByAddingTimeInterval:60*60*24*i];
      NSDate *jamaatDate = [Utils getDatefromDays:currenDate AndHours:jamaatTime];
      [self registerNotificationForMuteDeviceWithDate:[jamaatDate dateByAddingTimeInterval:-60*[notificationInfo[0] intValue]] withInfo:@"Mute"];
      [self registerNotificationForMuteDeviceWithDate:[jamaatDate dateByAddingTimeInterval:60*[notificationInfo[1] intValue]] withInfo:@"Unmute"];
    }
  }
}

- (void)registerNotificationForMuteDeviceWithDate:(NSDate *)date withInfo:(NSString*)info
{// TODO: notification upgrade
    if (IS_IOS_10_OR_LATER) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"Masjid Alert" arguments:nil];
        content.body = [NSString stringWithFormat:@"%@ Reminder", info];
        content.categoryIdentifier = @"Mute";
        
        content.sound = [UNNotificationSound soundNamed:@"muteSound.wav"];
        
        // update application icon badge number
        content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        
        // Deliver the notification in five seconds.
        NSTimeInterval timeInterval = date.timeIntervalSinceNow;
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:timeInterval repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"info"
                                                                              content:content trigger:trigger];
        // schedule localNotification
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@">>>>>>> add NotificationRequest succeeded!");
            }
        }];
    } else {
        UILocalNotification *muteNotification = [[UILocalNotification alloc] init];
        muteNotification.category = @"Mute";
        muteNotification.timeZone = [NSTimeZone systemTimeZone];
        muteNotification.alertBody = [NSString stringWithFormat:@"%@ Reminder", info];
        muteNotification.hasAction = YES;
        muteNotification.fireDate = date;
        muteNotification.soundName = @"muteSound.wav";
        muteNotification.repeatInterval = NSCalendarUnitEra;
        muteNotification.alertAction = @"Ok";
        muteNotification.userInfo = [NSDictionary dictionaryWithObject:info forKey:@"info"];
        [[UIApplication sharedApplication] scheduleLocalNotification:muteNotification];
    }
  
}

- (void)cancelMuteNotifications
{// TODO: notification upgrade
    
    if (IS_IOS_10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeDeliveredNotificationsWithIdentifiers:@[@"info"]];
        [center removePendingNotificationRequestsWithIdentifiers:@[@"info"]];
    }
    else
    {
        for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            if ([localNotification.userInfo valueForKey:@"info"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
  
}

#pragma mark - Other settings

- (void)creatLocalNotificationsForEvents
{
  @try {
    primaryMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"];
    if ([Utils getEventsHours] != 0 || [Utils getEventsDays] != 0) {
      NSArray *page1Events = [[MTDBHelper sharedDBHelper] getEvents:primaryMasjid.masjidId];
      if ([page1Events count] > 0) {
        [self generateNotificationForEventsWithEventsList:page1Events];
      }
      
      Masjid *seconderyMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"2"];
      NSArray *page2Events = [[MTDBHelper sharedDBHelper] getEvents:seconderyMasjid.masjidId];
      if ([page2Events count] > 0) {
        [self generateNotificationForEventsWithEventsList:page2Events];
      }
      
      Masjid *thirdMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"3"];
      NSArray *page3Events = [[MTDBHelper sharedDBHelper] getEvents:thirdMasjid.masjidId];
      if ([page3Events count] > 0) {
        [self generateNotificationForEventsWithEventsList:page3Events];
      }
      
      Masjid *fortyMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"4"];
      NSArray *page4Events = [[MTDBHelper sharedDBHelper] getEvents:fortyMasjid.masjidId];
      if ([page4Events count] > 0) {
        [self generateNotificationForEventsWithEventsList:page4Events];
      }
    }
  }
  @catch (NSException *exception) {
    
  }
}

- (void)generateNotificationForEventsWithEventsList:(NSArray *)eventList
{// TODO: notification upgrade
    
    for (Event *event in eventList) {
        if ([self isDateUpComming:event.longDate]) {

            NSArray *dateInfo = [Utils monthNameString:event.longDate];
            NSDate *fireDate = [Utils getDatefromDays:[Utils convertToDateFormat:event.longDate] AndHours:[Utils changeTo24timeFormat:event.time]];
            
            if (IS_IOS_10_OR_LATER) {
                UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                content.title = [NSString localizedUserNotificationStringForKey:@"Masjid Alert" arguments:nil];
                content.body = [NSString stringWithFormat:@"%@\n%@ %@th at %@", event.title, dateInfo[0], dateInfo[1], event.time];
                content.categoryIdentifier = @"Alert";
                
                content.sound = [UNNotificationSound defaultSound];
                
                // update application icon badge number
                content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
                
                // Deliver the notification in five seconds.
                fireDate = [fireDate dateByAddingTimeInterval:-60*60*([Utils getEventsHours]+ 24*[Utils getEventsDays])];
                NSTimeInterval timeInterval = fireDate.timeIntervalSinceNow;
                UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                              triggerWithTimeInterval:timeInterval repeats:NO];
                
                UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"event"
                                                                                      content:content trigger:trigger];
                // schedule localNotification
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    if (!error) {
                        NSLog(@">>>>>>> add NotificationRequest succeeded!");
                    }
                }];
            } else {
                
                UILocalNotification *eventNotification = [[UILocalNotification alloc] init];
                eventNotification.category = @"Alert";
                eventNotification.timeZone = [NSTimeZone systemTimeZone];
                eventNotification.alertBody = [NSString stringWithFormat:@"%@\n%@ %@th at %@", event.title, dateInfo[0], dateInfo[1], event.time];
                eventNotification.hasAction = YES;
                
                eventNotification.fireDate = [fireDate dateByAddingTimeInterval:-60*60*([Utils getEventsHours]+ 24*[Utils getEventsDays])];
                eventNotification.soundName = UILocalNotificationDefaultSoundName;
                eventNotification.repeatInterval = NSCalendarUnitEra;
                eventNotification.alertAction = @"Ok";
                eventNotification.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@E", event.title] forKey:@"event"];
                [[UIApplication sharedApplication] scheduleLocalNotification:eventNotification];
            }
        }
    }
}

- (BOOL)isDateUpComming:(NSDate*)eventDate
{
  NSDate *now = [NSDate date];
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
  [components setHour:[Utils getEventsHours]];
  [components setDay:[Utils getEventsDays]];
  NSDate *notifyDate = [calendar dateFromComponents:components];
  NSTimeInterval timeinterval = [eventDate timeIntervalSinceDate:notifyDate];
  
  return timeinterval > 0;
}

- (void)cancelEventsLocalNotifications
{// TODO: notification upgrade
    
    if (IS_IOS_10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers:@[@"event"]];
        [center removeDeliveredNotificationsWithIdentifiers:@[@"event"]];
    } else {
        for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            NSString * identifier = [localNotification.userInfo valueForKey:@"event"];
            if ([[identifier substringFromIndex:identifier.length - 1] isEqualToString:@"E"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
}

#pragma mark - Jamaat prayer time is changed

- (void)creatLocalNotificationsForJammatTimesChanged
{
  @try {
    if ([Utils getJamaatTimeChangesCount] != 0) {
      primaryMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"];
      if (primaryMasjid ) {
        [self checkForTimeTableDiffrenceForMasjid:primaryMasjid];
      }
    }
  }
  @catch (NSException *exception) {
    
  }
}

- (void)checkForTimeTableDiffrenceForMasjid:(Masjid *)masjid
{
  for (int i = 0; i < 10;  i ++) {
    NSDate *currentDate = [[Utils today] dateByAddingTimeInterval:60*60*24*i];
    NSDate *yesterdayDate = [currentDate dateByAddingTimeInterval:-60*60*24];
    MasjidTimetable *todaysTimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid.masjidId forDate:currentDate];
    MasjidTimetable *tomorrowTimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:masjid.masjidId forDate:yesterdayDate];
    TimeTableFormat *timeTableFormat = [[MTDBHelper sharedDBHelper]  getTimeTableFormat:masjid.masjidId forDate:currentDate];
    if (todaysTimeTable && tomorrowTimeTable) {
      NSString *jamaatTime;
      
      if (![todaysTimeTable.fajar isEqualToString:tomorrowTimeTable.fajar]) {
        jamaatTime = [Utils reformatTimeTo24timeFormat:todaysTimeTable.fajar isAMformat:YES withTimeFormat:timeTableFormat.format];
        if (jamaatTime) {
          [self generateLocalNotificationForJamaatChanges:@[jamaatTime, @"Fajar",[NSNumber numberWithInt:i]] forMasjid:masjid];
        }
      }
      
      if (![todaysTimeTable.zoharj isEqualToString:tomorrowTimeTable.zoharj]) {
        jamaatTime = [Utils reformatTimeTo24timeFormat:todaysTimeTable.zoharj isAMformat:NO withTimeFormat:timeTableFormat.format];
        if (jamaatTime) {
          [self generateLocalNotificationForJamaatChanges:@[jamaatTime, @"Zohar", [NSNumber numberWithInt:i]] forMasjid:masjid];
        }
      }
      
      if (![todaysTimeTable.asarj isEqualToString:tomorrowTimeTable.asarj]) {
        jamaatTime = [Utils reformatTimeTo24timeFormat:todaysTimeTable.asarj isAMformat:NO withTimeFormat:timeTableFormat.format];
        if (jamaatTime) {
          [self generateLocalNotificationForJamaatChanges:@[jamaatTime, @"Asar", [NSNumber numberWithInt:i]] forMasjid:masjid];
        }
      }
      
      if (![todaysTimeTable.eshaj isEqualToString:tomorrowTimeTable.eshaj]) {
        jamaatTime = [Utils reformatTimeTo24timeFormat:todaysTimeTable.eshaj isAMformat:NO withTimeFormat:timeTableFormat.format];
        if (jamaatTime) {
          [self generateLocalNotificationForJamaatChanges:@[jamaatTime, @"Esha", [NSNumber numberWithInt:i]] forMasjid:masjid];
        }
      }
    }
  }
}

- (void)generateLocalNotificationForJamaatChanges:(NSArray*)info forMasjid:(Masjid*)masjid
{// TODO: notification upgrade
    NSString *jamaatTime = info[0];
    NSString *name = info[1];
    NSDate *currenDate = [[Utils today] dateByAddingTimeInterval:60*60*24*[info[2] integerValue]];
    NSDate *jamaatDate = [Utils getDatefromDays:currenDate AndHours:jamaatTime];
    
    if (IS_IOS_10_OR_LATER) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"Masjid Alert" arguments:nil];
        content.body = [NSString stringWithFormat:@"%@ Jamaat is at %@ today",name, jamaatTime];
        content.categoryIdentifier = @"Alert";
        
        content.sound = [UNNotificationSound defaultSound];
        
        // update application icon badge number
        content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        
        // Deliver the notification in five seconds.
        jamaatDate = [jamaatDate dateByAddingTimeInterval:-60*[Utils getJamaatTimeChangesCount]];
        NSTimeInterval timeInterval = jamaatDate.timeIntervalSinceNow;
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:timeInterval repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"timeChange"
                                                                              content:content trigger:trigger];
        // schedule localNotification
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@">>>>>>> add NotificationRequest succeeded!");
            }
        }];
    } else {
        UILocalNotification *jamaatTimeChangeNotification = [[UILocalNotification alloc] init];
        jamaatTimeChangeNotification.category = @"Alert";
        jamaatTimeChangeNotification.timeZone = [NSTimeZone systemTimeZone];
        jamaatTimeChangeNotification.alertBody = [NSString stringWithFormat:@"%@ Jamaat is at %@ today",name, jamaatTime];
        jamaatTimeChangeNotification.hasAction = YES;
        jamaatTimeChangeNotification.repeatInterval = NSCalendarUnitEra;
        jamaatTimeChangeNotification.fireDate = [jamaatDate dateByAddingTimeInterval:-60*[Utils getJamaatTimeChangesCount]];
        jamaatTimeChangeNotification.soundName = UILocalNotificationDefaultSoundName;
        jamaatTimeChangeNotification.alertAction = @"Ok";
        jamaatTimeChangeNotification.userInfo = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%@C", name],jamaatDate, masjid.name] forKeys:@[ @"timeChange", @"jamaatDate", @"masjidName"]];
        [[UIApplication sharedApplication] scheduleLocalNotification:jamaatTimeChangeNotification];
    }
  
}

- (void)cancelJamaatLocalNotificationsforTimeChanges
{// TODO: notification upgrade
    
    if (IS_IOS_10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers:@[@"timeChange"]];
        [center removeDeliveredNotificationsWithIdentifiers:@[@"timeChange"]];
    } else {
        for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            NSString * identifier = [localNotification.userInfo valueForKey:@"timeChange"];
            if ([[identifier substringFromIndex:identifier.length - 1] isEqualToString:@"C"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
  
}

#pragma mark - Jamaat Notifications

- (void)creatLocalNotificationsForJammat
{
  jammatSoundSettings = [[MTDBHelper sharedDBHelper] getJammatSoundSettings];
  beginnnerSoundSettings = [[MTDBHelper sharedDBHelper] getBeginnerSoundSettings];
  primaryMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"];
  primaryTimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:primaryMasjid.masjidId forDate:[Utils today]];
  @try {
    if (primaryMasjid && primaryTimeTable && jammatSoundSettings) {
      if (![jammatSoundSettings.fajarJammatTime isEqualToString:@""] && jammatSoundSettings.fajarOn && jammatSoundSettings.fajarJammatTime) {
        [self generateLocalNotificationWithInfo:@[@"fajarJ", @"Fajar"]];
      }
      if (![jammatSoundSettings.zoharJammatTime isEqualToString:@""] && jammatSoundSettings.zoharOn && jammatSoundSettings.zoharJammatTime) {
        [self generateLocalNotificationWithInfo:@[@"zoharJ", @"Zohar"]];
      }
      if (![jammatSoundSettings.asarJammatTime isEqualToString:@""] && jammatSoundSettings.asarOn && jammatSoundSettings.asarJammatTime) {
        [self generateLocalNotificationWithInfo:@[@"asarJ", @"Asar"]];
      }
      if (![jammatSoundSettings.maghribJammatTime isEqualToString:@""] && jammatSoundSettings.maghribOn && jammatSoundSettings.maghribJammatTime) {
        [self generateLocalNotificationWithInfo:@[@"maghribJ", @"Maghrib"]];
      }
      if (![jammatSoundSettings.eshaJammatTime isEqualToString:@""] && jammatSoundSettings.eshaOn && jammatSoundSettings.eshaJammatTime) {
        [self generateLocalNotificationWithInfo:@[@"eshaJ", @"Esha"]];
      }
    }
    if (primaryMasjid && primaryTimeTable && beginnnerSoundSettings ) {

      if (![beginnnerSoundSettings.fajarBeginnnerTime isEqualToString:@""] && beginnnerSoundSettings.fajarOn && beginnnerSoundSettings.fajarBeginnnerTime) {
        [self generateLocalNotificationWithInfo:@[@"fajarB", @"Fajar"]];
      }
      if (![beginnnerSoundSettings.zoharBeginnnerTime isEqualToString:@""] && beginnnerSoundSettings.zoharOn && beginnnerSoundSettings.zoharBeginnnerTime) {
        [self generateLocalNotificationWithInfo:@[@"zoharB", @"Zohar"]];
      }
      if (![beginnnerSoundSettings.asarBeginnnerTime isEqualToString:@""] && beginnnerSoundSettings.asarOn && beginnnerSoundSettings.asarBeginnnerTime) {
        [self generateLocalNotificationWithInfo:@[@"asarB", @"Asar"]];
      }
      if (![beginnnerSoundSettings.maghribBeginnnerTime isEqualToString:@""] && beginnnerSoundSettings.maghribOn && beginnnerSoundSettings.maghribBeginnnerTime) {
        [self generateLocalNotificationWithInfo:@[@"maghribB", @"Maghrib"]];
      }
      if (![beginnnerSoundSettings.eshaBeginnnerTime isEqualToString:@""] && beginnnerSoundSettings.eshaOn && beginnnerSoundSettings.eshaBeginnnerTime) {
        [self generateLocalNotificationWithInfo:@[@"eshaB", @"Esha"]];
      }
    }
  }
  @catch (NSException *exception) {
    
  }
}

- (void)generateLocalNotificationWithInfo:(NSArray *)info
{// TODO: notification upgrade

    NSString *identifier = info[0];
    NSArray *fireDateInfo = [self getFireDateInfoWithIdentifier:identifier dayIndex:0];
    
    if (IS_IOS_10_OR_LATER) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"Masjid Alert" arguments:nil];
        content.categoryIdentifier = @"Alert";
        
        if ([identifier hasSuffix:@"B"]) {
            content.body = [NSString stringWithFormat:@"%@ Beginning in %@ mins at %@ ", info[1], fireDateInfo[1], fireDateInfo[2]];
            NSString *soundName = [self isTimetableSoundOffWithIdentifier:identifier] ? @"muteSound.wav" : beginnnerSoundSettings.soundName;
            if ([soundName isEqualToString:@"default"]) {
                content.sound = [UNNotificationSound defaultSound];
            } else {
                content.sound = [UNNotificationSound soundNamed:soundName];
            }
            
        }
        else {
            content.body = [NSString stringWithFormat:@"%@ Jamaat in %@ mins at %@ ", info[1], fireDateInfo[1], fireDateInfo[2]];
            NSString *soundName = [self isTimetableSoundOffWithIdentifier:identifier] ? @"muteSound.wav" : jammatSoundSettings.soundName;
            content.sound = [UNNotificationSound soundNamed:soundName];
            if ([soundName isEqualToString:@"default"]) {
                content.sound = [UNNotificationSound defaultSound];
            } else {
                content.sound = [UNNotificationSound soundNamed:soundName];
            }
        }
        
        // update application icon badge number
        content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        
        // Deliver the notification in five seconds.
        NSDate *fireDate1 = fireDateInfo[0];
        NSDate *fireDate = [[NSDate alloc] initWithTimeInterval:1 sinceDate:fireDate1];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components: NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                                       fromDate:fireDate];
        
        dateComponents.timeZone = [NSTimeZone systemTimeZone];
        
        NSLog(@">>>>> hour: %ld, min: %ld", (long)dateComponents.hour, (long)dateComponents.minute);
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                              content:content trigger:trigger];
        // schedule localNotification
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@">>>>>>> add NotificationRequest succeeded!");
            }
        }];
    } else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.category = @"Alert";
        if ([identifier hasSuffix:@"B"]) {
            notification.alertBody = [NSString stringWithFormat:@"%@ Beginning in %@ mins at %@ ", info[1], fireDateInfo[1], fireDateInfo[2]];
            notification.soundName = [self isTimetableSoundOffWithIdentifier:identifier] ? nil : beginnnerSoundSettings.soundName;
            
        }
        else {
            notification.soundName = [self isTimetableSoundOffWithIdentifier:identifier] ? nil : jammatSoundSettings.soundName;
            
            notification.alertBody = [NSString stringWithFormat:@"%@ Jamaat in %@ mins at %@ ", info[1], fireDateInfo[1], fireDateInfo[2]];
        }
        notification.fireDate = fireDateInfo[0];
        notification.alertAction = @"Go to App";
        notification.repeatInterval = NSCalendarUnitDay;
        notification.userInfo = [NSDictionary dictionaryWithObject:identifier forKey:@"identifier"];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (NSArray*)getFireDateInfoWithIdentifier:(NSString *)identifier dayIndex:(int)dayIndex
{
  primaryTimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:primaryMasjid.masjidId forDate:[[Utils today] dateByAddingTimeInterval:60*60*24*dayIndex]];
  TimeTableFormat *tableTimeFormat = [[MTDBHelper sharedDBHelper] getCurrentMontTimeTableFormat:primaryMasjid.masjidId];
  
  NSString *fajarTimeUnChanged;
  NSString *fajarTime;
  NSString *userSettedTimeCount;
  BOOL isTimeFromatAM = NO;
  if ([identifier hasSuffix:@"B"]) {
    if ([identifier isEqualToString:@"fajarB"]) {
      fajarTime = primaryTimeTable.subahsadiq;
      fajarTimeUnChanged = primaryTimeTable.subahsadiq;
      isTimeFromatAM = YES;
      userSettedTimeCount = beginnnerSoundSettings.fajarBeginnnerTime;
    } else if ([identifier isEqualToString:@"zoharB"]) {
      fajarTime = primaryTimeTable.zohar;
      fajarTimeUnChanged = primaryTimeTable.zohar;
      userSettedTimeCount = beginnnerSoundSettings.zoharBeginnnerTime;
    } else if ([identifier isEqualToString:@"asarB"]) {
      fajarTime = primaryTimeTable.asar;
      fajarTimeUnChanged = primaryTimeTable.asar;
      userSettedTimeCount = beginnnerSoundSettings.asarBeginnnerTime;
    } else if ([identifier isEqualToString:@"maghribB"]) {
      fajarTime = primaryTimeTable.sunset;
      fajarTimeUnChanged = primaryTimeTable.sunset;
      userSettedTimeCount = beginnnerSoundSettings.maghribBeginnnerTime;
    } else if ([identifier isEqualToString:@"eshaB"]) {
      fajarTime = primaryTimeTable.esha;
      fajarTimeUnChanged = primaryTimeTable.esha;
      userSettedTimeCount = beginnnerSoundSettings.eshaBeginnnerTime;
    }
  }
  else {
    if ([identifier isEqualToString:@"fajarJ"]) {
      fajarTime = primaryTimeTable.fajar;
      fajarTimeUnChanged = primaryTimeTable.fajar;
      isTimeFromatAM = YES;
      userSettedTimeCount = jammatSoundSettings.fajarJammatTime;
    } else if ([identifier isEqualToString:@"zoharJ"]) {
      fajarTime = primaryTimeTable.zoharj;
      fajarTimeUnChanged = primaryTimeTable.zoharj;
      userSettedTimeCount = jammatSoundSettings.zoharJammatTime;
    } else if ([identifier isEqualToString:@"asarJ"]) {
      fajarTime = primaryTimeTable.asarj;
      fajarTimeUnChanged = primaryTimeTable.asarj;
      userSettedTimeCount = jammatSoundSettings.asarJammatTime;
    } else if ([identifier isEqualToString:@"maghribJ"]) {
      fajarTime = primaryTimeTable.maghrib;
      fajarTimeUnChanged = primaryTimeTable.maghrib;
      userSettedTimeCount = jammatSoundSettings.maghribJammatTime;
    } else if ([identifier isEqualToString:@"eshaJ"]) {
      fajarTime = primaryTimeTable.eshaj;
      fajarTimeUnChanged = primaryTimeTable.eshaj;
      userSettedTimeCount = jammatSoundSettings.eshaJammatTime;
    }
  }
  fajarTime =  [Utils reformatTimeTo24timeFormat:fajarTime isAMformat:isTimeFromatAM withTimeFormat:tableTimeFormat.format];
  
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
  [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  [dateFormatter setDateFormat:@"d MMM yyyy"];
  
  NSString *monthYear = [dateFormatter stringFromDate:[[Utils today] dateByAddingTimeInterval:60*60*24*dayIndex]];
  NSString *fireTimeString = [NSString stringWithFormat:@"%@ %@", monthYear, fajarTime];
  [dateFormatter setDateFormat:@"d MMM yyyy HH:mm"];
  NSDate *jamatDate = [dateFormatter dateFromString:fireTimeString];
  NSLog(@">>>> event date: %@, userSettedTime: %@", jamatDate, userSettedTimeCount);
    
    if (userSettedTimeCount == nil) {
        userSettedTimeCount = @"";
    }
    
    jamatDate = [jamatDate dateByAddingTimeInterval: (-60 * [userSettedTimeCount integerValue])];
  return @[jamatDate, userSettedTimeCount, fajarTimeUnChanged];
}

- (BOOL)isTimetableSoundOffWithIdentifier:(NSString *)identifier {
  MasjidTimetable *currentTimeTable= [[MTDBHelper sharedDBHelper]
                                      getTimetableWithMashjidID:primaryMasjid.masjidId
                                      forDate:[Utils today]];
  
  if ([identifier isEqualToString:@"fajarJ"]) {
    return currentTimeTable.fajarSoundOff;
  } else if ([identifier isEqualToString:@"zoharJ"]) {
    return currentTimeTable.zoharSoundOff;
  } else if ([identifier isEqualToString:@"asarJ"]) {
    return currentTimeTable.asarSoundOff;
  } else if ([identifier isEqualToString:@"maghribJ"]) {
    return currentTimeTable.maghribSoundOff;
  } else if ([identifier isEqualToString:@"eshaJ"]) {
    return currentTimeTable.eshaSoundOff;
  }
  
  if ([identifier isEqualToString:@"fajarB"]) {
    return currentTimeTable.fajarSoundOff;
  } else if ([identifier isEqualToString:@"zoharB"]) {
    return currentTimeTable.zoharSoundOff;
  } else if ([identifier isEqualToString:@"asarB"]) {
    return currentTimeTable.asarSoundOff;
  } else if ([identifier isEqualToString:@"maghribB"]) {
    return currentTimeTable.maghribSoundOff;
  } else if ([identifier isEqualToString:@"eshaB"]) {
    return currentTimeTable.eshaSoundOff;
  }
  
  return NO;
}

- (void)changeNotificationSound:(BOOL)unMute withNotificationId:(NSArray *)info
{// TODO: notification upgrade
    NSString *identifier = info[0];
    NSArray *fireDateInfo = [self getFireDateInfoWithIdentifier:identifier dayIndex:0];
    
    if (jammatSoundSettings.soundName) {
        __block BOOL notificationExist = NO;
        __block NSDate *fireDate;
      
        if (IS_IOS_10_OR_LATER) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
              for (UNNotificationRequest *request in requests) {
                  if ([request.identifier isEqualToString:identifier]) {
                      UNCalendarNotificationTrigger *trigger = (UNCalendarNotificationTrigger *)request.trigger;
                      fireDate = trigger.nextTriggerDate;
                      notificationExist = YES;
                      
                      // remove old one
                      [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
                      
                      UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                      content.title = [NSString localizedUserNotificationStringForKey:@"Masjid Alert" arguments:nil];
                      content.body = [NSString stringWithFormat:@"%@ Jamaat in %@ mins at %@ ", info[1], fireDateInfo[1], fireDateInfo[2]];
                      content.categoryIdentifier = @"Alert";
                      
                      content.sound = unMute ? [UNNotificationSound soundNamed:jammatSoundSettings.soundName] : [UNNotificationSound soundNamed:@"muteSound.wav"];
                      
                      // Deliver the notification in five seconds.
                      NSCalendar *calendar = [NSCalendar currentCalendar];
                      NSDateComponents *dateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                                     fromDate:fireDate];
                      UNCalendarNotificationTrigger *newTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents
                                                                                                                        repeats:YES];
                      
                      UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                                            content:content trigger:newTrigger];
                      // schedule localNotification
                      UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                      [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                          if (!error) {
                              NSLog(@">>>>>>> add NotificationRequest succeeded!");
                          }
                      }];
                      
                      break;
                  }
              }
            }];
        } else {
              for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
                  if ([[localNotification.userInfo valueForKey:@"identifier"] isEqualToString:identifier]) {
                      notificationExist = YES;
                      fireDate = localNotification.fireDate;
                      [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                      break;
                  }
              }
              if (notificationExist) {
                  UILocalNotification *notification = [[UILocalNotification alloc] init];
                  notification.category = @"Alert";
                  notification.alertBody = [NSString stringWithFormat:@"%@ Jamaat in %@ mins at %@ ", info[1], fireDateInfo[1], fireDateInfo[2]];
                  notification.fireDate = fireDate;
                  notification.soundName = unMute ? jammatSoundSettings.soundName : nil;
                  notification.alertAction = @"Go to App";
                  notification.repeatInterval = NSCalendarUnitDay;
                  notification.userInfo = [NSDictionary dictionaryWithObject:identifier forKey:@"identifier"];
                  [[UIApplication sharedApplication] scheduleLocalNotification:notification];
              }
        }
    
    }
    
    if (beginnnerSoundSettings.soundName) {
        BOOL notificationExist = NO;
        NSDate *fireDate;
        for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            if ([[localNotification.userInfo valueForKey:@"identifier"] isEqualToString:identifier]) {
                notificationExist = YES;
                fireDate = localNotification.fireDate;
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
                break;
            }
        }
        if (notificationExist) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.category = @"Alert";
            notification.alertBody = [NSString stringWithFormat:@"%@ Beginning in %@ mins at %@ ", info[1], fireDateInfo[1], fireDateInfo[2]];
            notification.alertBody = @"Beginner Notification";
            notification.fireDate = fireDate;
            notification.soundName = unMute ? beginnnerSoundSettings.soundName : nil;
            notification.alertAction = @"Go to App";
            notification.repeatInterval = NSCalendarUnitDay;
            notification.userInfo = [NSDictionary dictionaryWithObject:identifier forKey:@"identifier"];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

- (void)cancelJammatLocalNotifications
{// TODO: notification upgrade
    
    if (IS_IOS_10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            for (UNNotificationRequest *request in requests) {
                NSString *identifier = request.identifier;
                
                if ([[identifier substringFromIndex:identifier.length - 1] isEqualToString:@"J"] || [[identifier substringFromIndex:identifier.length - 1] isEqualToString:@"B"]) {
                    [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
                }
            }
        }];
    } else {
        for (UILocalNotification *localNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
            NSString * identifier = [localNotification.userInfo valueForKey:@"identifier"];
            if ([[identifier substringFromIndex:identifier.length - 1] isEqualToString:@"J"] || [[identifier substringFromIndex:identifier.length - 1] isEqualToString:@"B"]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
    
}

- (void)updateDateForNextDay
{
  if ([Utils getFromTimeFloatValue:[Utils getCurrentTime]] == 0.0) {
    [self cancelJammatLocalNotifications];
    [self cancelJamaatLocalNotificationsforTimeChanges];
    [self creatLocalNotificationsForJammat];
    [self creatLocalNotificationsForJammatTimesChanged];
  }
}

#pragma mark - TimeTable speakers state

- (void)checkForTimeTableSpeakersState
{
  primaryMasjid = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"];
  MasjidTimetable *currentTimeTable = [[MTDBHelper sharedDBHelper] getTimetableWithMashjidID:primaryMasjid.masjidId forDate:[Utils today]];
  TimeTableFormat *currentTimeTableFormat = [[MTDBHelper sharedDBHelper] getTimeTableFormat:primaryMasjid.masjidId forDate:[Utils today]];
  if (primaryMasjid && currentTimeTable && currentTimeTableFormat) {
    if (currentTimeTable.fajarSoundOff) {
      NSString *notificationIdentifier = @"fajarJ";
      if (![self isSpeakerClickedAftherJamaatTime:@[currentTimeTable.fajarSpeakerSelectedTime, notificationIdentifier]]) {
        if ([self isJamaatNotificationTimePassed:notificationIdentifier]) {
          currentTimeTable.fajarSoundOff = NO;
        }
      }
    }
    if (currentTimeTable.zoharSoundOff) {
      NSString *notificationIdentifier = @"zoharJ";
      if (![self isSpeakerClickedAftherJamaatTime:@[currentTimeTable.zoharSpeakerSelectedTime, notificationIdentifier]]) {
        if ([self isJamaatNotificationTimePassed:notificationIdentifier]) {
          currentTimeTable.zoharSoundOff = NO;
        }
      }
    }
    if (currentTimeTable.asarSoundOff) {
      NSString *notificationIdentifier = @"asarJ";
      if (![self isSpeakerClickedAftherJamaatTime:@[currentTimeTable.asarSpeakerSelectedTime, notificationIdentifier]]) {
        if ([self isJamaatNotificationTimePassed:notificationIdentifier]) {
          currentTimeTable.asarSoundOff = NO;
        }
      }
    }
    if (currentTimeTable.maghribSoundOff) {
      NSString *notificationIdentifier = @"maghribJ";
      if (![self isSpeakerClickedAftherJamaatTime:@[currentTimeTable.maghribSpeakerSelectedTime, notificationIdentifier]]) {
        if ([self isJamaatNotificationTimePassed:notificationIdentifier]) {
          currentTimeTable.maghribSoundOff = NO;
        }
      }
    }
    if (currentTimeTable.eshaSoundOff) {
      NSString *notificationIdentifier = @"eshaJ";
      if (![self isSpeakerClickedAftherJamaatTime:@[currentTimeTable.eshaSpeakerSelectedTime, notificationIdentifier]]) {
        if ([self isJamaatNotificationTimePassed:notificationIdentifier]) {
          currentTimeTable.eshaSoundOff = NO;
        }
      }
    }
    [[MTDBHelper sharedDBHelper] saveContext];
  }
  [self performSelector:@selector(checkForTimeTableSpeakersState) withObject:nil afterDelay:60.0];
}

- (BOOL)isSpeakerClickedAftherJamaatTime:(NSArray*)info
{// TODO: notification upgrade
  NSDateFormatter *dateFormatter = [NSDateFormatter new];
  [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
  [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
  [dateFormatter setDateFormat:@"d MMM yyyy HH:mm"];
  
  NSDate *speakerSelectedTime = [dateFormatter dateFromString:info[0]];
  __block NSDate *jamaatTimeDate;
    __block BOOL returnValue = YES;
    
    if (IS_IOS_10_OR_LATER) {
        
        dispatch_semaphore_t semaphor = dispatch_semaphore_create(0);
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            
            NSString *targetIdentifier = info[1];
            for (UNNotificationRequest *request in requests) {
                
                if ([request.identifier isEqualToString:targetIdentifier]) {
                    UNCalendarNotificationTrigger *trigger = (UNCalendarNotificationTrigger *)request.trigger;
                    NSDate *date = trigger.nextTriggerDate;
                    jamaatTimeDate = [date dateByAddingTimeInterval:60];
                    
                    returnValue = [speakerSelectedTime timeIntervalSinceDate:jamaatTimeDate] > 0;
                    break;
                }
            }
            
            dispatch_semaphore_signal(semaphor);
        }];
        dispatch_semaphore_wait(semaphor, DISPATCH_TIME_FOREVER);
        
        return returnValue;
        
    } else {
        NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userInfo.identifier == %@", info[1]];
        NSArray *result = [notifications filteredArrayUsingPredicate:predicate];
        if ([result count ] > 0) {
            NSDate *date = [(UILocalNotification*)[result objectAtIndex:0] fireDate];
            jamaatTimeDate = [date dateByAddingTimeInterval:60];
            
            returnValue = [speakerSelectedTime timeIntervalSinceDate:jamaatTimeDate] > 0;
        }
        
        return returnValue;
    }
}

- (BOOL)isJamaatNotificationTimePassed:(NSString *)identifier
{// TODO: notification upgrade
    
    if (IS_IOS_10_OR_LATER) {
        
        __block BOOL returnValue = NO;
        
        dispatch_semaphore_t semaphor = dispatch_semaphore_create(0);
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            
            for (UNNotificationRequest *request in requests) {
                
                if ([request.identifier isEqualToString:identifier]) {
                    UNCalendarNotificationTrigger *trigger = (UNCalendarNotificationTrigger *)request.trigger;
                    NSDate *date = trigger.nextTriggerDate;
                    date = [date dateByAddingTimeInterval:60];
                    
                    returnValue = [date timeIntervalSinceDate:[NSDate date]] < 0;
                    break;
                }
            }
            
            dispatch_semaphore_signal(semaphor);
        }];
        dispatch_semaphore_wait(semaphor, DISPATCH_TIME_FOREVER);
        
        return returnValue;
        
    } else {
        NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userInfo.identifier == %@", identifier];
        NSArray *result = [notifications filteredArrayUsingPredicate:predicate];
        if ([result count ] > 0) {
            NSDate *date = [(UILocalNotification*)[result objectAtIndex:0] fireDate];
            date = [date dateByAddingTimeInterval:60];
            
            return [date timeIntervalSinceDate:[NSDate date]] < 0 ;
        }
        return NO;
    }
  
}

- (void)sendDeviceToken:(NSString *)token
{
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com/data/devicetokens.php"]];
  
  [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
  NSDictionary * params  = @{@"device_token" : token};
  NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@""  parameters:params];
  
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                       {
                                         
                                       }
                                                                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                        [SVProgressHUD dismiss];
                                                                                      }];
  [operation start];
  
}


- (void)updateMasjidsInfoInServer
{
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com/data/favorite.php"]];
  
  [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
  [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
  NSDictionary * params;
  if ([Utils getDeviceToken]) {
    params  = @{@"device_token" : [Utils getDeviceToken], @"masjid_ids" : [self getMasjidsIds]};
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:@""  parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                           
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                          
                                                                                        }];
    [operation start];
  }
}

- (NSString *)getMasjidsIds
{
  NSString *ids = @"";
  Masjid *masjid1 = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"1"];
  Masjid *masjid2 = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"2"];
  Masjid *masjid3 = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"3"];
  Masjid *masjid4 = [[MTDBHelper sharedDBHelper] getFavoritMasjidByPriority:@"4"];
  
  ids = masjid1 ? [ids stringByAppendingString:[NSString stringWithFormat:@"%i", masjid1.masjidId]] : ids;
  ids = masjid2 ? [ids stringByAppendingString:[NSString stringWithFormat:@",%i", masjid2.masjidId]] : ids;
  ids = masjid3 ? [ids stringByAppendingString:[NSString stringWithFormat:@",%i", masjid3.masjidId]] : ids;
  ids = masjid4 ? [ids stringByAppendingString:[NSString stringWithFormat:@",%i", masjid4.masjidId]] : ids;
  
  if (ids.length > 0 && [[ids substringToIndex:1] isEqualToString:@","]) {
    ids = [ids stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
  }
  
  return ids;
}

@end
