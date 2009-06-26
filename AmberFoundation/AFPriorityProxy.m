//
//  AFPriorityProxy.m
//  Priority
//
//  Created by Keith Duncan on 22/03/2009.
//  Copyright 2009 thirty-three. All rights reserved.
//

#import "AFPriorityProxy.h"

@implementation AFPriorityProxy

- (id)init {
	dispatchOrder = [[NSMutableArray alloc] init];
	
	dispatchMap = [[NSMapTable alloc] initWithKeyOptions:(NSPointerFunctionsOpaqueMemory | NSPointerFunctionsOpaquePersonality) valueOptions:(NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality) capacity:/* Default CF collection capacity */ 3];
	
	return self;
}

- (void)dealloc {
	[dispatchOrder release];
	[dispatchMap release];
	
	[super dealloc];
}

- (NSString *)description {
	NSMutableString *description = [[[super description] mutableCopy] autorelease];
	
	[description appendString:@" {"];
	[description appendFormat:@"\n\tDispatch Order: %@", dispatchOrder, nil];
	[description appendString:@"\n}"];
	
	return description;
}

- (BOOL)respondsToSelector:(SEL)selector {
	for (id currentDispatchTarget in dispatchOrder)
		if ([currentDispatchTarget respondsToSelector:selector])
			return YES;
	
	return NO;
}

- (void)insertTarget:(id)sender {
	[dispatchOrder insertObject:sender atIndex:0];
}

- (void)appendTarget:(id)sender {
	[dispatchOrder addObject:sender];
}

- (void)_setDispatchedTargets:(NSMutableArray *)targets forSelector:(SEL)selector {
	if (targets != nil)
		NSMapInsert(dispatchMap, selector, targets);
	else
		NSMapRemove(dispatchMap, selector);
}

- (NSMutableArray *)_dispatchedTargetsForSelector:(SEL)selector {
	NSMutableArray *dispatchedTargets = NSMapGet(dispatchMap, selector);
	
	if (dispatchedTargets == nil) {
		dispatchedTargets = [NSMutableArray array];
		[self _setDispatchedTargets:dispatchedTargets forSelector:selector];
	}
	
	return dispatchedTargets;
}

- (id)_dispatchTargetForSelector:(SEL)selector {
	id dispatchTarget = nil;
	for (NSUInteger index = 0; index < [dispatchOrder count]; index++) {
		id currentDispatchTarget = [dispatchOrder objectAtIndex:index];
		
		if (![currentDispatchTarget respondsToSelector:selector]) continue;
		if ([[self _dispatchedTargetsForSelector:selector] containsObject:currentDispatchTarget]) continue;
		
		return currentDispatchTarget;
	}
	
	return nil;
}

- (void)_addDispatchedTarget:(id)target forSelector:(SEL)selector {
	NSMutableArray *dispatchedTargets = [self _dispatchedTargetsForSelector:selector];
	[dispatchedTargets addObject:target];
}

- (void)_removeDispatchedTarget:(id)target forSelector:(SEL)selector {
	NSMutableArray *dispatchedTargets = [self _dispatchedTargetsForSelector:selector];
	[dispatchedTargets removeObject:target];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	SEL selector = [invocation selector];
	id dispatchTarget = [self _dispatchTargetForSelector:selector];
	
	if (dispatchTarget == nil) {
		[NSException raise:NSInternalInconsistencyException format:@"%s, cannot dispatch to a nil target", __PRETTY_FUNCTION__, nil];
		return;
	}
	
	[self _addDispatchedTarget:dispatchTarget forSelector:selector];
	[invocation invokeWithTarget:dispatchTarget];
	[self _removeDispatchedTarget:dispatchTarget forSelector:selector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
	return [[self _dispatchTargetForSelector:selector] methodSignatureForSelector:selector];
}

@end
