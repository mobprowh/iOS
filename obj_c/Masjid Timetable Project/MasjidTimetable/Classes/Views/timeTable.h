//
//  timeTable.h
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@interface timeTable : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *bStart;
@property (strong, nonatomic) IBOutlet UILabel *bEnd;
@property (strong, nonatomic) IBOutlet UILabel *fezarB;
@property (strong, nonatomic) IBOutlet UILabel *fazarJ;
@property (strong, nonatomic) IBOutlet UILabel *sunrise;
@property (strong, nonatomic) IBOutlet UILabel *zoharB;
@property (strong, nonatomic) IBOutlet UILabel *zoharJ;
@property (strong, nonatomic) IBOutlet UILabel *asarB;
@property (strong, nonatomic) IBOutlet UILabel *asarJ;
@property (strong, nonatomic) IBOutlet UILabel *magribB;
@property (strong, nonatomic) IBOutlet UILabel *magribJ;
@property (strong, nonatomic) IBOutlet UILabel *eshaB;
@property (strong, nonatomic) IBOutlet UILabel *eshaJ;

@end
