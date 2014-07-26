//
//  FreshlyStorageViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyStorageViewController.h"
#import "FreshlyStorageViewCell.h"
#import "FreshlyFoodItemService.h"
#import "FreshlyFoodItem.h"
#import "FreshlyFoodItemViewController.h"

#define kNumberOfItemsInRow 4

@interface FreshlyStorageViewController ()

@property (nonatomic, readwrite, assign) NSInteger space;
@property (nonatomic, readwrite, strong) NSArray *items;

@end

@implementation FreshlyStorageViewController

- (id)initWithSpace:(NSInteger)space
{
	if (self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]]) {
		
		self.space = space;

		switch (space) {
			case FreshlyStorageSpaceRefrigerator:
				self.title = @"Refrigerator";
				break;
			case FreshlyStorageSpaceFreezer:
				self.title = @"Freezer";
				break;
			case FreshlyStorageSpacePantry:
				self.title = @"Pantry";
				break;
			default:
				break;
		}
		
		self.items = [[FreshlyFoodItemService sharedInstance] retrieveItemsForStorageSpace:space];
		
		[self.collectionView registerClass:[FreshlyStorageViewCell class] forCellWithReuseIdentifier:@"cell"];
	}
	return self;
}

- (void)viewDidLoad
{
	self.collectionView.frame = CGRectMake(0, 64, 320, 640);
	
	UIView *bgView = [[UIView alloc] init];
	bgView.backgroundColor = COLOR_PRIMARY;
	self.collectionView.backgroundView = bgView;
    
	
}

- (void)viewDidAppear:(BOOL)animated
{
    
    FreshlyFoodItemViewController *vc = [[FreshlyFoodItemViewController alloc] initWithFoodItem:self.items[0]];
    [self.view addSubview:vc.view];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return (self.items.count / kNumberOfItemsInRow) + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return (section == (self.items.count / kNumberOfItemsInRow)) ? self.items.count % kNumberOfItemsInRow : kNumberOfItemsInRow;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	FreshlyStorageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	FreshlyFoodItem *item = [self.items objectAtIndex:indexPath.row];
	
	if (!cell) {
		cell = [[FreshlyStorageViewCell alloc] init];
	}
	
	cell.backgroundColor = [UIColor redColor];
	UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, cell.bounds.size.width, 20)];
	cellLabel.textColor = [UIColor blackColor];
	cellLabel.font = [UIFont systemFontOfSize:10.0];
	cellLabel.textAlignment = NSTextAlignmentCenter;
	cellLabel.text = item.name;
	[cell.contentView addSubview:cellLabel];
	return cell;
}

@end
