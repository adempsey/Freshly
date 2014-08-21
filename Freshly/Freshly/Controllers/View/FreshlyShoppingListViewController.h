//
//  FreshlyShoppingListViewController.h
//  Freshly
//
//  Created by Andrew Dempsey on 7/29/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreshlyFoodAutoCompletionViewController.h"
#import "FreshlyShoppingListTableViewCell.h"

@interface FreshlyShoppingListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FreshlyAutoCompletionDelegate, UITextFieldDelegate, FreshlyShoppingListCellDelegate>

@end
