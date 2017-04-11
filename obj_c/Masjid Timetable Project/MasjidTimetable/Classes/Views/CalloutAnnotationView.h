//
//  CalloutAnnotationView.h
//  CustomCalloutSample
//
//  Created by tochi on 11/05/17.
//  Copyright 2011 aguuu,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol CalloutAnnotationViewDelegate;
@interface CalloutAnnotationView : MKAnnotationView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *localAreaLabel;
@property (nonatomic, strong) UILabel *largerAreaLabel;
@property (nonatomic, strong) UILabel *postCodeLabel;
@property (nonatomic, strong) UILabel *telephoneLabel;
@property (nonatomic, strong) UILabel *r1Label;
@property (nonatomic, strong) UILabel *r2Label;
@property (nonatomic, strong) UILabel *r3Label;
@property (nonatomic, strong) UILabel *r4Label;
@property (nonatomic, strong) UIButton *infoWindowButton;
@property (nonatomic, strong) Masjid *masjid;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *infoButton;
- (float)updateFrame;

@property (nonatomic, assign) id<CalloutAnnotationViewDelegate> delegate;
@end

@protocol CalloutAnnotationViewDelegate
@required
- (void)infoWindowCLickedFormasjid:(Masjid *)masjid;
@end
