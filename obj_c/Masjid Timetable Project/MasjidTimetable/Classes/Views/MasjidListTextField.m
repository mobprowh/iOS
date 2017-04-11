//
//  MasjidListTextField.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 2/15/15.
//  Copyright (c) 2015 Lentrica Sotware. All rights reserved.
//

#import "MasjidListTextField.h"

@implementation MasjidListTextField

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect originalRect = [super clearButtonRectForBounds:bounds];
    return CGRectOffset(originalRect, -6, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (IS_IPAD) {
        return CGRectInset(bounds, 50, 0);
    }
    return CGRectInset(bounds, 30, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (IS_IPAD) {
        return CGRectInset(bounds, 50, 0);
    }
    return CGRectInset(bounds, 30, 0);
}

@end
