//
//  tasbeehSettings.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "tasbeehSettings.h"
#import "tasbeehViewController.h"



#define ACCEPTABLE_CHARECTERS @"0123456789"

@interface tasbeehSettings ()
{
    UIButton *doneButton;
}
@end

@implementation tasbeehSettings
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
    
    self.counterValue.keyboardType=UIKeyboardTypeNumberPad;
    UIImage *buttonImage = [UIImage imageNamed:@"Tasbeed_back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(-8, 0, 67, 32);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.title = @"Tasbeeh Settings";
    [self setPageSettings];
    if (IS_IPAD) {
        [self.aboveLabel setFont:[UIFont systemFontOfSize:20.0]];
        [self.aboveLabel setFrame:CGRectMake(self.aboveLabel.frame.origin.x, self.aboveLabel.frame.origin.y - 35, self.aboveLabel.frame.size.width, self.aboveLabel.frame.size.height)];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.counterValue isFirstResponder] || [self.playCounterValue isFirstResponder] || [self.counterLimitField isFirstResponder] || [self.tapLimitField isFirstResponder]) {
        int playCounter = (int)[self.playCounterValue.text integerValue];
        int limit = (int)[self.counterValue.text integerValue];
        [self.counterLimitField.text integerValue] >= 5 ? [Utils setCounterVibrateCount:5] : [Utils setCounterVibrateCount:(int)[self.counterLimitField.text integerValue]];
        [self.tapLimitField.text integerValue] >= 5 ? [Utils setTapVibrateCount:5] : [Utils setTapVibrateCount:(int)[self.tapLimitField.text integerValue]];
        [self.counterLimitField setText:[NSString stringWithFormat:@"%i", [Utils getCounterVibrateCount]]];
        [self.tapLimitField setText:[NSString stringWithFormat:@"%i", [Utils getTapVibrateCount]]];
        
        if (playCounter > limit)
        {
//            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"The counter value mast be bigger than play/vibrate count." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [errorAlert show];
            
            
            //***********************************
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"The counter value mast be bigger than play/vibrate count." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
            //***********************************
            
            
            
            self.playCounterValue.text = @"0";
        } else {
            [Utils setTapsLimitForTasbeeh:limit];
            [Utils setPlayLimitForTasbeeh:playCounter];
        }
        [self.counterValue resignFirstResponder];
        [self.playCounterValue resignFirstResponder];
        [self.counterLimitField resignFirstResponder];
        [self.tapLimitField resignFirstResponder];
    }
    [doneButton removeFromSuperview];
    doneButton = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
    if (IS_IPAD) [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.counterLimitField.keyboardType=UIKeyboardTypeNumberPad;
    self.counterValue.keyboardType=UIKeyboardTypeNumberPad;
    self.tapLimitField.keyboardType=UIKeyboardTypeNumberPad;
    self.playCounterValue.keyboardType=UIKeyboardTypeNumberPad;
    
    self.counterLimitField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.counterValue.keyboardAppearance = UIKeyboardAppearanceDark;
    self.tapLimitField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.playCounterValue.keyboardAppearance = UIKeyboardAppearanceDark;
    
    if (!IS_IPAD) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (IS_IPAD) [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [doneButton removeFromSuperview];
    doneButton = nil;

    [super viewWillDisappear:animated];
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
        }

        [keyboardView addSubview:doneButton];
        [keyboardView bringSubviewToFront:doneButton];
    });
}

- (void)closeKeyboard
{
    [doneButton removeFromSuperview];
    doneButton = nil;
    [self.view endEditing:YES];
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES ];
}

- (IBAction)chooseCounter:(UIButton *)sender
{
    for (UIImageView *imageView in self.counterCollection) {
        if (imageView.tag != sender.tag) {
            [imageView setImage:[UIImage imageNamed:@"wake_off.png"]];
        } else {
            [imageView setImage:[UIImage imageNamed:@"wake_on.png"]];
        }
    }
    [Utils setAlertTypeForCounter:(int)sender.tag];
}

- (IBAction)chooseTap:(UIButton *)sender
{
    for (UIImageView *imageView in self.tapCollection) {
        if (imageView.tag != sender.tag) {
            [imageView setImage:[UIImage imageNamed:@"wake_off.png"]];
        } else {
            [imageView setImage:[UIImage imageNamed:@"wake_on.png"]];
        }
    }
    [Utils setAlertTypeForTap:(int)sender.tag];
}

- (void)setPageSettings
{
    if ([Utils getTapsLimitForTasbeeh] > 0) [self.counterValue setText:[NSString stringWithFormat:@"%i", [Utils getTapsLimitForTasbeeh]]];
    self.playCounterValue.text = [NSString stringWithFormat:@"%i", [Utils getPlayLimitForTasbeeh]];
    [self.counterLimitField setText:[NSString stringWithFormat:@"%i", [Utils getCounterVibrateCount]]];
    [self.tapLimitField setText:[NSString stringWithFormat:@"%i", [Utils getTapVibrateCount]]];
    [(UIImageView *)[self.counterCollection objectAtIndex:[Utils isAlertTypeForCounterVibrate]] setImage:[UIImage imageNamed:@"wake_on.png"]];
    [(UIImageView *)[self.tapCollection objectAtIndex:[Utils isAlertTypeForTapVibrate]] setImage:[UIImage imageNamed:@"wake_on.png"]];
    if (IS_IPHONE_4) {
        [self.label1 setFont:[UIFont systemFontOfSize:9.0]];
        [self.label2 setFont:[UIFont systemFontOfSize:9.0]];
        [self.label3 setFont:[UIFont systemFontOfSize:9.0]];
        [self.aboveLabel setFont:[UIFont systemFontOfSize:11.0]];
    }
}

- (void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    [self saveVibrateCounts];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (IS_IPAD) {
        [self animateTextField: textField up: NO];
    }
    [self saveVibrateCounts];
    
    return YES;
}

- (void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    int txtPosition = textField.tag != 3 ? 50 * (int)textField.tag : 65 * (int)textField.tag;
    if (IS_IPAD ) {
        txtPosition += 10;
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

-(void)onKeyboardHide:(NSNotification *)notification
{
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.7f];
    self.view.frame = CGRectOffset(self.view.frame, 0, 0);
    [UIView commitAnimations];
    
}

- (void)saveVibrateCounts
{
    int playCounter = (int)[self.playCounterValue.text integerValue];
    int limit = (int)[self.counterValue.text integerValue];
    [self.counterLimitField.text integerValue] >= 5 ? [Utils setCounterVibrateCount:5] : [Utils setCounterVibrateCount:(int)[self.counterLimitField.text integerValue]];
    [self.tapLimitField.text integerValue] >= 5 ? [Utils setTapVibrateCount:5] : [Utils setTapVibrateCount:(int)[self.tapLimitField.text integerValue]];
    
    if (playCounter < limit) {
        [Utils setTapsLimitForTasbeeh:limit];
        [Utils setPlayLimitForTasbeeh:playCounter];
    }
}

@end
