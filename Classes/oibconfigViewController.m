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
	iphoneosLabel.alpha = 1.0;
	androidImage.alpha = 0.3;
	androidLabel.alpha = 0.3;
	consoleImage.alpha = 0.3;
	consoleLabel.alpha = 0.3;
	
	dataclass *thisconfig = [dataclass nvramconfig];
	thisconfig.opibDefaultOs = @"0";
}

-(IBAction) tapAndroid:(id)sender {
	iphoneosImage.alpha = 0.3;
	iphoneosLabel.alpha = 0.3;
	androidImage.alpha = 1.0;
	androidLabel.alpha = 1.0;
	consoleImage.alpha = 0.3;
	consoleLabel.alpha = 0.3;
	
	dataclass *thisconfig = [dataclass nvramconfig];
	thisconfig.opibDefaultOs = @"1";
}

-(IBAction) tapConsole:(id)sender {
	iphoneosImage.alpha = 0.3;
	iphoneosLabel.alpha = 0.3;
	androidImage.alpha = 0.3;
	androidLabel.alpha = 0.3;
	consoleImage.alpha = 1.0;
	consoleLabel.alpha = 1.0;
	
	dataclass *thisconfig = [dataclass nvramconfig];
	thisconfig.opibDefaultOs = @"2";
}

-(IBAction) timeoutSliderValueChanged:(UISlider *)sender {
	timeoutValue.text = [NSString stringWithFormat:@"%1.0f", [sender value]];
	
	dataclass *thisconfig = [dataclass nvramconfig];
	thisconfig.opibTimeout = [NSString stringWithFormat:@"%1.0f", [sender value]*1000];
}

-(IBAction) changeAutoboot:(id)sender {
	dataclass *thisconfig = [dataclass nvramconfig];
	
	if (autobootToggle.on) {
		timeoutSlider.enabled = YES;
		thisconfig.opibAutoBoot = @"1";
		
	} else {
		timeoutSlider.enabled = NO;
		thisconfig.opibAutoBoot = @"0";
	}	
}

-(IBAction) backup:(id) sender {
	UIAlertView *backupResults;
	
	backupResults = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you wish to overwrite the existing backup?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[backupResults setTag:12];
	[backupResults show];
	[backupResults release];	
}

-(IBAction)restore:(id) sender {
	UIAlertView *restoreResults;
	
	restoreResults = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you wish to restore the backup?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[restoreResults setTag:13];
	[restoreResults show];
	[restoreResults release];
}

-(IBAction)reset:(id) sender {
	UIAlertView *resetResults;
	
	resetResults = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you wish to reset the configuration to the defaults? Don't forget to apply after." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[resetResults setTag:14];
	[resetResults show];
	[resetResults release];
}

-(IBAction)apply:(id) sender {
	UIAlertView *applyResults;
	
	id mynvramutils;
	mynvramutils=[nvramutils new];
	
	NSString* updatePath = @"/var/mobile/Documents/NVRAM.plist";
	
	int generated = [mynvramutils nvramGenerate:updatePath];
	int updated;
	
	switch (generated) {
		case 0:
			updated = [mynvramutils nvramWrite:updatePath];
			break;
		case -1:
			applyResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to read NVRAM configuration." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case -2:
			applyResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid configuration generated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case -3:
			applyResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to replace old configuration with updated one." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		case -4:
			applyResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New configuration not found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
		default:
			applyResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown error occurred." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	
	if(generated<0){
		[applyResults show];
		[applyResults release];
	} else {
		if(updated==0){
			applyResults = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Settings successfully applied." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		} else if(updated==-1){
			applyResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"NVRAM could not be written." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		} else if(updated==-2){
			applyResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No configuration found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		} else {
			applyResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown error occurred." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		}
		[applyResults show];
		[applyResults release];
	}
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
	id mynvramutils;
	mynvramutils=[nvramutils new];
	int gotconfig = [mynvramutils nvramInit];
	
	UIAlertView *configDumpResult;
	
	switch (gotconfig) {
		case 0:
			break;
		case -1:
			configDumpResult = [[UIAlertView alloc] initWithTitle:@"Error" message:@"NVRAM configuration could not be read." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[configDumpResult setTag:10];
			break;
		case -2:
			configDumpResult = [[UIAlertView alloc] initWithTitle:@"Error" message:@"NVRAM configuration could not be read." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[configDumpResult setTag:10];
			break;
		case -3:
			configDumpResult = [[UIAlertView alloc] initWithTitle:@"Error" message:@"NVRAM appears to be corrupt." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[configDumpResult setTag:10];
			break;
		case -4:
			configDumpResult = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Openiboot is not installed or is incompatible." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[configDumpResult setTag:10];
			break;
		case -5:
			configDumpResult = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Openiboot configuration appears incomplete. Reset configuration or exit?" delegate:self cancelButtonTitle:@"Exit" otherButtonTitles:@"Reset", nil];
			[configDumpResult setTag:11];
			break;
		case -6:
			configDumpResult = [[UIAlertView alloc] initWithTitle:@"Error" message:@"NVRAM configuration could not be read." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[configDumpResult setTag:10];
			break;
		default:
			configDumpResult = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unknown error occurred." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[configDumpResult setTag:10];
	}
	
	if(gotconfig!=0){
		[configDumpResult show];
		[configDumpResult release];
	}
	
	dataclass *thisconfig = [dataclass nvramconfig];

	int timeout = [thisconfig.opibTimeout intValue];
	int formattedTimeout = timeout / 1000;
	int os = [thisconfig.opibDefaultOs intValue];
	int autoBoot = [thisconfig.opibAutoBoot intValue];
	
	NSLog(@"%d",formattedTimeout);
	
	switch (os) {
		case 0:
			iphoneosImage.alpha = 1.0;
			iphoneosLabel.alpha = 1.0;
			break;
		case 1:
			androidImage.alpha = 1.0;
			androidLabel.alpha = 1.0;
			break;
		case 2:
			consoleImage.alpha = 1.0;
			consoleLabel.alpha = 1.0;
			break;

		default:
			iphoneosImage.alpha = 1.0;
			iphoneosLabel.alpha = 1.0;
			UIAlertView* defaultOsInvalid = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Default OS setting invalid. Using iPhone OS." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[defaultOsInvalid show];
			[defaultOsInvalid release];
	}
	
	if (autoBoot==1) {
		autobootToggle.on = YES;
	} else {
		autobootToggle.on = NO;
		timeoutSlider.enabled = NO;
	}

	timeoutSlider.value = formattedTimeout;
	timeoutValue.text = [NSString stringWithFormat:@"%d",formattedTimeout];

	[super viewDidLoad];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([alertView tag] == 10) {
		if (buttonIndex == 0) {
			exit(0);
		}
	} else if ([alertView tag] == 11) {
		if (buttonIndex == 0) {
			exit(0);
		} else {
			id mynvramutils;
			mynvramutils=[nvramutils new];
			int resetSuccess = [mynvramutils nvramReset];
			if (resetSuccess==0) {
				dataclass *thisconfig = [dataclass nvramconfig];
				
				int timeout = [thisconfig.opibTimeout intValue];
				int formattedTimeout = timeout / 1000;
				int os = [thisconfig.opibDefaultOs intValue];
				int autoBoot = [thisconfig.opibAutoBoot intValue];
				
				switch (os) {
					case 0:
						[self tapIphoneos:nil];
						break;
					case 1:
						[self tapAndroid:nil];
						break;
					case 2:
						[self tapConsole:nil];
						break;
						
					default:
						[self tapIphoneos:nil];
				}
				
				if (autoBoot==1) {
					autobootToggle.on = YES;
				} else {
					autobootToggle.on = NO;
					timeoutSlider.enabled = NO;
				}
				
				timeoutSlider.value = formattedTimeout;
				timeoutValue.text = [NSString stringWithFormat:@"%d",formattedTimeout];
			} else {
				UIAlertView *resetResults;
				resetResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reset failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[resetResults setTag:10];
				[resetResults show];
				[resetResults release];
			}
		}
	} else if ([alertView tag] == 12) {
		if (buttonIndex == 1) {
			id mynvramutils;
			mynvramutils=[nvramutils new];
			int backedUp = [mynvramutils nvramBackup:YES];
			if (backedUp==0) {
				UIAlertView *backupResults;
				backupResults = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Current configuration successfully backed up." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[backupResults show];
				[backupResults release];
			} else {
				UIAlertView *backupResults;
				backupResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Backup failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[backupResults show];
				[backupResults release];
			}
		}
	} else if ([alertView tag] == 13) {
		if (buttonIndex == 1) {
			id mynvramutils;
			mynvramutils=[nvramutils new];
			int restored = [mynvramutils nvramWrite:@"/var/mobile/Documents/NVRAM.plist.backup"];
			if (restored==0) {
				[mynvramutils nvramInit];
				
				dataclass *thisconfig = [dataclass nvramconfig];
				
				int timeout = [thisconfig.opibTimeout intValue];
				int formattedTimeout = timeout / 1000;
				int os = [thisconfig.opibDefaultOs intValue];
				int autoBoot = [thisconfig.opibAutoBoot intValue];
				
				switch (os) {
					case 0:
						[self tapIphoneos:nil];
						break;
					case 1:
						[self tapAndroid:nil];
						break;
					case 2:
						[self tapConsole:nil];
						break;
						
					default:
						[self tapIphoneos:nil];
				}
				
				if (autoBoot==1) {
					autobootToggle.on = YES;
				} else {
					autobootToggle.on = NO;
					timeoutSlider.enabled = NO;
				}
				
				timeoutSlider.value = formattedTimeout;
				timeoutValue.text = [NSString stringWithFormat:@"%d",formattedTimeout];

				UIAlertView *restoreResults;
				restoreResults = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Backup restored." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[restoreResults show];
				[restoreResults release];
				
			} else {
				UIAlertView *restoreResults;
				restoreResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Restore failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[restoreResults show];
				[restoreResults release];
			}
		}
	} else if ([alertView tag] == 14) {
		if (buttonIndex == 1) {
			id mynvramutils;
			mynvramutils=[nvramutils new];
			int resetSuccess = [mynvramutils nvramReset];
			if (resetSuccess==0) {
				dataclass *thisconfig = [dataclass nvramconfig];
				
				int timeout = [thisconfig.opibTimeout intValue];
				int formattedTimeout = timeout / 1000;
				int os = [thisconfig.opibDefaultOs intValue];
				int autoBoot = [thisconfig.opibAutoBoot intValue];
				
				switch (os) {
					case 0:
						[self tapIphoneos:nil];
						break;
					case 1:
						[self tapAndroid:nil];
						break;
					case 2:
						[self tapConsole:nil];
						break;
						
					default:
						[self tapIphoneos:nil];
				}
				
				if (autoBoot==1) {
					autobootToggle.on = YES;
				} else {
					autobootToggle.on = NO;
					timeoutSlider.enabled = NO;
				}
				
				timeoutSlider.value = formattedTimeout;
				timeoutValue.text = [NSString stringWithFormat:@"%d",formattedTimeout];
				
				UIAlertView *resetResults;
				resetResults = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Configuration reset to defaults." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[resetResults show];
				[resetResults release];
			} else {
				UIAlertView *resetResults;
				resetResults = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reset failed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[resetResults show];
				[resetResults release];
			}
		}
	}
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
