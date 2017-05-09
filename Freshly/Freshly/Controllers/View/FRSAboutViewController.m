//
//  FreshlyAboutViewController.m
//  Freshly
//
//  Created by Andrew Dempsey on 11/14/14.
//  Copyright (c) 2014 Andrew Dempsey. All rights reserved.
//

#import "FRSAboutViewController.h"
#import "UIColor+FreshlyAdditions.h"

@interface FRSAboutViewController ()

@property (nonatomic, readwrite, strong) UITextView *textView;

@end

@implementation FRSAboutViewController

- (instancetype)init
{
	if (self = [super init]) {
		self.textView = [[UITextView alloc] init];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.textView.editable = NO;
	self.textView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.textView.backgroundColor = [UIColor freshly_backgroundColor];
	self.textView.tintColor = [UIColor freshly_primaryGreen];
	self.textView.attributedText = [self generateContent];

	[self.view addSubview:self.textView];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	self.textView.frame = self.view.frame;
}

- (NSMutableAttributedString*)generateContent
{
	NSString *content = @"";

	content = [content stringByAppendingString:@"Designed by Kiho Suh\n"];
	content = [content stringByAppendingString:@"Written by Andrew Dempsey\n\n"];

	content = [content stringByAppendingString:@"Freshly is open source under the MIT License. "];

	NSString *githubURLText = @"Fork on GitHub";
	NSRange githubURLRange = NSMakeRange(content.length+1, githubURLText.length);
	content = [content stringByAppendingString:[NSString stringWithFormat:@" %@\n\n",githubURLText]];

	NSArray *license = @[@"The MIT License (MIT)",
						 @"Copyright \u00A9 2014 Kiho Suh, Andrew Dempsey",
						 @"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:",
						 @"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.",
						 @"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."];
	NSString *licenseText = [NSString stringWithFormat:@"%@\n%@\n\n%@\n\n%@\n\n%@", license[0], license[1], license[2], license[3], license[4]];
	content = [content stringByAppendingString:licenseText];

	content = [content stringByAppendingString:@"\n\nNote: Freshly is intended to be a helpful resource for managing food purchases, but is not a reputable source for food quality. "];
	content = [content stringByAppendingString:@"Always check the date on packages before consuming."];

	content = [content stringByAppendingString:@"\n\nIcon Attributions:\n\n"];

	NSString *nounProjectURLText = @"Noun Project";

	content = [content stringByAppendingString:@"Spinach designed by "];
	NSString *spinachAuthorAttribution = @"Joyce Lin";
	NSRange spinachAuthorAttributionRange = NSMakeRange(content.length, spinachAuthorAttribution.length);
	content = [content stringByAppendingString:spinachAuthorAttribution];
	content = [content stringByAppendingString:@" from the "];
	NSRange spinachAuthorNPLinkRange = NSMakeRange(content.length, nounProjectURLText.length);
	content = [content stringByAppendingString:nounProjectURLText];

	content = [content stringByAppendingString:@"\n\n"];

	content = [content stringByAppendingString:@"Meat designed by "];
	NSString *meatAuthorAttribution = @"Christopher T. Howlett";
	NSRange meatAuthorAttributionRange = NSMakeRange(content.length, meatAuthorAttribution.length);
	content = [content stringByAppendingString:meatAuthorAttribution];
	content = [content stringByAppendingString:@" from the "];
	NSRange meatAuthorNPLinkRange = NSMakeRange(content.length, nounProjectURLText.length);
	content = [content stringByAppendingString:nounProjectURLText];

	content = [content stringByAppendingString:@"\n\n"];

	content = [content stringByAppendingString:@"Silverware designed by "];
	NSString *silverwareAuthorAttribution = @"Jardson A.";
	NSRange silverwareAuthorAttributionRange = NSMakeRange(content.length, silverwareAuthorAttribution.length);
	content = [content stringByAppendingString:silverwareAuthorAttribution];
	content = [content stringByAppendingString:@" from the "];
	NSRange silverwareAuthorNPLinkRange = NSMakeRange(content.length, nounProjectURLText.length);
	content = [content stringByAppendingString:nounProjectURLText];

	content = [content stringByAppendingString:@"\n\n"];

	content = [content stringByAppendingString:@"Fish designed by "];
	NSString *fishAuthorAttribution = @"Paul Smile";
	NSRange fishAuthorAttributionRange = NSMakeRange(content.length, fishAuthorAttribution.length);
	content = [content stringByAppendingString:fishAuthorAttribution];
	content = [content stringByAppendingString:@" from the "];
	NSRange fishAuthorNPLinkRange = NSMakeRange(content.length, nounProjectURLText.length);
	content = [content stringByAppendingString:nounProjectURLText];

	NSMutableAttributedString *attributedContent = [[NSMutableAttributedString alloc] initWithString:content];

	[attributedContent addAttribute:NSForegroundColorAttributeName value:FRESHLY_COLOR_DARK range:NSMakeRange(0, content.length)];

	[attributedContent addAttribute:NSLinkAttributeName value:@"https://github.com/adempsey/Freshly" range:githubURLRange];
	[attributedContent addAttribute:NSLinkAttributeName value:@"http://www.thenounproject.com/joicetotheworld" range:spinachAuthorAttributionRange];
	[attributedContent addAttribute:NSLinkAttributeName value:@"http://www.thenounproject.com" range:spinachAuthorNPLinkRange];
	[attributedContent addAttribute:NSLinkAttributeName value:@"http://www.thenounproject.com/howlettstudios" range:meatAuthorAttributionRange];
	[attributedContent addAttribute:NSLinkAttributeName value:@"http://www.thenounproject.com" range:meatAuthorNPLinkRange];
	[attributedContent addAttribute:NSLinkAttributeName value:@"http://www.thenounproject.com/jardson" range:silverwareAuthorAttributionRange];
	[attributedContent addAttribute:NSLinkAttributeName value:@"http://www.thenounproject.com" range:silverwareAuthorNPLinkRange];
	[attributedContent addAttribute:NSLinkAttributeName value:@"http://www.thenounproject.com/PaulSmile" range:fishAuthorAttributionRange];
	[attributedContent addAttribute:NSLinkAttributeName value:@"http://www.thenounproject.com" range:fishAuthorNPLinkRange];

	return attributedContent;
}

@end
