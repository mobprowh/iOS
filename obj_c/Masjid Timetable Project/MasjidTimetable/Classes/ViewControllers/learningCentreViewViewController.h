//
//  learningCentreViewViewController.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "LearningCenterTextField.h"

@interface learningCentreViewViewController : BaseViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (strong, nonatomic) IBOutlet LearningCenterTextField *writeText;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *navImage;

- (IBAction)cancelClicked;
- (IBAction)popView;
- (IBAction)updateIssues:(id)sender;

@end
