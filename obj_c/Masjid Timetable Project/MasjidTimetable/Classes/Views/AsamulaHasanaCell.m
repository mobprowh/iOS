//
//  AsamulaHasanaCell.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 5/19/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import "AsamulaHasanaCell.h"

@implementation AsamulaHasanaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (IS_IPAD) {
        [self.label1 setFont:[UIFont systemFontOfSize:18.0]];
        [self.label2 setFont:[UIFont systemFontOfSize:16.0]];
        [self.label3 setFont:[UIFont systemFontOfSize:16.0]];
    } else {
        [self.label1 setFont:[UIFont systemFontOfSize:self.label1.font.pointSize + 2]];
    }
}

@end
