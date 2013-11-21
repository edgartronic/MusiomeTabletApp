//
//  MusiomeWebServiceManager.h
//  tabletapp
//
//  Created by Edgar Nunez on 11/21/13.
//  Copyright (c) 2013 Musiome. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MusiomeWebServiceManagerDelegate;

@interface MusiomeWebServiceManager : NSObject

+ (MusiomeWebServiceManager *)sharedManager;

@property (nonatomic, assign) NSObject<MusiomeWebServiceManagerDelegate> *delegate;

@end


// Delegate methods. Yay delegation!
@protocol MusiomeWebServiceManagerDelegate <NSObject>

@optional

@end

