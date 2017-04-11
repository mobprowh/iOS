//
//  PhoneMuteSettings.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 3/30/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface PhoneMuteSettings : NSManagedObject

@property (nonatomic, retain) NSString *fajarMuteTime;
@property (nonatomic, retain) NSString *fajarUnMuteTime;
@property (nonatomic, retain) NSString *zoharMuteTime;
@property (nonatomic, retain) NSString *zoharUnMuteTime;
@property (nonatomic, retain) NSString *asarMuteTime;
@property (nonatomic, retain) NSString *asarUnMuteTime;
@property (nonatomic, retain) NSString *maghribMuteTime;
@property (nonatomic, retain) NSString *maghribUnMuteTime;
@property (nonatomic, retain) NSString *eshaMuteTime;
@property (nonatomic, retain) NSString *eshaUnMuteTime;
@property (nonatomic, assign) BOOL fajarOn;
@property (nonatomic, assign) BOOL zoharOn;
@property (nonatomic, assign) BOOL asarOn;
@property (nonatomic, assign) BOOL maghribOn;
@property (nonatomic, assign) BOOL eshaOn;

@end
