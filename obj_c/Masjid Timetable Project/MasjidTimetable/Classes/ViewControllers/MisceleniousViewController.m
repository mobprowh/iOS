//
//  MisceleniousViewController.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 5/19/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import "MisceleniousViewController.h"

@interface MisceleniousViewController ()

@end

@implementation MisceleniousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *defaults=[[NSUserDefaults standardUserDefaults] valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
