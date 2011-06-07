//
//  CRView.h
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/4/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//
//	The Characer Resource View base class really does very little.  It just holds 
//	couple of properties that are needed by all the subclases.  I suppose we could
//	have used a Category added to UIView, but that just seemed excessive.

#import <UIKit/UIKit.h>


@interface CRView : UIView {
	id dataSource;
	NSDictionary *params;
}

@property (readonly) id dataSource;
@property (readonly) NSDictionary *params;

/**
 *	Subclasses should use this method to adjust the layout and set the values of the 
 *	various views/controls.  Don't forget to call [super ...] first, though.
 */
- (void)setParams:(NSDictionary*)dict withDataSource:(id)source;

- (NSString*)getSourceString;

@end
