//
//  Note.m
//  Masjid Timetable
//
//  Created by Andranik Asilbekyan on 2/18/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "Note.h"


@implementation Note

@dynamic masjidId;
@dynamic month;
@dynamic noteListingId;
@dynamic created;
@dynamic noteId;
@dynamic text;

- (void)setAttributes:(NSDictionary *)attributes
{
    self.masjidId = [[attributes valueForKeyPath:@"masjid_id"] intValue];
    self.noteId = [[attributes valueForKeyPath:@"note_id"] intValue];
    self.noteListingId = [[attributes valueForKeyPath:@"noteListing_id"] intValue];
    self.text = [attributes valueForKeyPath:@"note_text"];
    self.created = [attributes valueForKeyPath:@"note_created"];
    self.month = [attributes valueForKeyPath:@"month"];
}

@end
