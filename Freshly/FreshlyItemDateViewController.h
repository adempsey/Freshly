//
//  FreshlyItemDateViewController.h
//  Freshly
//
//  Created by Andrew Dempsey on 8/11/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreshlyItemDateViewController : UIViewController

@property (nonatomic, readwrite, strong) NSDate *purchaseDate;
@property (nonatomic, readwrite, strong) NSDate *expirationDate;

- (void)setBackgroundColor:(UIColor*)color;

@end
