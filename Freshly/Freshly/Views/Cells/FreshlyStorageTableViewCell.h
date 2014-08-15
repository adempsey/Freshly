//
//  FreshlyStorageTableViewCell.h
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreshlyFoodItem.h"

#define TABLE_VIEW_CELL_STORAGE_IDENTIFIER @"StorageTableViewCell"

@interface FreshlyStorageTableViewCell : UITableViewCell

- (instancetype)initWithItem:(FreshlyFoodItem*)item;
- (void)setItem:(FreshlyFoodItem*)item;

@end
