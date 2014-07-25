//
//  FreshlyStorageViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 7/24/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyStorageViewController.h"

@implementation FreshlyStorageViewController

- (id)initWithTitle:(NSString*)title
{
	if (self = [super initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]]) {
		self.title = title;
		[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
	}
	return self;
}

- (void)viewDidLoad
{
	UIView *bgView = [[UIView alloc] init];
	bgView.backgroundColor = COLOR_PRIMARY;
	self.collectionView.backgroundView = bgView;
	
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
	
	if (!cell) {
		cell = [[UICollectionViewCell alloc] init];
	}
	return cell;
}

@end
