//
//  AFHTTPServer.h
//  pangolin
//
//  Created by Keith Duncan on 01/06/2009.
//  Copyright 2009. All rights reserved.
//

#import "CoreNetworking/AFNetworkServer.h"

@class AFHTTPServer;

@protocol AFHTTPServerDataDelegate <AFNetworkServerDelegate>

 @optional

/*!
	\brief
	The delegate is asked last, after each of the renderers.
 */
- (CFHTTPMessageRef)networkServer:(AFHTTPServer *)server renderResourceForRequest:(CFHTTPMessageRef)request;

@end

/*!
	\brief
	This is a simple HTTP server which attempts to return resources sourced through two means.
	It first consults the delegate to return a CFHTTPMessageRef response for a given request, if NULL 
 */
@interface AFHTTPServer : AFNetworkServer {
 @private
	NSArray *_renderers;
}

/*!
	\brief
	The HTTP server delegate participates in the response rendering process.
 */
@property (assign) id <AFHTTPServerDataDelegate> delegate;

/*!
	\brief
	The objects in this collection must implement the AFHTTPServerRenderer protocol.
	
	\details
	Each of these objects is consulted in order to render the resource, if NULL is returned the next is consulted.
 */
@property (copy) NSArray *renderers;

@end

@protocol AFHTTPServerRenderer <NSObject>

- (CFHTTPMessageRef)renderResourceForRequest:(CFHTTPMessageRef)request;

@end
