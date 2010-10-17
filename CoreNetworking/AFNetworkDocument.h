//
//  AFNetworkDocument.h
//  CoreNetworking
//
//  Created by Keith Duncan on 17/10/2010.
//  Copyright 2010 Realmac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol AFNetworkDocument <NSObject>

/*!
	\brief
	Used to convert the document into a wire format. This inefficiently decomposes the document into a single data object.
	
	\param dataRef
	Must not be NULL.
	
	\param contentTypeRef
	Must not be NULL.
	
	\return
	YES if the document could be decomposed, NO otherwise.
 */
- (BOOL)getData:(NSData **)dataRef contentType:(NSString **)contentTypeRef;

/*!
	\brief
	Used to convert the document into a wire format. This efficiently decomposes the document into multiple packets.
	
	\param contentTypeRef
	The document type.
	
	\param frameLengthRef
	Used for frame headers.
	
	\return
	An ordered collection of <AFPacketWriting> conforming objects which should be replayed over the wire.
	Nil return value means the document couldn't be converted.
 */
- (NSArray *)decomposeIntoPacketsWithContentType:(NSString **)contentTypeRef frameLength:(NSUInteger *)frameLengthRef;

@end
