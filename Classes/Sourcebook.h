//
//  Sourcebook.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/1/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 *	A sourcebook contains rules and resources for running a game in a particular milieu.  In the case
 *	of Spirit of the Century, it contains all of the standard aspects, stunts, skills, and 
 *	gadgets/gizmos.  For now we only support a single sourcebook, and it is just a big dictionary of 
 *	resources of known types.
 *
 *	Ultimately I would like to support multiple sourcebooks.  This would allow people to add their 
 *	own resources, and maybe provide a business model down the line.  The would require a major 
 *	overhaul of the sourcebook model, but it would roughly involve:
 *
 *	- Reading all sourcebooks and putting them into an SQLlite database
 *	- Updating the database at startup with any new/modified source material
 *	- Abstracting resource type definitions
 */
@interface Sourcebook : NSObject {

}

// Not a true singleton, since it doesn't return an actual Sourcebook*.  Someday...
+(NSDictionary*)sharedSourcebook;

@end
