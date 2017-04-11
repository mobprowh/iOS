//
//  otherSettings.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface otherSettings : BaseViewController

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *hourImage;
@property (strong, nonatomic) IBOutlet UIButton *jammatBtn;
@property (strong, nonatomic) IBOutlet UIButton *muteBtn;
@property (strong, nonatomic) IBOutlet UIButton *otherBtn;
@property (strong, nonatomic) IBOutlet UIButton *miscbtn;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIView *datePickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *daysPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *hoursPicker;
@property (strong, nonatomic) IBOutlet UILabel *jammatNotifyTime;
@property (strong, nonatomic) IBOutlet UIView *jammatPickerView;
@property (strong, nonatomic) IBOutlet UIPickerView *jammatPicker;
@property (strong, nonatomic) IBOutlet UIImageView *containerImage;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIImageView *frontView;
@property (strong, nonatomic) IBOutlet UILabel *daysCount;
@property (strong, nonatomic) IBOutlet UILabel *hoursCount;
@property (strong, nonatomic) IBOutlet UILabel *frstText;
@property (strong, nonatomic) IBOutlet UILabel *secondText;
@property (strong, nonatomic) IBOutlet UILabel *hrsMins;
@property (strong, nonatomic) IBOutlet UILabel *four;
@property (strong, nonatomic) IBOutlet UILabel *timeFormat;
@property (strong, nonatomic) IBOutlet UIButton *sd;
@property (strong, nonatomic) IBOutlet UIButton *sh;
@property (strong, nonatomic) IBOutlet UILabel *thrs;

- (IBAction)formatChange:(UIButton *)sender;
- (IBAction)daysClickd;
- (IBAction)hoursClickd;
- (IBAction)cancelPicker;
- (IBAction)donePicker;
- (IBAction)jammatNotifyBtn;
- (IBAction)jammatClickd;
- (IBAction)muteClickd;
- (IBAction)otherSettings;
- (IBAction)miscClicked;

@end
