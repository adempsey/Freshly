//
//  FreshlyFoodAutoCompletionService.m
//  Freshly
//
//  Created by Andrew Dempsey on 8/16/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FreshlyFoodAutoCompletionService.h"

@interface FreshlyFoodAutoCompletionService ()

@property (nonatomic, readwrite, strong) NSMutableDictionary *keys;

@end

@implementation FreshlyFoodAutoCompletionService

+ (FreshlyFoodAutoCompletionService*)sharedInstance
{
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init
{
	if (self = [super init]) {
		self.keys = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)insertString:(NSString*)string
{
	if (string.length < 1) return;

	NSString *key = [string substringToIndex:1];

	if (!self.keys[key]) {
		self.keys[key] = [[FreshlyFoodAutoCompletionService alloc] init];
	}

	[((FreshlyFoodAutoCompletionService*) self.keys[key]) insertString:[string substringFromIndex:1]];
}

- (NSArray*)wordsWithPrefix:(NSString*)prefix
{
	NSArray *words = [[NSArray alloc] initWithArray:[self wordsWithPrefix:prefix forList:self]];
	
	NSMutableArray *wordsWithPrefixes = [[NSMutableArray alloc] init];
	
	prefix = [prefix substringToIndex:prefix.length - 1];
	
	for (NSString *word in words) {
		[wordsWithPrefixes addObject:[prefix stringByAppendingString:word]];
	}
	
	return wordsWithPrefixes;
}

- (NSArray*)wordsWithPrefix:(NSString*)prefix forList:(FreshlyFoodAutoCompletionService*)list
{
	if (prefix.length > 1) {
		NSString *firstChar = [prefix substringToIndex:1];
		return [self wordsWithPrefix:[prefix substringFromIndex:1] forList:list.keys[firstChar]];
	}
	
	FreshlyFoodAutoCompletionService *newList = list.keys[prefix];
	
	NSMutableArray *words = [[NSMutableArray alloc] init];
	
	for (NSString *key in newList.keys) {
		
		if (((FreshlyFoodAutoCompletionService*)newList.keys[key]).keys.count) {
			NSArray *newListWords = [self wordsWithPrefix:key forList:newList];
			
			for (NSString *word in newListWords) {
				[words addObject:[prefix stringByAppendingString:word]];
			}
			
		} else {
			[words addObject:[prefix stringByAppendingString:key]];
		}
		
	}
	
	return words;
	
}

@end
