//
//  JammatNotificationsView.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//
#import "BeginnerSoundSettings.h"

@interface JammatNotificationsView : BaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UITextField *fajar;
@property (strong, nonatomic) IBOutlet UITextField *zohar;
@property (strong, nonatomic) IBOutlet UITextField *asar;
@property (strong, nonatomic) IBOutlet UITextField *maghrib;
@property (strong, nonatomic) IBOutlet UITextField *esha;
@property (strong, nonatomic) IBOutlet UIImageView *fajarAlert;
@property (strong, nonatomic) IBOutlet UIImageView *zoharAlert;
@property (strong, nonatomic) IBOutlet UIImageView *asarAlert;
@property (strong, nonatomic) IBOutlet UIImageView *magribAlert;
@property (strong, nonatomic) IBOutlet UIImageView *eshaAlert;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *frontView;
@property (strong, nonatomic) IBOutlet UILabel *pickLabel;
@property (strong, nonatomic) IBOutlet UILabel *frstText;
@property (strong, nonatomic) IBOutlet UILabel *f;
@property (strong, nonatomic) IBOutlet UILabel *z;
@property (strong, nonatomic) IBOutlet UILabel *a;
@property (strong, nonatomic) IBOutlet UILabel *mpray;
@property (strong, nonatomic) IBOutlet UILabel *e;
@property (strong, nonatomic) IBOutlet UILabel *prayerName;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;
@property (strong, nonatomic) IBOutlet UILabel *minsBf;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *radioButtonsColloction;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *radioImagesCollection;
@property (strong, nonatomic) IBOutlet UILabel *soundBottomLabel;

- (IBAction)alertOnOffClick:(UIButton *)sender;
- (IBAction)zoharAlertOnOFF:(UIButton *)sender;
- (IBAction)asarOnOFF:(UIButton *)sender;
- (IBAction)magribONOFF:(UIButton *)sender;
- (IBAction)eshaONOFF:(UIButton *)sender;
- (IBAction)selectAlertType:(UIButton *)sender;
- (IBAction)segmentControlButtonAction:(UISegmentedControl *)sender;

@end
