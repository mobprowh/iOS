//
//  alarmView.m
//  Masjid Timetable
//
//  Created by Lentrica Software -  © 2015
//  Copyright Lentrica Software -  © 2015. All rights reserved.
//

#import "alarmView.h"
#import "MasjidTimetable.h"
#import "GeoPointCompass.h"

@interface alarmView ()
{
    GeoPointCompass *geoPointCompass;
}

@end

@implementation alarmView

- (BOOL)shouldAutorotate
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000  
- (NSUInteger)supportedInterfaceOrientations  
#else  
- (UIInterfaceOrientationMask)supportedInterfaceOrientations  
#endif  
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadPageForCompass)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    [self initCompass];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
    [self.compassFrameImageView setFrame:CGRectMake(self.compassFrameImageView.frame.origin.x,self.compassImageView.frame.origin.y - self.compassFrameImageView.frame.size.height, self.compassFrameImageView.frame.size.width, self.compassFrameImageView.frame.size.height)];
    
    if (IS_IPHONE_4) {
        [self.headerBackgroundImageView setFrame:CGRectMake(self.headerBackgroundImageView.frame.origin.x, self.headerBackgroundImageView.frame.origin.y + 16, self.headerBackgroundImageView.frame.size.width, self.headerBackgroundImageView.frame.size.height - 16)];
        [self.distanceLabel setFrame:CGRectMake(self.distanceLabel.frame.origin.x, 250, self.distanceLabel.frame.size.width, self.distanceLabel.frame.size.width)];
    } else if (IS_IPHONE_5) {
        [self.headerBackgroundImageView setFrame:CGRectMake(self.headerBackgroundImageView.frame.origin.x, self.headerBackgroundImageView.frame.origin.y + 5, self.headerBackgroundImageView.frame.size.width, self.headerBackgroundImageView.frame.size.height - 5)];
        [self.distanceLabel setFrame:CGRectMake(self.distanceLabel.frame.origin.x, 310, self.distanceLabel.frame.size.width, self.distanceLabel.frame.size.width)];
    } else if (IS_IPHONE_6) {
        [self.headerBackgroundImageView setFrame:CGRectMake(self.headerBackgroundImageView.frame.origin.x, self.headerBackgroundImageView.frame.origin.y - 5, self.headerBackgroundImageView.frame.size.width, self.headerBackgroundImageView.frame.size.height + 5)];
        [self.distanceLabel setFrame:CGRectMake(self.distanceLabel.frame.origin.x, 355, self.distanceLabel.frame.size.width, self.distanceLabel.frame.size.width)];
    } else if (IS_IPHONE_6P) {
        [self.headerBackgroundImageView setFrame:CGRectMake(self.headerBackgroundImageView.frame.origin.x, self.headerBackgroundImageView.frame.origin.y - 11, self.headerBackgroundImageView.frame.size.width, self.headerBackgroundImageView.frame.size.height +10)];
        [self.distanceLabel setFrame:CGRectMake(self.distanceLabel.frame.origin.x, 385, self.distanceLabel.frame.size.width, self.distanceLabel.frame.size.width)];
    } else {
        [self.headerBackgroundImageView setFrame:CGRectMake(self.headerBackgroundImageView.frame.origin.x, self.headerBackgroundImageView.frame.origin.y - 45, self.headerBackgroundImageView.frame.size.width, self.headerBackgroundImageView.frame.size.height + 45)];
        [self.distanceLabel setFrame:CGRectMake(self.distanceLabel.frame.origin.x, 450, self.distanceLabel.frame.size.width, self.distanceLabel.frame.size.width)];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];

    [super viewWillDisappear:animated];
}

- (void)initCompass
{
    geoPointCompass = [[GeoPointCompass alloc] init];

    [geoPointCompass setArrowImageView:self.compassArrowImageview];
    [geoPointCompass setCompassImageView:self.compassImageView];

    geoPointCompass.latitudeOfTargetedPoint = 21.422871;
    geoPointCompass.longitudeOfTargetedPoint = 39.825735;
    geoPointCompass.distanceLabel = self.distanceLabel;
}

-(void)reloadPageForCompass
{
    [self initCompass];
}


- (void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
