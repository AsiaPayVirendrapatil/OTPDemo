//
//  isDebugged.h
//  interfaceFor3DS
//
//  Created by Vaibhav on 28/12/18.
//  Copyright © 2018 Vaibhav. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BasicEncodingRules.h"
NS_ASSUME_NONNULL_BEGIN

@interface isDebugged : NSObject

- (BOOL) AmIBeingDebugged;

- (NSData *) hexa : (NSString *) command;

@end

NS_ASSUME_NONNULL_END

