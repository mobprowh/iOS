//
//  ThemeViewController.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "ThemeViewController.h"


@interface ThemeViewController ()

@end

@implementation ThemeViewController

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
    self.title=@"Themes";
    
    UIImage *buttonImage = [UIImage imageNamed:@"dashboard_icon.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width/8, buttonImage.size.height/7);
    [button addTarget:self action:@selector(popview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.theme1.layer.cornerRadius=4;
    self.theme1.clipsToBounds=YES;
    self.theme2.layer.cornerRadius=4;
    self.theme2.clipsToBounds=YES;
    self.themeView.layer.cornerRadius=4;
    self.themeView.clipsToBounds=YES;
}

-(void)popview
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
     [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (IBAction)Theme1Action
{
    [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"themeChanged"];
    themeImage = [UIImage imageNamed:@"smooth_backgraund.png"];
}

- (IBAction)theme2Action
{
    [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"themeChanged"];
    themeImage=[UIImage imageNamed:@"background.png"];
}

- (IBAction)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)them3Action:(id)sender
{
    [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"themeChanged"];
    themeImage=[UIImage imageNamed:@"summerTheme.png"];
}

@end
