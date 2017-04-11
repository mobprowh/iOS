//
//  TimeTableFormat.m
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/24/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "TimeTableFormat.h"


@implementation TimeTableFormat

@dynamic masjidId;
@dynamic format;
@dynamic month;
@dynamic timetableformatId;

- (void)setAttributes:(NSDictionary *)attributes
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.month = [dateFormatter dateFromString:[attributes valueForKeyPath:@"timetable_month"]];
    self.masjidId = [[attributes valueForKeyPath:@"masjid_id"] intValue];
    self.timetableformatId = [[attributes valueForKeyPath:@"timetable_id"] intValue];
    self.format = [[attributes valueForKeyPath:@"timetable_format"] intValue];
}

@end
