//
//  AFMacro.h
//  Amber
//
//  Created by Keith Duncan on 16/05/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AmberFoundation/NSString+Additions.h"

/*!
	@file
 */

#define NSSTRING_CONSTANT(var) NSString *const var = @#var

#define NSSTRING_CONTEXT(var) static NSString *var = @#var

static inline BOOL AFFileExistsAtLocation(NSURL *location) {
	return (location != nil && ![[location path] isEmpty] && [[NSFileManager defaultManager] fileExistsAtPath:[location path]]);
}
