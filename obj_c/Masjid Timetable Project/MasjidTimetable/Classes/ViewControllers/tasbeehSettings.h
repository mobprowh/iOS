//
//  tasbeehSettings.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface tasbeehSettings : BaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *frontView;
@property (strong, nonatomic) IBOutlet UIImageView *vibImage;
@property (strong, nonatomic) IBOutlet UITextField *counterValue;
@property (weak,   nonatomic) IBOutlet UITextField *playCounterValue;
@property (strong, nonatomic) IBOutlet UITextField *counterLimitField;
@property (strong, nonatomic) IBOutlet UITextField *tapLimitField;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *counterCollection;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *tapCollection;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UILabel *aboveLabel;

- (IBAction)chooseCounter:(UIButton *)sender;
- (IBAction)chooseTap:(UIButton *)sender;


@end
