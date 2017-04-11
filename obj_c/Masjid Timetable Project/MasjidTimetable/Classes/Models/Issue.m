//
//  Issue.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 5/21/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import "Issue.h"

@implementation Issue

@dynamic pageId;
@dynamic title;
@dynamic userId;
@dynamic content;
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.pageId = [attributes valueForKey:@"page_id"];
    self.title = [attributes valueForKey:@"page_title"];
    self.userId = [attributes valueForKey:@"user_id"];
    
    return self;
}

- (void)setAttributes:(NSDictionary *)attributes
{
    self.pageId = [attributes valueForKey:@"page_id"];
    self.title = [attributes valueForKey:@"page_title"];
    self.userId = [attributes valueForKey:@"user_id"];
}

@end
