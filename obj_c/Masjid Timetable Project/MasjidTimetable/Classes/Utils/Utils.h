//
//  Utils.h
//  GeoLocator_iOS
//
//  Created by Gor Igityan on 2/19/15.
//  Copyright (c) 2015 VTGSoftware LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface Utils : NSObject <UIAlertViewDelegate>

+ (void)saveFirstRunInfo:(BOOL)isFirstRun;
+ (BOOL)getFirstRunInfo;
+ (void)setSettingsAlertShown;
+ (BOOL)isSettingsfirstRunAlertShown;
+ (NSDate*)today;
+ (NSDate*)tomorrow;
+ (NSString *)getCurrentTime;
+ (float)getFromTimeFloatValue:(NSString *)time;
+ (void)setEventDays:(NSString *)days;
+ (int)getEventsDays;
+ (void)setEventHours:(NSString *)hours;
+ (int)getEventsHours;
+ (NSString *)changeTo24timeFormat:(NSString*)eventStart;
+ (NSDate *)convertToDateFormat:(NSDate*)date;
+ (NSDate *)getDatefromDays:(NSDate*)date AndHours:(NSString *)hours;
+ (void)setJamaatTimeChangesNotifyCount:(NSString *)timeCount;
+ (int)getJamaatTimeChangesCount;
+ (NSArray*)monthNameString:(NSDate*)currentDate;
+ (void)setMasjidListIsOpened;
+ (BOOL)masjidsListIsOpened;
+ (void)setMasjidListOpenCountZero;
+ (NSString *)reformatTimeTo24timeFormat:(NSString*)eventStart isAMformat:(BOOL)formatAM withTimeFormat:(int)format;
+ (NSDate *)startOfMonth:(int)month;
+ (NSDate *)endOfMonth:(int)month;
+ (NSString *)getCurrentFullTime;
+ (void)setTimeTableOpenCount;
+ (NSInteger)getTimeTableOpenCount;
+ (void)saveTimeTableLastUpdateDate;
+ (NSDate *)getTimeTableLastUpdateDate;
+ (BOOL)isTimeTableUpdateExpired;
+ (BOOL)isMonthChanged;
+ (void)checkIsUserCountTimeToPast;
+ (NSDate *)getDateFromString:(NSString *)dateString;
+ (NSDate *)getCurrenMonthFirstDay;
+ (NSDate *)getCurrentMonthLastDay;
+ (void)setAlarmPeriod:(int)periud;
+ (void)setAlarmMinutesCount:(int)minutes;
+ (BOOL)isAlarmAfterJamaat;
+ (int)getAlarmMinutesCount;
+ (void)saveIssueLastUpdateTime;
+ (BOOL)isIssueupdateTimeExpired;
+ (void)saveInstructionLastUpdateTime;
+ (BOOL)isInstructionupdateTimeExpired;
+ (void)setDeviceToken:(NSString *)token;
+ (NSString *)getDeviceToken;
+ (void)setTapsLimitForTasbeeh:(int)count;
+ (int)getTapsLimitForTasbeeh;
+ (void)setPlayLimitForTasbeeh:(int)count;
+ (int)getPlayLimitForTasbeeh;
+ (void)setTasbeehSoundName:(NSString *)soundName;
+ (NSString *)getTasbeehSoundName;
+ (void)setTasbeehType:(int)tasbeehType;
+ (int)getTasbeehType;
+ (void)setAlarmButtonText:(NSString *)text;
+ (NSString *)getAlarmButtonText;
+ (void)setCounterVibrateCount:(int)vibrateCount;
+ (int)getCounterVibrateCount;
+ (void)setTapVibrateCount:(int)vibrateCount;
+ (int)getTapVibrateCount;
+ (void)setAlertTypeForCounter:(int)type;
+ (BOOL)isAlertTypeForCounterVibrate;
+ (void)setAlertTypeForTap:(int)type;
+ (BOOL)isAlertTypeForTapVibrate;
+ (void)saveUserLatCoordinate:(NSNumber *)lat;
+ (void)saveUserLngCoordinate:(NSNumber *)lng;
+ (NSNumber *)getUserLatCoordinate;
+ (NSNumber *)getUserLngCoordinate;

@end