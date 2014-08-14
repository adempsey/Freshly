//
//  FreshlyConstants.h
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#ifndef Freshly_FreshlyConstants_h
#define Freshly_FreshlyConstants_h

/************** Spaces **************/

#define FRESHLY_SPACE_STORAGE		@"Storage"
#define FRESHLY_SPACE_SHOPPING_LIST @"Shopping List"

/************** Colors **************/

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR_PRIMARY UIColorFromRGB(0xF6F5EE)
#define COLOR_SECONDARY UIColorFromRGB(0xE6E5DD)
#define COLOR_DARK UIColorFromRGB(0x666666)
#define COLOR_LIGHT UIColorFromRGB(0xFFFFFA)
#define COLOR_GREEN_MAIN UIColorFromRGB(0x6CB758)
#define FCOLOR_RED UIColorFromRGB(0xF34D49)

#define COLOR_DAIRY UIColorFromRGB(0xF1C94D)
#define COLOR_DRINK UIColorFromRGB(0x824D98)
#define COLOR_FRUIT UIColorFromRGB(0xA0Cb57)
#define COLOR_MEAT UIColorFromRGB(0xF1813B)
#define COLOR_MISC UIColorFromRGB(0x605F61)
#define COLOR_SEAFOOD UIColorFromRGB(0xB0E9)
#define COLOR_VEGETABLE UIColorFromRGB(0x36B45B)

#define COLOR_WHITISH UIColorFromRGB(0xF6F8F7)
#define COLOR_DARK_GREY UIColorFromRGB(0x444444)
#define COLOR_LIGHT_GREY UIColorFromRGB(0xCCCCCC)

/************** Notifications **************/

#define NOTIFICATION_ITEM_UPDATED @"notificationItemUpdated"

#endif
