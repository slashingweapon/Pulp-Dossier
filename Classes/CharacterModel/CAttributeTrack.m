//
//  CAttributeTrack.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/10/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CAttributeTrack.h"
#import "TrackViewController.h"

@implementation CAttributeTrack

@synthesize maximum;
@synthesize track;
@synthesize consequences;
@synthesize stringEquivalent;

- (id)initWithString:(NSString*)inputString {
	self = [super initWithString:inputString];
	if (self) {
		NSInteger max = [inputString integerValue];
		self.maximum = [NSNumber numberWithInteger:max];
		self.track = [NSNumber numberWithInteger:0];
		self.consequences = [NSMutableArray arrayWithCapacity:3];
		[self observeSelf];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	if (self) {
		self.maximum =  [decoder decodeObjectForKey:@"maximum"];
		self.track = [decoder decodeObjectForKey:@"track"];
		self.consequences = [decoder decodeObjectForKey:@"consequences"];
		[self observeSelf];
	}

	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[super encodeWithCoder:encoder];
	
	[encoder encodeObject:maximum forKey:@"maximum"];
	[encoder encodeObject:track forKey:@"track"];
	[encoder encodeObject:consequences forKey:@"consequences"];
}

- (void)dealloc {
	[super dealloc];
	[self unobserveSelf];
	[self.maximum release];
	[self.track	release];
	[self.consequences release];
}

/*	The stringEquivalent property depends on the three primary properties.  To make sure
	is is always up to date, a track registers itself as an observer of all three
	primary properties.  The last event registration triggers the building of our
	initial stringEquivalent value.
 */
- (void)observeSelf {
	[self addObserver:self forKeyPath:@"maximum" options:0 context:nil];
	[self addObserver:self forKeyPath:@"track" options:0 context:nil];
	[self addObserver:self forKeyPath:@"consequences" options:NSKeyValueObservingOptionInitial context:nil];
}

- (void)unobserveSelf {
	[self removeObserver:self forKeyPath:@"maximum"];
	[self removeObserver:self forKeyPath:@"track"];
	[self removeObserver:self forKeyPath:@"consequences"];
}

/*	We don't actually care which property changed.  We will always rebuild the stringEquivalent 
	property, and then set it in a KVO-compatible way.  Anyone observing the stringEquivalent
	property will be notified whenever any of the primary properties change.
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSMutableString *mutie = [NSMutableString stringWithCapacity:25];
	NSInteger idx;

	for (idx=0; idx<[maximum integerValue]; idx++) {
		if ([track integerValue] & (1 << idx))
			[mutie appendString:CAttributeTrackChecked];
		else
			[mutie appendString:CAttributeTrackUnchecked];
	}
	
	NSString *conseq = [self.consequences lastObject];
	if ([conseq isKindOfClass:[NSString class]])
		[mutie appendFormat:@": %@", conseq];
	
	self.stringEquivalent = [NSString stringWithString:mutie];
}

- (CAttributeCell*)cellForTableView:(UITableView *)tableView {
	static NSString* cellIdentifier = @"CAttributeTrackCell";
	CAttributeCell* cell = (CAttributeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (![cell isKindOfClass:[CAttributeCell class]]) {
		cell = [[[CAttributeCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier] autorelease];
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	if (cell != nil) {
		[cell setTarget:self withKey:@"stringEquivalent"];
		cell.textLabel.text = self.label;
	}
	
	return cell;
}

- (UIViewController*) detailViewController:(BOOL)editing {
	TrackViewController *tvc = [[[TrackViewController alloc] initWithNibName:@"TrackViewController" bundle:nil] autorelease];
	tvc.track = self;
	return tvc;
}

@end
