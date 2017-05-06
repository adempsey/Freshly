//
//  FreshlyItemViewController.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/9/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRSFoodItem.h"
#import "FRSItemDateViewController.h"
#import "FRSFoodAutoCompletionViewController.h"

@interface FRSItemViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, FreshlyItemDateProtocol, UITextFieldDelegate, UIActionSheetDelegate, FreshlyAutoCompletionDelegate>

- (instancetype)initWithItem:(FRSFoodItem *)item;

@end
