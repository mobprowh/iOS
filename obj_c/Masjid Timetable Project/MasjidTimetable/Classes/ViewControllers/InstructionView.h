//
//  InstructionView.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "LearningCenterTextField.h"

@interface InstructionView : BaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *navImage;
@property (strong, nonatomic) IBOutlet LearningCenterTextField *writeText;
@property (strong, nonatomic) IBOutlet UIButton *cancel;

- (IBAction)popView;
- (IBAction)cancelClicked;
- (IBAction)updateInstructions:(id)sender;
@end
