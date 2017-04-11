//
//  MuteView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "MuteView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

#import "JammatNotificationsView.h"
#import "otherSettings.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PhoneMuteSettings.h"
#import <UserNotifications/UserNotifications.h>

@import UserNotifications;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define ACCEPTABLE_CHARECTERS @"0123456789"

@interface MuteView ()
{// TODO: notification upgrade
    int val,val1,val2,val3,val4;
    int prayerTime, alertHours,alertMinutes,unmuteHours,unmuteMinutes;
    int minutes,hours,ii,intervalsAfter;
    float alertTime;
    NSString *time,*getString;
    NSString *fajar,*zohar,*asar,*maghrib,*esha;
    NSString *from,*JsonDate,*soundFile;
    NSString *prayerAlert;
    NSString *unmuteTime;
    NSMutableArray *currentMonthData;
//    UILocalNotification *localNotification;
    BOOL isOffsetSetted;
    PhoneMuteSettings *phoneMuteSettings;
//    UIAlertView *timeLimitAlert;
    UIButton *doneButton;
}

@end

@implementation MuteView

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
    
    prayerTime=0;
    intervalsAfter=30;
    currentMonthData=[[NSMutableArray alloc]init];
    val=1,val1=1,val2=1,val3=1,val4=1;

    _fajarMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _fajarMB.keyboardAppearance = UIKeyboardAppearanceDark;
    _zoharMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _zoharMB.keyboardAppearance = UIKeyboardAppearanceDark;
    _magribMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _magribMB.keyboardAppearance = UIKeyboardAppearanceDark;
    _eshaMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _eshaMB.keyboardAppearance = UIKeyboardAppearanceDark;
    _asarMA.keyboardAppearance = UIKeyboardAppearanceDark;
    _asarMB.keyboardAppearance = UIKeyboardAppearanceDark;
    
    UIAlertController *timeLimitAlert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [timeLimitAlert addAction:ok];
    [self presentViewController:timeLimitAlert animated:YES completion:nil];

    
    phoneMuteSettings = [[MTDBHelper sharedDBHelper] getPhoneMuteSettings];
    
    if (!phoneMuteSettings) phoneMuteSettings = [[MTDBHelper sharedDBHelper] createPhoneMuteSettings];
    
    [self alertValues];
    [self setViewsConfigurations];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLocalNotifications)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!IS_IPAD) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [doneButton removeFromSuperview];
    doneButton = nil;

    [self updateLocalNotifications];
    
    [super viewDidDisappear:animated];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *keyboardView = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];
        if (IS_IPHONE_6P) {
            [doneButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 140, 53)];
        } else if (IS_IPHONE_6) {
            [doneButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 126, 53)];
        } else {
            [doneButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 106, 53)];
        }        [keyboardView addSubview:doneButton];
        [keyboardView bringSubviewToFront:doneButton];
    });
}

- (void)closeKeyboard
{
    [doneButton removeFromSuperview];
    doneButton = nil;
    [self.view endEditing:YES];
}

- (void)alertValues {
    
    self.fajarMB.text = phoneMuteSettings.fajarMuteTime.length > 0 ? phoneMuteSettings.fajarMuteTime : @"";
    self.zoharMB.text = phoneMuteSettings.zoharMuteTime.length > 0 ? phoneMuteSettings.zoharMuteTime : @"";
    self.asarMB.text = phoneMuteSettings.asarMuteTime.length > 0 ? phoneMuteSettings.asarMuteTime : @"";
    self.magribMB.text = phoneMuteSettings.maghribMuteTime.length > 0 ? phoneMuteSettings.maghribMuteTime : @"";
    self.eshaMB.text = phoneMuteSettings.eshaMuteTime.length > 0 ? phoneMuteSettings.eshaMuteTime : @"";
    
    self.fajarMA.text = phoneMuteSettings.fajarUnMuteTime.length > 0 && [phoneMuteSettings.fajarUnMuteTime intValue] != 30? phoneMuteSettings.fajarUnMuteTime : @"";
    self.zoharMA.text = phoneMuteSettings.zoharUnMuteTime.length > 0  && [phoneMuteSettings.zoharUnMuteTime intValue] != 30? phoneMuteSettings.zoharUnMuteTime : @"";
    self.asarMA.text = phoneMuteSettings.asarUnMuteTime.length > 0 && [phoneMuteSettings.asarUnMuteTime intValue] != 30 ? phoneMuteSettings.asarUnMuteTime : @"";
    self.magribMA.text = phoneMuteSettings.maghribUnMuteTime.length > 0 && [phoneMuteSettings.maghribUnMuteTime intValue] != 30? phoneMuteSettings.maghribUnMuteTime : @"";
    self.eshaMA.text = phoneMuteSettings.eshaUnMuteTime.length > 0 && [phoneMuteSettings.eshaUnMuteTime intValue] != 30 ? phoneMuteSettings.eshaUnMuteTime : @"";
    
    
    if (phoneMuteSettings.fajarOn) {
        [_fImage setImage:[UIImage imageNamed:@"on2.png"]];
    } else {
        [_fImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    
    if (phoneMuteSettings.zoharOn) {
        [_zImage setImage:[UIImage imageNamed:@"on2.png"]];
    } else {
        [_zImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    if (phoneMuteSettings.asarOn) {
        [_asarImage setImage:[UIImage imageNamed:@"on2.png"]];
    } else {
        [_asarImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    
    if (phoneMuteSettings.maghribOn) {
        [_mImage setImage:[UIImage imageNamed:@"on2.png"]];
    } else {
        [_mImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
    
    if (phoneMuteSettings.eshaOn) {
        [_eImage setImage:[UIImage imageNamed:@"on2.png"]];
    } else {
        [_eImage setImage:[UIImage imageNamed:@"off2.png"]];
    }
}

- (IBAction)fajarAlert:(UIButton *)sender
{
    if ([self.fajarMB.text intValue] <= 180) {
        if (self.fajarMB.text.length !=0  ) {
            if (phoneMuteSettings.fajarOn) {
                [_fImage setImage:[UIImage imageNamed:@"off2.png"]];
                phoneMuteSettings.fajarOn = NO;
            } else {
                [_fImage setImage:[UIImage imageNamed:@"on2.png"]];
                phoneMuteSettings.fajarOn = YES;
            }
            phoneMuteSettings.fajarMuteTime = self.fajarMB.text;
            phoneMuteSettings.fajarUnMuteTime = self.fajarMA.text.length > 0 ? self.fajarMA.text : @"30";
            [[MTDBHelper sharedDBHelper] saveContext];
        }
    } else {
        UIAlertController *timeLimitAlert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [timeLimitAlert addAction:ok];
        [self presentViewController:timeLimitAlert animated:YES completion:nil];
    }
}

- (IBAction)zoharAlert:(UIButton *)sender
{
    if ([self.zoharMB.text intValue] <= 180) {
        if (self.zoharMB.text.length != 0) {
            if (phoneMuteSettings.zoharOn) {
                [_zImage setImage:[UIImage imageNamed:@"off2.png"]];
                phoneMuteSettings.zoharOn = NO;
            } else {
                [_zImage setImage:[UIImage imageNamed:@"on2.png"]];
                phoneMuteSettings.zoharOn = YES;
            }
            phoneMuteSettings.zoharMuteTime = self.zoharMB.text;
            phoneMuteSettings.zoharUnMuteTime = self.zoharMA.text.length > 0 ? self.zoharMA.text : @"30";
            [[MTDBHelper sharedDBHelper] saveContext];
        }
    } else {
        UIAlertController *timeLimitAlert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [timeLimitAlert addAction:ok];
        [self presentViewController:timeLimitAlert animated:YES completion:nil];
    }
}

- (IBAction)asarAlert:(UIButton *)sender
{
    if ([self.asarMB.text intValue] <= 180) {
        if (self.asarMB.text.length != 0) {
            if (phoneMuteSettings.asarOn) {
                [_asarImage setImage:[UIImage imageNamed:@"off2.png"]];
                phoneMuteSettings.asarOn = NO;
            } else {
                [_asarImage setImage:[UIImage imageNamed:@"on2.png"]];
                phoneMuteSettings.asarOn = YES;
            }
            phoneMuteSettings.asarMuteTime = self.asarMB.text;
            phoneMuteSettings.asarUnMuteTime = self.asarMA.text.length > 0 ? self.asarMA.text : @"30";
            [[MTDBHelper sharedDBHelper] saveContext];
        }
    } else {
        UIAlertController *timeLimitAlert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [timeLimitAlert addAction:ok];
        [self presentViewController:timeLimitAlert animated:YES completion:nil];
    }
}

- (IBAction)magribAlert:(UIButton *)sender
{
    if ([self.magribMB.text intValue] <= 180) {
        if (self.magribMB.text.length != 0) {
            if (phoneMuteSettings.maghribOn) {
                [_mImage setImage:[UIImage imageNamed:@"off2.png"]];
                phoneMuteSettings.maghribOn = NO;
            } else {
                [_mImage setImage:[UIImage imageNamed:@"on2.png"]];
                phoneMuteSettings.maghribOn = YES;
            }
            phoneMuteSettings.maghribMuteTime = self.magribMB.text;
            phoneMuteSettings.maghribUnMuteTime = self.magribMA.text.length > 0 ? self.magribMA.text : @"30";
            [[MTDBHelper sharedDBHelper] saveContext];
        }
    } else {
        UIAlertController *timeLimitAlert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [timeLimitAlert addAction:ok];
        [self presentViewController:timeLimitAlert animated:YES completion:nil];
    }
}

- (IBAction)eshaAlert:(UIButton *)sender
{
    if ([self.eshaMB.text intValue] <= 180) {
        if (self.eshaMB.text.length != 0) {
            if (phoneMuteSettings.eshaOn) {
                [_eImage setImage:[UIImage imageNamed:@"off2.png"]];
                phoneMuteSettings.eshaOn = NO;
            } else {
                [_eImage setImage:[UIImage imageNamed:@"on2.png"]];
                phoneMuteSettings.eshaOn = YES;
            }
            phoneMuteSettings.eshaMuteTime = self.eshaMB.text;
            phoneMuteSettings.eshaUnMuteTime = self.eshaMA.text.length > 0 ? self.eshaMA.text : @"30";
            [[MTDBHelper sharedDBHelper] saveContext];
        }
    } else {
        UIAlertController *timeLimitAlert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [timeLimitAlert addAction:ok];
        [self presentViewController:timeLimitAlert animated:YES completion:nil];
    }
}

-(void)offButton
{
    if (prayerTime == 5)    {
        [_fImage setImage:[UIImage imageNamed:@"off2.png"]];
        phoneMuteSettings.fajarOn = NO;
    }
    
    if (prayerTime==6) {
        [_zImage setImage:[UIImage imageNamed:@"off2.png"]];
        phoneMuteSettings.zoharOn = NO;
    }
    
    if (prayerTime==7) {
        [_asarImage setImage:[UIImage imageNamed:@"off2.png"]];
        phoneMuteSettings.asarOn = NO;
    }
    
    if (prayerTime==8) {
        [_mImage setImage:[UIImage imageNamed:@"off2.png"]];
        phoneMuteSettings.maghribOn = NO;
    }
    
    if (prayerTime==9) {
        [_eImage setImage:[UIImage imageNamed:@"off2.png"]];
        phoneMuteSettings.eshaOn = NO;
    }
    [[MTDBHelper sharedDBHelper] saveContext];
}

-(void)getTimeIntervals
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *serDate;
    
    NSDate *endDate;
    
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSString *ab=[formatter stringFromDate:[NSDate date]];
    serDate = [formatter dateFromString:ab];
    endDate = [formatter dateFromString:from];
    NSTimeInterval timeDifference = [endDate timeIntervalSinceDate:serDate];
    minutes = timeDifference / 60;
    hours = minutes / 60;
    double seconds = timeDifference;
    if (hours<0 || minutes<0) {
    }
    else
    {
        [self performSelector:@selector(offButton) withObject:self afterDelay:(seconds+60*intervalsAfter)];
    }
}

-(void)getNotifications
{// TODO: notification upgrade
    
    int hrs=hours *3600;
    int mins=minutes*60;
    
    if (IS_IOS_10_OR_LATER) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        
        content.sound = [UNNotificationSound soundNamed:@"azanx.wav"];
        
        // Deliver the notification in five seconds.
        NSTimeInterval timeInterval = hrs + mins;
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:timeInterval repeats:NO];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"alarm"
                                                                              content:content trigger:trigger];
        // schedule localNotification
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@">>>>>>> add NotificationRequest succeeded!");
            }
        }];
    } else {
        UILocalNotification *local =  [[UILocalNotification alloc] init];
        if (!local)
            return;
        
        NSDate *date = [NSDate date];
        NSDate *dateToFire = [date dateByAddingTimeInterval:(hrs+mins)];
        [local setFireDate:dateToFire];
        [local setTimeZone:[NSTimeZone defaultTimeZone]];
        [local setSoundName:@"azanx.wav"];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:local];
            }
    
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    [volumeViewSlider setValue:0.0f animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    BOOL needTodeleteDoneButton = NO;
    if ([_fajarMA isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_fajarMA resignFirstResponder];
    }
    else if ([_zoharMA isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_zoharMA resignFirstResponder];
    }
    else  if ([_asarMA isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_asarMA resignFirstResponder];
    }
    else  if ([_magribMA isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_magribMA resignFirstResponder];
    }
    else if ([_eshaMA isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_eshaMA resignFirstResponder];
    }
    else  if ([_fajarMB isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_fajarMB resignFirstResponder];
    }
    else if ([_zoharMB isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_zoharMB resignFirstResponder];
    }
    else  if ([_asarMB isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_asarMB resignFirstResponder];
    }
    else  if ([_magribMB isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_magribMB resignFirstResponder];
    }
    else if ([_eshaMB isFirstResponder]) {
        needTodeleteDoneButton = YES;
        [_eshaMB resignFirstResponder];
    }
    if (needTodeleteDoneButton) {
        [doneButton removeFromSuperview];
    }
}

- (IBAction)jammatClickd
{
    JammatNotificationsView *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"jammatNotifications"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (IBAction)muteClickd {
}

- (IBAction)otherClickd
{
    otherSettings *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"otherSettings"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (IBAction)miscClicked
{
    JammatNotificationsView *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"jammatNotifications"];
    [self.navigationController pushViewController:jView animated:NO];
}

- (void)updateLocalNotifications
{
    [Appdelegate cancelMuteNotifications];
    [Appdelegate createPhoneMuteNotifications];
}

- (void)setViewsConfigurations
{
    if (IS_IPAD) {
        self.frstText.font=[UIFont systemFontOfSize:29];
        self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,90, self.frstText.frame.size.width, 140);
        self.scnd.font=[UIFont systemFontOfSize:29];
        self.scnd.frame=CGRectMake(self.scnd.frame.origin.x,250, self.scnd.frame.size.width, self.scnd.frame.size.height);
        self.prayername.font=[UIFont systemFontOfSize:20];
        self.fnctn.font=[UIFont systemFontOfSize:22];
        self.muteBf.font=[UIFont systemFontOfSize:22];
        self.unmuteAf.font=[UIFont systemFontOfSize:22];
        self.magh.font=[UIFont systemFontOfSize:22];
        self.a.font=[UIFont systemFontOfSize:22];
        self.es.font=[UIFont systemFontOfSize:22];
        self.z.font=[UIFont systemFontOfSize:22];
        self.f.font=[UIFont systemFontOfSize:22];
        self.fajarMA.font=[UIFont systemFontOfSize:20];
        self.fajarMB.font=[UIFont systemFontOfSize:20];
        self.magribMA.font=[UIFont systemFontOfSize:20];
        self.magribMB.font=[UIFont systemFontOfSize:20];
        self.zoharMA.font=[UIFont systemFontOfSize:20];
        self.zoharMB.font=[UIFont systemFontOfSize:20];
        self.asarMA.font=[UIFont systemFontOfSize:20];
        self.asarMB.font=[UIFont systemFontOfSize:20];
        self.eshaMA.font=[UIFont systemFontOfSize:20];
        self.eshaMB.font=[UIFont systemFontOfSize:20];
    } else if (IS_IPHONE_6P) {
        self.frstText.font=[UIFont systemFontOfSize:15];
        self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,75, self.frstText.frame.size.width, self.frstText.frame.size.height);
        self.scnd.font=[UIFont systemFontOfSize:15];
        self.scnd.frame=CGRectMake(self.scnd.frame.origin.x,170, self.scnd.frame.size.width, self.scnd.frame.size.height);
    } else if(IS_IPHONE_6) {
        self.frstText.font=[UIFont systemFontOfSize:15];
        self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,75, self.frstText.frame.size.width, self.frstText.frame.size.height);
        self.scnd.font=[UIFont systemFontOfSize:15];
        self.scnd.frame=CGRectMake(self.scnd.frame.origin.x,162, self.scnd.frame.size.width, self.scnd.frame.size.height);
    } else if(IS_IPHONE_5) {
        self.frstText.font=[UIFont systemFontOfSize:13];
        self.frstText.frame=CGRectMake(self.frstText.frame.origin.x,75, self.frstText.frame.size.width, self.frstText.frame.size.height);
    }
    
    NSString *defaults=[[NSUserDefaults standardUserDefaults] valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
}

#pragma mark - Text Field

- (void)animateTextField: (UITextField*) textField up:(BOOL)up {
    int txtPosition;
    if (IS_IPHONE_6P) {
        txtPosition = 120;
    } else if (IS_IPHONE_6) {
        txtPosition = 140;
    } else if (IS_IPHONE_5) {
        txtPosition = 161;
    } else {
        txtPosition = 145;
    }
    const int movementDistance = (txtPosition < 0 ? 0 : txtPosition);
    const float movementDuration = 0.7f;
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    
    if ([textField.text integerValue] > 180) {
        UIAlertController *timeLimitAlert = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [timeLimitAlert addAction:ok];
        [self presentViewController:timeLimitAlert animated:YES completion:nil];
        textField.text = @"";
    } else {
        if ([self.fajarMB isEqual:textField]) {
            phoneMuteSettings.fajarMuteTime =  self.fajarMB.text;
        } else if ([self.fajarMA isEqual:textField]) {
            phoneMuteSettings.fajarUnMuteTime = [textField.text isEqualToString:@""]  ? @"30" :  textField.text;
        } else if ([self.zoharMB isEqual:textField]) {
            phoneMuteSettings.zoharMuteTime =  self.zoharMB.text;
        } else if ([self.zoharMA isEqual:textField]) {
            phoneMuteSettings.zoharUnMuteTime = [textField.text isEqualToString:@""]  ? @"30" :  textField.text;
        } else if ([self.asarMB isEqual:textField]) {
            phoneMuteSettings.asarMuteTime =  self.asarMB.text;
        } else if ([self.asarMA isEqual:textField]) {
            phoneMuteSettings.asarUnMuteTime = [textField.text isEqualToString:@""]  ? @"30" :  textField.text;
        } else if ([self.magribMB isEqual:textField]) {
            phoneMuteSettings.maghribMuteTime =  self.magribMB.text;
        } else if ([self.magribMA isEqual:textField]) {
            phoneMuteSettings.maghribUnMuteTime = [textField.text isEqualToString:@""]  ? @"30" :  textField.text;
        } else if ([self.eshaMB isEqual:textField]) {
            phoneMuteSettings.eshaMuteTime =  self.eshaMB.text;
        } else {
            phoneMuteSettings.eshaUnMuteTime = [textField.text isEqualToString:@""]  ? @"30" :  textField.text;
        }
        [[MTDBHelper sharedDBHelper] saveContext];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 3 && range.length == 0)
    {
        return NO;
    }
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}


@end
