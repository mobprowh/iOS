//
//  ViewController.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

#import "MasjidListView.h"
#import "AsmaulHusanaView.h"
#import "learningCentreViewViewController.h"
#import "InstructionView.h"
#import "alarmView.h"
#import "TimeTableView.h"
#import "ScrollViewWithPaging.h"
#import "tabBar.h"
#import "tasbeehViewController.h"
#import "JammatNotificationsView.h"
#import "ThemeViewController.h"
#import "NearestMasjidView.h"
#import "tasbeehSettings.h"
#import "TestingView.h"
#import "SponsorViewController.h"

@interface ViewController ()
{
    TimeTableView *tt1View;
}
@end

@implementation ViewController

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
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.settingLabel.textColor=[UIColor colorWithRed:171.0/255.0 green:244.0/255.0 blue:43.0/255.0 alpha:1.0];
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    if (IS_IPHONE_5) {
        [self.selectmasjidImage setFrame:CGRectMake(self.selectmasjidImage.frame.origin.x, self.selectmasjidImage.frame.origin.y + 15, self.selectmasjidImage.frame.size.width, self.selectmasjidImage.frame.size.width)];
        [self.nearestMasjidImage setFrame:CGRectMake(self.nearestMasjidImage.frame.origin.x, self.nearestMasjidImage.frame.origin.y + 15, self.nearestMasjidImage.frame.size.width, self.nearestMasjidImage.frame.size.width)];
        [self.tasbeehImage setFrame:CGRectMake(self.tasbeehImage.frame.origin.x, self.tasbeehImage.frame.origin.y + 15, self.tasbeehImage.frame.size.width, self.tasbeehImage.frame.size.width)];
        [self.wakeupImage setFrame:CGRectMake(self.wakeupImage.frame.origin.x, self.wakeupImage.frame.origin.y + 2, self.wakeupImage.frame.size.width, self.wakeupImage.frame.size.width)];
        [self.learningCentreImage setFrame:CGRectMake(self.learningCentreImage.frame.origin.x, self.learningCentreImage.frame.origin.y + 2, self.learningCentreImage.frame.size.width, self.learningCentreImage.frame.size.width)];
        [self.allahNameImage setFrame:CGRectMake(self.allahNameImage.frame.origin.x, self.allahNameImage.frame.origin.y + 2, self.allahNameImage.frame.size.width, self.allahNameImage.frame.size.width)];
        [self.instructionImage setFrame:CGRectMake(self.instructionImage.frame.origin.x, self.instructionImage.frame.origin.y - 8, self.instructionImage.frame.size.width, self.instructionImage.frame.size.width)];
        [self.themesImage setFrame:CGRectMake(self.themesImage.frame.origin.x, self.themesImage.frame.origin.y - 8, self.themesImage.frame.size.width, self.themesImage.frame.size.width)];
        [self.sponsorImage setFrame:CGRectMake(self.sponsorImage.frame.origin.x, self.sponsorImage.frame.origin.y - 8, self.sponsorImage.frame.size.width, self.sponsorImage.frame.size.width)];

        [self.settingsButton setFrame:CGRectMake(self.settingsButton.frame.origin.x, self.settingsButton.frame.origin.y - 7, self.settingsButton.frame.size.width, self.settingsButton.frame.size.height)];
        [self.settingsIcon setFrame:CGRectMake(self.settingsIcon.frame.origin.x, self.settingsIcon.frame.origin.y - 7, self.settingsIcon.frame.size.width, self.settingsIcon.frame.size.height)];
        [self.settingLabel setFrame:CGRectMake(self.settingLabel.frame.origin.x, self.settingLabel.frame.origin.y - 7, self.settingLabel.frame.size.width, self.settingLabel.frame.size.height)];
        [self.settingsImage setFrame:CGRectMake(self.settingsImage.frame.origin.x, self.settingsImage.frame.origin.y - 7, self.settingsImage.frame.size.width, self.settingsImage.frame.size.height)];
    } else if (IS_IPHONE_6) {
        [self.settingsButton setFrame:CGRectMake(self.settingsButton.frame.origin.x, self.settingsButton.frame.origin.y - 35, self.settingsButton.frame.size.width, self.settingsButton.frame.size.height)];
        [self.settingsIcon setFrame:CGRectMake(self.settingsIcon.frame.origin.x, self.settingsIcon.frame.origin.y - 35, self.settingsIcon.frame.size.width, self.settingsIcon.frame.size.height)];
        [self.settingLabel setFrame:CGRectMake(self.settingLabel.frame.origin.x, self.settingLabel.frame.origin.y - 35, self.settingLabel.frame.size.width, self.settingLabel.frame.size.height)];
        [self.settingsImage setFrame:CGRectMake(self.settingsImage.frame.origin.x, self.settingsImage.frame.origin.y - 35, self.settingsImage.frame.size.width, self.settingsImage.frame.size.height)];
        [self.timetbleBtn setFrame:CGRectMake(self.timetbleBtn.frame.origin.x, self.timetbleBtn.frame.origin.y - 12, self.timetbleBtn.frame.size.width, self.timetbleBtn.frame.size.height)];
        [self.timetableImage setFrame:CGRectMake(self.timetableImage.frame.origin.x, self.timetableImage.frame.origin.y - 12, self.timetableImage.frame.size.width, self.timetableImage.frame.size.height)];
    } else if (IS_IPHONE_6P) {
        [self.settingsButton setFrame:CGRectMake(self.settingsButton.frame.origin.x, self.settingsButton.frame.origin.y - 42, self.settingsButton.frame.size.width, self.settingsButton.frame.size.height)];
        [self.settingsIcon setFrame:CGRectMake(self.settingsIcon.frame.origin.x, self.settingsIcon.frame.origin.y - 42, self.settingsIcon.frame.size.width, self.settingsIcon.frame.size.height)];
        [self.settingLabel setFrame:CGRectMake(self.settingLabel.frame.origin.x, self.settingLabel.frame.origin.y - 42, self.settingLabel.frame.size.width, self.settingLabel.frame.size.height)];
        [self.settingsImage setFrame:CGRectMake(self.settingsImage.frame.origin.x, self.settingsImage.frame.origin.y - 42, self.settingsImage.frame.size.width, self.settingsImage.frame.size.height)];
        [self.timetbleBtn setFrame:CGRectMake(self.timetbleBtn.frame.origin.x, self.timetbleBtn.frame.origin.y - 17, self.timetbleBtn.frame.size.width, self.timetbleBtn.frame.size.height)];
        [self.timetableImage setFrame:CGRectMake(self.timetableImage.frame.origin.x, self.timetableImage.frame.origin.y - 17, self.timetableImage.frame.size.width, self.timetableImage.frame.size.height)];
    } else if (IS_IPAD) {
        [self.timetbleBtn setFrame:CGRectMake(self.timetbleBtn.frame.origin.x, self.timetbleBtn.frame.origin.y - 42, self.timetbleBtn.frame.size.width, self.timetbleBtn.frame.size.height)];
        [self.timetableImage setFrame:CGRectMake(self.timetableImage.frame.origin.x, self.timetableImage.frame.origin.y - 42, self.timetableImage.frame.size.width, self.timetableImage.frame.size.height)];
        [self.settingsButton setFrame:CGRectMake(self.settingsButton.frame.origin.x, self.settingsButton.frame.origin.y - 2, self.settingsButton.frame.size.width, self.settingsButton.frame.size.height)];
        [self.settingsIcon setFrame:CGRectMake(self.settingsIcon.frame.origin.x, self.settingsIcon.frame.origin.y - 2, self.settingsIcon.frame.size.width, self.settingsIcon.frame.size.height)];
        [self.settingLabel setFrame:CGRectMake(self.settingLabel.frame.origin.x, self.settingLabel.frame.origin.y - 2, self.settingLabel.frame.size.width, self.settingLabel.frame.size.height)];
        [self.settingsImage setFrame:CGRectMake(self.settingsImage.frame.origin.x, self.settingsImage.frame.origin.y - 2, self.settingsImage.frame.size.width, self.settingsImage.frame.size.height)];
    }
    [self setpageUISettings];
}

-(void)viewWillAppear:(BOOL)animated
{
    tt1View = [self.storyboard instantiateViewControllerWithIdentifier:@"timeTable"];

    xts=1;
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
        [self.frontView setImage:[UIImage imageNamed:@"1-4.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
        [self.frontView setImage:[UIImage imageNamed:@"smooth-inner.png"]];
    } else {
        self.settingLabel.textColor=[UIColor colorWithRed:171.0/255.0 green:244.0/255.0 blue:43.0/255.0 alpha:1.0];
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
        [self.frontView setImage:[UIImage imageNamed:@"summer-inner.png"]];
    }
    
    NSUserDefaults *userDefaults1 = [NSUserDefaults standardUserDefaults];
    NSArray *arrayOfIDs1 = [userDefaults1 objectForKey:@"idValues"];
    NSArray *arrayOfpriorities1 = [userDefaults1 objectForKey:@"priorityValues"];
    addids=[NSMutableArray arrayWithArray:arrayOfIDs1];
    addpri=[NSMutableArray arrayWithArray:arrayOfpriorities1];
    if (addids.count==0) {
    } else {
        globalMasjidID=[addids objectAtIndex:0];
    }
    [super viewWillAppear:animated];
}

- (IBAction)clickToSelectMasjid
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=NO;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move1) withObject:self afterDelay:0.0];
}

-(void)move1
{
    MasjidListView *masjidView = [self.storyboard instantiateViewControllerWithIdentifier:@"selectMasjid"];
    [self.navigationController pushViewController:masjidView animated:YES];
}

- (IBAction)clickToNearestMasjid
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=NO;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(moveToNearest) withObject:self afterDelay:0.0];
}

-(void)moveToNearest
{
    NearestMasjidView *masjidView = [self.storyboard instantiateViewControllerWithIdentifier:@"nearestMasjid"];
    [self.navigationController pushViewController:masjidView animated:YES];
}

- (IBAction)clickToTasbeeh
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=NO;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(movetoTasbeeh) withObject:self afterDelay:0.0];
}

-(void)movetoTasbeeh
{
    tasbeehViewController *View = [self.storyboard instantiateViewControllerWithIdentifier:@"tasbeeh"];
    [self.navigationController pushViewController:View animated:YES];
}

- (IBAction)clickToWakeUp
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=NO;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move4) withObject:self afterDelay:0.0];
}

-(void)move4
{
    alarmView *alarmView = [self.storyboard instantiateViewControllerWithIdentifier:@"alarm"];
    [self.navigationController pushViewController:alarmView animated:YES];
}

- (IBAction)clickTolearningCentre
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=NO;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move5) withObject:self afterDelay:0.0];
}

-(void)move5
{
    learningCentreViewViewController *lcView = [self.storyboard instantiateViewControllerWithIdentifier:@"learningCentre"];
    [self.navigationController pushViewController:lcView animated:YES];
}

- (IBAction)clickToGetInstructions
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=NO;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move7) withObject:self afterDelay:0.0];
}

-(void)move7
{
    InstructionView *instView = [self.storyboard instantiateViewControllerWithIdentifier:@"instructions"];
    [self.navigationController pushViewController:instView animated:YES];
}

- (IBAction)clickToGetAllahNames
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=NO;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move6) withObject:self afterDelay:0.0];
}

-(void)move6
{
    AsmaulHusanaView *AHView = [self.storyboard instantiateViewControllerWithIdentifier:@"AllahName"];
    [self.navigationController pushViewController:AHView animated:YES];
}

- (IBAction)clickToGoToSettings
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=NO;
    [self performSelector:@selector(move10) withObject:self afterDelay:0.0];
}

-(void)move10
{
    tabBar *jView = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    [self.navigationController pushViewController:jView animated:YES];
}

- (IBAction)timeTableAction
{
    self.timetableImage.hidden=NO;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move) withObject:self afterDelay:0.0];
}

-(void)move
{
    [self.navigationController pushViewController:tt1View animated:YES];
}

- (IBAction)themeBtnClickd
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=NO;
    self.sponsorImage.hidden=YES;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move8) withObject:self afterDelay:0.0];
}

-(void)move8
{
    ThemeViewController *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"themeView"];
    [self.navigationController pushViewController:ttView animated:YES];
}

- (IBAction)sponsorClickd
{
    self.timetableImage.hidden=YES;
    self.selectmasjidImage.hidden=YES;
    self.nearestMasjidImage.hidden=YES;
    self.tasbeehImage.hidden=YES;
    self.wakeupImage.hidden=YES;
    self.learningCentreImage.hidden=YES;
    self.allahNameImage.hidden=YES;
    self.instructionImage.hidden=YES;
    self.themesImage.hidden=YES;
    self.sponsorImage.hidden=NO;
    self.settingsImage.hidden=YES;
    [self performSelector:@selector(move9) withObject:self afterDelay:0.0];
}

- (void)move9
{
    SponsorViewController *ttView = [self.storyboard instantiateViewControllerWithIdentifier:@"sponsorView"];
    [self.navigationController pushViewController:ttView animated:YES];
}

- (void)setpageUISettings
{
    if (!IS_IPAD) {
        _settingLabel.font =[UIFont systemFontOfSize:16.0f];
        if(IS_IPHONE_6P){
            self.dashboard.font=[UIFont systemFontOfSize:30];
            self.frontView.frame=CGRectMake(self.frontView.frame.origin.x,220,self.frontView.frame.size.width,324);
            _settingLabel.frame = CGRectMake(150, self.settingLabel.frame.origin.y, self.settingLabel.frame.size.width, self.settingLabel.frame.size.height);
            
            [self.selectmasjid setFrame:CGRectMake(22, 228, 120, 99)];
            [self.nearest setFrame:CGRectMake(146, 228, 120, 99)];
            [self.tasbeeh setFrame:CGRectMake(272, 228, 120, 99)];
            [self.wakeup setFrame:CGRectMake(22, 332 , 120, 99)];
            [self.learning setFrame:CGRectMake(146, 332, 120, 99)];
            [self.alah setFrame:CGRectMake(272, 332, 120, 99)];
            [self.instructions setFrame:CGRectMake(22, 436, 120, 99)];
            [self.themes setFrame:CGRectMake(146, 436, 120, 99)];
            [self.sponsor setFrame:CGRectMake(272, 436, 120, 99)];
            [self.wakeupImage setFrame:CGRectMake(118, 330, 20, 23)];
            [self.learningCentreImage setFrame:CGRectMake(241, 330, 20, 23)];
            [self.allahNameImage setFrame:CGRectMake(368, 331, 20, 23.5)];
            [self.instructionImage setFrame:CGRectMake(120, 438, 20, 23)];
            [self.themesImage setFrame:CGRectMake(243, 437, 20, 23)];
            [self.sponsorImage setFrame:CGRectMake(367, 437, 20, 23)];
        } else if(IS_IPHONE_6) {
            self.dashboard.font=[UIFont systemFontOfSize:25];
            self.frontView.frame=CGRectMake(self.frontView.frame.origin.x,200,350,300);
            _settingLabel.frame = CGRectMake(135, self.settingLabel.frame.origin.y, self.settingLabel.frame.size.width, self.settingLabel.frame.size.height);
            
            [self.selectmasjid setFrame:CGRectMake(18, 208, 110, 92)];
            [self.nearest setFrame:CGRectMake(130, 208, 110, 92)];
            [self.tasbeeh setFrame:CGRectMake(246, 208, 110, 92)];
            [self.wakeup setFrame:CGRectMake(18, 304 , 110, 92)];
            [self.learning setFrame:CGRectMake(130, 304, 110, 92)];
            [self.alah setFrame:CGRectMake(246, 304, 110, 92)];
            [self.instructions setFrame:CGRectMake(18, 400, 110, 92)];
            [self.themes setFrame:CGRectMake(130, 400, 110, 92)];
            [self.sponsor setFrame:CGRectMake(246, 400, 110, 92)];
            [self.wakeupImage setFrame:CGRectMake(107.5, 305.5, 20, 20)];
            [self.learningCentreImage setFrame:CGRectMake(221, 305.5, 20, 20)];
            [self.allahNameImage setFrame:CGRectMake(331.5, 305.5, 20, 23.5)];
            [self.instructionImage setFrame:CGRectMake(107.5, 404, 20, 20)];
            [self.themesImage setFrame:CGRectMake(221, 404, 20, 20)];
            [self.sponsorImage setFrame:CGRectMake(331.5, 404, 20, 23.5)];
        } else if(IS_IPHONE_5) {
            self.frontView.frame=CGRectMake(self.frontView.frame.origin.x,183,self.frontView.frame.size.width,275);
            self.selectmasjid.frame=CGRectMake(self.selectmasjid.frame.origin.x,192,90,80);
            self.nearest.frame=CGRectMake(self.nearest.frame.origin.x,192,90, 80);
            self.tasbeeh.frame=CGRectMake(self.tasbeeh.frame.origin.x,192,90, 80);
            self.wakeup.frame=CGRectMake(self.wakeup.frame.origin.x,279,90,80);
            self.learning.frame=CGRectMake(self.learning.frame.origin.x,279,90,80);
            self.alah.frame=CGRectMake(self.alah.frame.origin.x,279,90,80);
            self.instructions.frame=CGRectMake(self.instructions.frame.origin.x,367,90,80);
            self.themes.frame=CGRectMake(self.themes.frame.origin.x,367,90,80);
            self.sponsor.frame=CGRectMake(self.sponsor.frame.origin.x,367,90,80);
        }
    } else {
        self.dashboard.font = [UIFont systemFontOfSize:35];
        _settingLabel.frame = CGRectMake(265, self.settingLabel.frame.origin.y, self.settingLabel.frame.size.width, self.settingLabel.frame.size.height);
    }
}

@end
