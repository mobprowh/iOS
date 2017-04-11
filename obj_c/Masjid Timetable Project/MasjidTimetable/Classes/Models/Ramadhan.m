//
//  Ramadhan.m
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/19/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "Ramadhan.h"


@implementation Ramadhan

@dynamic asar;
@dynamic asarj;
@dynamic date;
@dynamic esha;
@dynamic eshaj;
@dynamic fajar;
@dynamic maghrib;
@dynamic masjidId;
@dynamic subahsadiq;
@dynamic sunrise;
@dynamic zohar;
@dynamic zoharj;
@dynamic iftar;
@dynamic sehriends;

- (void)setAttributes:(NSDictionary *)attributes
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d-MM-yy"];
    self.date = [dateFormatter dateFromString:[attributes valueForKeyPath:@"DATE"]];
    self.asar = [attributes valueForKeyPath:@"Asar"];
    self.asarj = [attributes valueForKeyPath:@"Asar-j"];
    self.esha = [attributes valueForKeyPath:@"Esha"];
    self.eshaj = [attributes valueForKeyPath:@"Esha-j"];
    self.fajar = [attributes valueForKeyPath:@"Fajar"];
    self.maghrib = [attributes valueForKeyPath:@"Maghrib"];
    self.subahsadiq = [attributes valueForKeyPath:@"Subah Sadiq"];
    self.sunrise = [attributes valueForKeyPath:@"Sunrise"];
    self.iftar = [attributes valueForKeyPath:@"Iftar"];
    self.sehriends = [attributes valueForKeyPath:@"Sehri Ends"];
    self.zohar = [attributes valueForKeyPath:@"Zohar"];
    self.zoharj = [attributes valueForKeyPath:@"Zohar-j"];
}

- (NSString*)parsedShortDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"EEE d MMM"];
    NSArray *components = [[dateFormatter stringFromDate:self.date] componentsSeparatedByString:@" "];

    return [NSString stringWithFormat:@"%@ %@ %@", components[1], components[2], components[0]];
}

@end
