//
//  Sourcebook.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/1/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//


#import "Sourcebook.h"

static NSDictionary *gSourcebook;

@implementation Sourcebook

+(NSDictionary*)sharedSourcebook {
	
	// Greatfully stolen from Apple's Properly List Programming Guide
	if (!gSourcebook) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"SotC" ofType:@"plist"];
		NSData *plistData = [NSData dataWithContentsOfFile:path];
		NSString *error;
		NSPropertyListFormat format;
		
		gSourcebook = [NSPropertyListSerialization propertyListFromData:plistData
												 mutabilityOption:NSPropertyListImmutable
														   format:&format
												 errorDescription:&error];
		if (gSourcebook)
			[gSourcebook retain];
		else {
			NSLog(@"%@", error);
			[error release];
		}
	}
	
	return gSourcebook;
}


@end
