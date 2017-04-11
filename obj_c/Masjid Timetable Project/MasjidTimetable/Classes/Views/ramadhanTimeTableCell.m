//
//  ramadhanTimeTableCell.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/20/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "ramadhanTimeTableCell.h"

@implementation ramadhanTimeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPAD) {
        self.date.frame = CGRectMake(15, self.date.frame.origin.y, self.date.frame.size.width + 10, self.date.frame.size.height);
        [self.date setFont:[UIFont boldSystemFontOfSize:self.date.font.pointSize + 3]];
        [self.fajar setFont:[UIFont boldSystemFontOfSize:self.fajar.font.pointSize + 3]];
        [self.sunrise setFont:[UIFont boldSystemFontOfSize:self.sunrise.font.pointSize + 3]];
        [self.zohar setFont:[UIFont boldSystemFontOfSize:self.zohar.font.pointSize + 3]];
        [self.iftar setFont:[UIFont boldSystemFontOfSize:self.iftar.font.pointSize + 3]];
        [self.asar setFont:[UIFont boldSystemFontOfSize:self.asar.font.pointSize + 3]];
        [self.zoharB setFont:[UIFont boldSystemFontOfSize:self.zoharB.font.pointSize + 3]];
        [self.eshaBegin setFont:[UIFont boldSystemFontOfSize:self.eshaBegin.font.pointSize + 3]];
        [self.asarJammat setFont:[UIFont boldSystemFontOfSize:self.asarJammat.font.pointSize + 3]];
        [self.b setFont:[UIFont boldSystemFontOfSize:self.b.font.pointSize + 3]];
        [self.j setFont:[UIFont boldSystemFontOfSize:self.j.font.pointSize + 3]];
        [self.maghrib setFont:[UIFont boldSystemFontOfSize:self.maghrib.font.pointSize + 3]];
        [self.sehriEnd setFont:[UIFont boldSystemFontOfSize:self.sehriEnd.font.pointSize + 3]];
        [self.esha setFont:[UIFont boldSystemFontOfSize:self.esha.font.pointSize + 3]];
        [self.subah setFont:[UIFont boldSystemFontOfSize:self.subah.font.pointSize + 3]];
    }
}

- (void)prepareForReuse
{
    UIColor *setingColor = [UIColor whiteColor];
    self.date.textColor = setingColor;
    self.fajar.textColor = setingColor;
    self.sunrise.textColor = setingColor;
    self.zohar.textColor = setingColor;
    self.iftar.textColor = setingColor;
    self.asar.textColor = setingColor;
    self.zoharB.textColor = setingColor;
    self.eshaBegin.textColor = setingColor;
    self.asarJammat.textColor = setingColor;
    self.b.textColor = setingColor;
    self.j.textColor = setingColor;
    self.maghrib.textColor = setingColor;
    self.sehriEnd.textColor = setingColor;
    self.esha.textColor = setingColor;
    self.subah.textColor = setingColor;
}

@end
