//
//  Instuction.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 5/21/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Instruction : NSManagedObject

@property (retain, nonatomic) NSString * pageId;
@property (retain, nonatomic) NSString * title;
@property (retain, nonatomic) NSString * userId;
@property (retain, nonatomic) NSString * content;
@property (retain, nonatomic) NSDate * createdDate;
@property (retain, nonatomic) NSDate * lastModifiedDate;
@property (assign, nonatomic) BOOL status;

- (void)setAttributes:(NSDictionary *)attributes;

@end
