//
//  Ramadhan.h
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/19/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ramadhan : NSManagedObject

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
@property (nonatomic, retain) NSString * zohar;
@property (nonatomic, retain) NSString * zoharj;
@property (nonatomic, retain) NSString * iftar;
@property (nonatomic, retain) NSString * sehriends;

- (void)setAttributes:(NSDictionary *)attributes;
- (NSString*)parsedShortDate;

@end
