//
//  isDebugged.m
//  interfaceFor3DS
//
//  Created by Vaibhav on 28/12/18.
//  Copyright © 2018 Vaibhav. All rights reserved.
//

#import "isDebugged.h"
#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>
#import <Security/Security.h>
#import <CommonCrypto/CommonHMAC.h>


@implementation isDebugged

- (BOOL) AmIBeingDebugged {
    // Returns true if the current process is being debugged (either
    // running under the debugger or has a debugger attached post facto).
    //{
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
    
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
    
    info.kp_proc.p_flag = 0;
    
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    
    // Call sysctl.
    
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
    
    // We're being debugged if the P_TRACED flag is set.
    
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}


- (NSDictionary *) getDecodedCode: (NSString *)code {
    NSData *clearHeader = [self decodeBase64FromString:code];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:clearHeader
                                                         options:kNilOptions
                                                           error:&error];
    return json;
}


- (void)verifyWithSecKey:(SecKeyRef)keyRef :(NSData *)data : (NSData *) signature {
    uint8_t hash[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256((const void *)[data bytes], [data length], (unsigned char *)hash);
    OSStatus status = SecKeyRawVerify (keyRef, kSecPaddingPKCS1SHA256, hash, CC_SHA256_DIGEST_LENGTH, (const uint8_t *)[signature bytes], [signature length]);
    NSLog(@"%d",(int)status);
}


- (NSData *) hexa : (NSString *) command {
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i = 0; i < ([command length] / 2); i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}


- (NSData *) decodeBase64FromString: (NSString *) base64String {
    return  [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
}


- (NSString *)hmacSHA256EncryptString : (NSString *) parameterSecret : (NSString *) plainString {
    
    //NSString * parameterSecret = @"input secret key";
    //NSString *plainString = @"input encrypt content string";
    const char *secretKey  = [parameterSecret cStringUsingEncoding:NSUTF8StringEncoding];
    const char *plainData = [plainString cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, secretKey, strlen(secretKey), plainData, strlen(plainData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *bufferChar = (const unsigned char *)[HMACData bytes];
    NSMutableString *hmacString = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i) {
        [hmacString appendFormat:@"%02x", bufferChar[i]];
    }
    return hmacString;
    
}


@end


