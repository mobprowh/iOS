//  MKPersianFont.h
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#define CENTER kCAAlignmentCenter
#define RIGHT kCAAlignmentRight
#define LEFT kCAAlignmentLeft

@interface MKPersianFont : UIView
{
    @private  CATextLayer *persianFontLayer;
}

- (void)setPersianFont:(NSString *)font  withText:(NSString *)text  fontSize:(int)size textAlignment:(NSString *)alignment textWrapped:(BOOL)isWrapped fontColor:(UIColor*)color ;
- (void)setFrame:(CGRect)frame;

@end
