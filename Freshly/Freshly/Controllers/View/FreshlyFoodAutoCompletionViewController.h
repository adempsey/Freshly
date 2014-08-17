//
//  FreshlyFoodAutoCompletionViewController.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/16/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FreshlyAutoCompletionViewControllerDelegate <NSObject>

@required
- (void)didSelectAutoCompletedItem:(NSString*)item withCategory:(NSString*)category;

@end

@interface FreshlyFoodAutoCompletionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite, weak) id<FreshlyAutoCompletionViewControllerDelegate> delegate;
@property (nonatomic, readwrite, strong) NSString *prefix;

@end
