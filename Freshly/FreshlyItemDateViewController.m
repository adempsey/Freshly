//
//  FreshlyItemDateViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/11/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyItemDateViewController.h"

#import "NSDate+FreshlyAdditions.h"

#define kTimeIntervalTwoWeeks 1209600

@interface FreshlyItemDateViewController ()

@property (nonatomic, readwrite, assign) BOOL expirationDateSet;

@property (nonatomic, readwrite, strong) UILabel *purchaseTitleLabel;
@property (nonatomic, readwrite, strong) UILabel *purchaseDayLabel;
@property (nonatomic, readwrite, strong) UILabel *purchaseMonthLabel;
@property (nonatomic, readwrite, strong) UILabel *purchaseYearLabel;

@property (nonatomic, readwrite, strong) UILabel *expirationTitleLabel;
@property (nonatomic, readwrite, strong) UILabel *expirationDayLabel;
@property (nonatomic, readwrite, strong) UILabel *expirationMonthLabel;
@property (nonatomic, readwrite, strong) UILabel *expirationYearLabel;

@end

@implementation FreshlyItemDateViewController

- (instancetype)initWithPurchaseDate:(NSDate*)purchaseDate expirationDate:(NSDate*)expirationDate
{
	if (self = [super init]) {
		self.purchaseDate = purchaseDate ? : [NSDate date];

		if (expirationDate) {
			self.expirationDate = expirationDate;
			self.expirationDateSet = YES;
		} else {
			self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:kTimeIntervalTwoWeeks];
			self.expirationDateSet = NO;
		}
		
		self.purchaseTitleLabel = [[UILabel alloc] init];
		self.purchaseDayLabel = [[UILabel alloc] init];
		self.purchaseMonthLabel = [[UILabel alloc] init];
		self.purchaseYearLabel = [[UILabel alloc] init];
		
		self.expirationTitleLabel = [[UILabel alloc] init];
		self.expirationDayLabel = [[UILabel alloc] init];
		self.expirationMonthLabel = [[UILabel alloc] init];
		self.expirationYearLabel = [[UILabel alloc] init];
	}
	return self;
}

- (instancetype)init
{
	return [self initWithPurchaseDate:nil expirationDate:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
	[self.view setBounds:CGRectMake(0, 0, screenBounds.size.width, 100)];
	self.view.backgroundColor = [UIColor grayColor];
	
	[self.purchaseTitleLabel setFrame:CGRectMake(20, 5, 120, 20)];
	self.purchaseTitleLabel.font = [UIFont systemFontOfSize:14.0];
	self.purchaseTitleLabel.text = @"Purchased";
	self.purchaseTitleLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.purchaseTitleLabel];
	
	[self.purchaseDayLabel setFrame:CGRectMake(20, 25, 60, 60)];
	self.purchaseDayLabel.font = [UIFont boldSystemFontOfSize:48.0];
	self.purchaseDayLabel.text = [NSString stringWithFormat:@"%ld", (long) self.purchaseDate.calendarDescription.day];
	self.purchaseDayLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.purchaseDayLabel];
	
	[self.purchaseMonthLabel setFrame:CGRectMake(80, 35, 60, 20)];
	self.purchaseMonthLabel.font = [UIFont systemFontOfSize:16.0];
	self.purchaseMonthLabel.text = [self.purchaseDate monthAsString];
	self.purchaseMonthLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.purchaseMonthLabel];
	
	[self.purchaseYearLabel setFrame:CGRectMake(80, 55, 60, 20)];
	self.purchaseYearLabel.font = [UIFont systemFontOfSize:16.0];
	self.purchaseYearLabel.text = [NSString stringWithFormat:@"%ld", (long) self.purchaseDate.calendarDescription.year];
	self.purchaseYearLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.purchaseYearLabel];
	
	[self.expirationTitleLabel setFrame:CGRectMake(screenBounds.size.width - 15 - 100, 5, 120, 20)];
	self.expirationTitleLabel.font = [UIFont systemFontOfSize:14.0];
	self.expirationTitleLabel.text = @"Expires";
	self.expirationTitleLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.expirationTitleLabel];
	
	[self.expirationDayLabel setFrame:CGRectMake(screenBounds.size.width - 15 - 100, 25, 60, 60)];
	self.expirationDayLabel.font = [UIFont boldSystemFontOfSize:48.0];
	self.expirationDayLabel.text = [NSString stringWithFormat:@"%ld", (long) self.expirationDate.calendarDescription.day];
	self.expirationDayLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.expirationDayLabel];
	
	[self.expirationMonthLabel setFrame:CGRectMake(screenBounds.size.width - 15 - 40, 35, 60, 20)];
	self.expirationMonthLabel.font = [UIFont systemFontOfSize:16.0];
	self.expirationMonthLabel.text = self.expirationDate.monthAsString;
	self.expirationMonthLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.expirationMonthLabel];
	
	[self.expirationYearLabel setFrame:CGRectMake(screenBounds.size.width - 15 - 40, 55, 60, 20)];
	self.expirationYearLabel.font = [UIFont systemFontOfSize:16.0];
	self.expirationYearLabel.text = [NSString stringWithFormat:@"%ld", (long) self.expirationDate.calendarDescription.year];
	self.expirationYearLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.expirationYearLabel];
}

- (void)setBackgroundColor:(UIColor*)color
{
	self.view.backgroundColor = color;
}

@end
