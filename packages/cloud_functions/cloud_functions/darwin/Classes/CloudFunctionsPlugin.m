// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "CloudFunctionsPlugin.h"

#import <firebase_core/FLTFirebasePlugin.h>
#import "Firebase/Firebase.h"

@interface CloudFunctionsPlugin ()
@property(nonatomic, retain) FlutterMethodChannel *_channel;
@end

@implementation CloudFunctionsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/cloud_functions"
                                  binaryMessenger:[registrar messenger]];
  CloudFunctionsPlugin *instance = [[CloudFunctionsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  SEL sel = NSSelectorFromString(@"registerLibrary:withVersion:");
  if ([FIRApp respondsToSelector:sel]) {
    [FIRApp performSelector:sel withObject:LIBRARY_NAME withObject:LIBRARY_VERSION];
  }
}

- (instancetype)init {
  self = [super init];
  return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
  if ([@"CloudFunctions#call" isEqualToString:call.method]) {
    NSString *functionName = call.arguments[@"functionName"];
    NSObject *parameters = call.arguments[@"parameters"];
    NSString *appName = call.arguments[@"app"];
    NSString *region = call.arguments[@"region"];
    NSString *origin = call.arguments[@"origin"];
    NSNumber *timeoutMicroseconds = call.arguments[@"timeoutMicroseconds"];

    FIRApp *app = [FLTFirebasePlugin firebaseAppNamed:appName];
    FIRFunctions *functions;
    if (region != nil && region != (id)[NSNull null]) {
      functions = [FIRFunctions functionsForApp:app region:region];
    } else {
      functions = [FIRFunctions functionsForApp:app];
    }
    if (origin != nil && origin != (id)[NSNull null]) {
      [functions useFunctionsEmulatorOrigin:origin];
    }
    FIRHTTPSCallable *function = [functions HTTPSCallableWithName:functionName];
    if (timeoutMicroseconds != nil && timeoutMicroseconds != [NSNull null]) {
      [function setTimeoutInterval:(NSTimeInterval)timeoutMicroseconds.doubleValue / 1000000];
    }
    [function callWithObject:parameters
                  completion:^(FIRHTTPSCallableResult *callableResult, NSError *error) {
                    if (error) {
                      FlutterError *flutterError;
                      if (error.domain == FIRFunctionsErrorDomain) {
                        NSDictionary *details = [NSMutableDictionary dictionary];
                        [details setValue:[self mapFunctionsErrorCodes:error.code] forKey:@"code"];
                        if (error.localizedDescription != nil) {
                          [details setValue:error.localizedDescription forKey:@"message"];
                        }
                        if (error.userInfo[FIRFunctionsErrorDetailsKey] != nil) {
                          [details setValue:error.userInfo[FIRFunctionsErrorDetailsKey]
                                     forKey:@"details"];
                        }

                        flutterError =
                            [FlutterError errorWithCode:@"functionsError"
                                                message:@"Firebase function failed with exception."
                                                details:details];
                      } else {
                        flutterError = [FlutterError
                            errorWithCode:[NSString stringWithFormat:@"%ld", error.code]
                                  message:error.localizedDescription
                                  details:nil];
                      }
                      result(flutterError);
                    } else {
                      result(callableResult.data);
                    }
                  }];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

// Map function error code objects to Strings that match error names on Android.
- (NSString *)mapFunctionsErrorCodes:(FIRFunctionsErrorCode)code {
  if (code == FIRFunctionsErrorCodeAborted) {
    return @"ABORTED";
  } else if (code == FIRFunctionsErrorCodeAlreadyExists) {
    return @"ALREADY_EXISTS";
  } else if (code == FIRFunctionsErrorCodeCancelled) {
    return @"CANCELLED";
  } else if (code == FIRFunctionsErrorCodeDataLoss) {
    return @"DATA_LOSS";
  } else if (code == FIRFunctionsErrorCodeDeadlineExceeded) {
    return @"DEADLINE_EXCEEDED";
  } else if (code == FIRFunctionsErrorCodeFailedPrecondition) {
    return @"FAILED_PRECONDITION";
  } else if (code == FIRFunctionsErrorCodeInternal) {
    return @"INTERNAL";
  } else if (code == FIRFunctionsErrorCodeInvalidArgument) {
    return @"INVALID_ARGUMENT";
  } else if (code == FIRFunctionsErrorCodeNotFound) {
    return @"NOT_FOUND";
  } else if (code == FIRFunctionsErrorCodeOK) {
    return @"OK";
  } else if (code == FIRFunctionsErrorCodeOutOfRange) {
    return @"OUT_OF_RANGE";
  } else if (code == FIRFunctionsErrorCodePermissionDenied) {
    return @"PERMISSION_DENIED";
  } else if (code == FIRFunctionsErrorCodeResourceExhausted) {
    return @"RESOURCE_EXHAUSTED";
  } else if (code == FIRFunctionsErrorCodeUnauthenticated) {
    return @"UNAUTHENTICATED";
  } else if (code == FIRFunctionsErrorCodeUnavailable) {
    return @"UNAVAILABLE";
  } else if (code == FIRFunctionsErrorCodeUnimplemented) {
    return @"UNIMPLEMENTED";
  } else {
    return @"UNKNOWN";
  }
}

@end
