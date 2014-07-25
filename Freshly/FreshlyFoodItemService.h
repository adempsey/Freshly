//
//  FreshlyFoodItemService.h
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreshlyFoodItemService : NSObject

+ (FreshlyFoodItemService*)sharedInstance;

- (NSArray*)retrieveItemsForStorageSpace:(NSInteger)space;

@end
