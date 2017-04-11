//
//  alarmView.h
//  Masjid Timetable
//
//  Created by Lentrica Software -  © 2015
//  Copyright Lentrica Software -  © 2015. All rights reserved.
//

@interface alarmView : BaseViewController

@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *navImage;
@property (strong, nonatomic) IBOutlet UIImageView *compassArrowImageview;
@property (strong, nonatomic) IBOutlet UIImageView *compassImageView;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *compassFrameImageView;
@property (strong, nonatomic) IBOutlet UIImageView *headerBackgroundImageView;



- (void)popView;

@end
