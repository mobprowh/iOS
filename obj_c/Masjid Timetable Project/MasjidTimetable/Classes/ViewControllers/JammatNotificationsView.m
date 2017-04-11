//
//  JammatNotificationsView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "JammatNotificationsView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import <math.h>
#import "otherSettings.h"
#import "MuteView.h"
#import <UserNotifications/UserNotifications.h>

#define ACCEPTABLE_CHARECTERS @"0123456789"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface JammatNotificationsView ()
{
  NSMutableArray *currentMonthData,*alertOnOFF,*previousDayData;
  float alertTime;
  NSArray *json;
  NSInteger tag;
  NSMutableArray *alertsPopup;
  int alertHours,alertMinutes;
  NSArray *ArrayObjects;
  NSString *from,*soundFile;
  int minutes,hours,ii,m,k,l,seconds,xx;
  NSString *prayerAlert,*time,*prayerTime,*prayerTime1,*prayerTime2,*prayerTime3,*prayerTime4;
  NSString *finalAlert,*AlertTag;
  NSTimer *timer;
  NSUserDefaults *userDefaults;
//  UIAlertView *timeLimitAlert;
  JammatSoundSettings *soundSettings;
  BeginnerSoundSettings *beginnerSoundSettings;
  UIButton *doneButton;
    int segmentVal;
}

@end

@implementation JammatNotificationsView

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
  
  alertsPopup=[[NSMutableArray alloc]init];
  ii=1;
  xx=1;
  
  ArrayObjects=[NSArray arrayWithObjects:@"Azan",@"Phone Alert",@"None",nil];
  previousDayData=[[NSMutableArray alloc]init];
  userDefaults = [NSUserDefaults standardUserDefaults];
  currentMonthData=[[NSMutableArray alloc]init];
  alertOnOFF=[[NSMutableArray alloc]init];
  
  NSDateFormatter *istDateFormatter1 = [[NSDateFormatter alloc] init];
  [istDateFormatter1 setDateFormat:@"dd-MM-yyyy"];
  myMonthString=[istDateFormatter1 stringFromDate:[NSDate date]];
  NSString *dated=[myMonthString substringToIndex:2];
  if (([dated isEqualToString:@"09"])||([dated isEqualToString:@"07"])||([dated isEqualToString:@"06"])||([dated isEqualToString:@"05"])||([dated isEqualToString:@"04"])||([dated isEqualToString:@"03"])||([dated isEqualToString:@"02"])||([dated isEqualToString:@"01"])) {
    [istDateFormatter1 setDateFormat:@"d-MM-yyyy"];
    myMonthString = [istDateFormatter1 stringFromDate:[NSDate date]];
  }
  
  NSDateFormatter *date = [[NSDateFormatter alloc] init];
  [date setDateFormat:@"HH:mm"];
  time = [date stringFromDate:[NSDate date]];
  NSString *phone=[userDefaults valueForKey:@"sound"];
  if (phone.length==0 || [phone isEqualToString:@"2"]) {
    self.pickLabel.text=@"Select Alert Type";
  } else if ([phone isEqualToString:@"0"]) {
    self.pickLabel.text=@"Azan";
  } else if ([phone isEqualToString:@"1"]) {
    self.pickLabel.text = @"Phone Alert";
  }
  
  _fajar.keyboardType=UIKeyboardTypeNumberPad;
  _asar.keyboardType=UIKeyboardTypeNumberPad;
  _maghrib.keyboardType=UIKeyboardTypeNumberPad;
  _esha.keyboardType=UIKeyboardTypeNumberPad;
  _zohar.keyboardType=UIKeyboardTypeNumberPad;
  _fajar.keyboardAppearance = UIKeyboardAppearanceDark;
  self.asar.keyboardAppearance = UIKeyboardAppearanceDark;
  _zohar.keyboardAppearance = UIKeyboardAppearanceDark;
  _maghrib.keyboardAppearance = UIKeyboardAppearanceDark;
  _esha.keyboardAppearance = UIKeyboardAppearanceDark;
  
//  timeLimitAlert =[[UIAlertView alloc]initWithTitle:@"Message" message:@"Please set minutes less than 180 and it shouldn't be blank." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
  
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180 and it shouldn't be blank." preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:ok];
//    [self presentViewController:alertController animated:YES completion:nil];
    
  if (!primaryMasjid) {
//    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Many of these settings may not work until a masjid is selected as a favourite in the Primary position. You can select and set a particular masjid to be your primary favourite by visiting the Select Masjid page from the Dashboard." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
      
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Many of these settings may not work until a masjid is selected as a favourite in the Primary position. You can select and set a particular masjid to be your primary favourite by visiting the Select Masjid page from the Dashboard." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
      [alertController addAction:ok];
      [self presentViewController:alertController animated:YES completion:nil];

  }
  soundSettings = [[MTDBHelper sharedDBHelper] getJammatSoundSettings];
  if (!soundSettings) {
    soundSettings =  [[MTDBHelper sharedDBHelper] createJammatSoundSettings];
  }
  beginnerSoundSettings = [[MTDBHelper sharedDBHelper] getBeginnerSoundSettings];
  if (!beginnerSoundSettings) {
    beginnerSoundSettings =  [[MTDBHelper sharedDBHelper] createBeginnerSoundSettings];
  }
  [self setUISettings];
  
  if (self.segmentControl.selectedSegmentIndex==0)
    [self alertsBeginnerValues];
  else
    [self alertsJamaatValues];
}

- (void)viewWillAppear:(BOOL)animated
{
  [self.navigationController setNavigationBarHidden:YES];
  
  xx=1;
  doneButton.hidden=YES;
  NSString *defaults=[[NSUserDefaults standardUserDefaults] valueForKey:@"themeChanged"];
  if ([defaults intValue]==0 || defaults.length==0) {
    [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
  } else if ( [defaults intValue] == 1) {
    [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
  } else {
    [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateLocalNotifications)
                                               name:UIApplicationDidEnterBackgroundNotification object:nil];
  
  
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (!IS_IPAD) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  }
}


- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self updateLocalNotifications];
  [doneButton removeFromSuperview];
  doneButton = nil;
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  
  [super viewWillDisappear:animated];
}

- (void)keyboardWillShow:(NSNotification *)note
{
  if([doneButton isDescendantOfView:self.view]) {
    [doneButton removeFromSuperview];
  }
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

-(void)alertsJamaatValues
{// TODO: notification upgrade
 // NSString *popup=[userDefaults valueForKey:@"popup"];
  NSString *phone=[userDefaults valueForKey:@"sound"];
  if (!soundSettings.fajarOn) {
    [_fajarAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_fajarAlert setImage:[UIImage imageNamed:@"on2.png"]];
    
  }
  _fajar.text = [soundSettings.fajarJammatTime intValue] == 0 ? @"" : soundSettings.fajarJammatTime;
  if (!soundSettings.zoharOn) {
    [_zoharAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_zoharAlert setImage:[UIImage imageNamed:@"on2.png"]];
   
  }
   _zohar.text = [soundSettings.zoharJammatTime intValue] == 0 ? @"" : soundSettings.zoharJammatTime;
  if (!soundSettings.asarOn) {
    [_asarAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_asarAlert setImage:[UIImage imageNamed:@"on2.png"]];
    
  }
  _asar.text = [soundSettings.asarJammatTime intValue] == 0 ? @"" : soundSettings.asarJammatTime;
  if (!soundSettings.maghribOn) {
    [_magribAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_magribAlert setImage:[UIImage imageNamed:@"on2.png"]];
   
  }
   _maghrib.text = [soundSettings.maghribJammatTime intValue] == 0 ? @"" : soundSettings.maghribJammatTime;
  if (!soundSettings.eshaOn) {
    [_eshaAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_eshaAlert setImage:[UIImage imageNamed:@"on2.png"]];
   
    
  }
   _esha.text = [soundSettings.eshaJammatTime intValue] == 0 ? @"" : soundSettings.eshaJammatTime;
  if (phone.length==0 || [phone isEqualToString:@"0"]) {
    m=0;
  } else {
    m=1;
  }
  [(UIImageView *)[self.radioImagesCollection objectAtIndex:0] setImage:[UIImage imageNamed:@"off.png"]];
  [(UIImageView *)[self.radioImagesCollection objectAtIndex:1] setImage:[UIImage imageNamed:@"off.png"]];
  [(UIImageView *)[self.radioImagesCollection objectAtIndex:2] setImage:[UIImage imageNamed:@"off.png"]];

  int imageViewTag;
  if ([soundSettings.soundName containsString:@"azan"])
  {
    imageViewTag = 0;

    [self.pickLabel setText:@"Azan"];
  }
  else if (soundSettings.soundName == nil)
  {
    imageViewTag = 2;
    [self.pickLabel setText:@"Select Alert type"];
  }
  else
  {
      imageViewTag = 1;
      [self.pickLabel setText:@"Phone Alert"];
  }
  [(UIImageView *)[self.radioImagesCollection objectAtIndex:imageViewTag] setImage:[UIImage imageNamed:@"on.png"]];
  
}

-(void)alertsBeginnerValues
{// TODO: notification upgrade
  //NSString *popup=[userDefaults valueForKey:@"popup"];
  NSString *phone=[userDefaults valueForKey:@"sound"];
  if (!beginnerSoundSettings.fajarOn || [beginnerSoundSettings.fajarBeginnnerTime intValue] == 0) {
    [_fajarAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_fajarAlert setImage:[UIImage imageNamed:@"on2.png"]];
    _fajar.text = [beginnerSoundSettings.fajarBeginnnerTime intValue] == 0 ? @"" : beginnerSoundSettings.fajarBeginnnerTime;
  }
  if (!beginnerSoundSettings.zoharOn || [beginnerSoundSettings.zoharBeginnnerTime intValue] == 0) {
    [_zoharAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_zoharAlert setImage:[UIImage imageNamed:@"on2.png"]];
  }
  _zohar.text = [beginnerSoundSettings.zoharBeginnnerTime intValue] == 0 ? @"" : beginnerSoundSettings.zoharBeginnnerTime;

  if (!beginnerSoundSettings.asarOn || [beginnerSoundSettings.asarBeginnnerTime intValue] == 0) {
    [_asarAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_asarAlert setImage:[UIImage imageNamed:@"on2.png"]];
  }
  _asar.text = [beginnerSoundSettings.asarBeginnnerTime intValue] == 0 ? @"" : beginnerSoundSettings.asarBeginnnerTime;

  if (!beginnerSoundSettings.maghribOn || [beginnerSoundSettings.maghribBeginnnerTime intValue] == 0) {
    [_magribAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_magribAlert setImage:[UIImage imageNamed:@"on2.png"]];
  }
  _maghrib.text = [beginnerSoundSettings.maghribBeginnnerTime intValue] == 0 ? @"" : beginnerSoundSettings.maghribBeginnnerTime;

  if (!beginnerSoundSettings.eshaOn || [beginnerSoundSettings.eshaBeginnnerTime intValue] == 0) {
    [_eshaAlert setImage:[UIImage imageNamed:@"off2.png"]];
  } else {
    [_eshaAlert setImage:[UIImage imageNamed:@"on2.png"]];
    
    
  }
  _esha.text = [beginnerSoundSettings.eshaBeginnnerTime intValue] == 0 ? @"" : beginnerSoundSettings.eshaBeginnnerTime;
  if (phone.length==0 || [phone isEqualToString:@"0"]) {
    m=0;
  } else {
    m=1;
  }
  [(UIImageView *)[self.radioImagesCollection objectAtIndex:0] setImage:[UIImage imageNamed:@"off.png"]];
  [(UIImageView *)[self.radioImagesCollection objectAtIndex:1] setImage:[UIImage imageNamed:@"off.png"]];
  [(UIImageView *)[self.radioImagesCollection objectAtIndex:2] setImage:[UIImage imageNamed:@"off.png"]];

  int imageViewTag;
  
    if ([beginnerSoundSettings.soundName containsString:@"azan"])
    {
        imageViewTag = 0;
        
        [self.pickLabel setText:@"Azan"];
    }
    else if (beginnerSoundSettings.soundName == nil)
    {
        imageViewTag = 2;
        [self.pickLabel setText:@"Select Alert type"];
    }
    else
    {
        imageViewTag = 1;
        [self.pickLabel setText:@"Phone Alert"];
    }
  [(UIImageView *)[self.radioImagesCollection objectAtIndex:imageViewTag] setImage:[UIImage imageNamed:@"on.png"]];
  
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if ([_fajar isFirstResponder]) {
    [_fajar resignFirstResponder];
    [doneButton removeFromSuperview];
  }
  if ([_zohar isFirstResponder]) {
    [_zohar resignFirstResponder];
    [doneButton removeFromSuperview];
  }
  if ([_asar isFirstResponder]) {
    [_asar resignFirstResponder];
    [doneButton removeFromSuperview];
  }
  if ([_maghrib isFirstResponder]) {
    [_maghrib resignFirstResponder];
    [doneButton removeFromSuperview];
  }
  if ([_esha isFirstResponder]) {
    [_esha resignFirstResponder];
    [doneButton removeFromSuperview];
  }
}


- (void)animateTextField:(UITextField*) textField up: (BOOL) up
{
  int txtPosition = 50;
  const int movementDistance = (txtPosition < 0 ? 0 : txtPosition);
  const float movementDuration = 0.7f;
  
  int movement = (up ? -movementDistance : movementDistance);
  
  [UIView beginAnimations: @"anim" context: nil];
  [UIView setAnimationBeginsFromCurrentState: YES];
  [UIView setAnimationDuration: movementDuration];
  self.view.frame = CGRectOffset(self.view.frame, 0, movement);
  [UIView commitAnimations];
}

- (void)updateLocalNotifications
{
  [[MTDBHelper sharedDBHelper] saveContext];
  [Appdelegate cancelJammatLocalNotifications];
  [Appdelegate creatLocalNotificationsForJammat];
}

- (void)setUISettings
{
  if (IS_IPAD) {
    self.frstText.font=[UIFont systemFontOfSize:20];
    self.soundBottomLabel.font = [UIFont italicSystemFontOfSize:13];
    self.soundBottomLabel.frame = CGRectMake(self.soundBottomLabel.frame.origin.x - 60, self.soundBottomLabel.frame.origin.y, self.soundBottomLabel.frame.size.width + 130, self.soundBottomLabel.frame.size.height);
    self.f.font=[UIFont systemFontOfSize:22];
    self.z.font=[UIFont systemFontOfSize:22];
    self.a.font=[UIFont systemFontOfSize:22];
    self.mpray.font=[UIFont systemFontOfSize:22];
    self.e.font=[UIFont systemFontOfSize:22];
    self.fajar.font=[UIFont systemFontOfSize:20];
    self.asar.font=[UIFont systemFontOfSize:20];
    self.maghrib.font=[UIFont systemFontOfSize:20];
    self.zohar.font=[UIFont systemFontOfSize:20];
    self.esha.font=[UIFont systemFontOfSize:20];
    self.prayerName.font=[UIFont systemFontOfSize:22];
    self.alertLabel.font=[UIFont systemFontOfSize:22];
    self.minsBf.font=[UIFont systemFontOfSize:22];
    self.minsBf.frame=CGRectMake(305, self.minsBf.frame.origin.y,self.minsBf.frame.size.width,self.minsBf.frame.size.height);
    self.alertLabel.frame=CGRectMake(560, self.alertLabel.frame.origin.y,self.alertLabel.frame.size.width,self.alertLabel.frame.size.height);
    self.pickLabel.font=[UIFont systemFontOfSize:18];
  } else {
    if(IS_IPHONE_6P) {
      self.frstText.font=[UIFont systemFontOfSize:13];
    } else if(IS_IPHONE_6) {
      self.frstText.font=[UIFont systemFontOfSize:13];
    } else if(IS_IPHONE_5) {
      self.frstText.font=[UIFont systemFontOfSize:11];
    }
  }
}

#pragma mark - Table View Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section
{
  return [ArrayObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"cellID";
  UILabel *myLabel;
  UIView *gradientBack;
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    myLabel=[[UILabel alloc]init];
    gradientBack=[[UIView alloc]init];
    myLabel.frame=CGRectMake(0,2,160,28);
    gradientBack.frame=CGRectMake(0,2,160,28);
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = gradientBack.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1.0]CGColor], (id)[[UIColor colorWithRed:214.0f/255.0f green:214.0f/255.0f blue:214.0f/255.0f alpha:1.0]CGColor], nil];
    [gradientBack.layer insertSublayer:gradientLayer atIndex:0];
    
    [cell.contentView addSubview:gradientBack];
    [cell.contentView addSubview:myLabel];
    [cell.contentView bringSubviewToFront:myLabel];
  }
  myLabel.textColor=[UIColor blackColor];
  myLabel.textAlignment=NSTextAlignmentLeft;
  myLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold"size:12];
  myLabel.text=[ArrayObjects objectAtIndex:indexPath.row];
  
  return cell;
}

#pragma mark - Textfield's delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if (textField.text.length >= 3 && range.length == 0) {
    return NO;
  }
  NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
  NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
  
  return [string isEqualToString:filtered];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  if ([textField.text integerValue]> 180) {
//    [timeLimitAlert show];
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180 and it shouldn't be blank." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
      [alertController addAction:ok];
      [self presentViewController:alertController animated:YES completion:nil];
    textField.text = @"";
  } else {
    if ([textField isEqual:self.fajar]) {
        if (textField.text.length == 0) {
          [_fajarAlert setImage:[UIImage imageNamed:@"off2.png"]];
        }

      if (segmentVal==0) {
        beginnerSoundSettings.fajarBeginnnerTime = textField.text;
      }
      else {
        soundSettings.fajarJammatTime = textField.text;
      }
    } else if ([textField isEqual:self.zohar]) {
        if (textField.text.length == 0) {
            [_zoharAlert setImage:[UIImage imageNamed:@"off2.png"]];
        }
        
      if (segmentVal==0) {
        beginnerSoundSettings.zoharBeginnnerTime = textField.text;
      }
      else {
        soundSettings.zoharJammatTime = textField.text;
      }
    } else if ([textField isEqual:self.asar]) {
        if (textField.text.length == 0) {
            [_asarAlert setImage:[UIImage imageNamed:@"off2.png"]];
        }
        
      if (segmentVal==0) {
        beginnerSoundSettings.asarBeginnnerTime = textField.text;
      }
      else {
        
        soundSettings.asarJammatTime = textField.text;
      }
    } else if ([textField isEqual:self.maghrib]) {
        if (textField.text.length == 0) {
            [_magribAlert setImage:[UIImage imageNamed:@"off2.png"]];
        }
        
      if (segmentVal==0) {
        beginnerSoundSettings.maghribBeginnnerTime = textField.text;
      }
      else {
        
        soundSettings.maghribJammatTime = textField.text;
      }
    } else {
        if (textField.text.length == 0) {
            [_eshaAlert setImage:[UIImage imageNamed:@"off2.png"]];
        }
        
      if (segmentVal==0) {
        beginnerSoundSettings.eshaBeginnnerTime = textField.text;
      }
      else {
        
        soundSettings.eshaJammatTime = textField.text;
      }
    }
    [[MTDBHelper sharedDBHelper] saveContext];
  }
  if (IS_IPHONE_4 ) {
    [self animateTextField: textField up: NO];
  }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  if (IS_IPHONE_4) {
    [self animateTextField: textField up: YES];
  }
}

- (IBAction)segmentControlButtonAction:(UISegmentedControl *)sender {
    
    [[MTDBHelper sharedDBHelper] saveContext];
    
  if(sender.selectedSegmentIndex == 0)
  {
      segmentVal = 0;
      beginnerSoundSettings = [[MTDBHelper sharedDBHelper] getBeginnerSoundSettings];
    
      if (!beginnerSoundSettings)
    {
      beginnerSoundSettings =  [[MTDBHelper sharedDBHelper] createBeginnerSoundSettings];
    }
    [self alertsBeginnerValues];
    [self setUISettings];

    self.frstText.text = @"Be notified xx minutes before the Beginning time of each salah";
  }
  else
  {
    segmentVal = 1 ;
    soundSettings = [[MTDBHelper sharedDBHelper] getJammatSoundSettings];
    if (!soundSettings)
    {
      soundSettings =  [[MTDBHelper sharedDBHelper] createJammatSoundSettings];
    }

    [self alertsJamaatValues];
    [self setUISettings];
    self.frstText.text = @"Be notified XX minutes before each Jamaat time, thereby alerting you to prepare for congregation";
  }
}

#pragma mark - Switch actions
- (IBAction)alertOnOffClick:(UIButton *)sender
{
  if (self.fajar.text.length == 0) {
    return;
  }
  else if (self.fajar.text.length > 0 && [self.fajar.text intValue] <= 180 ) {
    alert=1;
    tag=sender.tag;
    if (segmentVal==1) {
      if (soundSettings.fajarOn) {
        prayerID=@"5";
        [_fajarAlert setImage:[UIImage imageNamed:@"off2.png"]];
        soundSettings.fajarOn = NO;
      } else {
        [_fajarAlert setImage:[UIImage imageNamed:@"on2.png"]];
        prayerID=@"5";
        soundSettings.fajarOn = YES;
      }
    }else{
      if (beginnerSoundSettings.fajarOn) {
        prayerID=@"5";
        [_fajarAlert setImage:[UIImage imageNamed:@"off2.png"]];
        beginnerSoundSettings.fajarOn = NO;
      } else {
        [_fajarAlert setImage:[UIImage imageNamed:@"on2.png"]];
        prayerID=@"5";
        beginnerSoundSettings.fajarOn = YES;
      }
    }
    [[MTDBHelper sharedDBHelper] saveContext];
  } else {
//    [timeLimitAlert show];
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180 and it shouldn't be blank." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
      [alertController addAction:ok];
      [self presentViewController:alertController animated:YES completion:nil];
    self.fajar.text = @"";
  }
}

- (IBAction)zoharAlertOnOFF:(UIButton *)sender
{
  if (self.zohar.text.length == 0) {
    return;
  }
  else if (self.zohar.text.length > 0 && [self.zohar.text intValue] <= 180 ) {
    alert=1;
    tag = sender.tag;
    if (tag == 1) {
      prayerID=@"6";
      if (segmentVal==0) {
        
        if (beginnerSoundSettings.zoharOn){
          [_zoharAlert setImage:[UIImage imageNamed:@"off2.png"]];
          beginnerSoundSettings.zoharOn = NO;
        } else {
          [_zoharAlert setImage:[UIImage imageNamed:@"on2.png"]];
          beginnerSoundSettings.zoharOn = YES;
        }
      }else{
        if (soundSettings.zoharOn){
          [_zoharAlert setImage:[UIImage imageNamed:@"off2.png"]];
          soundSettings.zoharOn = NO;
        } else {
          [_zoharAlert setImage:[UIImage imageNamed:@"on2.png"]];
          soundSettings.zoharOn = YES;
        }
      }
      [[MTDBHelper sharedDBHelper] saveContext];
    }
  } else {
//    [timeLimitAlert show];
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180 and it shouldn't be blank." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
      [alertController addAction:ok];
      [self presentViewController:alertController animated:YES completion:nil];
    self.zohar.text = @"";
  }
}

- (IBAction)magribONOFF:(UIButton *)sender
{
  if (self.maghrib.text.length == 0) {
    return;
  }
  else if (self.maghrib.text.length > 0 &&[self.maghrib.text intValue] <= 180 ) {
    alert=1;
    tag=sender.tag;
    if (tag == 3) {
      prayerID=@"8";
      if (segmentVal==0) {
        if (beginnerSoundSettings.maghribOn) {
          [_magribAlert setImage:[UIImage imageNamed:@"off2.png"]];
          beginnerSoundSettings.maghribOn = NO;
        } else {
          [_magribAlert setImage:[UIImage imageNamed:@"on2.png"]];
          beginnerSoundSettings.maghribOn = YES;
        }
      }else{
        if (soundSettings.maghribOn) {
          [_magribAlert setImage:[UIImage imageNamed:@"off2.png"]];
          soundSettings.maghribOn = NO;
        } else {
          [_magribAlert setImage:[UIImage imageNamed:@"on2.png"]];
          soundSettings.maghribOn = YES;
        }
        
      }
      [[MTDBHelper sharedDBHelper] saveContext];
    }
  } else {
//    [timeLimitAlert show];
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180 and it shouldn't be blank." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
      [alertController addAction:ok];
      [self presentViewController:alertController animated:YES completion:nil];
    self.maghrib.text = @"";
  }
}

- (IBAction)asarOnOFF:(UIButton *)sender
{
  if (self.asar.text.length == 0) {
    return;
  }
  else if (self.asar.text.length > 0 &&[self.asar.text intValue] <= 180 ) {
    alert=1;
    tag=sender.tag;
    
    if (tag == 2) {
      if (segmentVal==0) {
        if (beginnerSoundSettings.asarOn) {
          [_asarAlert setImage:[UIImage imageNamed:@"off2.png"]];
          beginnerSoundSettings.asarOn = NO;
        } else {
          prayerID=@"7";
          [_asarAlert setImage:[UIImage imageNamed:@"on2.png"]];
          beginnerSoundSettings.asarOn = YES;
        }
      }else{
        if (soundSettings.asarOn) {
          [_asarAlert setImage:[UIImage imageNamed:@"off2.png"]];
          soundSettings.asarOn = NO;
        } else {
          prayerID=@"7";
          [_asarAlert setImage:[UIImage imageNamed:@"on2.png"]];
          soundSettings.asarOn = YES;
        }
      }
      [[MTDBHelper sharedDBHelper] saveContext];
    }
  } else {
//    [timeLimitAlert show];
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180 and it shouldn't be blank." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
      [alertController addAction:ok];
      [self presentViewController:alertController animated:YES completion:nil];
    self.asar.text = @"";
  }
}

- (IBAction)eshaONOFF:(UIButton *)sender
{
  if (self.esha.text.length == 0) {
    return;
  }
  else if (self.esha.text.length > 0 &&[self.esha.text intValue] <= 180) {
    alert=1;
    tag=sender.tag;
    prayerID=@"9";
    if (segmentVal==0) {
      if (beginnerSoundSettings.eshaOn) {
        [_eshaAlert setImage:[UIImage imageNamed:@"off2.png"]];
        beginnerSoundSettings.eshaOn = NO;
      } else {
        [_eshaAlert setImage:[UIImage imageNamed:@"on2.png"]];
        beginnerSoundSettings.eshaOn = YES;
      }
    }else{
      if (soundSettings.eshaOn) {
        [_eshaAlert setImage:[UIImage imageNamed:@"off2.png"]];
        soundSettings.eshaOn = NO;
      } else {
        [_eshaAlert setImage:[UIImage imageNamed:@"on2.png"]];
        soundSettings.eshaOn = YES;
      }
    }
    [[MTDBHelper sharedDBHelper] saveContext];
  } else {
//    [timeLimitAlert show];
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message" message:@"Please set minutes less than 180 and it shouldn't be blank." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
      [alertController addAction:ok];
      [self presentViewController:alertController animated:YES completion:nil];
    self.esha.text = @"";
  }
}

#pragma mark - Actions

- (IBAction)selectAlertType:(UIButton *)sender
{// TODO: notification upgrade
    for (UIImageView *imageView in self.radioImagesCollection)
    {
        if (imageView.tag != sender.tag)
        {
            [imageView setImage:[UIImage imageNamed:@"off.png"]];
        }
        else
        {
            [imageView setImage:[UIImage imageNamed:@"on.png"]];
        }
    }
    if (segmentVal == 0)
    {
        switch (sender.tag) {
            case 0:
                self.pickLabel.text = @"Azan";
                beginnerSoundSettings.soundName = @"azanx.wav";
                break;
            case 1:
                self.pickLabel.text = @"Phone Alert";
                
                if (IS_IOS_10_OR_LATER) {
                    beginnerSoundSettings.soundName = [NSString stringWithFormat:@"%@", [UNNotificationSound defaultSound]];
                }
                else
                {
                    beginnerSoundSettings.soundName = UILocalNotificationDefaultSoundName;
                }
                
                break;
            case 2:
                self.pickLabel.text = @"Select Alert Type";
                beginnerSoundSettings.soundName = nil;
                break;
        }
    }
    else
    {
        switch (sender.tag) {
            case 0:
                self.pickLabel.text = @"Azan";
                jammatSoundSettings.soundName = @"azanx.wav";
                break;
            case 1:
                self.pickLabel.text = @"Phone Alert";
                
                if (IS_IOS_10_OR_LATER)
                {
                    jammatSoundSettings.soundName = [NSString stringWithFormat:@"%@", [UNNotificationSound defaultSound]];
                }
                else
                {
                    jammatSoundSettings.soundName = UILocalNotificationDefaultSoundName;
                }
                break;
            case 2:
                self.pickLabel.text = @"Select Alert Type";
                jammatSoundSettings.soundName = nil;
                break;
        }
    }
}

@end
