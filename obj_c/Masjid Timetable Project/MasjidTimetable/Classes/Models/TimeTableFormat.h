//
//  TimeTableFormat.h
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/24/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeTableFormat : NSManagedObject

@property (nonatomic, assign) int masjidId;
@property (nonatomic, assign) int format;
@property (nonatomic, assign) int timetableformatId;
@property (nonatomic, retain) NSDate * month;

- (void)setAttributes:(NSDictionary *)attributes;

@end
