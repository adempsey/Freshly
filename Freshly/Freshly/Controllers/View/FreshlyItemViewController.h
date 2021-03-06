//
//  FreshlyItemViewController.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/9/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FreshlyFoodItem.h"
#import "FreshlyItemDateViewController.h"
#import "FreshlyFoodAutoCompletionViewController.h"

@interface FreshlyItemViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, FreshlyItemDateProtocol, UITextFieldDelegate, UIActionSheetDelegate, FreshlyAutoCompletionDelegate>

- (instancetype)initWithItem:(FreshlyFoodItem*)item;

@end
