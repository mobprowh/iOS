//
//  CalloutAnnotation.h
//  CustomCalloutSample
//
//  Created by Vardan Abrahamyan on 11/05/17.
//  Copyright 2011 aguuu,Inc. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CalloutAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *masjidId;
@property (nonatomic, assign) BOOL isFromDB;

@end
