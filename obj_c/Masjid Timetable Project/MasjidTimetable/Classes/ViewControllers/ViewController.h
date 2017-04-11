//
//  ViewController.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@class PBViewController;

@interface ViewController : BaseViewController <UIDocumentInteractionControllerDelegate>

@property(strong,nonatomic) UIDocumentInteractionController *documentInteractionController;
@property (strong, nonatomic) IBOutlet UILabel *settingLabel;
@property (strong, nonatomic) PBViewController *viewController;
@property (strong, nonatomic) IBOutlet UIImageView *timetableImage;
@property (strong, nonatomic) IBOutlet UIImageView *selectmasjidImage;
@property (strong, nonatomic) IBOutlet UIImageView *nearestMasjidImage;
@property (strong, nonatomic) IBOutlet UIImageView *tasbeehImage;
@property (strong, nonatomic) IBOutlet UIImageView *wakeupImage;
@property (strong, nonatomic) IBOutlet UIImageView *learningCentreImage;
@property (strong, nonatomic) IBOutlet UIImageView *allahNameImage;
@property (strong, nonatomic) IBOutlet UIImageView *instructionImage;
@property (strong, nonatomic) IBOutlet UIImageView *themesImage;
@property (strong, nonatomic) IBOutlet UIImageView *settingsImage;
@property (strong, nonatomic) IBOutlet UIImageView *sponsorImage;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *frontView;
@property (strong, nonatomic) IBOutlet UIButton *selectmasjid;
@property (strong, nonatomic) IBOutlet UIButton *nearest;
@property (strong, nonatomic) IBOutlet UIButton *tasbeeh;
@property (strong, nonatomic) IBOutlet UIButton *wakeup;
@property (strong, nonatomic) IBOutlet UIButton *learning;
@property (strong, nonatomic) IBOutlet UIButton *alah;
@property (strong, nonatomic) IBOutlet UIButton *instructions;
@property (strong, nonatomic) IBOutlet UIButton *themes;
@property (strong, nonatomic) IBOutlet UIButton *sponsor;
@property (strong, nonatomic) IBOutlet UIButton *timetbleBtn;
@property (strong, nonatomic) IBOutlet UILabel *dashboard;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet UIImageView *settingsIcon;

- (IBAction)clickToSelectMasjid;
- (IBAction)clickToNearestMasjid;
- (IBAction)clickToTasbeeh;
- (IBAction)clickToWakeUp;
- (IBAction)sponsorClickd;
- (IBAction)clickTolearningCentre;
- (IBAction)clickToGetInstructions;
- (IBAction)clickToGetAllahNames;
- (IBAction)clickToGoToSettings;
- (IBAction)themeBtnClickd;

@end

