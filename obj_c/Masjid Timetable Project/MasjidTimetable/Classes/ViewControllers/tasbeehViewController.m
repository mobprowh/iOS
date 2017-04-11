//
//  tasbeehViewController.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "tasbeehViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "tasbeehSettings.h"
#import "tabBar.h"

#import "Chameleon.h"

@interface tasbeehViewController ()
{
    BOOL mustStopVibrate;
}
@property (strong, nonatomic) IBOutlet UIImageView *yellowCircle;

@end

@implementation tasbeehViewController
{
    MDRadialProgressView *radialView;
    int counter;
    AVAudioPlayer *audioPlayer;
    NSInteger tapVibrateCount;
    NSInteger counterVibrateCount;
    NSTimer *tapVibrateTimer;
    NSTimer *ounterVibrateTimer;
}
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

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
    MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    view.center = CGPointMake(self.view.center.x + 80, view.center.y);
    
    return view;
}

- (UILabel *)labelAtY:(CGFloat)y andText:(NSString *)text
{
    CGRect frame = CGRectMake(5, y, 180, 50);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [label.font fontWithSize:14];
    return label;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
        [self.ringerImage setImage:[UIImage imageNamed:@"Yellow_Circle.png"]];
        radialView.theme.completedColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:radialView.bounds andColors:@[[UIColor colorWithRed:255.f/255.0 green:104.f/255.0 blue:11.f/255.0 alpha:1.0],[UIColor colorWithRed:255.f/255.0 green:255.f/255.0 blue:19.f/255.0 alpha:1.0], [UIColor colorWithRed:108.f/255.0 green:215.f/255.0 blue:74.f/255.0 alpha:1.0], [UIColor colorWithRed:74.f/255.0 green:161.f/255.0 blue:172.f/255.0 alpha:1.0]]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
        [self.ringerImage setImage:[UIImage imageNamed:@"whiteCircle.png"]];
        radialView.theme.completedColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:radialView.bounds andColors:@[[UIColor colorWithRed:255.f/255.0 green:104.f/255.0 blue:11.f/255.0 alpha:1.0],[UIColor colorWithRed:255.f/255.0 green:255.f/255.0 blue:19.f/255.0 alpha:1.0], [UIColor colorWithRed:108.f/255.0 green:215.f/255.0 blue:74.f/255.0 alpha:1.0], [UIColor colorWithRed:74.f/255.0 green:161.f/255.0 blue:172.f/255.0 alpha:1.0]]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
        [self.ringerImage setImage:[UIImage imageNamed:@"whiteCircle.png"]];
        radialView.theme.completedColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:radialView.bounds andColors:@[[UIColor colorWithRed:255.f/255.0 green:104.f/255.0 blue:11.f/255.0 alpha:1.0],[UIColor colorWithRed:255.f/255.0 green:255.f/255.0 blue:19.f/255.0 alpha:1.0], [UIColor colorWithRed:108.f/255.0 green:215.f/255.0 blue:74.f/255.0 alpha:1.0], [UIColor colorWithRed:74.f/255.0 green:161.f/255.0 blue:172.f/255.0 alpha:1.0]]];
    }
    tapVibrateCount = [Utils getTapVibrateCount];
    counterVibrateCount = [Utils getCounterVibrateCount];
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    counter = 0;
    
    UISwipeGestureRecognizer *settingSwipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveToSettings)];
    [settingSwipe setNumberOfTouchesRequired:2];
    [settingSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:settingSwipe];
    UISwipeGestureRecognizer *settingSwipe2=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveToSettings)];
    [settingSwipe2 setNumberOfTouchesRequired:2];
    [settingSwipe2 setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:settingSwipe2];
    
    CGRect frame = CGRectMake(0, 0, 189.6, 189.6);
    
    radialView = [[MDRadialProgressView alloc] initWithFrame:frame];
    radialView.center = self.yellowCircle.center;
    radialView.progressTotal = [Utils getTapsLimitForTasbeeh];
    radialView.label.hidden=YES;
    radialView.theme.incompletedColor = [UIColor clearColor];
    radialView.theme.thickness=45;
    radialView.theme.completedColor = [UIColor colorWithGradientStyle:UIGradientStyleRadial
                                                            withFrame:radialView.bounds
                                                            andColors:@[[UIColor colorWithRed:111.0/255.0 green:54.0/255.0 blue:73.0/255.0 alpha:1.0],[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:97.0/255.0 alpha:1.0]]];
    radialView.theme.sliceDividerHidden = YES;
    [self.view addSubview:radialView];
    [self.view bringSubviewToFront:self.counterBtn];
}

-(void)moveToSettings
{
    tasbeehSettings *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"tasbeehSettings"];
    [self.navigationController pushViewController:jView animated:YES];
}

- (IBAction)btnTapped:(id)sender
{
    radialView.progressTotal = [Utils getTapsLimitForTasbeeh];
    
    if (radialView.progressTotal ==0 ) {
        UIAlertController *timeLimitAlert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please select the counter value first in Tasbeeh Settings" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [timeLimitAlert addAction:ok];
        [self presentViewController:timeLimitAlert animated:YES completion:nil];

    } else {
        if (counter < radialView.progressTotal) {
            counter++;
            [self.counterBtn setTitle:[NSString stringWithFormat:@"%d",counter]forState:UIControlStateNormal];
            radialView.progressCounter = counter;
            int playCount = [Utils getPlayLimitForTasbeeh];
            if (counter == radialView.progressTotal) {
                if ([Utils isAlertTypeForCounterVibrate]) {
                    mustStopVibrate = NO;
                    [self counterVibrate];
                } else {
                    NSString *path = [[NSBundle mainBundle]
                                      pathForResource:@"complete" ofType:@"m4r"];
                    [self startPlayingWithFilePath:path];
                }
            } else if( playCount != 0 && counter%playCount == 0) {
                if ([Utils isAlertTypeForTapVibrate]) {
                    mustStopVibrate = NO;
                    [self tapVibrate];
                } else {
                    NSString *path = [[NSBundle mainBundle]
                                      pathForResource:@"keys" ofType:@"m4r"];
                    [self startPlayingWithFilePath:path];
                }
            }
        }
    }
}

- (void)tapVibrate
{
    if (!mustStopVibrate) {
    if(tapVibrateCount == 0) {
        tapVibrateCount = [Utils getTapVibrateCount];
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        tapVibrateCount -= 1;
        [self performSelector:@selector(tapVibrate) withObject:nil afterDelay:1.0];
    }
    }
}

- (void)counterVibrate
{
    if (!mustStopVibrate) {
    if(counterVibrateCount == 0) {
        counterVibrateCount = [Utils getCounterVibrateCount];
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        counterVibrateCount -= 1;
        [self performSelector:@selector(counterVibrate) withObject:nil afterDelay:1.0];
    }
    }
}

- (void)startPlayingWithFilePath:(NSString *)path
{
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:
                       [NSURL fileURLWithPath:path] error:NULL];
        [audioPlayer play];
        if ([Utils getTasbeehType] == 3) AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetCounter
{
    [self.counterBtn setTitle:[NSString stringWithFormat:@"%d",0]forState:UIControlStateNormal];
    radialView.progressCounter = 0.5;
    counter = 0;
    [audioPlayer stop];
    mustStopVibrate = YES;
}

@end
