//
//  TodayViewController.h
//  MasjidWidget
//
//  Created by Manpreet Singh on 6/3/16.
//  Copyright © 2016 Lentrica Software. All rights reserved.

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *subasadiqLabel;
@property (strong, nonatomic) IBOutlet UILabel *sunriseBottomLabel;
@property (strong, nonatomic) IBOutlet UILabel *beginingLabel;
@property (strong, nonatomic) IBOutlet UILabel *jamatNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *fajarTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *zoharTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *asarTitlelabel;
@property (strong, nonatomic) IBOutlet UILabel *maghribTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *eshaTitleLabel;

@property (strong, nonatomic) IBOutlet UITextField *fajarLabel;
@property (strong, nonatomic) IBOutlet UITextField *zoharLabel;
@property (strong, nonatomic) IBOutlet UITextField *asarlabel;
@property (strong, nonatomic) IBOutlet UITextField *maghribLabel;
@property (strong, nonatomic) IBOutlet UITextField *eshaLabel;
@property (strong, nonatomic) IBOutlet UITextField *fajarJLabel;
@property (strong, nonatomic) IBOutlet UITextField *zoharJlabel;
@property (strong, nonatomic) IBOutlet UITextField *asarJLabel;
@property (strong, nonatomic) IBOutlet UITextField *maghribJLabel;
@property (strong, nonatomic) IBOutlet UITextField *eshaJLabel;
@property (strong, nonatomic) IBOutlet UITextField *sunriselabel;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIView *borderView;


@end
