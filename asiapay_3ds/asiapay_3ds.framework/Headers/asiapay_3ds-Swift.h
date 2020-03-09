// Generated by Apple Swift version 4.2.1 (swiftlang-1000.11.42 clang-1000.11.45.1)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import ObjectiveC;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="asiapay_3ds",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif


SWIFT_CLASS("_TtC11asiapay_3ds22AbstractNetworkRequest")
@interface AbstractNetworkRequest : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11asiapay_3ds20ConfigurationManager")
@interface ConfigurationManager : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull REFERENCE_APP_SERVER_IP;)
+ (NSString * _Nonnull)REFERENCE_APP_SERVER_IP SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull REFERENCE_APP_SERVER_PORT;)
+ (NSString * _Nonnull)REFERENCE_APP_SERVER_PORT SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull PROTOCOL;)
+ (NSString * _Nonnull)PROTOCOL SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull SDK_VENDOR_HEADER_KEY;)
+ (NSString * _Nonnull)SDK_VENDOR_HEADER_KEY SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull SDK_VENDOR_KEY_VALUE;)
+ (NSString * _Nonnull)SDK_VENDOR_KEY_VALUE SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull THREE_DS_SERVER_ENDPOINT;)
+ (NSString * _Nonnull)THREE_DS_SERVER_ENDPOINT SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull RAS_FETCH_TC_MESSAGE_ENDPOINT;)
+ (NSString * _Nonnull)RAS_FETCH_TC_MESSAGE_ENDPOINT SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull RAS_DELETE_ALL_TC_MESSAGES_ENDPOINT;)
+ (NSString * _Nonnull)RAS_DELETE_ALL_TC_MESSAGES_ENDPOINT SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull DEVICE_INFO;)
+ (NSString * _Nonnull)DEVICE_INFO SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull RAS_NOTIFY_TEST_MANAEGMENT_ENDPOINT;)
+ (NSString * _Nonnull)RAS_NOTIFY_TEST_MANAEGMENT_ENDPOINT SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull REFERENCE_APP_SERVER_SCREENSHOT_ENDPOINT;)
+ (NSString * _Nonnull)REFERENCE_APP_SERVER_SCREENSHOT_ENDPOINT SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull API_KEY;)
+ (NSString * _Nonnull)API_KEY SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull CARDHOLDER_ENDPOINT;)
+ (NSString * _Nonnull)CARDHOLDER_ENDPOINT SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull ENVIRONMENT_NAME;)
+ (NSString * _Nonnull)ENVIRONMENT_NAME SWIFT_WARN_UNUSED_RESULT;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, copy) NSString * _Nonnull challengeUrl;)
+ (NSString * _Nonnull)challengeUrl SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class Emvco3dsFrameworkManager;
@class NSBundle;
@class UINavigationController;

SWIFT_CLASS("_TtC11asiapay_3ds17Emvco3dsFramework")
@interface Emvco3dsFramework : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL isRegressionTest;)
+ (BOOL)isRegressionTest SWIFT_WARN_UNUSED_RESULT;
+ (void)setIsRegressionTest:(BOOL)value;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) Emvco3dsFrameworkManager * _Nonnull manager;)
+ (Emvco3dsFrameworkManager * _Nonnull)manager SWIFT_WARN_UNUSED_RESULT;
+ (void)setManager:(Emvco3dsFrameworkManager * _Nonnull)value;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) NSBundle * _Nullable bundle;)
+ (NSBundle * _Nullable)bundle SWIFT_WARN_UNUSED_RESULT;
+ (void)setBundle:(NSBundle * _Nullable)value;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL isFetchingTestcases;)
+ (BOOL)isFetchingTestcases SWIFT_WARN_UNUSED_RESULT;
+ (void)setIsFetchingTestcases:(BOOL)value;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class) BOOL isCurrentTestcaseFinished;)
+ (BOOL)isCurrentTestcaseFinished SWIFT_WARN_UNUSED_RESULT;
+ (void)setIsCurrentTestcaseFinished:(BOOL)value;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, strong) UINavigationController * _Nullable navigationController;)
+ (UINavigationController * _Nullable)navigationController SWIFT_WARN_UNUSED_RESULT;
+ (void)setNavigationController:(UINavigationController * _Nullable)value;
+ (void)setContinuousFetchingWithValue:(BOOL)value;
+ (void)clearLogResults;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC11asiapay_3ds24Emvco3dsFrameworkManager")
@interface Emvco3dsFrameworkManager : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@protocol SDKChallengeProtocol;

SWIFT_PROTOCOL("_TtP11asiapay_3ds24GenericChallengeProtocol_")
@protocol GenericChallengeProtocol
- (void)clickVerifyButton;
- (NSString * _Nonnull)getChallengeType SWIFT_WARN_UNUSED_RESULT;
- (void)clickCancelButton;
- (void)setChallengeProtocolWithChallegeprotocol:(id <SDKChallengeProtocol> _Nonnull)challegeprotocol;
- (void)expandTextsBeforeScreenshot;
- (void)selectWhitelistCheckedWithChecked:(BOOL)checked;
@end


SWIFT_PROTOCOL("_TtP11asiapay_3ds28MultiSelectChallengeProtocol_")
@protocol MultiSelectChallengeProtocol <GenericChallengeProtocol>
- (void)selectIndex:(NSInteger)index;
@end


SWIFT_PROTOCOL("_TtP11asiapay_3ds26OutOfBandChallengeProtocol_")
@protocol OutOfBandChallengeProtocol <GenericChallengeProtocol>
@end


SWIFT_CLASS("_TtC11asiapay_3ds5PAReq")
@interface PAReq : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC11asiapay_3ds18RequesterConnector")
@interface RequesterConnector : AbstractNetworkRequest
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_PROTOCOL("_TtP11asiapay_3ds20SDKChallengeProtocol_")
@protocol SDKChallengeProtocol
- (void)handleChallenge;
@end


SWIFT_CLASS("_TtC11asiapay_3ds14SdkEphemPubKey")
@interface SdkEphemPubKey : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_PROTOCOL("_TtP11asiapay_3ds31SingleSelectorChallengeProtocol_")
@protocol SingleSelectorChallengeProtocol <GenericChallengeProtocol>
- (void)selectObject:(NSInteger)index;
@end


SWIFT_PROTOCOL("_TtP11asiapay_3ds21TextChallengeProtocol_")
@protocol TextChallengeProtocol <GenericChallengeProtocol>
- (void)typeTextChallengeValue:(NSString * _Nonnull)value;
@end

@class UIViewController;

SWIFT_CLASS("_TtC11asiapay_3ds18TransactionManager")
@interface TransactionManager : NSObject
- (NSString * _Nonnull)getSdkVersion SWIFT_WARN_UNUSED_RESULT;
- (void)initializeSdk;
- (void)startAResAResFlowWithPAreq:(PAReq * _Nonnull)pAreq projectId:(NSString * _Nonnull)projectId uiViewController:(UIViewController * _Nonnull)uiViewController;
- (void)onFailureWithErrorMessage:(NSString * _Nonnull)errorMessage;
- (void)onResponseWithResponseObject:(NSObject * _Nonnull)responseObject;
- (void)onErrorResponseWithErrorMessage:(NSString * _Nonnull)errorMessage;
- (void)cancelled;
- (void)timedout;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end



#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
