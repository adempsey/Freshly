//
//  FreshlyShoppingListTableViewCell.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/15/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreshlyFoodItem.h"

#define TABLE_VIEW_CELL_SHOPPING_LIST_IDENTIFIER @"GroceryListTableViewCell"

@interface FreshlyShoppingListTableViewCell : UITableViewCell

- (instancetype)initWithItem:(FreshlyFoodItem*)item;
- (void)setItem:(FreshlyFoodItem*)item;

@end
