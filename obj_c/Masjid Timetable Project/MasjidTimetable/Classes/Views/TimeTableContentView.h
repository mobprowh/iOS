//
//  timeTableContentView.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/14/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "TimetableMidleInfoTableView.h"

@interface TimeTableContentView : UIView

@property (strong, nonatomic) IBOutlet TimetableMidleInfoTableView *midleTableView;
@property (strong, nonatomic) IBOutlet TimetableMidleInfoTableView *notesTableView;

@property (strong, nonatomic) IBOutlet UIView *midleContentView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIImageView *footerTableBackgroundImageview;
@property (strong, nonatomic) IBOutlet UIImageView *secondViewbackgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *greenButtonImageView;
@property (strong, nonatomic) IBOutlet UIImageView *firstViewbackground;
@property (strong, nonatomic) IBOutlet UIImageView *redButtonImageView;
@property (strong, nonatomic) IBOutlet UIImageView *timeMeterImage;
@property (strong, nonatomic) IBOutlet UIImageView *ramadhanIcon;
@property (strong, nonatomic) IBOutlet UIImageView *donationIcon;
@property (strong, nonatomic) IBOutlet UIImageView *eventIcon;

@property (strong, nonatomic) IBOutlet UITextField *fajarLabel;
@property (strong, nonatomic) IBOutlet UITextField *zoharLabel;
@property (strong, nonatomic) IBOutlet UITextField *asarlabel;
@property (strong, nonatomic) IBOutlet UITextField *maghribLabel;
@property (strong, nonatomic) IBOutlet UITextField *eshaLabel;
@property (strong, nonatomic) IBOutlet UITextField *fajarJLabel;
@property (strong, nonatomic) IBOutlet UITextField *zoharJlabel;
@property (strong, nonatomic) IBOutlet UITextField *asarJLabel;
@property (strong, nonatomic) IBOutlet UITextField *maghribJLabel;
@property (strong, nonatomic) IBOutlet UITextField *eshaJLabel;
@property (strong, nonatomic) IBOutlet UITextField *sunriselabel;

@property (strong, nonatomic) IBOutlet UIButton *eventsBtn;
@property (strong, nonatomic) IBOutlet UIButton *donationBtn;
@property (strong, nonatomic) IBOutlet UIButton *ramadhanBtn;
@property (strong, nonatomic) IBOutlet UIButton *fajarVolumeBtn;
@property (strong, nonatomic) IBOutlet UIButton *eshaVolumeBtn;
@property (strong, nonatomic) IBOutlet UIButton *maghribVolumeBtn;
@property (strong, nonatomic) IBOutlet UIButton *asarVolumeBtn;
@property (strong, nonatomic) IBOutlet UIButton *zoharVolumeBtn;

@property (strong, nonatomic) IBOutlet UILabel *masjidInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *masjidnameLabel;
@property (strong, nonatomic) IBOutlet UILabel *redLabel;
@property (strong, nonatomic) IBOutlet UILabel *greenLabel;
@property (strong, nonatomic) IBOutlet UILabel *fajarTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *zoharTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *asarTitlelabel;
@property (strong, nonatomic) IBOutlet UILabel *maghribTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *eshaTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *digitalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *masjidNotes;
@property (strong, nonatomic) IBOutlet UILabel *subasadiqLabel;
@property (strong, nonatomic) IBOutlet UILabel *sunriseBottomLabel;
@property (strong, nonatomic) IBOutlet UILabel *beginingLabel;
@property (strong, nonatomic) IBOutlet UILabel *jamatNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *midleDateTitle;
@property (strong, nonatomic) IBOutlet UILabel *b_JMidleTitle;
@property (strong, nonatomic) IBOutlet UILabel *fajarMidleTitle;
@property (strong, nonatomic) IBOutlet UILabel *srMidleTitle;
@property (strong, nonatomic) IBOutlet UILabel *zoharMidleTitle;
@property (strong, nonatomic) IBOutlet UILabel *iftharMidleTitle;
@property (strong, nonatomic) IBOutlet UILabel *eshaMildeTitle;
@property (strong, nonatomic) IBOutlet UILabel *sahriMidleTitle;
@property (strong, nonatomic) IBOutlet UILabel *asarMidleTitle;
@property (strong, nonatomic) IBOutlet UILabel *eventsTitle;
@property (strong, nonatomic) IBOutlet UILabel *ramdhanTitle;
@property (strong, nonatomic) IBOutlet UILabel *donationTitle;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *noDataLabel;

- (void)hideSpeakerButtons;
- (void)changeMidleViewToRamadhanView:(BOOL)isRamadhanTable;

@end
