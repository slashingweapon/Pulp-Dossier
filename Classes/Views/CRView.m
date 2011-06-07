//
//  CRView.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/4/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CRView.h"


@implementation CRView

@synthesize dataSource;
@synthesize params;

- (void)dealloc {
    [super dealloc];
	[self.dataSource release];
	[self.params release];
}

- (void)setParams:(NSDictionary*)dict withDataSource:(id)source {
	params = [dict retain];
	dataSource = [source retain];
}

- (NSString*)getSourceString {
	NSString *retval;
	
	NSString *path = [params valueForKey:@"fromAttribute"];
	if (path != nil)
		retval = [dataSource valueForKey:path];
	
	return retval;
}

@end
