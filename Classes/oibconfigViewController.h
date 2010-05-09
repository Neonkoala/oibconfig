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
	IBOutlet UIButton *iphoneosImage;
	IBOutlet UILabel *androidLabel;
	IBOutlet UIButton *androidImage;
	IBOutlet UILabel *consoleLabel;
	IBOutlet UIButton *consoleImage;
	IBOutlet UISwitch *autobootToggle;
	IBOutlet UISlider *timeoutSlider;
	IBOutlet UILabel *timeoutValue;
	IBOutlet UITextView *cmdResult;

}

@property(nonatomic,retain) IBOutlet UILabel *iphoneosLabel;
@property(nonatomic,retain) IBOutlet UIButton *iphoneosImage;
@property(nonatomic,retain) IBOutlet UILabel *androidLabel;
@property(nonatomic,retain) IBOutlet UIButton *androidImage;
@property(nonatomic,retain) IBOutlet UILabel *consoleLabel;
@property(nonatomic,retain) IBOutlet UIButton *consoleImage;
@property(nonatomic,retain) IBOutlet UISwitch *autobootToggle;
@property(nonatomic,retain) IBOutlet UISlider *timeoutSlider;
@property(nonatomic,retain) IBOutlet UILabel *timeoutValue;
@property(nonatomic,retain) IBOutlet UITextView *cmdResult;

- (IBAction) tapIphoneos:(id)sender;
- (IBAction) tapAndroid:(id)sender;
- (IBAction) tapConsole:(id)sender;
- (IBAction) changeAutoboot:(id)sender;
- (IBAction) timeoutSliderValueChanged:(id)sender;
- (IBAction) backup:(id) sender;
- (IBAction) restore:(id) sender;
- (IBAction) apply:(id) sender;

@end

