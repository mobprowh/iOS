//
//  NearestMasjidView.m
//  Masjid Timetable
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "NearestMasjidView.h"
#import "MasjidDetailView.h"
#import "AFNetworking.h"

#import "MapAnnotation.h"
#import "PinAnnotation.h"
#import "CalloutAnnotationView.h"

#define kGOOGLE_API_KEY @"AIzaSyCmSqUd3wPMncaFJM-Q38nqEImkPza4fr8"
#define	kMosque	@"mosque"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
NSString *const kMAKRViewControllerMapAnnotationViewReuseIdentifier = @"MAKRViewControllerMapAnnotationViewReuseIdentifier";

@interface NearestMasjidView () <CalloutAnnotationViewDelegate>
{
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    NSString *latitude,*longitude,*city;
    NSMutableArray *masjids;
    NSMutableDictionary *coordinates;
    NSInteger masjidIndex;
    BOOL isRadiusSetted;
    BOOL isCloseButtonClicked;
    NSInteger pageNumber;
    BOOL isreceiveMasjids;
    BOOL needToStopRequests;
}
@end

@implementation NearestMasjidView

- (BOOL)shouldAutorotate
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000  
- (NSUInteger)supportedInterfaceOrientations  
#else  
- (UIInterfaceOrientationMask)supportedInterfaceOrientations  
#endif  
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pageNumber = 1;
    coordinates = [NSMutableDictionary dictionary];
    masjids = [NSMutableArray array];
    self.nearMap.delegate = self;
    [self.nearMap setShowsUserLocation:YES];
    
    [self initLocationManager];
}

- (void)initLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    if(IS_IOS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSString *defaults=[[NSUserDefaults standardUserDefaults]valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0) {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *location = newLocation;
    NSNumber *lng = [[NSNumber alloc] initWithDouble:location.coordinate.longitude];
    NSNumber *lat = [[NSNumber alloc] initWithDouble:location.coordinate.latitude];
    [Utils saveUserLatCoordinate:lat];
    [Utils saveUserLngCoordinate:lng];
    
    if (!isRadiusSetted) {
        isRadiusSetted = YES;
        double miles = 2.0;
        double scalingFactor = ABS( (cos(2 * M_PI * newLocation.coordinate.latitude / 360.0) ));
        
        MKCoordinateSpan span;
        span.latitudeDelta = miles/69.0;
        span.longitudeDelta = miles/(scalingFactor * 69.0);
        MKCoordinateRegion region;
        region.span = span;
        region.center = newLocation.coordinate;
        
        [self.nearMap setRegion:region animated:YES];
        [self getMasjids];
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    MKMapRect mRect = self.nearMap.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    currentCentre = self.nearMap.centerCoordinate;
}


#pragma mark - API

- (void)getMasjids
{
    if (!needToStopRequests) {

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.masjid-timetable.com"]];
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString * urlPath = [NSString stringWithFormat:@"/data/masjiddistance.php?page=%li&lat=%@&long=%@", (long)pageNumber,[Utils getUserLatCoordinate], [Utils getUserLngCoordinate]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:urlPath parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObjct) {
                                                                                            NSArray *responseArray = (NSArray*)responseObjct;
                                                                                            if (responseArray.count > 0) {
                                                                                                isreceiveMasjids = YES;
                                                                                                masjids = (NSMutableArray *)[masjids arrayByAddingObjectsFromArray:responseArray];
                                                                                                [self setMarkersToMap:responseArray];
                                                                                            } else {
                                                                                                if (!isreceiveMasjids) {
                                                                                                    pageNumber+=1;
                                                                                                    [self getMasjids];
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            
                                                                                        }];
    [operation start];
    } else {
        
    }
}

- (void)setMarkersToMap:(NSArray *)secondServerMasjids
{
    for (NSDictionary *currentMasjid in secondServerMasjids) {
        if ([[currentMasjid valueForKey:@"distance"] floatValue] > 100.0) needToStopRequests = YES;
        CLLocation* myLocation = [[CLLocation alloc] initWithLatitude:[[currentMasjid valueForKey:@"lat"] doubleValue] longitude:[[currentMasjid valueForKey:@"lng"] doubleValue]];
        PinAnnotation *marker = [PinAnnotation new];
        [marker setIsFromDB:NO];
        [marker setMasjidId:[currentMasjid valueForKey:@"masjid_id"]];
        marker.coordinate = myLocation.coordinate;
        marker.title = [currentMasjid valueForKey:@"masjid_name"] ;
        [self.nearMap addAnnotation:marker];
    }
    pageNumber+=1;
    [self getMasjids];
}

#pragma mark - Actions.

- (IBAction)popView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView;
    NSString *identifier;
    
    if ([annotation isKindOfClass:[PinAnnotation class]]) {
        // Pin annotation.
        identifier = @"Pin";
        annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
    } else if ([annotation isKindOfClass:[CalloutAnnotation class]]) {
        // Callout annotation.
        identifier = @"Callout";
        annotationView = (CalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[CalloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        CalloutAnnotation *calloutAnnotation = (CalloutAnnotation *)annotation;
        ((CalloutAnnotationView *)annotationView).delegate = self;
        [((CalloutAnnotationView *)annotationView).closeButton addTarget:self action:@selector(closeInfoWindow) forControlEvents:UIControlEventTouchUpInside];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(masjid_id == %@)" , calloutAnnotation.masjidId];
        NSDictionary *calloutInfo = [[masjids filteredArrayUsingPredicate:predicate] lastObject];
        [((CalloutAnnotationView *)annotationView).titleLabel setText:[calloutInfo valueForKey:@"masjid_name"]];
        [((CalloutAnnotationView *)annotationView).addressLabel setText:[calloutInfo valueForKey:@"masjid_add_1"]];
        [((CalloutAnnotationView *)annotationView).localAreaLabel setText:[calloutInfo valueForKey:@"masjid_local_area"]];
        [((CalloutAnnotationView *)annotationView).largerAreaLabel setText:[calloutInfo valueForKey:@"masjid_larger_area"]];
        [((CalloutAnnotationView *)annotationView).postCodeLabel setText:[calloutInfo valueForKey:@"masjid_post_code"]];
        [((CalloutAnnotationView *)annotationView).telephoneLabel setText:[calloutInfo valueForKey:@"masjid_telephone"]];
        [((CalloutAnnotationView *)annotationView).r1Label setText:[calloutInfo valueForKey:@"r1"]];
        [((CalloutAnnotationView *)annotationView).r2Label setText:[calloutInfo valueForKey:@"r2"]];
        [((CalloutAnnotationView *)annotationView).r3Label setText:[calloutInfo valueForKey:@"r3"]];
        [((CalloutAnnotationView *)annotationView).r4Label setText:[calloutInfo valueForKey:@"r4"]];
        float calloutheight = [((CalloutAnnotationView *)annotationView) updateFrame];

        if ([calloutInfo valueForKey:@"db_id"]) {
            Masjid *currentMasjid = [[MTDBHelper sharedDBHelper] getMasjidWithID:[calloutInfo valueForKey:@"db_id"]];
            [((CalloutAnnotationView *)annotationView) setMasjid:currentMasjid];
            [((CalloutAnnotationView *)annotationView).infoButton setHidden:NO];
        } else {
            [((CalloutAnnotationView *)annotationView) setMasjid:nil];
            [((CalloutAnnotationView *)annotationView).infoButton setHidden:YES];
        }
        
        [annotationView setNeedsDisplay];
        
        [annotationView setCenterOffset:CGPointMake(0, -(calloutheight/2 + 35))];
        // Move the display position of MapView.
        [UIView animateWithDuration:0.3f
                         animations:^(void) {
                             mapView.centerCoordinate = calloutAnnotation.coordinate;
                         }];
    }
    
    annotationView.annotation = annotation;
    
    return annotationView;
}

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
        // Selected the pin annotation.
        CalloutAnnotation *calloutAnnotation = [[CalloutAnnotation alloc] init];
        
        PinAnnotation *pinAnnotation = ((PinAnnotation *)view.annotation);
        calloutAnnotation.title = pinAnnotation.title;
        calloutAnnotation.coordinate = pinAnnotation.coordinate;
        pinAnnotation.calloutAnnotation = calloutAnnotation;
        calloutAnnotation.masjidId = pinAnnotation.masjidId;
        [mapView addAnnotation:calloutAnnotation];
    }
}

//---------------------------------------------------------------

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
        // Deselected the pin annotation.
        PinAnnotation *pinAnnotation = ((PinAnnotation *)view.annotation);
        
        [mapView removeAnnotation:pinAnnotation.calloutAnnotation];
        
        pinAnnotation.calloutAnnotation = nil;
    }
}

#pragma mark
#pragma mark Custom methods

//---------------------------------------------------------------

- (void)closeInfoWindow
{
    NSArray *selectedAnnotations = self.nearMap.selectedAnnotations;
    for(id annotation in selectedAnnotations) {
        [self.nearMap deselectAnnotation:annotation animated:NO];
    }
}

- (void)infoWindowCLickedFormasjid:(Masjid *)masjid
{
    if (masjid) {
        MasjidDetailView *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"masjidDetails"];
        [detailViewController setMasjid:masjid];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

- (float)infowindowHeightForMasjid:(Masjid *)masjid
{
    int infoCount = 0;
    
    if (masjid.name.length > 0) {
        infoCount += 1;
    }
    if (masjid.add_1.length > 0) {
        infoCount += 1;
    }
    if (masjid.localArea.length > 0) {
        infoCount += 1;
    }
    if (masjid.largerArea.length > 0) {
        infoCount += 1;
    }
    if (masjid.postCode.length > 0) {
        infoCount += 1;
    }
    if (masjid.telephone.length > 0) {
        infoCount += 1;
    }
    
    return infoCount * 24;
}

@end

