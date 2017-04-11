//
//  MuteView.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface MuteView : BaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *fajarMB;
@property (strong, nonatomic) IBOutlet UITextField *zoharMB;
@property (strong, nonatomic) IBOutlet UITextField *asarMB;
@property (strong, nonatomic) IBOutlet UITextField *magribMB;
@property (strong, nonatomic) IBOutlet UITextField *eshaMB;
@property (strong, nonatomic) IBOutlet UITextField *fajarMA;
@property (strong, nonatomic) IBOutlet UITextField *zoharMA;
@property (strong, nonatomic) IBOutlet UITextField *asarMA;
@property (strong, nonatomic) IBOutlet UITextField *magribMA;
@property (strong, nonatomic) IBOutlet UITextField *eshaMA;
@property (strong, nonatomic) IBOutlet UIImageView *fImage;
@property (strong, nonatomic) IBOutlet UIImageView *zImage;
@property (strong, nonatomic) IBOutlet UIImageView *asarImage;
@property (strong, nonatomic) IBOutlet UIImageView *mImage;
@property (strong, nonatomic) IBOutlet UIImageView *eImage;
@property (strong, nonatomic) IBOutlet UIButton *jammatbtn;
@property (strong, nonatomic) IBOutlet UIButton *muteBtn;
@property (strong, nonatomic) IBOutlet UIButton *otherBtn;
@property (strong, nonatomic) IBOutlet UIButton *miscBtn;
@property (strong, nonatomic) IBOutlet UILabel *frstText;
@property (strong, nonatomic) IBOutlet UILabel *fnctn;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UILabel *unmuteAf;
@property (strong, nonatomic) IBOutlet UIImageView *frontView;
@property (strong, nonatomic) IBOutlet UILabel *scnd;
@property (strong, nonatomic) IBOutlet UILabel *prayername;
@property (strong, nonatomic) IBOutlet UILabel *f;
@property (strong, nonatomic) IBOutlet UILabel *z;
@property (strong, nonatomic) IBOutlet UILabel *a;
@property (strong, nonatomic) IBOutlet UILabel *magh;
@property (strong, nonatomic) IBOutlet UILabel *es;
@property (strong, nonatomic) IBOutlet UILabel *muteBf;

- (IBAction)fajarAlert:(UIButton *)sender;
- (IBAction)zoharAlert:(UIButton *)sender;
- (IBAction)asarAlert:(UIButton *)sender;
- (IBAction)magribAlert:(UIButton *)sender;
- (IBAction)eshaAlert:(UIButton *)sender;
- (IBAction)jammatClickd;
- (IBAction)muteClickd;
- (IBAction)otherClickd;
- (IBAction)miscClicked;

@end
