//
//  nvramutils.h
//  oibconfig
//
//  Created by Neonkoala on 03/05/2010.
//  Copyright 2010 yourcompany. All rights reserved.
//

#import "dataclass.h"
#import <Foundation/Foundation.h>
#import <Foundation/NSTask.h>
#import <UIKit/UIKit.h>
#include <sys/types.h>

@interface nvramutils : NSObject {

}

-(int)nvramHook:(NSString *)filePath withArgs:(NSArray *)arguments withMode:(int)rorw;
-(int)nvramBackup:(BOOL)withOverwrite;
-(int)nvramDump:(NSString *)filePath;
-(int)nvramWrite:(NSString *)filePath;
-(int)nvramParse:(NSString *)filePath;
-(int)nvramGenerate:(NSString *)filePath;
-(int)nvramInit;
-(int)nvramReset;

@end
