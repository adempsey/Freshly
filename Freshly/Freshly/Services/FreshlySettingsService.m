//
//  FreshlySettingsService.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlySettingsService.h"

#define kFRESHLY_SETTINGS_KEY_SELECTED_SECTION @"selectedSection"

@implementation FreshlySettingsService

+ (FreshlySettingsService*)sharedInstance
{
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (NSInteger)selectedSection
{
	return [self integerForKey:kFRESHLY_SETTINGS_KEY_SELECTED_SECTION];
}

- (void)setSelectedSection:(NSInteger)selectedSection
{
	[self setInteger:selectedSection forKey:kFRESHLY_SETTINGS_KEY_SELECTED_SECTION];
}

#pragma mark - User Defaults Accessors

- (void)setInteger:(NSInteger)integer forKey:(NSString*)key
{
	[[NSUserDefaults standardUserDefaults] setInteger:integer forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)integerForKey:(NSString*)key
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

@end
