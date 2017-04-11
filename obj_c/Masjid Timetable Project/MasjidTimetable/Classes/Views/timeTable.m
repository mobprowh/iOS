//
//  timeTable.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "timeTable.h"

@implementation timeTable

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPAD) {
        [self.date setFont:[UIFont boldSystemFontOfSize:self.date.font.pointSize + 3]];
        [self.bStart setFont:[UIFont boldSystemFontOfSize:self.bStart.font.pointSize + 3]];
        [self.bEnd setFont:[UIFont boldSystemFontOfSize:self.bEnd.font.pointSize + 3]];
        [self.fezarB setFont:[UIFont boldSystemFontOfSize:self.fezarB.font.pointSize + 3]];
        [self.fazarJ setFont:[UIFont boldSystemFontOfSize:self.fazarJ.font.pointSize + 3]];
        [self.sunrise setFont:[UIFont boldSystemFontOfSize:self.sunrise.font.pointSize + 3]];
        [self.zoharB setFont:[UIFont boldSystemFontOfSize:self.zoharB.font.pointSize + 3]];
        [self.zoharJ setFont:[UIFont boldSystemFontOfSize:self.zoharJ.font.pointSize + 3]];
        [self.asarB setFont:[UIFont boldSystemFontOfSize:self.asarB.font.pointSize + 3]];
        [self.asarJ setFont:[UIFont boldSystemFontOfSize:self.asarJ.font.pointSize + 3]];
        [self.magribB setFont:[UIFont boldSystemFontOfSize:self.magribB.font.pointSize + 3]];
        [self.magribJ setFont:[UIFont boldSystemFontOfSize:self.magribJ.font.pointSize + 3]];
        [self.eshaB setFont:[UIFont boldSystemFontOfSize:self.eshaB.font.pointSize + 3]];
        [self.eshaJ setFont:[UIFont boldSystemFontOfSize:self.eshaJ.font.pointSize + 3]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
