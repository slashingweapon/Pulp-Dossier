//
//  CAttributeString.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/6/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CAttributeInteger.h"
#import "IntegerCell.h"

@implementation CAttributeInteger

@synthesize integerValue;

- (NSString*)type {
	return @"integer";
}

- (id)initWithString:(NSString*)inputString {
	self = [super initWithString:inputString];
	if (self)
		self.integerValue = [NSNumber numberWithInteger:[inputString integerValue]];
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
	
	if (self)
		self.integerValue = [decoder decodeObjectForKey:@"integerValue"];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.integerValue forKey:@"integerValue"];	
}

- (void)dealloc {
	[self.integerValue release];
	[super dealloc];
}

- (NSString*)getStringValue {
	return [NSString stringWithFormat:@"%d", [integerValue integerValue]];
}

- (UITableViewCell*)cellForTableView:(UITableView *)tableView {
	static NSString* cellIdentifier = @"CAttributeIntegerCell";
	IntegerCell* cell = (IntegerCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (![cell isKindOfClass:[IntegerCell class]]) {
		cell = [[[IntegerCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier] autorelease];
	}
	
	if (cell != nil) {
		cell.textLabel.text = self.label;
		cell.formatSelector = @selector(getStringValue);
		[cell setTarget:self withKey:@"integerValue"];
		cell.minValue = 0;
		cell.maxValue = 99;
	}
	
	return cell;
}

@end
