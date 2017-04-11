//
//  GeoPointCompass.m
//  GeoPointCompass
//
//  Created by Vardan Abrahamyan on 3/27/14.
//  Copyright (c) 2014  Vardan Abrahamyan. All rights reserved.
//

#import "GeoPointCompass.h"

#define RadiansToDegrees(radians)(radians * 180.0/M_PI)
#define DegreesToRadians(degrees)(degrees * M_PI / 180.0)

float angle;

@implementation GeoPointCompass

- (id) init {
    self = [super init];
    
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled])
        {
            // Configure and start the LocationManager instance
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.distanceFilter = 100.0f;
            
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
            [self.locationManager startUpdatingHeading];
        } else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"You need to turn On Gps for Compass" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [alertView show];
            
            //***********************************
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"You need to turn On Gps for Compass" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
//            [self presentViewController:alertController animated:YES completion:nil];
            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alertController animated:YES completion:nil];
            //***********************************
        }
    }
    return self;
}

// Caculate the angle between the north and the direction to observed geo-location
- (float)calculateAngle:(CLLocation *)userlocation
{
    float userLocationLatitude = DegreesToRadians(userlocation.coordinate.latitude);
    float userLocationLongitude = DegreesToRadians(userlocation.coordinate.longitude);
    
    float targetedPointLatitude = DegreesToRadians(self.latitudeOfTargetedPoint);
    float targetedPointLongitude = DegreesToRadians(self.longitudeOfTargetedPoint);
    
    float longitudeDifference = targetedPointLongitude - userLocationLongitude;
    
    float y = sin(longitudeDifference) * cos(targetedPointLatitude);
    float x = cos(userLocationLatitude) * sin(targetedPointLatitude) - sin(userLocationLatitude) * cos(targetedPointLatitude) * cos(longitudeDifference);
    float radiansValue = atan2(y, x);
    if(radiansValue < 0.0) radiansValue += 2*M_PI;
    
    return radiansValue;
}

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"new Location : %@",[newLocation description]);
    
    angle = [self calculateAngle:newLocation];
    
    CLLocation *firstLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    CLLocation *secondLocation = [[CLLocation alloc] initWithLatitude:21.422510 longitude:39.826168];
    CLLocationDistance distance = [firstLocation distanceFromLocation:secondLocation];
    NSString * distanceText = [NSString stringWithFormat:@"Distance: %.02f km", distance/1000];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:distanceText];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:NSMakeRange(0,9)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(9,distanceText.length - 9)];
    [self.distanceLabel setText:[NSString stringWithFormat:@"Distance: %.02f km", distance/1000]];
    self.distanceLabel.attributedText = attributedString;
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error : %@",[error localizedDescription]);
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    float direction = newHeading.magneticHeading;
    
    direction = direction > 180 ?  360 - direction : 0 - direction;
    
    // Rotate the arrow image
    if (self.arrowImageView) {
        [UIView animateWithDuration:3.0f animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(direction) + angle);
        }];
    }
    
    if (self.compassImageView) {
        [UIView animateWithDuration:3.0f animations:^{
            self.compassImageView.transform = CGAffineTransformMakeRotation(DegreesToRadians(direction));
        }];
    }
}

@end
