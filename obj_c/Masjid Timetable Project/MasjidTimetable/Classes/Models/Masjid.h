//
//  Masjid.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Masjid : NSManagedObject

@property (nonatomic, assign) int masjidId;
@property (nonatomic, retain) NSString * favorite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, assign) BOOL isNameUpperCased;
@property (nonatomic, retain) NSString * localArea;
@property (nonatomic, retain) NSString * largerArea;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * add_1;
@property (nonatomic, retain) NSString * postCode;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate *timeTableUpdateDate;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lng;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (void)setAttributes:(NSDictionary *)attributes;
- (NSDictionary *)getAttributes;

@end
