//
//  oibconfigViewController.h
//  oibconfig
//
//  Created by Neonkoala on 02/05/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "nvramutils.h"
#import "dataclass.h"
#import <UIKit/UIKit.h>
#import <Foundation/NSTask.h>

extern NSMutableArray* nvramconfig;

@interface oibconfigViewController : UIViewController {
	IBOutlet UILabel *iphoneosLabel;
	IBOutlet UILabel *androidLabel;
	IBOutlet UILabel *consoleLabel;
	IBOutlet UISwitch *autobootToggle;
	IBOutlet UISlider *timeoutSlider;
	IBOutlet UILabel *timeoutValue;
	IBOutlet UITextView *cmdResult;

}

@property(nonatomic,retain) IBOutlet UILabel *iphoneosLabel;
@property(nonatomic,retain) IBOutlet UILabel *androidLabel;
@property(nonatomic,retain) IBOutlet UILabel *consoleLabel;
@property(nonatomic,retain) IBOutlet UISwitch *autobootToggle;
@property(nonatomic,retain) IBOutlet UISlider *timeoutSlider;
@property(nonatomic,retain) IBOutlet UILabel *timeoutValue;
@property(nonatomic,retain) IBOutlet UITextView *cmdResult;

- (IBAction) timeoutSliderValueChanged:(id)sender;
- (IBAction) backup:(id) sender;
- (IBAction) getnew:(id) sender;
- (IBAction) update:(id) sender;
- (IBAction) parsexml:(id) sender;

@end

