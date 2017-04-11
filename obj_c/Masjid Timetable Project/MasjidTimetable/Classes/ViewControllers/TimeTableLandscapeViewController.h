//
//  TimeTableLandscapeViewController.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/16/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

@interface TimeTableLandscapeViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) NSUInteger masjidId;
@property (strong, nonatomic) NSString *masjidName;
@property (strong, nonatomic) IBOutlet UILabel *navigationLeftLabel;
@property (strong, nonatomic) IBOutlet UIPageControl *pageController;
@property (strong, nonatomic) IBOutlet UILabel *navigationCenterLabel;
@property (strong, nonatomic) IBOutlet UILabel *navigationRightLabel;
@property (strong, nonatomic) IBOutlet UILabel *masjidNameLabel;
@property (strong, nonatomic) IBOutlet UIView *customNavigationBar;

@end
