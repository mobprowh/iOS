//  MKPersianFont.m
//
//  Created by Lentrica Software - © 2015
//  Copyright Lentrica Software - © 2015. All rights reserved.
//

#import "MKPersianFont.h"

@implementation MKPersianFont

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setPersianFont:(NSString *)font  withText:(NSString *)text  fontSize:(int)size textAlignment:(NSString *)alignment textWrapped:(BOOL)isWrapped fontColor:(UIColor*)color
{
    NSString *fontName = font;
    CTFontRef persianFont = [self PersianFontWithName:fontName
                                          ofType:@"ttf" 
                                      attributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:16.f] 
                                                                             forKey:(NSString *)kCTFontSizeAttribute]];
    persianFontLayer = [[CATextLayer alloc] init];
    persianFontLayer.font = persianFont;
    persianFontLayer.string = text ; 
    persianFontLayer.wrapped = isWrapped;
    [persianFontLayer setForegroundColor:[color CGColor]];
    persianFontLayer.fontSize = size;
    persianFontLayer.alignmentMode = alignment;
    persianFontLayer.contentsScale = [[UIScreen mainScreen] scale];
    persianFontLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    [self.layer addSublayer:persianFontLayer];
}

- (void)setFrame:(CGRect)frame
{
    persianFontLayer.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width , frame.size.height);
}

- (CTFontRef)PersianFontWithName:(NSString *)fontName ofType:(NSString *)type attributes:(NSDictionary *)attributes {
    NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:type];
    NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
    CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((__bridge_retained CFDataRef)data);
    CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
    CGDataProviderRelease(fontProvider);
    CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((__bridge_retained CFDictionaryRef)attributes);
    CTFontRef font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
    CFRelease(fontDescriptor);
    CGFontRelease(cgFont);
    return font;
}

@end
