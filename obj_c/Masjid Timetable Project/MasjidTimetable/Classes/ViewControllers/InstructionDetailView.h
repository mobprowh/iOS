//
//  InstructionDetailView.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "Issue.h"

@interface InstructionDetailView : BaseViewController

@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UILabel *heading;
@property (strong, nonatomic) IBOutlet UITextView *detailtext;
@property (strong, nonatomic) IBOutlet UILabel *navTitle;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) NSArray *contentInfo;
@property (strong, nonatomic) Issue *issue;
@property (assign ,nonatomic) BOOL isFromLearning;

- (IBAction)back;

@end
