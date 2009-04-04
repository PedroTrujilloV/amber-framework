//
//  AFPacketRead.h
//  Amber
//
//  Created by Keith Duncan on 15/03/2009.
//  Copyright 2009 thirty-three. All rights reserved.
//

#import "CoreNetworking/AFPacket.h"

@interface AFPacketRead : AFPacket {
	CFIndex _bytesRead;	
	NSMutableData *_buffer;
	
	NSData *_terminator;
	NSUInteger _maximumLength;
}

- (id)initWithTag:(NSUInteger)tag timeout:(NSTimeInterval)duration terminator:(id)terminator;

/*!
	@method	
	@result	true if the packet is complete
 */
- (BOOL)performRead:(CFReadStreamRef)stream error:(NSError **)errorRef;

@end
