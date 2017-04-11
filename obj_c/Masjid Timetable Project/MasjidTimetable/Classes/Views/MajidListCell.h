//
//  MajidListCell.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/13/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

@interface MajidListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *mainContentView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *localNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countryLabel;

@end
