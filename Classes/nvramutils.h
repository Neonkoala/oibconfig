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
#include <sys/types.h>

@interface nvramutils : NSObject {

}

- (int) backupNVRAM;
- (int) getNVRAM:(NSString*)filePath;
- (int) updateNVRAM:(NSString*)filePath usingOutput:(NSString**)cmdout;
- (int) parseNVRAM:(NSString*)filePath;
- (int) generateNVRAM:(NSString*)filePath;
- (int) grabNVRAM;

@end
