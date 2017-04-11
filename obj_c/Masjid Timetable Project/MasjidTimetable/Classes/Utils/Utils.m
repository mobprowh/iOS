//
//  Utils.m
//  GeoLocator_iOS
//
//  Created by Gor Igityan on 2/19/15.
//  Copyright (c) 2015 VTGSoftware LLC. All rights reserved.
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "Utils.h"

@implementation Utils

+ (void)saveToUserDefaultsWithKey:(NSString *)key value:(id)value
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:value forKey:key];
        [standardUserDefaults synchronize];
    }
}

+ (id)readFromUserDefaults:(NSString *)key
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [standardUserDefaults objectForKey:key];
    }
    
    return nil;
}

+ (void)saveFirstRunInfo:(BOOL)isFirstRun
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setBool:isFirstRun forKey:@"first_run"];
        [standardUserDefaults synchronize];
    }
}

+ (BOOL)getFirstRunInfo
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [standardUserDefaults boolForKey:@"first_run"];
    }
    
    return NO;
}

+ (void)setSettingsAlertShown
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:@"1" forKey:@"isSettingsAlertShown"];
    }
}

+ (BOOL)isSettingsfirstRunAlertShown
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [[standardUserDefaults valueForKey:@"isSettingsAlertShown"] boolValue];
    }
    return NO;
}

+ (NSDate*)today
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    NSString *todayDateStringWithTimeZone = [dateFormatter stringFromDate:[NSDate date]];
    
    return [dateFormatter dateFromString:todayDateStringWithTimeZone];
}

+ (NSDate*)tomorrow
{
    return [[self today] dateByAddingTimeInterval:60*60*24];
}

+ (NSString *)getCurrentTime
{
    NSDateFormatter *date = [NSDateFormatter new];
    [date setTimeZone:[NSTimeZone systemTimeZone]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [date setLocale:locale];
    [date setDateFormat:@"HH:mm"];
    
    return [date stringFromDate:[NSDate date]];
}

+ (float)getFromTimeFloatValue:(NSString *)time
{
    return [[time stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue];
}

+ (void)setEventDays:(NSString *)days
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:days forKey:@"eventsDays"];
    }
}

+ (int)getEventsDays
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return  (int)[[standardUserDefaults valueForKey:@"eventsDays"] integerValue];
    }
    return 0;
}

+ (void)setEventHours:(NSString *)hours
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:hours forKey:@"eventsHours"];
    }
}

+ (int)getEventsHours
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return  (int)[[standardUserDefaults valueForKey:@"eventsHours"] integerValue];
    }
    
    return 0;
}

+ (NSDate *)getDateFromString:(NSString *)dateString
{
    NSDateFormatter * converter = [[NSDateFormatter alloc]init];
    [converter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [converter setTimeZone:[NSTimeZone systemTimeZone]];
    [converter setDateFormat:@"d MMM yyyy HH:mm"];
    
    return [converter dateFromString:dateString];
}

+ (NSDate *)getCurrenMonthFirstDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra  | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[Utils today]];
    components.day = 1;
    
    return  [gregorian dateFromComponents:components];
}

+ (NSDate *)getCurrentMonthLastDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra  | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[Utils today]];
    components.month += 1;
    components.day = 0;
    
    return  [gregorian dateFromComponents:components];
}

+ (void)setAlarmPeriod:(int)periud
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setBool:periud forKey:@"AlarmPeriud"];
    }
}

+ (void)setAlarmMinutesCount:(int)minutes
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:minutes forKey:@"alarmMinutes"];
    }
}

+ (BOOL)isAlarmAfterJamaat
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    return [standardUserDefaults boolForKey:@"AlarmPeriud"];
}

+ (int)getAlarmMinutesCount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    return (int)[standardUserDefaults integerForKey:@"alarmMinutes"];

}

+ (NSString *)changeTo24timeFormat:(NSString*)eventStart
{
    if (([eventStart containsString:@"AM"] || [eventStart containsString:@"PM"]) && [[eventStart stringByReplacingOccurrencesOfString:@":" withString:@"."] floatValue] < 13.0) {
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setTimeZone:[NSTimeZone systemTimeZone]];
        [date setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        
        [date setAMSymbol:@"AM"];
        [date setPMSymbol:@"PM"];
        [date setDateFormat:@"hh:mm a"];
        
        NSDate *evenStartDate = [date dateFromString:eventStart];
        
        [date setDateFormat:@"HH:mm"];
        
        eventStart = [date stringFromDate:evenStartDate];
    } else {
        if ([eventStart containsString:@"AM"] || [eventStart containsString:@"PM"]) {
            eventStart  = [eventStart stringByReplacingCharactersInRange:NSMakeRange(eventStart.length - 3,3) withString:@""];
        }
    }
    return eventStart;
}

+ (NSDate*)convertToDateFormat:(NSDate*)date
{
    NSDateFormatter * converter = [[NSDateFormatter alloc]init];
    [converter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [converter setTimeZone:[NSTimeZone systemTimeZone]];
    [converter setDateFormat:@"d MMM yyyy"];
    NSString *dateString = [converter stringFromDate:date];
    
    return [converter dateFromString:dateString];
}

+ (NSDate *)getDatefromDays:(NSDate*)date AndHours:(NSString *)hours
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"d MMM yyyy"];
    
    NSString *monthYear = [dateFormatter stringFromDate:date];
    NSString *fireTimeString = [NSString stringWithFormat:@"%@ %@", monthYear, hours];
    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm"];
    NSDate *currentDate = [dateFormatter dateFromString:fireTimeString];
    
    return currentDate;
}

+ (void)setJamaatTimeChangesNotifyCount:(NSString *)timeCount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:timeCount forKey:@"NotifyCount"];
    }
}

+ (int)getJamaatTimeChangesCount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return (int)[[standardUserDefaults valueForKey:@"NotifyCount"] integerValue];
    }
    
    return 0;
}

+ (NSArray*)monthNameString:(NSDate*)currentDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
    
    NSDateFormatter *formate = [NSDateFormatter new];
    
    return @[[[formate standaloneMonthSymbols] objectAtIndex:([components month] - 1)], [NSString stringWithFormat:@"%li", (long)[components day]]];
}

+(void)setMasjidListOpenCountZero
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:@"0" forKey:@"ListOPeningCount"];
    }
}

+ (void)setMasjidListIsOpened
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:@"1" forKey:@"ListOPeningCount"];
    }
}

+ (BOOL)masjidsListIsOpened
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [[standardUserDefaults valueForKey:@"ListOPeningCount"] boolValue];
    }
    return 0;
}

+ (NSString *)reformatTimeTo24timeFormat:(NSString*)eventStart
                              isAMformat:(BOOL)formatAM
                          withTimeFormat:(int)format
{
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setTimeZone:[NSTimeZone systemTimeZone]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [date setLocale:locale];
    
    if (format == 12 ) {
        [date setAMSymbol:@"AM"];
        [date setPMSymbol:@"PM"];
        [date setDateFormat:@"hh:mm a"];
        
        NSString *timeFormat = formatAM ? @" AM" : @" PM";
        eventStart = [eventStart stringByAppendingString:timeFormat];
        NSDate *evenStartDate = [date dateFromString:eventStart];
        [date setDateFormat:@"HH:mm"];
        
        eventStart = [date stringFromDate:evenStartDate];
    }
    return eventStart;
}

+ (NSDate *)startOfMonth:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    //NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSWeekCalendarUnit | NSCalendarUnitWeekday fromDate:[NSDate date]];
    [components setMonth:[components month] + month];
    [components setDay:1];
    
    return [calendar dateFromComponents:components];
}

+ (NSDate *)endOfMonth:(int)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    NSDateComponents *months = [[NSDateComponents alloc] init];
    [months setMonth:month];
    NSDate *plusOneMonthDate = [calendar dateByAddingComponents:months toDate:[NSDate date] options:0];
    
    NSDateComponents *plusOneMonthDateComponents = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth fromDate:plusOneMonthDate];
    
    return [[calendar dateFromComponents:plusOneMonthDateComponents] dateByAddingTimeInterval:-1];
}

+ (NSString *)getCurrentFullTime
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d MMM yyyy HH:mm"];
    
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (void)setTimeTableOpenCount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setInteger:[self getTimeTableOpenCount] + 1 forKey:@"timeTableOpenCount"];
    }
}

+ (NSInteger)getTimeTableOpenCount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [standardUserDefaults integerForKey:@"timeTableOpenCount"];
    }
    return 0;
}

+ (void)saveTimeTableLastUpdateDate
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:[Utils today] forKey:@"timeTableLastUpdateDate"];
      NSDate *currentDate = [NSDate date];
      NSCalendar* calendar = [NSCalendar currentCalendar];
      NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components
      [[NSUserDefaults standardUserDefaults] setInteger:[components month] forKey:@"LastUpdateMonth"];

    }
}

+ (void)saveIssueLastUpdateTime
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:[Utils today] forKey:@"issueLastUpdateDate"];
    }
}

+ (void)saveInstructionLastUpdateTime
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setValue:[Utils today] forKey:@"instructionLastUpdateDate"];
    }
}

+ (NSDate *)getIssueLastUpdateTime
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [standardUserDefaults valueForKey:@"issueLastUpdateDate"];
    }
    return nil;
}

+ (NSDate *)getInstructionLastUpdateTime
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [standardUserDefaults valueForKey:@"issueLastUpdateDate"];
    }
    return nil;
}

+ (BOOL)isInstructionupdateTimeExpired
{
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:unitFlags fromDate:[self getInstructionLastUpdateTime] toDate:[self today] options:0];
    
    return [components day] >= 30;
}

+ (void)setAlarmEnabled:(BOOL)isEnabled
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setBool:isEnabled forKey:@"AlarmEnabled"];
    }
}

+ (BOOL)IsAlarmEnabled
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
      return [standardUserDefaults boolForKey:@"AlarmEnabled"];
    }
    return NO;
}

+ (void)setDeviceToken:(NSString *)token
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setValue:token forKey:@"deviceToken"];
}
+ (NSString *)getDeviceToken
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults valueForKey:@"deviceToken"];
}

+ (NSDate *)getTimeTableLastUpdateDate
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [standardUserDefaults valueForKey:@"timeTableLastUpdateDate"];
    }
    return nil;
}

+ (BOOL)isMonthChanged
{
  NSDate *currentDate = [NSDate date];
  NSCalendar* calendar = [NSCalendar currentCalendar];
  NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate]; // Get necessary date components

    return ([[NSUserDefaults standardUserDefaults] integerForKey:@"LastUpdateMonth"] != [components month]);

}

+ (BOOL)isTimeTableUpdateExpired
{
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:unitFlags fromDate:[self getTimeTableLastUpdateDate] toDate:[self today] options:0];
    
    return [components day] >= 5;
}

+ (BOOL)isIssueupdateTimeExpired
{
        NSUInteger unitFlags = NSCalendarUnitDay;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:unitFlags fromDate:[self getIssueLastUpdateTime] toDate:[self today] options:0];
        
        return [components day] >= 30;
}

+ (void)checkIsUserCountTimeToPast
{
    if ([[self getTimeTableLastUpdateDate] timeIntervalSinceDate:[self today]] > 0) {
        [self saveTimeTableLastUpdateDate];
    }
}

+ (void)setTapsLimitForTasbeeh:(int)count
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:count forKey:@"tasbeehtapsCount"];
}

+ (int)getTapsLimitForTasbeeh
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return (int)[standardUserDefaults integerForKey:@"tasbeehtapsCount"];
}

+ (void)setPlayLimitForTasbeeh:(int)count
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:count forKey:@"tasbeehPlayCount"];
}

+ (int)getPlayLimitForTasbeeh
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return (int)[standardUserDefaults integerForKey:@"tasbeehPlayCount"];
}

+ (void)setTasbeehSoundName:(NSString *)soundName
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults setValue:soundName forKey:@"tasbeehSoundName"];
}

+ (NSString *)getTasbeehSoundName
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    return (NSString *)[standardUserDefaults valueForKey:@"tasbeehSoundName"];
}

+ (void)setTasbeehType:(int)tasbeehType
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:tasbeehType forKey:@"tasbeehType"];
}

+ (int)getTasbeehType
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    return (int)[standardUserDefaults integerForKey:@"tasbeehType"];
}

+ (void)setAlarmButtonText:(NSString *)text
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setValue:text forKey:@"buttonText"];
  
}
+ (NSString *)getAlarmButtonText
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults valueForKey:@"buttonText"];
}

+ (void)setCounterVibrateCount:(int)vibrateCount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:vibrateCount forKey:@"vibrateCount"];
   
}

+ (int)getCounterVibrateCount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return (int)[standardUserDefaults integerForKey:@"vibrateCount"];
}
+ (void)setTapVibrateCount:(int)vibrateCount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:vibrateCount forKey:@"tapVibrateCount"];
}

+ (int)getTapVibrateCount
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return (int)[standardUserDefaults integerForKey:@"tapVibrateCount"];
}

+ (void)setAlertTypeForCounter:(int)type
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:type forKey:@"counterType"];
}

+ (BOOL)isAlertTypeForCounterVibrate
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    return [standardUserDefaults boolForKey:@"counterType"];
}

+ (void)setAlertTypeForTap:(int)type
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setBool:type forKey:@"tapType"];

}
+ (BOOL)isAlertTypeForTapVibrate
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    return [standardUserDefaults boolForKey:@"tapType"];
}

+ (void)saveUserLatCoordinate:(NSNumber *)lat
{
    if (lat != nil) {
        [self saveToUserDefaultsWithKey:@"lat" value:lat];
    }
}

+ (void)saveUserLngCoordinate:(NSNumber *)lng
{
    if (lng != nil) {
        [self saveToUserDefaultsWithKey:@"lng" value:lng];
    }
}

+ (NSNumber *)getUserLatCoordinate
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [standardUserDefaults objectForKey:@"lat"];
    }
    
    return nil;
}

+ (NSNumber *)getUserLngCoordinate
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        return [standardUserDefaults objectForKey:@"lng"];
    }
    
    return nil;
}

@end
