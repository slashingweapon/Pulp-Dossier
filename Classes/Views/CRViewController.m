    //
//  CRViewController.m
//  Pulp Dossier
//
//  Created by Courtney Holmes on 6/4/11.
//  Copyright 2011 CJ Holmes. All rights reserved.
//

#import "CRViewController.h"
#import "CRView.h"

@implementation CRViewController

/*	Initialize a detail view with a dictionary like:
 
	<resourceInterface>
		<type>aspect</type>
		<heading>Aspect</heading>
		<sectionOrder>100</sectionOrder>
		<detailView>
			<title fromAttribute="name"/>
			<text fromAttribute="description"/>
		</detailView>
		<cellView>
			<textLabel fromAttribute="name"/>
			<detailLabel fromAttribute="description"/>
		</cellView>
	</resourceInterface>
*/
+ (CRViewController*)hardInit:(id)targetResource {
	
	id rez = [NSDictionary dictionaryWithObjectsAndKeys:
			  @"aspect", @"type",
			  @"Aspect", @"heading",
			  @"100", @"sectionOrder",
			  [NSArray arrayWithObjects:
			   [NSDictionary dictionaryWithObjectsAndKeys:
				@"CRTitleView", @"_class",
				@"name", @"fromAttribute",
				nil],
			   [NSDictionary dictionaryWithObjectsAndKeys:
				@"CRTextView", @"_class",
				@"description", @"fromAttribute",
				nil],
			   [NSDictionary dictionaryWithObjectsAndKeys:
				@"CRLadderView", @"_class",
				@"level", @"fromAttribute",
				nil],
			   nil], @"detailView",
			  nil];
	return [[[CRViewController alloc] initWithDefinition:rez resource:targetResource] autorelease];
}

- (id)initWithDefinition:(id)resourceSpec resource:(id)targetResource {
	self = [super initWithNibName:nil bundle:nil];	// call the designated initializer
	
	if (self) {
		viewSpecs = [resourceSpec retain];
		resource = [targetResource retain];
	}
	
	return self;
}

- (void)dealloc {
    [super dealloc];
	[viewSpecs release];
	[resource release];
}

/*	We need to create a scroll view that is the width of our window, then add views which we initialize
	according to the viewSpecs.
*/
- (void)loadView {
	[super loadView];
	float totalHeight = 0.0;
	
    CGRect fullScreenRect = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:fullScreenRect];

	self.view = sv;
	[sv release];
	
	id specList = [viewSpecs valueForKey:@"detailView"];
	for (id oneSpec in specList) {
		// Figure out what class we're supposed to instantiate
		Class viewClass;
		id viewClassString = [oneSpec valueForKey:@"_class"];
		if ([viewClassString isKindOfClass:[NSString class]])
			viewClass = NSClassFromString((NSString*)viewClassString);

		// Make an instance of the class with the appropriate frame, then give it the data it needs
		if (viewClass) {
			CGRect frame = CGRectMake(0.0, totalHeight, fullScreenRect.size.width, 10.0);
			CRView* oneView = [[viewClass alloc] initWithFrame:frame];
			if (oneView) {
				[oneView setParams:oneSpec withDataSource:(id)resource];
				[self.view addSubview:oneView];
				frame = oneView.frame;
			}
			totalHeight += frame.size.height;
		}
	}
	
	CGRect frame = self.view.frame;
	frame.size.height = totalHeight + 150;
	
	// set the title
	id headingObj = [viewSpecs valueForKey:@"heading"];
	if ([headingObj isKindOfClass:[NSString class]])
		self.title = (NSString*)headingObj;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
