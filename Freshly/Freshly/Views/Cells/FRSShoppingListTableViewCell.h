//
//  FreshlyShoppingListTableViewCell.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/15/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRSFoodItem.h"

#define TABLE_VIEW_CELL_SHOPPING_LIST_IDENTIFIER @"GroceryListTableViewCell"

@protocol FreshlyShoppingListCellDelegate;

@interface FRSShoppingListTableViewCell : UITableViewCell

@property (nonatomic, readwrite, weak) id<FreshlyShoppingListCellDelegate> delegate;
@property (nonatomic, readwrite, assign) BOOL checked;

- (instancetype)initWithItem:(FRSFoodItem *)item;
- (void)setItem:(FRSFoodItem *)item;

@end

@protocol FreshlyShoppingListCellDelegate <NSObject>

@required
- (void)shoppingListCell:(FRSShoppingListTableViewCell*)cell didChangeCheckboxValue:(BOOL)value;

@end
