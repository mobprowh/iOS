//
//  LearningCenterTextField.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 5/15/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import "LearningCenterTextField.h"

@implementation LearningCenterTextField

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect originalRect = [super clearButtonRectForBounds:bounds];
    return CGRectOffset(originalRect, -6, 0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    if (IS_IPAD) {
        return CGRectInset(bounds, 50, 0);
    }
    return CGRectInset(bounds, 15, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    if (IS_IPAD) {
        return CGRectInset(bounds, 50, 0);
    }
    return CGRectInset(bounds, 15, 0);
}

@end
