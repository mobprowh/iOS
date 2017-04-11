//
//  MasjidDetailTableCell.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "MasjidDetailTableCell.h"

@implementation MasjidDetailTableCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ([UIScreen mainScreen].bounds.size.height>=650) {
            self.dateTimeLabel.frame=CGRectMake(self.dateTimeLabel.frame.origin.x, self.dateTimeLabel.frame.origin.y,300, self.dateTimeLabel.frame.size.height);
        }
        else if ([UIScreen mainScreen].bounds.size.height>=480) {
            self.dateTimeLabel.frame=CGRectMake(self.dateTimeLabel.frame.origin.x, self.dateTimeLabel.frame.origin.y,250, self.dateTimeLabel.frame.size.height);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
