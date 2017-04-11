//
//  MapAnnotation.h
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 6/3/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapAnnotation : MKPointAnnotation

@property (nonatomic, strong) NSString *masjidId;

@end
