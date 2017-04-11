//
//  TableViewCell.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.arrow.frame=CGRectMake(self.arrow.frame.origin.x,40,10,12);
        if ([UIScreen mainScreen].bounds.size.height>=650) {
            self.localName.frame=CGRectMake(self.localName.frame.origin.x, self.localName.frame.origin.y,300, self.localName.frame.size.height);
        } else if ([UIScreen mainScreen].bounds.size.height>=480) {
            self.localName.frame=CGRectMake(self.localName.frame.origin.x, self.localName.frame.origin.y,250, self.localName.frame.size.height);
        }
    } else {
        self.masjidName.frame=CGRectMake(self.masjidName.frame.origin.x, self.masjidName.frame.origin.y,400, self.masjidName.frame.size.height);
        self.localName.frame=CGRectMake(self.localName.frame.origin.x, self.localName.frame.origin.y,400, self.localName.frame.size.height);
        self.country.frame=CGRectMake(self.country.frame.origin.x, self.country.frame.origin.y,400, self.country.frame.size.height);
        self.country.font=[UIFont systemFontOfSize:12];
        self.localName.font=[UIFont systemFontOfSize:12];
        self.masjidName.font=[UIFont fontWithName:@"Helvetica Bold" size:15];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *separatorView = [self valueForKey:@"_separatorView"];
    CGRect newFrame = CGRectMake(0.0, 0.0, self.bounds.size.width, separatorView.frame.size.height);
    newFrame = CGRectInset(newFrame, 15.0, 0.0);
    [separatorView setFrame:newFrame];
    separatorView.hidden = NO;
}


@end
