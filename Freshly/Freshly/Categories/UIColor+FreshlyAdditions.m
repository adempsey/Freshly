//
//  UIColor+FreshlyAdditions.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/2/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "UIColor+FreshlyAdditions.h"

@implementation UIColor (FreshlyAdditions)

#pragma mark - System Colors

+ (UIColor *)freshly_primaryGreen
{
    return [UIColor colorWithRGBHexCode:0x4AA85F];
}

+ (UIColor *)freshly_lightGreen
{
    return [UIColor colorWithRGBHexCode:0xEFFFFE];
}

+ (UIColor *)freshly_backgroundColor
{
    return [UIColor colorWithRGBHexCode:0xEDF2F4];
}

+ (UIColor *)freshly_whiteColor
{
    return [UIColor colorWithRGBHexCode:0xFFFFFF];
}

+ (UIColor *)freshly_darkGrayColor
{
    return [UIColor colorWithRGBHexCode:0x646464];
}

#pragma mark - Food Category Colors

+ (UIColor *)freshly_alcoholColor
{
    return [UIColor colorWithRGBHexCode:0xB55085];
}

+ (UIColor *)freshly_dairyColor
{
    return [UIColor colorWithRGBHexCode:0xDED362];
}

+ (UIColor *)freshly_defaultColor
{
    return [UIColor freshly_darkGrayColor];
}

+ (UIColor *)freshly_drinkColor
{
    return [UIColor colorWithRGBHexCode:0x684A97];
}

+ (UIColor *)freshly_fruitColor
{
    return [UIColor colorWithRGBHexCode:0xB1D15C];
}

+ (UIColor *)freshly_grainColor
{
    return [UIColor colorWithRGBHexCode:0xDEA962];
}

+ (UIColor *)freshly_proteinColor
{
    return [UIColor colorWithRGBHexCode:0xDE6E62];
}

+ (UIColor *)freshly_seafoodColor
{
    return [UIColor colorWithRGBHexCode:0x3F7C8A];
}

+ (UIColor *)freshly_vegetableColor
{
    return [UIColor freshly_primaryGreen];
}

#pragma mark - Private Helper Methods

+ (UIColor *)colorWithRGBHexCode:(uint32_t)code
{
    float r = ((float) ((code & 0xFF0000) >> 16)) / 255.0;
    float g = ((float) ((code & 0x00FF00) >> 8)) / 255.0;
    float b = ((float) ((code & 0x0000FF))) / 255.0;

    return [UIColor colorWithRed:r
                           green:g
                            blue:b
                           alpha:1.0];
}

@end
