//
//  Timetable.m
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/16/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "MasjidTimetable.h"

@implementation MasjidTimetable

@dynamic asar;
@dynamic asarj;
@dynamic date;
@dynamic esha;
@dynamic eshaj;
@dynamic fajar;
@dynamic maghrib;
@dynamic subahsadiq;
@dynamic sunrise;
@dynamic sunset;
@dynamic zohar;
@dynamic zoharj;
@dynamic masjidId;
@dynamic fajarSoundOff;
@dynamic zoharSoundOff;
@dynamic asarSoundOff;
@dynamic maghribSoundOff;
@dynamic eshaSoundOff;
@dynamic fajarSpeakerSelectedTime;
@dynamic zoharSpeakerSelectedTime;
@dynamic asarSpeakerSelectedTime;
@dynamic eshaSpeakerSelectedTime;
@dynamic maghribSpeakerSelectedTime;

- (void)setAttributes:(NSDictionary *)attributes
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d-MM-yyyy"];
    self.date = [dateFormatter dateFromString:[attributes valueForKeyPath:@"DATE"]];
    self.asar = [attributes valueForKeyPath:@"Asar"];
    self.asarj = [attributes valueForKeyPath:@"Asar-j"];
    self.esha = [attributes valueForKeyPath:@"Esha"];
    self.eshaj = [attributes valueForKeyPath:@"Esha-j"];
    self.fajar = [attributes valueForKeyPath:@"Fajar"];
    self.maghrib = [attributes valueForKeyPath:@"Maghrib"];
    self.subahsadiq = [attributes valueForKeyPath:@"Subah Sadiq"];
    self.sunrise = [attributes valueForKeyPath:@"Sunrise"];
    self.sunset = [attributes valueForKeyPath:@"Sunset"];
    self.zohar = [attributes valueForKeyPath:@"Zohar"];
    self.zoharj = [attributes valueForKeyPath:@"Zohar-j"];
    self.fajarSoundOff = [[attributes valueForKeyPath:@"fajarVolume"] boolValue];
    self.zoharSoundOff = [[attributes valueForKeyPath:@"zoharVolume"] boolValue];
    self.asarSoundOff = [[attributes valueForKeyPath:@"asarVolume"] boolValue];
    self.maghribSoundOff = [[attributes valueForKeyPath:@"maghribVolume"] boolValue];
    self.eshaSoundOff = [[attributes valueForKeyPath:@"eshaVolume"] boolValue];
}

- (NSString*)parsedDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    
    return [dateFormatter stringFromDate:self.date];
}

- (NSString*)parsedShortDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"d MMM yyyy"];
    
    return [dateFormatter stringFromDate:self.date];
}

@end
