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

- (void)retrieveItemsForStorageWithBlock:(void (^)(NSArray*))completionBlock;
- (void)createItemWithAttributes:(NSDictionary*)attributes;
- (void)updateItem:(FreshlyFoodItem*)item;
- (void)deleteItem:(FreshlyFoodItem*)item;

@end
