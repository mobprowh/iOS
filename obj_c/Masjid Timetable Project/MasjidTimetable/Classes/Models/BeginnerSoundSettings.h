//
//  BeginnerSoundSettings.h
//  Masjid Timetable
//
//  Created by Iqbinder Brar on 04/06/16.
//  Copyright © 2016 Lentrica Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface BeginnerSoundSettings : NSManagedObject

@property (nonatomic, retain) NSString *fajarBeginnnerTime;
@property (nonatomic, retain) NSString *zoharBeginnnerTime;
@property (nonatomic, retain) NSString *asarBeginnnerTime;
@property (nonatomic, retain) NSString *maghribBeginnnerTime;
@property (nonatomic, retain) NSString *eshaBeginnnerTime;

@property (nonatomic, retain) NSString *soundName;
@property (nonatomic, assign) BOOL fajarOn;
@property (nonatomic, assign) BOOL zoharOn;
@property (nonatomic, assign) BOOL asarOn;
@property (nonatomic, assign) BOOL maghribOn;
@property (nonatomic, assign) BOOL eshaOn;

@end
