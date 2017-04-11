//
//  JammatSoundSettings.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 3/6/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface JammatSoundSettings : NSManagedObject

@property (nonatomic, retain) NSString *fajarJammatTime;
@property (nonatomic, retain) NSString *zoharJammatTime;
@property (nonatomic, retain) NSString *asarJammatTime;
@property (nonatomic, retain) NSString *maghribJammatTime;
@property (nonatomic, retain) NSString *eshaJammatTime;



@property (nonatomic, retain) NSString *soundName;
@property (nonatomic, assign) BOOL fajarOn;
@property (nonatomic, assign) BOOL zoharOn;
@property (nonatomic, assign) BOOL asarOn;
@property (nonatomic, assign) BOOL maghribOn;
@property (nonatomic, assign) BOOL eshaOn;


@end
