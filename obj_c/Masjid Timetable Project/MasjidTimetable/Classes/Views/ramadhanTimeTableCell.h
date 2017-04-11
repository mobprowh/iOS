//
//  ramadhanTimeTableCell.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/20/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

@interface ramadhanTimeTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *b;
@property (strong, nonatomic) IBOutlet UILabel *j;
@property (strong, nonatomic) IBOutlet UILabel *sehriEnd;
@property (strong, nonatomic) IBOutlet UILabel *subah;
@property (strong, nonatomic) IBOutlet UILabel *fajar;
@property (strong, nonatomic) IBOutlet UILabel *sunrise;
@property (strong, nonatomic) IBOutlet UILabel *zoharB;
@property (strong, nonatomic) IBOutlet UILabel *zohar;
@property (strong, nonatomic) IBOutlet UILabel *asar;
@property (strong, nonatomic) IBOutlet UILabel *asarJammat;
@property (strong, nonatomic) IBOutlet UILabel *iftar;
@property (strong, nonatomic) IBOutlet UILabel *maghrib;
@property (strong, nonatomic) IBOutlet UILabel *eshaBegin;
@property (strong, nonatomic) IBOutlet UILabel *esha;

@end
