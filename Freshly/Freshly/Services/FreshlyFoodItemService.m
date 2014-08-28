//
//  FreshlyFoodItemService.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyAppDelegate.h"
#import "FreshlyFoodItemService.h"
#import "FreshlyAppDelegate.h"

#define kFoodItemEntityName @"FreshlyFoodItem"
#define kCustomUserFoodSourcesFileName @"userFoodSources.json"

@interface FreshlyFoodItemService ()

@property (nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation FreshlyFoodItemService

+ (FreshlyFoodItemService*)sharedInstance
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
		FreshlyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
			 FRESHLY_CATEGORY_MEAT,
			 FRESHLY_CATEGORY_MISC,
			 FRESHLY_CATEGORY_SEAFOOD,
			 FRESHLY_CATEGORY_VEGETABLE];
}

- (UIColor*)colorForCategory:(NSString*)category
{	
	if ([category isEqualToString:FRESHLY_CATEGORY_DAIRY]) {
		return FRESHLY_CATEGORY_COLOR_DAIRY;
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_DRINK]) {
		return FRESHLY_CATEGORY_COLOR_DRINK;
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_FRUIT]) {
		return FRESHLY_CATEGORY_COLOR_FRUIT;
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_GRAIN]) {
		return FRESHLY_CATEGORY_COLOR_GRAIN;
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_MEAT]) {
		return FRESHLY_CATEGORY_COLOR_MEAT;
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_SEAFOOD]) {
		return FRESHLY_CATEGORY_COLOR_SEAFOOD;
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_VEGETABLE]) {
		return FRESHLY_CATEGORY_COLOR_VEGETABLE;
		
	}
	
	return FRESHLY_CATEGORY_COLOR_MISC;
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

- (void)generateUserCustomFoodItem:(NSString*)name category:(NSString*)category
{
	NSMutableDictionary *userFoodSources = [[self userFoodSources] mutableCopy];
	NSMutableDictionary *foodDictionary = [[NSMutableDictionary alloc] init];
	foodDictionary[FRESHLY_ITEM_ATTRIBUTE_CATEGORY] = category;
	userFoodSources[name.lowercaseString] = foodDictionary;
	[self writeUserFoodSources:userFoodSources];
}

- (NSString*)categoryForFoodItemName:(NSString*)itemName
{
	NSString *category = self.defaultFoodItemData[itemName][FRESHLY_ITEM_ATTRIBUTE_CATEGORY];

	if (!category) {
		category = [[self userFoodSources] objectForKey:itemName][FRESHLY_ITEM_ATTRIBUTE_CATEGORY];

		if (!category) {
			return FRESHLY_CATEGORY_MISC;
		}

		return category;
	}

	return category;
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

	NSString *defaultFoodItemKey = ((NSString*) attributes[FRESHLY_ITEM_ATTRIBUTE_NAME]).lowercaseString;
	if (![self.defaultFoodItemData objectForKey:defaultFoodItemKey]) {
		[self generateUserCustomFoodItem:attributes[FRESHLY_ITEM_ATTRIBUTE_NAME] category:attributes[FRESHLY_ITEM_ATTRIBUTE_CATEGORY]];
	}
}

- (void)updateItem:(FreshlyFoodItem*)item
{
	[self.managedObjectContext save:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ITEM_UPDATED object:nil];
}

- (void)deleteItem:(FreshlyFoodItem*)item
{
	[self.managedObjectContext deleteObject:item];
	[self.managedObjectContext save:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ITEM_UPDATED object:nil];
}

@end
