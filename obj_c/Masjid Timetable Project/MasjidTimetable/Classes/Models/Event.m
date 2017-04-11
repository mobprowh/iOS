//
//  Event.m
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/18/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "Event.h"


@implementation Event

@dynamic date;
@dynamic details;
@dynamic eventId;
@dynamic time;
@dynamic title;
@dynamic masjidId;
@dynamic created;
@dynamic longDate;

- (void)setAttributes:(NSDictionary *)attributes
{
    self.date = [attributes valueForKeyPath:@"event_date"];
    self.time = [attributes valueForKeyPath:@"event_time"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.longDate = [dateFormatter dateFromString:self.date];
    self.date = [self convertToDateFormat:self.date];
    self.masjidId = [[attributes valueForKeyPath:@"masjid_id"] intValue];
    self.eventId = [[attributes valueForKeyPath:@"event_id"] intValue];
    self.details = [attributes valueForKeyPath:@"event_details"];
    self.title = [attributes valueForKeyPath:@"event_title"];
    self.created = [attributes valueForKeyPath:@"event_created"];
}

- (NSString*)convertToDateFormat:(NSString*)date
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *convertedDate = [dateFormatter dateFromString:date];
    NSDateFormatter * converter = [[NSDateFormatter alloc]init];
    [converter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [converter setDateFormat:@"dd MMM yyyy"];
    
    return [converter stringFromDate:convertedDate];
}

@end
