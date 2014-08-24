//
//  UIFont+FreshlyAdditions.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "UIFont+FreshlyAdditions.h"

@implementation UIFont (FreshlyAdditions)

+ (UIFont*)freshlyFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"AvenirNext-Regular" size:size];
}

+ (UIFont*)boldFreshlyFontOfSize:(CGFloat)size
{
	return [UIFont fontWithName:@"AvenirNext-DemiBold" size:size];
}

@end
