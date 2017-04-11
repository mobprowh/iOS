//
//  BeginnerSoundSettings+CoreDataProperties.h
//  Masjid Timetable
//
//  Created by Iqbinder Brar on 04/06/16.
//  Copyright © 2016 Lentrica Software. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "BeginnerSoundSettings.h"

NS_ASSUME_NONNULL_BEGIN

@interface BeginnerSoundSettings (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *asarBeginnnerTime;
@property (nullable, nonatomic, retain) NSNumber *asarOn;
@property (nullable, nonatomic, retain) NSString *eshaBeginnnerTime;
@property (nullable, nonatomic, retain) NSNumber *eshaOn;
@property (nullable, nonatomic, retain) NSString *fajarBeginnnerTime;
@property (nullable, nonatomic, retain) NSNumber *fajarOn;
@property (nullable, nonatomic, retain) NSString *maghribBeginnnerTime;
@property (nullable, nonatomic, retain) NSNumber *maghribOn;
@property (nullable, nonatomic, retain) NSString *soundName;
@property (nullable, nonatomic, retain) NSString *zoharBeginnnerTime;
@property (nullable, nonatomic, retain) NSNumber *zoharOn;

@end

NS_ASSUME_NONNULL_END
