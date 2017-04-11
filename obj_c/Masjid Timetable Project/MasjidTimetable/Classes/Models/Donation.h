//
//  Donation.h
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/18/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Donation : NSManagedObject

@property (nonatomic, assign) int donationId;
@property (nonatomic, assign) int live;
@property (nonatomic, assign) int masjidId;
@property (nonatomic, retain) NSString * created;
@property (nonatomic, retain) NSString * encouragementText;
@property (nonatomic, retain) NSString * paypalCode;
@property (nonatomic, retain) NSString * bankDetails;

- (void)setAttributes:(NSDictionary *)attributes;

@end
