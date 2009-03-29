//
//  NSTreeNode+Additions.m
//  Amber
//
//  Created by Keith Duncan on 22/08/2007.
//  Copyright 2007 thirty-three. All rights reserved.
//

#import "NSTreeNode+Additions.h"

@interface _NSControllerTreeProxy : NSObject {
    id _controller;
}

- (NSTreeNode *)descendantNodeAtIndexPath:(NSIndexPath *)path;

@end

@interface _NSControllerTreeProxy (AFPrivateAdditions)
- (void)addChildrenToCollection:(id)collection;
@end

// This function doesn't handle recursive relationships
void AddChildrenToCollection(id node, id collection) {	
	for (NSTreeNode *currentNode in [node childNodes]) {
		[collection addObject:currentNode];
		
		if ([currentNode isLeaf]) continue;
		AddChildrenToCollection(currentNode, collection);
	}
}

id CollectionFromNode(Class collectionClass, id node, BOOL inclusive) {
	id collection = [[[collectionClass alloc] init] autorelease];
	
	if (inclusive) [collection addObject:node];
	AddChildrenToCollection(node, collection);
	
	return collection;
}

@implementation _NSControllerTreeProxy (AFPrivateAdditions)

#warning this is a stop-gap measure until Apple fixes _NSControllerTreeProxy to inherit from NSTreeNode

- (NSSet *)objectsAtIndexPaths:(NSArray *)indexPaths {
	NSMutableSet *objects = [NSMutableSet setWithCapacity:[indexPaths count]];
	for (NSIndexPath *currentPath in indexPaths) [objects addObject:[self descendantNodeAtIndexPath:currentPath]];
	return objects;
}

- (NSMutableSet *)setFromNodeInclusive:(BOOL)inclusive {
	return CollectionFromNode([NSMutableSet class], self, inclusive);
}

- (NSMutableArray *)arrayFromNodeInclusive:(BOOL)inclusive {
	return CollectionFromNode([NSMutableArray class], self, inclusive);
}

- (void)addChildrenToCollection:(id)collection {
	AddChildrenToCollection(self, collection);
}

@end

@implementation NSTreeNode (AFPrivateAdditions)

- (NSSet *)objectsAtIndexPaths:(NSArray *)indexPaths {
	NSMutableSet *objects = [NSMutableSet setWithCapacity:[indexPaths count]];
	for (NSIndexPath *currentPath in indexPaths) [objects addObject:[self descendantNodeAtIndexPath:currentPath]];
	return objects;
}

- (NSMutableSet *)setFromNodeInclusive:(BOOL)inclusive {
	return CollectionFromNode([NSMutableSet class], self, inclusive);
}

- (NSMutableArray *)arrayFromNodeInclusive:(BOOL)inclusive {
	return CollectionFromNode([NSMutableArray class], self, inclusive);
}

- (void)addChildrenToCollection:(id)collection {
	AddChildrenToCollection(self, collection);
}

@end
