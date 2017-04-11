//
//  AppDelegate.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//


extern int masjidTurn;
extern int val,val1,val2,val3,val4,val5,val6,alert,mSound;
extern int xts,l,localDataFetched;
extern BOOL changeFormat;
extern BOOL isSearching;
extern BOOL isColored;
extern BOOL localDataForSecond;
extern BOOL localDataForThird;
extern BOOL localDataForFourth;
extern NSArray *jsonCalled;
extern NSArray *globalMasjidNotes,*globalTimeTable,*globalTimeTableFormat,*globalTimeTableValues;
extern NSMutableArray *globalMasjidBasicValues;
extern NSMutableArray *arrayList,*newArrayList,*get,*addids,*addpri,*fetchResults;
extern NSDictionary *checking;
extern NSMutableDictionary *dictData,*thirdMasjidDictionary;
extern NSMutableDictionary *globalMasjidNames;
extern NSString *globalMasjidID;
extern NSString *fPrayer,*zPrayer,*aPrayer,*mPrayer,*ePrayer,*timetableFormat;
extern NSString *fajarFormat,*zoharFormat,*asarFormat,*maghribFormat,*eshaFormat,*fajarJFormat,*zoharJFormat,*asarJFormat,*maghribJFormat,*eshaJFormat,*sunsetFormat;
extern NSString *fajarPrayer,*zoharPrayer,*asarPrayer,*maghribPrayer,*eshaPrayer;
extern NSString *previousFajar,*previousZohar,*previousAsar,*previousMaghrib,*previousEsha;
extern NSString *getID,*address,*city,*state,*pin,*country,*telephoneNo;
extern NSString *fajarJammat,*zoharJammat,*asarJammat,*maghribJammat,*eshaJammat,*fajarBegin,*zoharBegin,*asarBegin,*maghribBegin,*eshaBegin;
extern NSString *myMonthString,*dVal,*prayerID,*JsonDate,*interval;
extern NSString *currentEventTime;
//extern UILocalNotification *localNotification;
extern UIImage *themeImage;
extern Masjid *primaryMasjid;
extern MasjidTimetable *primaryTimeTable;
extern JammatSoundSettings *jammatSoundSettings;
extern BeginnerSoundSettings *beginnnerSoundSettings;
extern PhoneMuteSettings *phoneMuteSettings;
extern NSDate *currentDatefortest;

@class PBViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) PBViewController *viewController;

- (void)cancelJammatLocalNotifications;
- (void)creatLocalNotificationsForJammat;
- (void)changeNotificationSound:(BOOL)unMute withNotificationId:(NSArray *)info;
- (void)cancelEventsLocalNotifications;
- (void)creatLocalNotificationsForEvents;
- (void)cancelJamaatLocalNotificationsforTimeChanges;
- (void)creatLocalNotificationsForJammatTimesChanged;
- (void)createPhoneMuteNotifications;
- (void)cancelMuteNotifications;
- (void)checkForTimeTableSpeakersState;
- (void)updateMasjidsInfoInServer;

@end

