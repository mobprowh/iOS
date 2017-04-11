//
//  Event.h
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/18/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, assign) int masjidId;
@property (nonatomic, assign) int eventId;
@property (nonatomic, retain) NSDate   * longDate;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * created;

- (void)setAttributes:(NSDictionary *)attributes;

@end
