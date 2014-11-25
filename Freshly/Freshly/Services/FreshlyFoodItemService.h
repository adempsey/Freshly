//
//  FreshlyFoodItemService.h
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FreshlyFoodItem.h"

@interface FreshlyFoodItemService : NSObject

+ (FreshlyFoodItemService*)sharedInstance;

@property (nonatomic, readwrite, strong) NSDictionary *defaultFoodItemData;

- (UIColor*)colorForCategory:(NSString*)category;
- (NSArray*)foodItemCategoryList;

- (NSString*)defaultCategoryForFoodItemName:(NSString*)itemName;
- (NSString*)defaultSpaceForFoodItemName:(NSString*)itemName;
- (NSInteger)defaultExpirationTimeForFoodItemName:(NSString*)itemName inSpace:(NSString*)space;

- (NSString*)titleForSpaceIndex:(NSInteger)number;
- (NSInteger)spaceIndexForTitle:(NSString*)title;

- (NSDictionary*)userFoodSources;

- (void)retrieveItemsForStorageWithBlock:(void (^)(NSArray*))completionBlock;
- (void)retrieveItemsForShoppingListWithBlock:(void (^)(NSArray*))completionBlock;
- (void)createItemWithAttributes:(NSDictionary*)attributes;
- (void)updateItem:(FreshlyFoodItem*)item;
- (void)deleteItem:(FreshlyFoodItem*)item;

@end
