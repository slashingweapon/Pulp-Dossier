//
//  Character.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 5/30/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//
//	This is our character model.  It has to be serializable, and versioned so we can gracefully
//	update character files when the application is updated.
//
//	TODO: Hook up proper key-value observing
//	TODO: Valicate gadget keys with the source material plist for different kinds of gagets
//

#import <Foundation/Foundation.h>

#define CHARACTER_FORMAT_VERSION 1

@interface Character : NSObject <NSCoding> {
	
	// The format version defines the file format, and only changes as the application evolves.
	NSInteger formatVersion;
	
	// The character version increments every time non-status changes are saved to the character.
	// Its purpose is to cut down on updates to characters shared on the network.  (If you 
	// already have a copy of someone's character, it doesn't need to be transmitted again.)
	NSInteger characterVersion;
	
	// A picture of the character
	NSData* portrait;
	
	// Character name
	NSString* name;
	
	// Appearss on the UI below the name.  Should be something intersting, like
	// "Urban Mystic", "Champion Ambulance Driver", or "Hell for Hire"
	NSString* occupation;
	
	// How many fate points does the character currently have.
	NSInteger fatePoints;
	
	// The minimum number of fate points a character has after a refresh.  For most characters,
	// this is the same as the number of aspects.
	NSInteger refreshRate;
	
	// The maximum health of a characters.  Usually 5.
	NSInteger health;
	
	// The stress track for the character's health.
	NSString* healthTrack;
	
	// The maximum composure of a character.  Usually 5.
	NSInteger composure;
	
	// The stress track for the character's composure.
	NSString* composureTrack;
	
	// An array of dictionaries, with keys name, severity
	NSMutableArray* consequences;
	
	// Each aspect is a dictionary with the keys name, description
	NSMutableArray* aspects;

	// Each skill is a dictionary with with the keys id, name, quality, description
	NSMutableArray* skills;
	
	// Each stunt is a dictionary with the keys id, name, skill, preq, description
	NSMutableArray* stunts;
	
	// Each gadget is a dictionary with the keys id, name, description cost, type, and perhaps 
	// other keys depending on the kind of gadget.
	NSMutableArray* gadgets;
	
	// The following are not encoded as part of the character data
	
	NSString* filePath;
	
	// The dirty flag is only set when non-status changes are made to the character.  This will
	// cause the characterVersion number to be incremented the next time the character is saved.
	BOOL dirty;
}

@property (nonatomic) NSInteger formatVersion;
@property (nonatomic) NSInteger characterVersion;
@property (nonatomic, retain) NSData* portrait;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* occupation;
@property (nonatomic) NSInteger fatePoints;
@property (nonatomic) NSInteger refreshRate;
@property (nonatomic) NSInteger health;
@property (nonatomic, copy) NSString* healthTrack;
@property (nonatomic) NSInteger composure;
@property (nonatomic, copy) NSString* composureTrack;
@property (nonatomic, retain) NSMutableArray* consequences;
@property (nonatomic, retain) NSMutableArray* aspects;
@property (nonatomic, retain) NSMutableArray* skills;
@property (nonatomic, retain) NSMutableArray* stunts;
@property (nonatomic, retain) NSMutableArray* gadgets;
@property (nonatomic) BOOL dirty;

+ (NSString*) createSavePathForName:(NSString*)characterName;
+ (NSMutableArray*) readAllCharacters;

- (BOOL)saveWithError:(NSString**)error;

@end
