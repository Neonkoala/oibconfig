/*
 *  nvramutils.h
 *  oibconfig
 *
 *  Created by Neonkoala on 03/05/2010.
 *  Copyright 2010 yourcompany. All rights reserved.
 *
 */

#import <Foundation/NSXMLParser.h>
#import <Foundation/NSTask.h>

- (int) backupNVRAM;
- (int) updateNVRAM;
- (int) getNVRAM;
- (int) generateNVRAMXML;
- (int) parseNVRAMXML;