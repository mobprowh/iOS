//
//  IssueCell.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 6/26/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import "IssueCell.h"

@implementation IssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleLabel setNumberOfLines:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
