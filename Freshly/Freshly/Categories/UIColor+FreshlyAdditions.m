//
//  UIColor+FreshlyAdditions.m
//  Freshly
//
//  Created by Andrew Dempsey on 5/2/17.
//  Copyright © 2017 Andrew Dempsey. All rights reserved.
//

#import "UIColor+FreshlyAdditions.h"

@implementation UIColor (FreshlyAdditions)

+ (UIColor *)freshly_primaryGreen
{
    return [UIColor colorWithRed:50.0/255.0
                           green:179.0/255.0
                            blue:101.0/255.0
                           alpha:1.0];
}

+ (UIColor *)freshly_lightGreen
{
    return [UIColor colorWithRed:240.0/255.0
                           green:248.0/255.0
                            blue:245.0/255.0
                           alpha:1.0];
}

+ (UIColor *)freshly_backgroundColor
{
    return [UIColor colorWithRed:237.0/255.0
                           green:242.0/255.0
                            blue:244.0/255.0
                           alpha:1.0];
}

+ (UIColor *)freshly_whiteColor
{
    return [UIColor colorWithRed:255.0/255.0
                           green:255.0/255.0
                            blue:255.0/255.0
                           alpha:1.0];
}

+ (UIColor *)freshly_darkGrayColor
{
    return [UIColor colorWithWhite:100.0/255.0
                             alpha:1.0];
}

@end
