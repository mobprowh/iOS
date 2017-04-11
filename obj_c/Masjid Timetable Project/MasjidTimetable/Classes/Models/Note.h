//
//  Note.h
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/18/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, assign) int noteId;
@property (nonatomic, assign) int masjidId;
@property (nonatomic, assign) int noteListingId;
@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSString * created;
@property (nonatomic, retain) NSString * text;

- (void)setAttributes:(NSDictionary *)attributes;

@end
