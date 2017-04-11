//
//  timeTableContentView.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/14/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "TimeTableContentView.h"
//#import "MasjidPrefixHeader.pch"
#import "Constants.h"

@implementation TimeTableContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.midleContentView setHidden:YES];
    [self.noDataLabel setText:@"No data are available at this time. Please check with masjid administartor."];
    [self.noDataLabel setHidden:YES];
    if (IS_IPAD) {
        [self.masjidnameLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.eventsTitle setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.ramdhanTitle setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.donationTitle setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.dateLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.masjidInfoLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.redLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.greenLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        self.digitalTimeLabel.font=[UIFont boldSystemFontOfSize:12];
        self.captionLabel.font=[UIFont boldSystemFontOfSize:10];
        self.digitalTimeLabel.frame=CGRectMake(47.5,90,60,15);
        self.captionLabel.frame=CGRectMake(43,100,80,23);
        [self.fajarLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.zoharLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.asarlabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.maghribLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.eshaLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.fajarJLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.zoharJlabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.asarJLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.maghribJLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.eshaJLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.sunriselabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.fajarTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.zoharTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.asarTitlelabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.maghribTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.eshaTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.eshaJLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.sunriselabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [self.midleDateTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.b_JMidleTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.srMidleTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.zoharMidleTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.iftharMidleTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.eshaMildeTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.sahriMidleTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.asarMidleTitle setFont:[UIFont boldSystemFontOfSize:15.0]];
        [self.fajarMidleTitle setFont:[UIFont boldSystemFontOfSize:15.0]];

        [self.subasadiqLabel setFont:[UIFont systemFontOfSize:self.subasadiqLabel.font.pointSize +3]];
        [self.beginingLabel setFont:[UIFont systemFontOfSize:self.beginingLabel.font.pointSize + 4]];
        [self.jamatNameLabel setFont:[UIFont systemFontOfSize:self.jamatNameLabel.font.pointSize +4]];
        [self.sunriseBottomLabel setFont:[UIFont systemFontOfSize:self.sunriseBottomLabel.font.pointSize +3]];
        [self.subasadiqLabel setFrame:CGRectMake(self.subasadiqLabel.frame.origin.x - 3, self.subasadiqLabel.frame.origin.y, self.subasadiqLabel.frame.size.width + 15, self.subasadiqLabel.frame.size.height)];
        [self.sunriseBottomLabel setFrame:CGRectMake(self.sunriseBottomLabel.frame.origin.x - 6, self.sunriseBottomLabel.frame.origin.y, self.sunriseBottomLabel.frame.size.width + 15, self.sunriseBottomLabel.frame.size.height)];
        [self.beginingLabel setFrame:CGRectMake(self.beginingLabel.frame.origin.x - 15, self.beginingLabel.frame.origin.y, self.beginingLabel.frame.size.width + 15, self.beginingLabel.frame.size.height)];
        [self.jamatNameLabel setFrame:CGRectMake(self.jamatNameLabel.frame.origin.x - 5, self.jamatNameLabel.frame.origin.y, self.jamatNameLabel.frame.size.width + 15, self.jamatNameLabel.frame.size.height)];

        CGRect footerTableFrame = self.notesTableView.frame;
        footerTableFrame.size.height -= 16;
        footerTableFrame.origin.y += 5;
        footerTableFrame.origin.x = + 25;
        footerTableFrame.size.width = + 260;
        self.notesTableView.frame = footerTableFrame;
        [self.footerTableBackgroundImageview setFrame:CGRectMake(self.footerTableBackgroundImageview.frame.origin.x + 8, self.footerTableBackgroundImageview.frame.origin.y , self.footerTableBackgroundImageview.frame.size.width - 14, 160)];
        [self.midleContentView setFrame:CGRectMake(self.midleContentView.frame.origin.x, self.midleContentView.frame.origin.y - 20, self.midleContentView.frame.size.width, self.midleContentView.frame.size.height + 10)];
        self.digitalTimeLabel.frame=CGRectMake(self.digitalTimeLabel.frame.origin.x + 2,self.digitalTimeLabel.frame.origin.y,self.digitalTimeLabel.frame.size.width,self.digitalTimeLabel.frame.size.height);
        [self.dateLabel setFrame:CGRectMake(self.dateLabel.frame.origin.x - 8, self.dateLabel.frame.origin.y, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height)];
        [self.eventsTitle setFrame:CGRectMake(self.eventsTitle.frame.origin.x + 7, self.eventsTitle.frame.origin.y, self.eventsTitle.frame.size.width, self.eventsTitle.frame.size.height)];
        [self.ramdhanTitle setFrame:CGRectMake(self.ramdhanTitle.frame.origin.x + 10, self.ramdhanTitle.frame.origin.y, self.ramdhanTitle.frame.size.width, self.ramdhanTitle.frame.size.height)];
        [self.donationTitle setFrame:CGRectMake(self.donationTitle.frame.origin.x + 11, self.donationTitle.frame.origin.y, self.donationTitle.frame.size.width, self.donationTitle.frame.size.height)];
        [self.eventIcon setFrame:CGRectMake(self.eventIcon.frame.origin.x + 7, self.eventIcon.frame.origin.y, self.eventIcon.frame.size.width, self.eventIcon.frame.size.height)];
        [self.ramadhanIcon setFrame:CGRectMake(self.ramadhanIcon.frame.origin.x + 11, self.ramadhanIcon.frame.origin.y, self.ramadhanIcon.frame.size.width, self.ramadhanIcon.frame.size.height)];
        [self.donationIcon setFrame:CGRectMake(self.donationIcon.frame.origin.x + 12, self.donationIcon.frame.origin.y + 2, self.donationIcon.frame.size.width, self.donationIcon.frame.size.height)];

    } else if (IS_IPHONE_6P) {
        self.timeMeterImage.frame = CGRectMake(2.5,33,175,130);
        self.digitalTimeLabel.frame=CGRectMake(46,92,60,15);
        self.captionLabel.frame=CGRectMake(29 ,100,100,23);
        [self.midleContentView setFrame:CGRectMake(self.midleContentView.frame.origin.x, self.midleContentView.frame.origin.y - 12, self.midleContentView.frame.size.width, self.midleContentView.frame.size.height + 12)];
        [self.donationIcon setFrame:CGRectMake(self.donationIcon.frame.origin.x+9, self.donationIcon.frame.origin.y + 2, self.donationIcon.frame.size.width, self.donationIcon.frame.size.height)];
        [self.eventsTitle setFrame:CGRectMake(self.eventsTitle.frame.origin.x + 4, self.eventsTitle.frame.origin.y, self.eventsTitle.frame.size.width, self.eventsTitle.frame.size.height)];
        [self.ramdhanTitle setFrame:CGRectMake(self.ramdhanTitle.frame.origin.x + 6, self.ramdhanTitle.frame.origin.y, self.ramdhanTitle.frame.size.width, self.ramdhanTitle.frame.size.height)];
        [self.donationTitle setFrame:CGRectMake(self.donationTitle.frame.origin.x +8, self.donationTitle.frame.origin.y, self.donationTitle.frame.size.width, self.donationTitle.frame.size.height)];
        [self.eventIcon setFrame:CGRectMake(self.eventIcon.frame.origin.x + 5, self.eventIcon.frame.origin.y, self.eventIcon.frame.size.width, self.eventIcon.frame.size.height)];
        [self.ramadhanIcon setFrame:CGRectMake(self.ramadhanIcon.frame.origin.x + 7, self.ramadhanIcon.frame.origin.y, self.ramadhanIcon.frame.size.width, self.ramadhanIcon.frame.size.height)];
    } else if (IS_IPHONE_6) {
        self.timeMeterImage.frame=CGRectMake(6.5,42,146,108);
        self.digitalTimeLabel.frame=CGRectMake(56.5,95,30,15);
        self.captionLabel.frame=CGRectMake(34,101,80,23);
        [self.donationIcon setFrame:CGRectMake(self.donationIcon.frame.origin.x+7, self.donationIcon.frame.origin.y + 2, self.donationIcon.frame.size.width, self.donationIcon.frame.size.height)];
        [self.eventsTitle setFrame:CGRectMake(self.eventsTitle.frame.origin.x + 2, self.eventsTitle.frame.origin.y, self.eventsTitle.frame.size.width, self.eventsTitle.frame.size.height)];
        [self.ramdhanTitle setFrame:CGRectMake(self.ramdhanTitle.frame.origin.x + 4, self.ramdhanTitle.frame.origin.y, self.ramdhanTitle.frame.size.width, self.ramdhanTitle.frame.size.height)];
        [self.donationTitle setFrame:CGRectMake(self.donationTitle.frame.origin.x + 7, self.donationTitle.frame.origin.y, self.donationTitle.frame.size.width, self.donationTitle.frame.size.height)];
        [self.eventIcon setFrame:CGRectMake(self.eventIcon.frame.origin.x + 3, self.eventIcon.frame.origin.y, self.eventIcon.frame.size.width, self.eventIcon.frame.size.height)];
        [self.ramadhanIcon setFrame:CGRectMake(self.ramadhanIcon.frame.origin.x + 5, self.ramadhanIcon.frame.origin.y, self.ramadhanIcon.frame.size.width, self.ramadhanIcon.frame.size.height)];
    } else if (IS_IPHONE_5) {
        self.timeMeterImage.frame=CGRectMake(6,38,124.7,95);
        self.digitalTimeLabel.font=[UIFont systemFontOfSize:8];
        self.captionLabel.font=[UIFont systemFontOfSize:6];
        self.digitalTimeLabel.frame=CGRectMake(54.5,90,30,15);
        self.captionLabel.frame=CGRectMake(29,95,80,23);
        [self.fajarLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.zoharLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.asarlabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.maghribLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.eshaLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.fajarJLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.zoharJlabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.asarJLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.maghribJLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.eshaJLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.sunriselabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.dateLabel setFrame:CGRectMake(self.dateLabel.frame.origin.x, self.dateLabel.frame.origin.y + 3, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height)];
        [self.masjidnameLabel setFrame:CGRectMake(self.masjidnameLabel.frame.origin.x, self.masjidnameLabel.frame.origin.y + 3, self.masjidnameLabel.frame.size.width, self.masjidnameLabel.frame.size.height)];
        CGRect footerTableFrame = self.notesTableView.frame;
        footerTableFrame.size.height -= 16;
        footerTableFrame.origin.y += 5;
        self.notesTableView.frame = footerTableFrame;
        [self.footerTableBackgroundImageview setFrame:CGRectMake(self.footerTableBackgroundImageview.frame.origin.x, self.footerTableBackgroundImageview.frame.origin.y + 5, self.footerTableBackgroundImageview.frame.size.width, 128)];
        CGRect masjidNotesFrame = self.masjidNotes.frame;
        masjidNotesFrame.origin.y += 3;
        self.masjidNotes.frame = masjidNotesFrame;
        [self.donationIcon setFrame:CGRectMake(self.donationIcon.frame.origin.x+4, self.donationIcon.frame.origin.y + 2, self.donationIcon.frame.size.width, self.donationIcon.frame.size.height)];
        [self.donationTitle setFrame:CGRectMake(self.donationTitle.frame.origin.x + 3, self.donationTitle.frame.origin.y, self.donationTitle.frame.size.width, self.donationTitle.frame.size.height)];
        [self.eventIcon setFrame:CGRectMake(self.eventIcon.frame.origin.x + 1, self.eventIcon.frame.origin.y, self.eventIcon.frame.size.width, self.eventIcon.frame.size.height)];
        [self.ramadhanIcon setFrame:CGRectMake(self.ramadhanIcon.frame.origin.x +1, self.ramadhanIcon.frame.origin.y, self.ramadhanIcon.frame.size.width, self.ramadhanIcon.frame.size.height)];
    } else if (IS_IPHONE_4) {
        self.timeMeterImage.frame=CGRectMake(8,27,127,95);
        self.digitalTimeLabel.frame=CGRectMake(48,82,48,23);
        self.captionLabel.frame=CGRectMake(32,90,80,30);
        self.captionLabel.font=[UIFont systemFontOfSize:6];
        [self.fajarLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.zoharLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.asarlabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.maghribLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.eshaLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.fajarJLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.zoharJlabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.asarJLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.maghribJLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.eshaJLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.sunriselabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.dateLabel setFrame:CGRectMake(self.dateLabel.frame.origin.x, self.dateLabel.frame.origin.y + 3, self.dateLabel.frame.size.width, self.dateLabel.frame.size.height)];
        [self.masjidnameLabel setFrame:CGRectMake(self.masjidnameLabel.frame.origin.x, self.masjidnameLabel.frame.origin.y + 3, self.masjidnameLabel.frame.size.width, self.masjidnameLabel.frame.size.height)];
        CGRect footerTableFrame = self.notesTableView.frame;
        footerTableFrame.size.height -= 23;
        footerTableFrame.origin.y += 5;
        self.notesTableView.frame = footerTableFrame;
        [self.footerTableBackgroundImageview setFrame:CGRectMake(self.footerTableBackgroundImageview.frame.origin.x, self.footerTableBackgroundImageview.frame.origin.y + 5, self.footerTableBackgroundImageview.frame.size.width, 120)];
        [self.donationIcon setFrame:CGRectMake(self.donationIcon.frame.origin.x+3, self.donationIcon.frame.origin.y + 2, self.donationIcon.frame.size.width, self.donationIcon.frame.size.height)];
        [self.eventsTitle setFrame:CGRectMake(self.eventsTitle.frame.origin.x + 1, self.eventsTitle.frame.origin.y, self.eventsTitle.frame.size.width, self.eventsTitle.frame.size.height)];
        [self.ramdhanTitle setFrame:CGRectMake(self.ramdhanTitle.frame.origin.x + 1, self.ramdhanTitle.frame.origin.y, self.ramdhanTitle.frame.size.width, self.ramdhanTitle.frame.size.height)];
        [self.donationTitle setFrame:CGRectMake(self.donationTitle.frame.origin.x + 3, self.donationTitle.frame.origin.y, self.donationTitle.frame.size.width, self.donationTitle.frame.size.height)];
        [self.eventIcon setFrame:CGRectMake(self.eventIcon.frame.origin.x + 1, self.eventIcon.frame.origin.y, self.eventIcon.frame.size.width, self.eventIcon.frame.size.height)];
        [self.ramadhanIcon setFrame:CGRectMake(self.ramadhanIcon.frame.origin.x + 1, self.ramadhanIcon.frame.origin.y, self.ramadhanIcon.frame.size.width, self.ramadhanIcon.frame.size.height)];
    }
}

- (void)changeMidleViewToRamadhanView:(BOOL)isRamadhanTable
{
    if (isRamadhanTable) {
        [self.headerView setHidden:NO];
        [self.midleTableView setFrame:CGRectMake(0, self.headerView.frame.size.height, self.midleTableView.frame.size.width, self.midleContentView.frame.size.height - self.headerView.frame.size.height)];
    } else {
        [self.headerView setHidden:YES];
        [self.midleTableView setFrame:CGRectMake(0, 0, self.midleTableView.frame.size.width, self.midleContentView.frame.size.height)];
    }
}

- (void)hideSpeakerButtons
{
    [self.fajarVolumeBtn setHidden:YES];
    [self.zoharVolumeBtn setHidden:YES];
    [self.asarVolumeBtn setHidden:YES];
    [self.maghribVolumeBtn setHidden:YES];
    [self.eshaVolumeBtn setHidden:YES];
}

@end
