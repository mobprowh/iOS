//
//  MasjidDetailView.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Masjid.h"
#import "MasjidListView.h"

@interface MasjidDetailView : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *masjidNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *masjidDetailLabel;
@property (strong, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) IBOutlet UILabel *callLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;
@property (strong, nonatomic) IBOutlet UIButton *eventBtn;
@property (strong, nonatomic) IBOutlet UIButton *donationBtn;
@property (strong, nonatomic) IBOutlet UIImageView *donationImage;
@property (strong, nonatomic) IBOutlet UIImageView *eventImage;
@property (strong, nonatomic) IBOutlet UIImageView *mapImage;
@property (strong, nonatomic) IBOutlet UITableView *donationTable;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *eventTable;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UIButton *primaryBtn;
@property (strong, nonatomic) IBOutlet UIButton *thrdBtn;
@property (strong, nonatomic) IBOutlet UIButton *scndBtn;
@property (strong, nonatomic) IBOutlet UIButton *fourthBtn;
@property (strong, nonatomic) IBOutlet UILabel *Label2;
@property (strong, nonatomic) IBOutlet UILabel *label4;
@property (strong, nonatomic) IBOutlet UILabel *lable1;
@property (strong, nonatomic) IBOutlet UILabel *label3;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UITableView *footerTable;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *headingLabel;
@property (strong, nonatomic) IBOutlet UILabel *mapLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventlabel;
@property (strong, nonatomic) IBOutlet UILabel *donationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIButton *left;
@property (strong, nonatomic) IBOutlet UIButton *right;
@property (strong, nonatomic) IBOutlet UIImageView *frontView1;
@property (strong, nonatomic) IBOutlet UIImageView *frontView2;
@property (strong, nonatomic) IBOutlet UIImageView *frontView3;
@property (strong, nonatomic) IBOutlet UIImageView *navImage;
@property (strong, nonatomic) IBOutlet UIImageView *line1;
@property (strong, nonatomic) IBOutlet UIImageView *line2;
@property (strong, nonatomic) IBOutlet UILabel *timetableLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventDonationLabel;
@property (strong, nonatomic) IBOutlet UILabel *bj;
@property (strong, nonatomic) IBOutlet UILabel *fLabl;
@property (strong, nonatomic) IBOutlet UILabel *zLbl;
@property (strong, nonatomic) IBOutlet UILabel *aLabl;
@property (strong, nonatomic) IBOutlet UILabel *mLabl;
@property (strong, nonatomic) IBOutlet UILabel *sLabl;
@property (strong, nonatomic) IBOutlet UILabel *eLabl;
@property (strong, nonatomic) IBOutlet UIButton *navLeft;
@property (strong, nonatomic) IBOutlet UILabel *navCenter;
@property (strong, nonatomic) IBOutlet UIButton *naveRight;
@property (strong, nonatomic) IBOutlet UILabel *pri;
@property (strong, nonatomic) IBOutlet UILabel *s;
@property (strong, nonatomic) IBOutlet UILabel *t;
@property (strong, nonatomic) IBOutlet UILabel *quat;
@property (strong, nonatomic) IBOutlet UILabel *pleaseSelect;
@property (strong, nonatomic) IBOutlet UILabel *dLabel;
//@property(nonatomic, strong, readwrite) UIPopoverController *flipsidePopoverController;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(weak, nonatomic) Masjid *masjid;
@property (strong, nonatomic) MasjidListView *masjidList;

- (IBAction)callAction;
- (IBAction)refreshAllData;
- (IBAction)popView;
- (IBAction)goLeft;
- (IBAction)goRight;
- (IBAction)setPriority:(UIButton *)sender;
- (IBAction)mapView;
- (IBAction)eventView;
- (IBAction)donationView;

@end
