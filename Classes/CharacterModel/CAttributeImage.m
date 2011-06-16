//
//  CAttributeImage.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/6/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CAttributeImage.h"
#import "ImageCell.h"

@implementation CAttributeImage

@synthesize imageValue;

- (NSString*)type {
	return @"image";
}

/*	The string is a path of some kind, relative to a sourcebook.  Load and go! */
- (id)initWithString:(NSString*)inputString {
	// ok, so we're not implemented yet.
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
	
	if (self) {
		NSData *imageData = [decoder decodeObjectForKey:@"imageValue"];
		if (imageData)
			self.imageValue = [[[UIImage alloc] initWithData:imageData] autorelease];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
	
	if (imageValue) {
		NSData *imageData = UIImagePNGRepresentation(self.imageValue);
		if (imageData)
			[encoder encodeObject:imageData forKey:@"imageValue"];
	}
}

- (void)dealloc {
	[super dealloc];
	[self.imageValue dealloc];
}

- (UITableViewCell*)cellForTableView:(UITableView *)tableView {
	static NSString* cellIdentifier = @"CAttributeImageCell";
	ImageCell* cell = (ImageCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (![cell isKindOfClass:[ImageCell class]]) {
		cell = [[[ImageCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier] autorelease];
	}
	
	if (cell != nil) {
		cell.textLabel.text = self.label;
		[cell setTarget:self withKey:@"imageValue"];
	}
	
	return cell;
}



@end
