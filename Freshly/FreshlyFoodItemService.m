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
	return @[@"Dairy", @"Drink", @"Fish", @"Fruit", @"Meat", @"Default", @"Seafood", @"Vegetable"];
}

- (UIColor*)colorForCategory:(NSString*)category
{
	category = [category lowercaseString];
	
	if ([category isEqualToString:@"dairy"]) {
		return COLOR_DAIRY;
		
	} else if ([category isEqualToString:@"drink"]) {
		return COLOR_DRINK;
		
	} else if ([category isEqualToString:@"fish"]) {
		return COLOR_FISH;
		
	} else if ([category isEqualToString:@"fruit"]) {
		return COLOR_FRUIT;
		
	} else if ([category isEqualToString:@"meat"]) {
		return COLOR_MEAT;
		
	} else if ([category isEqualToString:@"seafood"]) {
		return COLOR_SEAFOOD;
		
	} else if ([category isEqualToString:@"vegetable"]) {
		return COLOR_VEGETABLE;
		
	}
	
	return COLOR_MISC;
}

#pragma mark - Database Methods

- (NSArray*)retrieveItemsForStorage
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	request.entity = [NSEntityDescription entityForName:kFoodItemEntityName inManagedObjectContext:self.managedObjectContext];
	request.predicate = [NSPredicate predicateWithFormat:@"(inStorage == 1)"];
	
	return [self.managedObjectContext executeFetchRequest:request error:nil];
}

- (BOOL)createItemWithAttributes:(NSDictionary*)attributes
{
	NSManagedObject *newItem = [NSEntityDescription insertNewObjectForEntityForName:kFoodItemEntityName inManagedObjectContext:self.managedObjectContext];
	[newItem setValuesForKeysWithDictionary:attributes];
	
	if (![self.managedObjectContext save:nil]) {
		return NO;
	}
	
	return YES;
}

@end
