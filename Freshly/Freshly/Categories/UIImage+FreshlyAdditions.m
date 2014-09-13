//
//  UIImage+FreshlyAdditions.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/9/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "UIImage+FreshlyAdditions.h"

@implementation UIImage (FreshlyAdditions)

+ (UIImage*)imageForCategory:(NSString *)category withSize:(NSUInteger)size
{
	return [UIImage imageNamed:[NSString stringWithFormat:@"%@ %lux%lu", category.lowercaseString, (unsigned long)size, (unsigned long)size]];
}

@end
