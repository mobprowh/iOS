//
//  ramadhanTable.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "ramadhanTable.h"

@implementation ramadhanTable

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([UIScreen mainScreen].bounds.size.height == 736) {
       self.noteText.frame=CGRectMake(self.noteText.frame.origin.x, self.noteText.frame.origin.y,self.noteText.frame.size.width, 400);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
