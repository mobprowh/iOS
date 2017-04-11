//
//  CalloutAnnotationView.m
//  CustomCalloutSample
//
//  Created by tochi on 11/05/17.
//  Copyright 2011 aguuu,Inc. All rights reserved.
//

#import "CalloutAnnotationView.h"
#import "CalloutAnnotation.h"

@implementation CalloutAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
  
  if (self) {
      self.frame = CGRectMake(0.0f, 0.0f, 180, 223);
      self.backgroundColor = [UIColor whiteColor];
      self.clipsToBounds = YES;
      self.layer.cornerRadius = 15.0;
    
      _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 145.0, 50.0)];
      self.titleLabel.textColor = [UIColor blackColor];
      self.titleLabel.textAlignment = NSTextAlignmentLeft;
      self.titleLabel.font = [UIFont boldSystemFontOfSize:13];
      [_titleLabel setNumberOfLines:0];
      [self addSubview:self.titleLabel];
    
      _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 45.0, 145.0, 17.0)];
      self.addressLabel.textColor = [UIColor blackColor];
      self.addressLabel.textAlignment = NSTextAlignmentLeft;
      self.addressLabel.font = [UIFont systemFontOfSize:12];
      [self.addressLabel setNumberOfLines:0];
      [self addSubview:self.addressLabel];
      
      _localAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 67.0, 145.0, 17.0)];
      self.localAreaLabel.textColor = [UIColor blackColor];
      self.localAreaLabel.textAlignment = NSTextAlignmentLeft;
      self.localAreaLabel.font = [UIFont systemFontOfSize:12];
      [self.localAreaLabel setNumberOfLines:0];
      [self addSubview:self.localAreaLabel];
      
      _largerAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 99.0, 145.0, 17.0)];
      self.largerAreaLabel.textColor = [UIColor blackColor];
      self.largerAreaLabel.textAlignment = NSTextAlignmentLeft;
      self.largerAreaLabel.font = [UIFont systemFontOfSize:12];
      [self.largerAreaLabel setNumberOfLines:0];
      [self addSubview:self.largerAreaLabel];
      
      _postCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 111.0, 145.0, 17.0)];
      self.postCodeLabel.textColor = [UIColor blackColor];
      self.postCodeLabel.textAlignment = NSTextAlignmentLeft;
      self.postCodeLabel.font = [UIFont systemFontOfSize:12];
      [self.postCodeLabel setNumberOfLines:0];
      [self addSubview:self.postCodeLabel];
      
      _telephoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 133.0, 145.0, 17.0)];
      self.telephoneLabel.textColor = [UIColor blackColor];
      self.telephoneLabel.textAlignment = NSTextAlignmentLeft;
      self.telephoneLabel.font = [UIFont systemFontOfSize:12];
      [self.telephoneLabel setNumberOfLines:0];
      [self addSubview:self.telephoneLabel];
      
      _r1Label = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 155.0, 145.0, 17.0)];
      self.r1Label.textColor = [UIColor blackColor];
      self.r1Label.textAlignment = NSTextAlignmentLeft;
      self.r1Label.font = [UIFont systemFontOfSize:12];
      [self.r1Label setNumberOfLines:0];
      [self addSubview:self.r1Label];
      
      _r2Label = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 177.0, 145.0, 17.0)];
      self.r2Label.textColor = [UIColor blackColor];
      self.r2Label.textAlignment = NSTextAlignmentLeft;
      self.r2Label.font = [UIFont systemFontOfSize:12];
      [self.r2Label setNumberOfLines:0];
      [self addSubview:self.r2Label];
      
      _r3Label = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 199.0, 145.0, 17.0)];
      self.r3Label.textColor = [UIColor blackColor];
      self.r3Label.textAlignment = NSTextAlignmentLeft;
      self.r3Label.font = [UIFont systemFontOfSize:12];
      [self.r3Label setNumberOfLines:0];
      [self addSubview:self.r3Label];
      
      _r4Label = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 221.0, 145.0, 17.0)];
      self.r4Label.textColor = [UIColor blackColor];
      self.r4Label.textAlignment = NSTextAlignmentLeft;
      self.r4Label.font = [UIFont systemFontOfSize:12];
      [self.r4Label setNumberOfLines:0];

      [self addSubview:self.r4Label];
      
      _infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
      [_infoButton setFrame:CGRectMake(153.0, self.frame.size.height - 25, 20, 20)];
      [self addSubview:_infoButton];
      
      self.infoWindowButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_infoWindowButton setFrame:self.frame];
      [self.infoWindowButton addTarget:self action:@selector(infoWindowCLicked) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:self.infoWindowButton];
      
      self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [self.closeButton setFrame:CGRectMake(self.frame.size.width - 30, 0, 30, 30)];
      [self.closeButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
      [self.closeButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
      [self addSubview:self.closeButton];
  }
  return self;
}


-(void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
}

- (float)updateFrame
{
    CGSize constraintSizeOfTitle = CGSizeMake(self.titleLabel.frame.size.width, MAXFLOAT);
    CGSize constraintSizeOfOthers = CGSizeMake(self.addressLabel.frame.size.width, MAXFLOAT);

    if (self.titleLabel.text.length > 0) {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:13.0]}];
    CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfTitle
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
     self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, rect.size.height);

    } else {
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, 0);
    }
    
    if (self.addressLabel.text.length > 0) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.addressLabel.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfOthers
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.addressLabel.frame = CGRectMake(self.addressLabel.frame.origin.x, self.titleLabel.frame.origin.y +  self.titleLabel.frame.size.height + 3, self.addressLabel.frame.size.width, rect.size.height);
    } else {
        self.addressLabel.frame = CGRectMake(self.addressLabel.frame.origin.x, self.titleLabel.frame.origin.y +  self.titleLabel.frame.size.height, self.addressLabel.frame.size.width, 0);
    }
    if (self.localAreaLabel.text.length > 0) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.localAreaLabel.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfOthers
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.localAreaLabel.frame = CGRectMake(self.localAreaLabel.frame.origin.x, self.addressLabel.frame.origin.y + self.addressLabel.frame.size.height + 3, self.localAreaLabel.frame.size.width, rect.size.height);
    } else {
        self.localAreaLabel.frame = CGRectMake(self.localAreaLabel.frame.origin.x, self.addressLabel.frame.origin.y + self.addressLabel.frame.size.height, self.localAreaLabel.frame.size.width, 0);
    }
    if (self.largerAreaLabel.text.length > 0) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.largerAreaLabel.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfOthers
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.largerAreaLabel.frame = CGRectMake(self.largerAreaLabel.frame.origin.x, self.localAreaLabel.frame.origin.y + self.localAreaLabel.frame.size.height + 3, self.largerAreaLabel.frame.size.width, rect.size.height);
    } else {
        self.largerAreaLabel.frame = CGRectMake(self.largerAreaLabel.frame.origin.x, self.localAreaLabel.frame.origin.y + self.localAreaLabel.frame.size.height, self.largerAreaLabel.frame.size.width, 0);
    }
    
    if (self.postCodeLabel.text.length > 0) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.postCodeLabel.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfOthers
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.postCodeLabel.frame = CGRectMake(self.postCodeLabel.frame.origin.x, self.largerAreaLabel.frame.origin.y + self.largerAreaLabel.frame.size.height + 3, self.postCodeLabel.frame.size.width, rect.size.height);
    } else {
        self.postCodeLabel.frame = CGRectMake(self.postCodeLabel.frame.origin.x, self.largerAreaLabel.frame.origin.y + self.largerAreaLabel.frame.size.height, self.postCodeLabel.frame.size.width, 0);
    }
    
    if (self.telephoneLabel.text.length > 0) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.telephoneLabel.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfOthers
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.telephoneLabel.frame = CGRectMake(self.telephoneLabel.frame.origin.x, self.postCodeLabel.frame.origin.y + self.postCodeLabel.frame.size.height + 3, self.telephoneLabel.frame.size.width, rect.size.height);
    } else {
        self.telephoneLabel.frame = CGRectMake(self.telephoneLabel.frame.origin.x, self.postCodeLabel.frame.origin.y + self.postCodeLabel.frame.size.height, self.telephoneLabel.frame.size.width, 0);
    }
    
    if (self.r1Label.text.length > 0) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.r1Label.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfOthers
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.r1Label.frame = CGRectMake(self.r1Label.frame.origin.x, self.telephoneLabel.frame.origin.y + self.telephoneLabel.frame.size.height + 3, self.r1Label.frame.size.width, rect.size.height);
    } else {
        self.r1Label.frame = CGRectMake(self.r1Label.frame.origin.x, self.telephoneLabel.frame.origin.y + self.telephoneLabel.frame.size.height, self.r1Label.frame.size.width, 0);
    }
    
    if (self.r2Label.text.length > 0) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.r2Label.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfOthers
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.r2Label.frame = CGRectMake(self.r2Label.frame.origin.x, self.r1Label.frame.origin.y + self.r1Label.frame.size.height + 3, self.r2Label.frame.size.width, rect.size.height);
    } else {
        self.r2Label.frame = CGRectMake(self.r2Label.frame.origin.x, self.r1Label.frame.origin.y + self.r1Label.frame.size.height, self.r2Label.frame.size.width, 0);
    }
    
    if (self.r3Label.text.length > 0) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.r3Label.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfOthers
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.r3Label.frame = CGRectMake(self.r3Label.frame.origin.x, self.r2Label.frame.origin.y + self.r2Label.frame.size.height + 3, self.r3Label.frame.size.width, rect.size.height);
    } else {
        self.r3Label.frame = CGRectMake(self.r3Label.frame.origin.x, self.r2Label.frame.origin.y + self.r2Label.frame.size.height, self.r3Label.frame.size.width, 0);
    }
    
    if (self.r4Label.text.length > 0) {
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.r4Label.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]}];
        CGRect rect = [attributedText boundingRectWithSize:constraintSizeOfOthers
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        self.r4Label.frame = CGRectMake(self.r4Label.frame.origin.x, self.r3Label.frame.origin.y + self.r3Label.frame.size.height + 3, self.r4Label.frame.size.width, rect.size.height);
    } else {
        self.r4Label.frame = CGRectMake(self.r4Label.frame.origin.x, self.r3Label.frame.origin.y + self.r3Label.frame.size.height, self.r4Label.frame.size.width, 0);
    }
    

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,self.r4Label.frame.origin.y + self.r4Label.frame.size.height+ 5);
    [_infoButton setFrame:CGRectMake(153.0, self.frame.size.height - 25, 20, 20)];
    
    return self.frame.size.height;
}

#pragma mark - Button clicked

- (void)infoWindowCLicked
{
    [self.delegate infoWindowCLickedFormasjid:self.masjid];
}


@end
