//
//  MDRadialProgressLabel.h
//  MDRadialProgress
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

@class MDRadialProgressTheme;

@interface MDRadialProgressLabel : UILabel

- (id)initWithFrame:(CGRect)frame andTheme:(MDRadialProgressTheme *)theme;

// If adjustFontSizeToFitBounds is enabled, limit the size of the font to the bounds'width * pointSizeToWidthFactor.
@property (assign, nonatomic) CGFloat pointSizeToWidthFactor;

// Whether the algorithm to autoscale the font size is enabled or not.
@property (assign, nonatomic) BOOL adjustFontSizeToFitBounds;

@end
