//
//  FreshlyConstants.h
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#ifndef Freshly_FreshlyConstants_h
#define Freshly_FreshlyConstants_h

typedef NS_ENUM(NSInteger, FreshlySpaces) {
	FreshlySpaceRefrigerator = 0,
	FreshlySpaceFreezer,
	FreshlySpacePantry,
	FreshlySpaceCount
};

/************** Strings **************/

#define FRESHLY_SECTION_STORAGE			@"Storage"
#define FRESHLY_SECTION_SHOPPING_LIST	@"Shopping List"

#define FRESHLY_SPACE_REFRIGERATOR	@"Refrigerator"
#define FRESHLY_SPACE_FREEZER		@"Freezer"
#define FRESHLY_SPACE_PANTRY		@"Pantry"

#define FRESHLY_CATEGORY_DAIRY		@"Dairy"
#define FRESHLY_CATEGORY_DRINK		@"Drink"
#define FRESHLY_CATEGORY_FRUIT		@"Fruit"
#define FRESHLY_CATEGORY_GRAIN		@"Grain"
#define FRESHLY_CATEGORY_MEAT		@"Meat"
#define FRESHLY_CATEGORY_MISC		@"Misc"
#define FRESHLY_CATEGORY_SEAFOOD	@"Seafood"
#define FRESHLY_CATEGORY_VEGETABLE	@"Vegetable"

#define FRESHLY_ITEM_ATTRIBUTE_NAME				@"name"
#define FRESHLY_ITEM_ATTRIBUTE_CATEGORY			@"category"
#define FRESHLY_ITEM_ATTRIBUTE_SPACE			@"space"
#define FRESHLY_ITEM_ATTRIBUTE_IN_STORAGE		@"inStorage"
#define FRESHLY_ITEM_ATTRIBUTE_BRAND			@"brand"
#define FRESHLY_ITEM_ATTRIBUTE_PURCHASE_DATE	@"dateOfPurchase"
#define FRESHLY_ITEM_ATTRIBUTE_EXPIRATION_DATE	@"dateOfExpiration"

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

#define FRESHLY_COLOR_SELECTED UIColorFromRGB(0xC7F9DE)

#define FRESHLY_CATEGORY_COLOR_DAIRY UIColorFromRGB(0xF1C94D)
#define FRESHLY_CATEGORY_COLOR_DRINK UIColorFromRGB(0x824D98)
#define FRESHLY_CATEGORY_COLOR_FRUIT UIColorFromRGB(0xA0Cb57)
#define FRESHLY_CATEGORY_COLOR_GRAIN UIColorFromRGB(0xD6C086)
#define FRESHLY_CATEGORY_COLOR_MEAT UIColorFromRGB(0xF1813B)
#define FRESHLY_CATEGORY_COLOR_MISC UIColorFromRGB(0x605F61)
#define FRESHLY_CATEGORY_COLOR_SEAFOOD UIColorFromRGB(0xB0E9)
#define FRESHLY_CATEGORY_COLOR_VEGETABLE UIColorFromRGB(0x36B45B)

#define COLOR_WHITISH UIColorFromRGB(0xF6F8F7)
#define COLOR_DARK_GREY UIColorFromRGB(0x444444)
#define COLOR_LIGHT_GREY UIColorFromRGB(0xCCCCCC)

/************** Notifications **************/

#define NOTIFICATION_ITEM_UPDATED	@"notificationItemUpdated"
#define NOTIFICATION_STORAGE_SETTINGS_UPDATED	@"notificationStorageSettingsUpdated"

#endif
