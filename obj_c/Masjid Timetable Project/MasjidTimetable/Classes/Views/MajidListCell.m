//
//  MajidListCell.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/13/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "MajidListCell.h"

@implementation MajidListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.nameLabel setNumberOfLines:0];
    [self.localNameLabel setNumberOfLines:0];
    [self.countryLabel setNumberOfLines:0];
}


@end
