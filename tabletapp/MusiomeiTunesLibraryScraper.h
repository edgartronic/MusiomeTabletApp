//
//  MusiomeiTunesLibraryScraper.h
//  tabletapp
//
//  Created by Edgar Nunez on 11/21/13.
//  Copyright (c) 2013 Musiome. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MusiomeiTunesLibraryScraperDelegate;

@interface MusiomeiTunesLibraryScraper : NSObject

+ (MusiomeiTunesLibraryScraper *)sharedScraper;
- (NSString *) getJSONForiTunesLibrary;

@property (nonatomic, assign) NSObject<MusiomeiTunesLibraryScraperDelegate> *delegate;

@end

@protocol MusiomeiTunesLibraryScraperDelegate <NSObject>

@optional

- (void) songScrapingDidBegin;
- (void) songScrapingDidSucceed;
- (void) songScrapingDidFail;

@end
