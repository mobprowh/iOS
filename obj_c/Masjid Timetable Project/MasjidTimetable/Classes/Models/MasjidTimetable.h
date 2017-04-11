//
//  Timetable.h
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/16/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MasjidTimetable : NSManagedObject

@property (nonatomic, assign) int masjidId;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * asar;
@property (nonatomic, retain) NSString * asarj;
@property (nonatomic, retain) NSString * esha;
@property (nonatomic, retain) NSString * eshaj;
@property (nonatomic, retain) NSString * fajar;
@property (nonatomic, retain) NSString * maghrib;
@property (nonatomic, retain) NSString * subahsadiq;
@property (nonatomic, retain) NSString * sunrise;
@property (nonatomic, retain) NSString * sunset;
@property (nonatomic, retain) NSString * zohar;
@property (nonatomic, retain) NSString * zoharj;
@property (nonatomic, retain) NSString *fajarSpeakerSelectedTime;
@property (nonatomic, retain) NSString *zoharSpeakerSelectedTime;
@property (nonatomic, retain) NSString *asarSpeakerSelectedTime;
@property (nonatomic, retain) NSString *maghribSpeakerSelectedTime;
@property (nonatomic, retain) NSString *eshaSpeakerSelectedTime;

@property (nonatomic, assign) BOOL fajarSoundOff;
@property (nonatomic, assign) BOOL zoharSoundOff;
@property (nonatomic, assign) BOOL asarSoundOff;
@property (nonatomic, assign) BOOL maghribSoundOff;
@property (nonatomic, assign) BOOL eshaSoundOff;

- (void)setAttributes:(NSDictionary *)attributes;
- (NSString*)parsedDate;
- (NSString*)parsedShortDate;

@end
