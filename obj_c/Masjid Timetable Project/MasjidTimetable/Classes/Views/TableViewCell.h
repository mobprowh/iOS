//
//  TableViewCell.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface TableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *masjidName;
@property (strong, nonatomic) IBOutlet UILabel *localName;
@property (strong, nonatomic) IBOutlet UILabel *country;
@property (strong, nonatomic) IBOutlet UIImageView *l1;
@property (strong, nonatomic) IBOutlet UIImageView *l2;
@property (strong, nonatomic) IBOutlet UILabel *LearningText;
@property (strong, nonatomic) IBOutlet UIImageView *arrow;

@end
