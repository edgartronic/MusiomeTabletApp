//
//  MusiomeWebServiceManager.m
//  tabletapp
//
//  Created by Edgar Nunez on 11/21/13.
//  Copyright (c) 2013 Musiome. All rights reserved.
//

#import "MusiomeWebServiceManager.h"

@implementation MusiomeWebServiceManager

+ (MusiomeWebServiceManager *)sharedManager;
{
    static MusiomeWebServiceManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[MusiomeWebServiceManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedManager;
}

@end
