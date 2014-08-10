//
//  FreshlyImageService.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyImageService.h"

@implementation FreshlyImageService

+ (FreshlyImageService*)sharedInstance
{
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (id)init
{
	if (self = [super init]) {
		
	}
	return self;
}

- (UIImage*)retrieveImageForCategory:(NSString *)category withSize:(NSUInteger)size
{
	return [UIImage imageNamed:[NSString stringWithFormat:@"%@ %dx%d", category, size, size]];
}

@end
