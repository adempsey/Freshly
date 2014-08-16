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

- (NSArray*)foodItemCategoryList
{
	return @[FRESHLY_CATEGORY_DAIRY,
			 FRESHLY_CATEGORY_DRINK,
			 FRESHLY_CATEGORY_FRUIT,
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
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_MEAT]) {
		return FRESHLY_CATEGORY_COLOR_MEAT;
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_SEAFOOD]) {
		return FRESHLY_CATEGORY_COLOR_SEAFOOD;
		
	} else if ([category isEqualToString:FRESHLY_CATEGORY_VEGETABLE]) {
		return FRESHLY_CATEGORY_COLOR_VEGETABLE;
		
	}
	
	return FRESHLY_CATEGORY_COLOR_MISC;
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
