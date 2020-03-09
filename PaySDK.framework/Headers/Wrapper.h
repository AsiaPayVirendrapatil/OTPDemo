//
//  Asiapay_alipay_sdk
//  Created by Virendra patil on 05/03/19.
//  Copyright © 2019 Virendra patil. All rights reserved.

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN



@interface Wrapper : NSObject 
+(Wrapper *) sharedWrapper;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_ref;


- (void) getWrappedV2 : (NSString *) param;
- (void) getWrapped : (NSString *) param;
- (void) processOrder : (NSURL *) url;
//static var shared = MakePayment()

@end


NS_ASSUME_NONNULL_END




