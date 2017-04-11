//
//  MasjidDetailTableCell.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface MasjidDetailTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *seperatorView;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *donationLabel;
@property (strong, nonatomic) IBOutlet UILabel *donationText;
@property (strong, nonatomic) IBOutlet UIButton *donationButton;
@property (strong, nonatomic) IBOutlet UIImageView *donationImage;
@property (strong, nonatomic) IBOutlet UILabel *bankDetails;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@end
