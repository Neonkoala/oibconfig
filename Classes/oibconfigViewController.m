//
//  oibconfigViewController.m
//  oibconfig
//
//  Created by Neonkoala on 02/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "oibconfigViewController.h"

@implementation oibconfigViewController

@synthesize timeoutSlider, timeoutValue, cmdResult;

-(IBAction) tapIphoneos:(id)sender {
	iphoneosImage.alpha = 1.0;
	iphoneosLabel.hidden = NO;
	androidImage.alpha = 0.3;
	androidLabel.hidden = YES;
	consoleImage.alpha = 0.3;
	consoleLabel.hidden = YES;
	
	dataclass *thisconfig = [dataclass nvramconfig];
	thisconfig.defaultos = @"0";
}

-(IBAction) tapAndroid:(id)sender {
	iphoneosImage.alpha = 0.3;
	iphoneosLabel.hidden = YES;
	androidImage.alpha = 1.0;
	androidLabel.hidden = NO;
	consoleImage.alpha = 0.3;
	consoleLabel.hidden = YES;
	
	dataclass *thisconfig = [dataclass nvramconfig];
	thisconfig.defaultos = @"1";
}

-(IBAction) tapConsole:(id)sender {
	iphoneosImage.alpha = 0.3;
	iphoneosLabel.hidden = YES;
	androidImage.alpha = 0.3;
	androidLabel.hidden = YES;
	consoleImage.alpha = 1.0;
	consoleLabel.hidden = NO;
	
	dataclass *thisconfig = [dataclass nvramconfig];
	thisconfig.defaultos = @"2";
}

-(IBAction) timeoutSliderValueChanged:(UISlider *)sender {
	timeoutValue.text = [NSString stringWithFormat:@"%.1f", [sender value]];
}

-(IBAction) backup:(id) sender {
	NSString* results = @"Backup NVRAM results:\n";
	
	id mynvramutils;
	mynvramutils=[nvramutils new];
	
	int backup = [mynvramutils backupNVRAM];
	
	if (backup==1) {
		results = [results stringByAppendingString:@"Backup created.\n"];
	} else if (backup==0) {
		results = [results stringByAppendingString:@"Backup already exists.\n"];
	} else {
		results = [results stringByAppendingString:@"Backup operation failed. Aborting.\n"];
	}

	cmdResult.text = results;

}

-(IBAction) getnew:(id) sender {
	NSString* results = @"Get new NVRAM results:\n";
	
	id mynvramutils;
	mynvramutils=[nvramutils new];
	
	NSString* freshPath = @"/var/mobile/Documents/NVRAM.xml";
	
	int getnew = [mynvramutils getNVRAM:freshPath];
	
	if (getnew==0) {
		results = [results stringByAppendingString:@"New working copy created.\n"];
	} else {
		results = [results stringByAppendingString:@"Failed to obtain fresh NVRAM.\n"];
	}
	
	cmdResult.text = results;
}
 
-(IBAction) update:(id) sender {
	NSString* results = @"Update NVRAM results:\n";
	
	id mynvramutils;
	mynvramutils=[nvramutils new];
	
	NSString* updatePath = @"/var/mobile/Documents/NVRAM.xml";
	NSString* cmdout;
	
	results = [results stringByAppendingString:updatePath];
	results = [results stringByAppendingString:@"\n"];
	
	[mynvramutils updateNVRAM:updatePath usingOutput:&cmdout];
	
	results = [results stringByAppendingString:cmdout];
		
	cmdResult.text = results;
}

-(IBAction) parsexml:(id) sender {
	NSString* results = @"Parse XML results:\n";
	
	id mynvramutils;
	mynvramutils=[nvramutils new];
	
	NSString* xmlPath = @"/var/mobile/Documents/NVRAM.xml";
	
	[mynvramutils parseNVRAMXML:xmlPath];
	
	//results = [results stringByAppendingString:randstring];
	
	cmdResult.text = results;
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	dataclass *thisconfig = [dataclass nvramconfig];
	
	NSLog(@"Check global var has sumat in it");
	NSLog(@"%@",thisconfig.timeout);
	NSLog(@"%@",thisconfig.defaultos);
	
	int timeout = [thisconfig.timeout intValue];
	int formattedTimeout = timeout / 1000;
	int os = [thisconfig.defaultos intValue];
	int autoboot = [thisconfig.autoboot intValue];
	
	NSLog(@"%d",formattedTimeout);
	
	switch (os) {
		case 0:
			iphoneosImage.alpha = 1.0;
			iphoneosLabel.hidden = NO;
			break;
		case 1:
			androidImage.alpha = 1.0;
			androidLabel.hidden = NO;
			break;
		case 2:
			consoleImage.alpha = 1.0;
			consoleLabel.hidden	= NO;
			break;

		default:
			//Otherwise set default iphone and send uialert erroring
			iphoneosImage.alpha = 1.0;
			iphoneosLabel.hidden = NO;
			break;
	}
	
	if (autoboot==1) {
		autobootToggle.on = YES;
	} else {
		autobootToggle.on = NO;
		timeoutSlider.enabled = NO;
	}
	
	timeoutSlider.value = formattedTimeout;
	timeoutValue.text = [NSString stringWithFormat:@"%d",formattedTimeout];
	
    [super viewDidLoad];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
