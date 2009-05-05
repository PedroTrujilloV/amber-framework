//
//  AFNetworkObject.m
//  Amber
//
//  Created by Keith Duncan on 04/05/2009.
//  Copyright 2009 thirty-three. All rights reserved.
//

#import "AFNetworkLayer.h"

#import <objc/runtime.h>

#import "AmberFoundation/AFPriorityProxy.h"

@interface AFNetworkLayer ()
@property (readwrite, retain) id <AFTransportLayer> lowerLayer;
@property (readwrite, retain) NSMutableDictionary *transportInfo;
@end

@implementation AFNetworkLayer

@synthesize lowerLayer=_lowerLayer;
@synthesize delegate=_delegate;
@synthesize transportInfo=_transportInfo;

+ (Class)lowerLayerClass {
	[self doesNotRecognizeSelector:_cmd];
	return Nil;
}

- (id)init {
	self = [super init];
	if (self == nil) return nil;
	
	self.transportInfo = [NSMutableDictionary dictionary];
	
	return self;
}

- (id)initWithLowerLayer:(id <AFTransportLayer>)layer {
	self = [self init];
	if (self == nil) return nil;
	
	self.lowerLayer = layer;
	self.lowerLayer.delegate = (id)self;
	
	return self;
}

- (id <AFTransportLayer>)initWithSignature:(const AFNetworkTransportPeerSignature *)signature {	
	id <AFTransportLayer> lowerLayer = [[[[[self class] lowerLayerClass] alloc] initWithSignature:signature] autorelease];
	return [self initWithLowerLayer:lowerLayer];
}

- (id <AFTransportLayer>)initWithNetService:(id <AFNetServiceCommon>)netService {
	id <AFTransportLayer> lowerLayer = [[[[[self class] lowerLayerClass] alloc] initWithNetService:netService] autorelease];
	return [self initWithLowerLayer:lowerLayer];
}

- (void)dealloc {
	self.lowerLayer = nil;
	self.transportInfo = nil;
	
	[super dealloc];
}

- (id)forwardingTargetForSelector:(SEL)selector {
	return self.lowerLayer;
}

- (BOOL)respondsToSelector:(SEL)selector {
	return ([super respondsToSelector:selector] || [[self forwardingTargetForSelector:selector] respondsToSelector:selector]);
}

- (AFPriorityProxy *)delegateProxy:(AFPriorityProxy *)proxy {
	if (proxy == nil) proxy = [[[AFPriorityProxy alloc] init] autorelease];
	
	id delegate = nil;
	object_getInstanceVariable(self, "_delegate", (void **)&delegate);
	// Note: this intentionally doesn't use the accessor, I changed it before and left this comment here to warn me off next time.
	
	if ([delegate respondsToSelector:@selector(delegateProxy:)]) proxy = [(id)delegate delegateProxy:proxy];
	[proxy insertTarget:delegate atPriority:0];
	
	return proxy;
}

- (id)delegate {
	return [self delegateProxy:nil];
}

@end
