//
//  FreshlySettingsService.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FRSSettingsService.h"

#define kFRESHLY_SETTINGS_KEY_SELECTED_SECTION		@"selectedSection"
#define kFRESHLY_SETTINGS_KEY_STORAGE_SORTING		@"storageSorting"
#define kFRESHLY_SETTINGS_KEY_STORAGE_GROUPING		@"storageGrouping"
#define kFRESHLY_SETTINGS_KEY_SHOW_PURCHASE_DATE	@"showPurchaseDate"
#define kFRESHLY_SETTINGS_KEY_SHOW_EXPIRATION_DATE	@"showExpirationDate"
#define kFRESHLY_SETTINGS_KEY_SHOW_STORAGE_LOCATION	@"showStorageLocation"

@implementation FRSSettingsService

+ (FRSSettingsService *)sharedInstance
{
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init
{
	if (self = [super init]) {
		NSDictionary *defaultValues = @{
										kFRESHLY_SETTINGS_KEY_SELECTED_SECTION: @0,
										kFRESHLY_SETTINGS_KEY_STORAGE_SORTING: @0,
										kFRESHLY_SETTINGS_KEY_STORAGE_GROUPING: @0,
										kFRESHLY_SETTINGS_KEY_SHOW_PURCHASE_DATE: @YES,
										kFRESHLY_SETTINGS_KEY_SHOW_EXPIRATION_DATE: @YES,
										kFRESHLY_SETTINGS_KEY_SHOW_STORAGE_LOCATION: @YES
										};
		[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	}
	return self;
}

- (NSInteger)selectedSection
{
	return [self integerForKey:kFRESHLY_SETTINGS_KEY_SELECTED_SECTION];
}

- (void)setSelectedSection:(NSInteger)selectedSection
{
	[self setInteger:selectedSection forKey:kFRESHLY_SETTINGS_KEY_SELECTED_SECTION];
}

- (NSInteger)storageSorting
{
	return [self integerForKey:kFRESHLY_SETTINGS_KEY_STORAGE_SORTING];
}

- (void)setStorageSorting:(NSInteger)storageSorting
{
	if (self.storageSorting != storageSorting) {
		[self setInteger:storageSorting forKey:kFRESHLY_SETTINGS_KEY_STORAGE_SORTING];
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORAGE_SETTINGS_UPDATED object:nil];
	}
}

- (NSInteger)storageGrouping
{
	return [self integerForKey:kFRESHLY_SETTINGS_KEY_STORAGE_GROUPING];
}

- (void)setStorageGrouping:(NSInteger)storageGrouping
{
	if (self.storageGrouping != storageGrouping) {
		[self setInteger:storageGrouping forKey:kFRESHLY_SETTINGS_KEY_STORAGE_GROUPING];
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORAGE_SETTINGS_UPDATED object:nil];
	}
}

- (BOOL)showPurchaseDate
{
	return [self boolForKey:kFRESHLY_SETTINGS_KEY_SHOW_PURCHASE_DATE];
}

- (void)setShowPurchaseDate:(BOOL)showPurchaseDate
{
	if (self.showPurchaseDate != showPurchaseDate) {
		[self setBool:showPurchaseDate forKey:kFRESHLY_SETTINGS_KEY_SHOW_PURCHASE_DATE];
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORAGE_SETTINGS_UPDATED object:nil];
	}
}

- (BOOL)showExpirationDate
{
	return [self boolForKey:kFRESHLY_SETTINGS_KEY_SHOW_EXPIRATION_DATE];
}

- (void)setShowExpirationDate:(BOOL)showExpirationDate
{
	if (self.showExpirationDate != showExpirationDate) {
		[self setBool:showExpirationDate forKey:kFRESHLY_SETTINGS_KEY_SHOW_EXPIRATION_DATE];
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORAGE_SETTINGS_UPDATED object:nil];
	}
}

- (BOOL)showStorageLocation
{
	return [self boolForKey:kFRESHLY_SETTINGS_KEY_SHOW_STORAGE_LOCATION];
}

- (void)setShowStorageLocation:(BOOL)showStorageLocation
{
	if (self.showStorageLocation != showStorageLocation) {
		[self setBool:showStorageLocation forKey:kFRESHLY_SETTINGS_KEY_SHOW_STORAGE_LOCATION];
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_STORAGE_SETTINGS_UPDATED object:nil];
	}
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

- (void)setBool:(BOOL)boolean forKey:(NSString *)key
{
	[[NSUserDefaults standardUserDefaults] setBool:boolean forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)boolForKey:(NSString*)key
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

@end
