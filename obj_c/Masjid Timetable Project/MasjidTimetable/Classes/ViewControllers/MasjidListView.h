//
//  MasjidListView.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "TableViewCell.h"

@class MasjidListTextField;

@interface MasjidListView : BaseViewController <UITextFieldDelegate,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIImageView *searchImage;
@property (strong, nonatomic) IBOutlet MasjidListTextField *searchtextField;
@property (strong, nonatomic) IBOutlet UIButton *crossBtn;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *greenDot;
@property (strong, nonatomic) IBOutlet UIImageView *navImage;
@property (strong, nonatomic) IBOutlet UIButton *navLeft;
@property (strong, nonatomic) IBOutlet UILabel *navCenter;
@property (strong, nonatomic) IBOutlet UIButton *navRight;
@property (strong, nonatomic) IBOutlet UIButton *all;
@property (assign, nonatomic) BOOL needUpdateLocalNotifications;
@property (strong, nonatomic) IBOutlet UIView *navigationCustomView;
@property (strong, nonatomic) IBOutlet UIButton *timeTableButton;
@property (strong, nonatomic) IBOutlet UIImageView *timiTableText;
@property (strong, nonatomic) IBOutlet UIImageView *timetableIcon;

- (IBAction)cancelTapped;
- (IBAction)timeTablePage;
- (IBAction)popView;
- (IBAction)reload;

@end
