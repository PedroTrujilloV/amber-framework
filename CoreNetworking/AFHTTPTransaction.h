//
//  AFHTTPTransaction.h
//  Amber
//
//  Created by Keith Duncan on 18/05/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	\brief
	This class encapsulates a request/response pair.
 */
@interface AFHTTPTransaction : NSObject {
 @private
	NSArray *_requestPackets;
	NSArray *_responsePackets;
	
	void *_context;
}

/*!
	\brief
	This method retains the request and creates an empty response.
	A NULL request, will result in an empty request being allocated.
 */
- (id)initWithRequestPackets:(NSArray *)requestPackets responsePackets:(NSArray *)responsePackets context:(void *)context;

@property (readonly) NSArray *requestPackets;
@property (readonly) NSArray *responsePackets;

@property (readonly) void *context;

@end
