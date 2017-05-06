//
//  FreshlyItemDateViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/11/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FRSItemDateViewController.h"

#import "NSDate+FreshlyAdditions.h"
#import "UIFont+FreshlyAdditions.h"

#define kTimeIntervalTwoWeeks 1209600

#define kItemHorizontalOffsetiPhone 20.0
#define kiPadFormSheetWidth 540.0
#define kItemVerticalOffset 5.0

@interface FRSItemDateViewController ()

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

@implementation FRSItemDateViewController

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
	
	self.view.backgroundColor = FRESHLY_CATEGORY_COLOR_MISC;
	CGFloat purchaseLabelsOriginX = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? (kiPadFormSheetWidth / 4 ) - 40.0 : kItemHorizontalOffsetiPhone;
	CGFloat expirationLabelsOriginX = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? (3*(kiPadFormSheetWidth / 4 )) - 100.0 : self.view.bounds.size.width - kItemHorizontalOffsetiPhone - 140;
	
	[self.purchaseTitleLabel setFrame:CGRectMake(purchaseLabelsOriginX, kItemVerticalOffset, 120, 20)];
	self.purchaseTitleLabel.font = [UIFont freshlyFontOfSize:14.0];
	self.purchaseTitleLabel.text = @"Purchased";
	self.purchaseTitleLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.purchaseTitleLabel];
	
	[self.purchaseDayLabel setFrame:CGRectMake(self.purchaseTitleLabel.frame.origin.x, 25, 60, 60)];
	self.purchaseDayLabel.font = [UIFont boldFreshlyFontOfSize:48.0];
	self.purchaseDayLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.purchaseDayLabel];
	
	[self.purchaseMonthLabel setFrame:CGRectMake(self.purchaseTitleLabel.frame.origin.x + self.purchaseDayLabel.frame.size.width, 35, 60, 20)];
	self.purchaseMonthLabel.font = [UIFont freshlyFontOfSize:16.0];
	self.purchaseMonthLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.purchaseMonthLabel];
	
	[self.purchaseYearLabel setFrame:CGRectMake(self.purchaseTitleLabel.frame.origin.x + self.purchaseDayLabel.frame.size.width, 55, 60, 20)];
	self.purchaseYearLabel.font = [UIFont freshlyFontOfSize:16.0];
	self.purchaseYearLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.purchaseYearLabel];
	
	[self.expirationTitleLabel setFrame:CGRectMake(expirationLabelsOriginX, 5, 120, 20)];
	self.expirationTitleLabel.font = [UIFont freshlyFontOfSize:14.0];
	self.expirationTitleLabel.text = @"Expires";
	self.expirationTitleLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.expirationTitleLabel];
	
	[self.expirationDayLabel setFrame:CGRectMake(self.expirationTitleLabel.frame.origin.x, 25, 60, 60)];
	self.expirationDayLabel.font = [UIFont boldFreshlyFontOfSize:48.0];
	self.expirationDayLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.expirationDayLabel];
	
	[self.expirationMonthLabel setFrame:CGRectMake(self.expirationDayLabel.frame.origin.x + self.expirationDayLabel.frame.size.width, 35, 60, 20)];
	self.expirationMonthLabel.font = [UIFont freshlyFontOfSize:16.0];
	self.expirationMonthLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.expirationMonthLabel];
	
	[self.expirationYearLabel setFrame:CGRectMake(self.expirationDayLabel.frame.origin.x + self.expirationDayLabel.frame.size.width, 55, 60, 20)];
	self.expirationYearLabel.font = [UIFont freshlyFontOfSize:16.0];
	self.expirationYearLabel.textColor = [UIColor whiteColor];
	[self.view addSubview:self.expirationYearLabel];
	
	[self setDateLabelTexts];
	
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didReceiveTap:)];
	[self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)setDateLabelTexts
{
	self.purchaseDayLabel.text = [NSString stringWithFormat:@"%ld", (long) self.purchaseDate.calendarDescription.day];
	self.purchaseMonthLabel.text = [self.purchaseDate monthAsString];
	self.purchaseYearLabel.text = [NSString stringWithFormat:@"%ld", (long) self.purchaseDate.calendarDescription.year];
	
	self.expirationDayLabel.text = [NSString stringWithFormat:@"%ld", (long) self.expirationDate.calendarDescription.day];
	self.expirationMonthLabel.text = self.expirationDate.monthAsString;
	self.expirationYearLabel.text = [NSString stringWithFormat:@"%ld", (long) self.expirationDate.calendarDescription.year];
}

- (void)setPurchaseDate:(NSDate *)purchaseDate
{
	_purchaseDate = purchaseDate;
	[self setDateLabelTexts];
}

- (void)setExpirationDate:(NSDate *)expirationDate
{
	_expirationDate = expirationDate;
	[self setDateLabelTexts];
}

- (void)setBackgroundColor:(UIColor*)color
{
	self.view.backgroundColor = color;
}

- (void)didReceiveTap:(UITapGestureRecognizer*)sender
{
	CGPoint location = [sender locationInView:self.view];
	
	if (location.x < self.view.bounds.size.width/2) {
		[self.delegate itemDateViewDidBeginEditingDate:self.purchaseDate];
	} else {
		[self.delegate itemDateViewDidBeginEditingDate:self.expirationDate];
	}
}

@end
