//
//  FreshlyFoodItemViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/25/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyFoodItemViewController.h"

#define kViewWidth 280
#define kViewHeight 400

@interface FreshlyFoodItemViewController ()

@property (nonatomic, readwrite, strong) FreshlyFoodItem *item;

@property (nonatomic, readwrite, strong) UITextField *titleField;
@property (nonatomic, readwrite, strong) UITextField *categoryField;
@property (nonatomic, readwrite, strong) UIView *dateBanner;

@end

@implementation FreshlyFoodItemViewController

- (id)initWithFoodItem:(FreshlyFoodItem*)item
{
    if (self = [super init]) {
        self.item = item;
        self.titleField = [[UITextField alloc] init];
        self.categoryField = [[UITextField alloc] init];
        self.dateBanner = [[UIView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake((screenBounds.size.width - kViewWidth)/2, 80, kViewWidth, kViewHeight);
    
    self.view.backgroundColor = COLOR_SECONDARY;
    
    self.titleField.frame = CGRectMake(130, 30, 130, 30);
    self.titleField.text = self.item.name;
    [self.view addSubview:self.titleField];
    
    self.categoryField.frame = CGRectMake(130, 70, 130, 30);
    self.categoryField.text = self.item.category;
    [self.view addSubview:self.categoryField];
    
    self.dateBanner.frame = CGRectMake(0, 130, self.view.frame.size.width, 100);
    self.dateBanner.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.dateBanner];
}

@end
