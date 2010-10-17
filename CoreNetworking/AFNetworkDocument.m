//
//  AFNetworkDocument.m
//  CoreNetworking
//
//  Created by Keith Duncan on 17/10/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import "AFNetworkDocument.h"

#import "AFPacket.h"

NSString *const AFNetworkDocumentMIMEContentType = @"Content-Type";
NSString *const AFNetworkDocumentMIMEContentTransferEncoding = @"Content-Transfer-Encoding";
NSString *const AFNetworkDocumentMIMEContentDisposition = @"Content-Disposition";

@implementation AFNetworkDocument

- (NSArray *)serialisedPacketsWithContentType:(NSString **)contentTypeRef frameLength:(NSUInteger *)frameLengthRef {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (NSData *)serialisedDataWithContentType:(NSString **)contentTypeRef {
	NSUInteger frameLength = 0;
	NSArray *writePackets = [self serialisedPacketsWithContentType:contentTypeRef frameLength:&frameLength];
	if (writePackets == nil) return nil;
	
	uint8_t *buffer = (uint8_t *)malloc(frameLength);
	NSOutputStream *memoryStream = [NSOutputStream outputStreamToBuffer:buffer capacity:frameLength];
	
	// Note: this ensures the buffer is free()'d if we bail inside the loop
	NSData *dataBuffer = [NSData dataWithBytesNoCopy:buffer length:frameLength freeWhenDone:YES];
	
	for (AFPacket <AFPacketWriting> *currentPacket in writePackets) {
		__block NSNotification *completionNotification = nil;
		id completionListener = [[NSNotificationCenter defaultCenter] addObserverForName:AFPacketDidCompleteNotificationName object:currentPacket queue:nil usingBlock:^ (NSNotification *notification) {
			completionNotification = notification;
		}];
		
		while (completionListener == nil) {
			[currentPacket performWrite:memoryStream];
		}
		
		[[NSNotificationCenter defaultCenter] removeObserver:completionListener];
		
		
		NSError *completionError = [[completionNotification userInfo] objectForKey:AFPacketErrorKey];
		if (completionError != nil) {
			return nil;
		}
		
		continue;
	}
	
	return dataBuffer;
}

@end
