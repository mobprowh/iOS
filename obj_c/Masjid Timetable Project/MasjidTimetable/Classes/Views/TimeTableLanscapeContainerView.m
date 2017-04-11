//
//  TimeTableLanscapeContainerView.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/16/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "TimeTableLanscapeContainerView.h"

@implementation TimeTableLanscapeContainerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setFrame:CGRectMake(0, 0, ScreenSizeWidth, self.frame.size.height)];
    self.layer.cornerRadius = 15.0;
    self.layer.masksToBounds = YES;
}

@end
