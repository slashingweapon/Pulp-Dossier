//
//  CAttribute.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/5/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>

/*	Characters have multiple attribute types in Pulp.  Most are pretty simple (string and text) while
	others are compound attributes with several properties of their own.  An character attribute
	may or may not have a label, which affects how it is displayed.
 */
@interface CAttribute : NSObject <NSCoding> {
	NSString *label;
}

@property (nonatomic, retain) NSString *label;

- (id)initWithString:(NSString*)inputString;

- (id)initWithCoder:(NSCoder *)decoder;

- (void)encodeWithCoder:(NSCoder *)encoder;

/*	Takes an abbreviated class name from our xml parser and turns it into the correct
	class.  For example, the XML element name "track" would return the CAttributeTrack class.

+ (Class)classForString:(NSString*)className;

+ (NSString*)stringForClass;
 
*/

@end
