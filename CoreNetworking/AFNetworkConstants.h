//
//  AFNetworkConstants.h
//  Amber
//
//  Created by Keith Duncan on 08/03/2009.
//  Copyright 2009 thirty-three. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
	@const
 */
extern NSString *const AFCoreNetworkingBundleIdentifier;

/*!
	@enum
 */
enum {
	AFNetworkingErrorNone					= 0,
	
	// AFNetworkSocketError					 [100, 299]
	AFNetworkSocketErrorUnknown				= 101,
	AFNetworkSocketErrorTimeout				= 102,
	
	// AFNetworkTransportError				 [300, 499]
	AFNetworkTransportErrorUnknown			= 301,
	AFNetworkTransportReachabilityError		= 302,
	AFNetworkTransportReadTimeoutError		= 304,
	AFNetworkTransportWriteTimeoutError		= 305,
	AFNetworkTransportTLSError				= 306,
	
	// AFPacketError						 [500, 699]
	AFNetworkPacketParseError				= 500,
};
typedef NSInteger AFNetworkingErrorCode;
