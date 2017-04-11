//
//  Constants.h
//  Masjid Timetable
//
//  Created by Ivan Kulyk on 9/23/16.
//  Copyright © 2016 Lentrica Software. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define dDeviceOrientation [[UIDevice currentDevice] orientation]
#define isPortrait  UIDeviceOrientationIsPortrait(dDeviceOrientation)
#define isLandscape UIDeviceOrientationIsLandscape(dDeviceOrientation)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define Appdelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IOS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IOS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IOS_10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 736.0)
#define IS_PORTRAIT (UIDeviceOrientationIsPortrait(self.interfaceOrientation))
#define ScreenSizeWidth (( double )[ [ UIScreen mainScreen ] bounds ].size.width)
#define ScreenSizeHeight (( double )[ [ UIScreen mainScreen ] bounds ].size.height)
#define NULL_TO_NIL(obj)        ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })
#define AppGroupsID @"group.com.lentricasoftware.masjid"

#endif /* Constants_h */
