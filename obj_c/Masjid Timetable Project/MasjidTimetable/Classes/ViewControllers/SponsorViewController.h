//
//  SponsorViewController.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 5/16/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

@interface SponsorViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *navImage;


- (IBAction)popView;

@end
