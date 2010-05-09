//
//  nvramutils.m
//  oibconfig
//
//  Created by Neonkoala on 03/05/2010.
//  Copyright 2010 yourcompany. All rights reserved.
//

#import "nvramutils.h"

@implementation nvramutils

- (int) backupNVRAM
{
	//check for backup first
	NSString* nvrambackup = @"/var/mobile/Documents/nvram.xml.backup";
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:nvrambackup];
	
	if(!fileExists){
		id mynvramutils;
		mynvramutils=[nvramutils new];

		NSString *filePath = @"/var/mobile/Documents/nvram.xml.backup";
		
		int gotNVRAM = [mynvramutils getNVRAM: filePath];

		if (gotNVRAM==0) {
			return 1;
		} else {
			return -1;
		}
	}
	
	return 0;
}

- (int) getNVRAM: (NSString*)filePath
{
	NSTask *dumpNVRAM;
	dumpNVRAM = [[NSTask alloc] init];
	[dumpNVRAM setLaunchPath: @"/usr/sbin/nvram"];
	
	NSArray *dumpNVRAMargs;
	dumpNVRAMargs = [NSArray arrayWithObjects: @"-x", @"-p", nil];
	[dumpNVRAM setArguments: dumpNVRAMargs];
	
	NSPipe *dumpNVRAMpipe;
	dumpNVRAMpipe = [NSPipe pipe];
	[dumpNVRAM setStandardOutput: dumpNVRAMpipe];
	
	NSFileHandle *dumpNVRAMfile;
	dumpNVRAMfile = [dumpNVRAMpipe fileHandleForReading];
	
	[dumpNVRAM launch];
	[dumpNVRAM waitUntilExit];
	
	NSData *dumpNVRAMdata;
	dumpNVRAMdata = [dumpNVRAMfile readDataToEndOfFile];
	
	NSString *string;
	string = [[NSString alloc] initWithData: dumpNVRAMdata encoding: NSUTF8StringEncoding];
	
	NSError *error = [[NSError alloc] init];
	[string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if (fileExists) {
		return 0;
	} else {
		return -1;
	}
}

- (int) updateNVRAM:(NSString*)filePath usingOutput:(NSString**)cmdout
{
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
	
	if (fileExists) {
		NSTask *writeNVRAM;
		writeNVRAM = [[NSTask alloc] init];
		[writeNVRAM setLaunchPath: @"/usr/sbin/nvram"];
		
		NSArray *writeNVRAMargs;
		writeNVRAMargs = [NSArray arrayWithObjects: @"-x", @"-f", filePath, nil];
		[writeNVRAM setArguments: writeNVRAMargs];
		
		NSPipe *writeNVRAMpipe;
		writeNVRAMpipe = [NSPipe pipe];
		[writeNVRAM setStandardOutput: writeNVRAMpipe];
		
		NSFileHandle *writeNVRAMfile;
		writeNVRAMfile = [writeNVRAMpipe fileHandleForReading];
		
		[writeNVRAM launch];
		[writeNVRAM waitUntilExit];
		int status = [writeNVRAM terminationStatus];
		
		NSData *writeNVRAMdata;
		writeNVRAMdata = [writeNVRAMfile readDataToEndOfFile];
		
		NSString *string;
		string = [[NSString alloc] initWithData: writeNVRAMdata encoding: NSUTF8StringEncoding];
		
		if (status == 0) {
			*cmdout = @"Successfully updated the NVRAM.\n";
			return 0;
		} else {
			*cmdout = string;
			return status;
		}
		
	} else {
		*cmdout = @"File doesn't exist. Failed to update NVRAM from file.";
				
		return 1;
	}
}

- (int) parseNVRAMXML:(NSString*)filePath
{
	NSMutableDictionary* dictnvram = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
	
	NSLog(@"%@", dictnvram);
	
	NSData* rawtimeout = [dictnvram objectForKey:@"opib-menu-timeout"];
	NSString* timeout = [NSString stringWithCString:[rawtimeout bytes] encoding:NSUTF8StringEncoding];
	NSData* rawdefaultos = [dictnvram objectForKey:@"opib-default-os"];
	NSString* defaultos = [NSString stringWithCString:[rawdefaultos bytes] encoding:NSUTF8StringEncoding];
	NSData* rawautoboot = [dictnvram objectForKey:@"opib-auto-boot"];
	NSString* autoboot = [NSString stringWithCString:[rawautoboot bytes] encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", timeout);
	NSLog(@"%@", defaultos);
	NSLog(@"%@", autoboot);
	
	dataclass *thisconfig = [dataclass nvramconfig];
	
	thisconfig.timeout = timeout;
	thisconfig.defaultos = defaultos;
	thisconfig.autoboot = autoboot;
	
	return 0;
}

- (int) grabNVRAM
{
	id grabnvramutils;
	grabnvramutils=[nvramutils new];
	
	int backup = [grabnvramutils backupNVRAM];
	
	if (backup<0) {
		NSLog(@"NVRAM Backup failed.");
		return -1;
	}
	
	NSString* xmlPath = @"/var/mobile/Documents/NVRAM.xml";
	
	int getnew = [grabnvramutils getNVRAM:xmlPath];
	
	if (getnew!=0) {
		NSLog(@"Failed to obtain working copy of NVRAM.");
		return -2;
	}
	
	int parsed = [grabnvramutils parseNVRAMXML:xmlPath];
	
	if (parsed!=0) {
		NSLog(@"Failed to parse NVRAM dump.");
		return -3;
	}
	
	return 0;
}

@end
