//
//  FreshlyFoodAutoCompletionService.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/16/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FRSFoodAutoCompletionService.h"
#import "FRSFoodItemService.h"

@interface FRSFoodAutoCompletionService ()

@property (nonatomic, readwrite, strong) NSMutableDictionary *keys;
@property (nonatomic, readwrite, assign) BOOL terminal;

@end

@implementation FRSFoodAutoCompletionService

+ (FRSFoodAutoCompletionService *)sharedInstance
{
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] initRootStructure];
	});
	return sharedInstance;
}

#pragma mark - Auto Completion Data Structure

- (instancetype)initRootStructure
{
	if (self = [self init]) {

		NSDictionary *foodItemData = [[FRSFoodItemService sharedInstance] defaultFoodItemData];

		if (foodItemData) {
			[self insertData:foodItemData];
		}

		[self loadUserFoodSources];

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserFoodSources) name:NOTIFICATION_CUSTOM_USER_FOOD_SOURCES_UPDATED object:nil];
	}
	return self;
}

- (instancetype)init
{
	if (self = [super init]) {
		self.terminal = NO;
		self.keys = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-  (void)loadUserFoodSources
{
	NSDictionary *userFoodItemData = [[FRSFoodItemService sharedInstance] userFoodSources];

	if (userFoodItemData) {
		[self insertData:userFoodItemData];
	}
}

- (void)insertString:(NSString*)string
{
	if (string.length < 1) {
		self.terminal = YES;
		return;
	}

	NSString *key = [string substringToIndex:1];

	if (!self.keys[key]) {
		self.keys[key] = [[FRSFoodAutoCompletionService alloc] init];
	}

	[((FRSFoodAutoCompletionService *) self.keys[key]) insertString:[string substringFromIndex:1]];
}


- (void)insertData:(NSDictionary*)data
{
	for (NSString *itemName in data) {
		[self insertString:itemName.lowercaseString];
	}
}

- (NSArray*)itemsWithPrefix:(NSString*)prefix
{
	NSArray *words = [[NSArray alloc] initWithArray:[self wordsWithPrefix:prefix forList:self]];
	
	NSMutableArray *wordsWithPrefixes = [[NSMutableArray alloc] init];
	
	if (prefix.length > 0) {
		prefix = [prefix substringToIndex:prefix.length - 1];

		for (NSString *word in words) {
			[wordsWithPrefixes addObject:[prefix stringByAppendingString:word]];
		}
	}

	return wordsWithPrefixes;
}

- (NSArray*)wordsWithPrefix:(NSString*)prefix forList:(FRSFoodAutoCompletionService*)list
{
	// Traverse prefix trie until we reach the final character of the prefix
	if (prefix.length > 1) {
		NSString *firstChar = [prefix substringToIndex:1];
		return [self wordsWithPrefix:[prefix substringFromIndex:1] forList:list.keys[firstChar]];
	}
	
	// Suffix list is composed of all keys that can follow the given prefix
	FRSFoodAutoCompletionService *suffixKeys = list.keys[prefix];
	
	// Words will contain all our suffixes
	NSMutableArray *suffixList = [[NSMutableArray alloc] init];

	if (suffixKeys.terminal) {
		[suffixList addObject:prefix];
	}
	
	// We first check that our list has keys for the given prefix
	if (list.keys.count > 0 && list.keys[prefix]) {
		
		for (NSString *key in suffixKeys.keys) {

			// If a suffix key is non-terminal, recurse into it
			if (((FRSFoodAutoCompletionService *)suffixKeys.keys[key]).keys.count) {
				NSArray *newListWords = [self wordsWithPrefix:key forList:suffixKeys];

				// Add each suffix we found at a deeper level to the suffix list
				for (NSString *word in newListWords) {
					[suffixList addObject:[prefix stringByAppendingString:word]];
				}

			} else {
				[suffixList addObject:[prefix stringByAppendingString:key]];
			}
		}
		
		if (suffixList.count == 0) {
			return @[prefix];
		}
	}
	
	return suffixList;
}

@end
