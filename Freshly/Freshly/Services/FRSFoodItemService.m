//
//  FreshlyFoodItemService.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FRSAppDelegate.h"
#import "FRSFoodItemService.h"

#import "UIColor+FreshlyAdditions.h"

#define kFoodItemEntityName @"FreshlyFoodItem"
#define kCustomUserFoodSourcesFileName @"userFoodSources.json"

@interface FRSFoodItemService ()

@property (nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation FRSFoodItemService

+ (FRSFoodItemService*)sharedInstance
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
		FRSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		self.managedObjectContext = appDelegate.managedObjectContext;
	}
	return self;
}

#pragma mark - Helper Methods

- (NSArray*)foodItemCategoryList
{
	return @[FRESHLY_CATEGORY_DAIRY,
			 FRESHLY_CATEGORY_DRINK,
			 FRESHLY_CATEGORY_FRUIT,
			 FRESHLY_CATEGORY_GRAIN,
			 FRESHLY_CATEGORY_MISC,
			 FRESHLY_CATEGORY_PROTEIN,
			 FRESHLY_CATEGORY_SEAFOOD,
			 FRESHLY_CATEGORY_VEGETABLE];
}

- (UIColor*)colorForCategory:(NSString*)category
{	
	if ([category isEqualToString:FRESHLY_CATEGORY_DAIRY]) {
		return [UIColor freshly_dairyColor];
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_DRINK]) {
		return [UIColor freshly_drinkColor];
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_FRUIT]) {
		return [UIColor freshly_fruitColor];
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_GRAIN]) {
		return [UIColor freshly_grainColor];
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_PROTEIN]) {
		return [UIColor freshly_proteinColor];
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_SEAFOOD]) {
		return [UIColor freshly_seafoodColor];
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_VEGETABLE]) {
		return [UIColor freshly_vegetableColor];
		
	}
	
	return [UIColor freshly_defaultColor];
}

- (NSString*)defaultCategoryForFoodItemName:(NSString*)itemName
{
	NSString *category = self.userFoodSources[itemName][FRESHLY_ITEM_ATTRIBUTE_CATEGORY];

	if (!category) {
		return self.defaultFoodItemData[itemName][FRESHLY_ITEM_ATTRIBUTE_CATEGORY] ? : FRESHLY_CATEGORY_MISC;
	}

	return category;
}

- (NSString*)defaultSpaceForFoodItemName:(NSString *)itemName
{
	itemName = itemName.lowercaseString;

	NSString *space = self.userFoodSources[itemName][FRESHLY_ITEM_ATTRIBUTE_SPACE];

	if (!space) {
		space = self.defaultFoodItemData[itemName][FRESHLY_ITEM_ATTRIBUTE_SPACE];
	}
	// this is dumb - should just convert short spaces to full in json
	if (!space || [space isEqualToString:@"r"]) {
		return FRESHLY_SPACE_REFRIGERATOR;

	} else if ([space isEqualToString:@"f"]) {
		return FRESHLY_SPACE_FREEZER;

	} else if ([space isEqualToString:@"p"]) {
		return FRESHLY_SPACE_PANTRY;
	}

	return nil;
}

- (NSInteger)defaultExpirationTimeForFoodItemName:(NSString *)itemName inSpace:(NSString*)space
{

	itemName = itemName.lowercaseString;

	NSString *shortSpace;
	// this is dumb - should just convert short spaces to full in json
	if ([space isEqualToString:FRESHLY_SPACE_REFRIGERATOR]) {
		shortSpace = @"r";
	} else if ([space isEqualToString:FRESHLY_SPACE_FREEZER]) {
		shortSpace = @"f";
	} else if ([space isEqualToString:FRESHLY_SPACE_PANTRY]) {
		shortSpace = @"p";
	} else {
		return -1;
	}

	NSString *timeString = self.userFoodSources[itemName][@"exp"][shortSpace];

	if (!timeString) {
		timeString = self.defaultFoodItemData[itemName][@"exp"][shortSpace];
	}

	// by default, we'll just return two weeks.
	if (!timeString) {
		return 14;

	} else if ([timeString isEqualToString:FRESHLY_ITEM_EXPIRATION_DATE_INFINITE]) {
		return -1;
	}

	return timeString.integerValue;
}

- (NSString*)titleForSpaceIndex:(NSInteger)number
{
	switch (number) {
		case FreshlySpaceRefrigerator:
			return FRESHLY_SPACE_REFRIGERATOR;
			break;
		case FreshlySpaceFreezer:
			return FRESHLY_SPACE_FREEZER;
			break;
		case FreshlySpacePantry:
			return FRESHLY_SPACE_PANTRY;
			break;
		default:
			return @"";
			break;
	}
}

- (NSInteger)spaceIndexForTitle:(NSString*)title
{
	if ([title isEqualToString:FRESHLY_SPACE_REFRIGERATOR]) {
		return 0;
	} else if ([title isEqualToString:FRESHLY_SPACE_FREEZER]) {
		return 1;
	} else {
		return 2;
	}
}

- (NSDictionary*)defaultExpirationTimesForItemInCategory:(NSString*)category
{
	if ([category isEqualToString:FRESHLY_CATEGORY_DAIRY]) {
		return @{@"r": @"14", @"f": @"168", @"p": @"1"};

	} else if ([category isEqualToString:FRESHLY_CATEGORY_DRINK]) {
		return @{@"r": @"31", @"f": @"365", @"p": @"31"};

	} else if ([category isEqualToString:FRESHLY_CATEGORY_FRUIT]) {
		return @{@"r": @"14", @"f": @"168", @"p": @"7"};

	} else if ([category isEqualToString:FRESHLY_CATEGORY_GRAIN]) {
		return @{@"r": @"1", @"f": @"365", @"p": @"7"};

	} else if ([category isEqualToString:FRESHLY_CATEGORY_MISC]) {
		return @{@"r": @"7", @"f": @"365", @"p": @"7"};

	} else if ([category isEqualToString:FRESHLY_CATEGORY_PROTEIN]) {
		return @{@"r": @"7", @"f": @"365", @"p": @"0"};

	} else if ([category isEqualToString:FRESHLY_CATEGORY_SEAFOOD]) {
		return @{@"r": @"7", @"f": @"62", @"p": @"0"};

	} else if ([category isEqualToString:FRESHLY_CATEGORY_VEGETABLE]) {
		return @{@"r": @"14", @"f": @"365", @"p": @"14"};

	}

	return @{@"r": @"14", @"f": @"365", @"p": @"7"};
}

#pragma mark - Static Food Sources

- (void)createUserFoodSources
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];

	NSString *fileName = [NSString stringWithFormat:@"%@/%@",documentsDirectory, kCustomUserFoodSourcesFileName];
	NSString *content = @"{}";
	[content writeToFile:fileName atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

- (NSString*)userFoodSourcesFilePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, kCustomUserFoodSourcesFileName];

	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		[self createUserFoodSources];
	}
	return filePath;
}

- (NSDictionary*)userFoodSources
{
	NSString *filePath = [self userFoodSourcesFilePath];
	NSString *content = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *contentDictionary = [NSJSONSerialization JSONObjectWithData:contentData options:0 error:nil];
	return contentDictionary;
}

- (void)writeUserFoodSources:(NSDictionary*)sources
{
	NSString *filePath = [self userFoodSourcesFilePath];
	NSData *data = [NSJSONSerialization dataWithJSONObject:sources options:0 error:nil];
	[data writeToFile:filePath atomically:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CUSTOM_USER_FOOD_SOURCES_UPDATED object:nil];
}

- (void)generateUserCustomFoodItemWithAttributes:(NSDictionary*)attributes
{
	NSMutableDictionary *userFoodSources = [[self userFoodSources] mutableCopy];
	NSString *itemName = attributes[FRESHLY_ITEM_ATTRIBUTE_NAME];

	NSMutableDictionary *userValues = [[NSMutableDictionary alloc] init];
	userValues[FRESHLY_ITEM_ATTRIBUTE_CATEGORY] = attributes[FRESHLY_ITEM_ATTRIBUTE_CATEGORY];
	NSInteger userSpaceIndex = [attributes[FRESHLY_ITEM_ATTRIBUTE_SPACE] integerValue];
	NSString *userSpace = @[@"r",@"f",@"p"][userSpaceIndex];
	userValues[FRESHLY_ITEM_ATTRIBUTE_SPACE] = userSpace;

	NSDictionary *oldUserValues = self.userFoodSources[itemName.lowercaseString];
	NSDictionary *defaultValues = self.defaultFoodItemData[itemName.lowercaseString];
	NSDictionary *precedentedDictionary = (oldUserValues) ? : defaultValues;

	if (precedentedDictionary) {
		NSMutableDictionary *expirationTimes = [precedentedDictionary[@"exp"] mutableCopy];
		NSTimeInterval customExpirationTime = [attributes[FRESHLY_ITEM_ATTRIBUTE_EXPIRATION_DATE] timeIntervalSinceDate:attributes[FRESHLY_ITEM_ATTRIBUTE_PURCHASE_DATE]];
		NSInteger customExpirationDays = ((NSInteger) customExpirationTime)/(60*60*24);
		expirationTimes[userSpace] = [NSString stringWithFormat:@"%ld", (long) customExpirationDays];
		userValues[@"exp"] = expirationTimes;
	} else {
		userValues[@"exp"] = [self defaultExpirationTimesForItemInCategory:attributes[FRESHLY_ITEM_ATTRIBUTE_CATEGORY]];
	}

	userFoodSources[itemName.lowercaseString] = userValues;
	[self writeUserFoodSources:userFoodSources];
}

- (NSDictionary*)defaultFoodItemData
{
	if (!_defaultFoodItemData) {

		_defaultFoodItemData = [[NSDictionary alloc] init];

		NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:@"minFoodSource" ofType:@"json"];
		NSError *error;
		NSData *foodData = [NSData dataWithContentsOfFile:jsonFilePath options:NSDataReadingMappedIfSafe error:&error];

		if (error) {
			NSLog(@"Error loading food JSON file");
			return nil;
		} else {
			NSDictionary *foodDictionary = [NSJSONSerialization JSONObjectWithData:foodData options:NSJSONReadingAllowFragments error:&error];

			if (error || ![foodDictionary isKindOfClass:[NSDictionary class]]) {
				NSLog(@"Error parsing JSON file");
				return nil;
			}
			_defaultFoodItemData = foodDictionary;
		}
	}
	return _defaultFoodItemData;
}

#pragma mark - Database Methods

- (void)retrieveItemsForStorageWithBlock:(void (^)(NSArray*))completionBlock
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:kFoodItemEntityName inManagedObjectContext:self.managedObjectContext];
	request.predicate = [NSPredicate predicateWithFormat:@"(self.inStorage == 1)"];
	
	completionBlock([self.managedObjectContext executeFetchRequest:request error:nil]);
}

- (void)retrieveItemsForShoppingListWithBlock:(void (^)(NSArray*))completionBlock
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:kFoodItemEntityName inManagedObjectContext:self.managedObjectContext];
	request.predicate = [NSPredicate predicateWithFormat:@"(self.inStorage == 0)"];
	
	completionBlock([self.managedObjectContext executeFetchRequest:request error:nil]);
}

- (void)createItemWithAttributes:(NSDictionary*)attributes
{
	NSManagedObject *newItem = [NSEntityDescription insertNewObjectForEntityForName:kFoodItemEntityName inManagedObjectContext:self.managedObjectContext];
	[newItem setValuesForKeysWithDictionary:attributes];
	[self.managedObjectContext save:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ITEM_UPDATED object:nil];
	if (attributes[FRESHLY_ITEM_ATTRIBUTE_IN_STORAGE] == [NSNumber numberWithBool:1]) {
		[self generateUserCustomFoodItemWithAttributes:attributes];
	}
}

- (void)updateItem:(FRSFoodItem *)item
{
	[self.managedObjectContext save:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ITEM_UPDATED object:nil];
}

- (void)deleteItem:(FRSFoodItem *)item
{
	[self.managedObjectContext deleteObject:item];
	[self.managedObjectContext save:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ITEM_UPDATED object:nil];
}

@end
