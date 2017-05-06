//
//  FreshlyAutoCompletionTableViewCell.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/16/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABLE_VIEW_CELL_AUTO_COMPLETION_IDENTIFIER @"AutoCompletionTableViewCell"

@interface FRSAutoCompletionTableViewCell : UITableViewCell

- (instancetype)initWithName:(NSString*)name;

@end
