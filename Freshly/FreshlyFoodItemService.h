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

- (UIColor*)colorForCategory:(NSString*)category;
- (NSArray*)foodItemCategoryList;

- (NSArray*)retrieveItemsForStorage;
- (BOOL)createItemWithAttributes:(NSDictionary*)attributes;
- (BOOL)updateItem:(FreshlyFoodItem*)item;


@end
