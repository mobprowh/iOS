//
//  Instuction.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 5/21/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import "Instruction.h"

@implementation Instruction

@dynamic pageId;
@dynamic title;
@dynamic userId;
@dynamic lastModifiedDate;
@dynamic createdDate;
@dynamic content;
@dynamic status;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.pageId = [attributes valueForKey:@"page_id"];
    self.title = [attributes valueForKey:@"page_title"];
    self.userId = [attributes valueForKey:@"user_id"];
    self.content = [attributes valueForKey:@"content"];
    self.status = [[attributes valueForKey:@"status"] boolValue];
    self.lastModifiedDate = [dateFormatter dateFromString:[attributes valueForKey:@"last_modified_date"]];
    self.createdDate = [dateFormatter dateFromString:[attributes valueForKey:@"created_date"]];
    
    return self;
}

- (void)setAttributes:(NSDictionary *)attributes
{
    self.pageId = [attributes valueForKey:@"page_id"];
    self.title = [attributes valueForKey:@"page_title"];
    self.userId = [attributes valueForKey:@"user_id"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.content = [attributes valueForKey:@"content"];
    self.status = [[attributes valueForKey:@"status"] boolValue];
    self.lastModifiedDate = [dateFormatter dateFromString:[attributes valueForKey:@"last_modified_date"]];
    self.createdDate = [dateFormatter dateFromString:[attributes valueForKey:@"created_date"]];
}

@end
