//
//  GeoPointCompass.h
//  GeoPointCompass
//
//  Created by Vardan Abrahamyan on 3/27/14.
//  Copyright (c) 2014 Maduranga Edirisinghe. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface GeoPointCompass : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager* locationManager;

@property (nonatomic, retain) UIImageView *arrowImageView;

@property (nonatomic, retain) UIImageView *compassImageView;

@property (nonatomic, retain) UILabel *distanceLabel;

@property (nonatomic) CLLocationDegrees latitudeOfTargetedPoint;

@property (nonatomic) CLLocationDegrees longitudeOfTargetedPoint;

@end
