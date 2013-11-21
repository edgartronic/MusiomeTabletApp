//
//  MusiomeiTunesLibraryScraper.m
//  tabletapp
//
//  Created by Edgar Nunez on 11/21/13.
//  Copyright (c) 2013 Musiome. All rights reserved.
//

#import "MusiomeiTunesLibraryScraper.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation MusiomeiTunesLibraryScraper

@synthesize delegate;

+ (MusiomeiTunesLibraryScraper *)sharedScraper;
{
    static MusiomeiTunesLibraryScraper *sharedScraper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedScraper = [[MusiomeiTunesLibraryScraper alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedScraper;
}

- (NSString *) getJSONForiTunesLibrary {
    
    [delegate songScrapingDidBegin];
    
    // JSON payload construction
    NSMutableString *JSONString = [NSMutableString string];
    [JSONString appendString: @"{\"tracks\":["];
    
    MPMediaQuery *songQuery = [MPMediaQuery songsQuery];
    
    NSArray *songsFromSongQuery = [songQuery items];
    
    // if no songs, error out & stop.
    if ([songQuery items].count == 0) {
        NSLog(@"no songs returned.");
        [delegate songScrapingDidFail];
        return Nil;
    }
    
    for (MPMediaItem *song in songsFromSongQuery) {
        
        NSMutableString *songString = [NSMutableString string];
        [songString appendString:@"{\n"];
        
        // Song Title
        NSString *songTitle = [NSString stringWithFormat:@"\"Name\": \"%@\",\n",[song valueForProperty: MPMediaItemPropertyTitle]];
        
        // Artist Name
        NSString *songArtistName = [NSString stringWithFormat:@"\"Artist\": \"%@\",\n", [song valueForProperty: MPMediaItemPropertyArtist]];
        
        // Album Artist Name
        NSString *songAlbumArtistName = [NSString stringWithFormat:@"\"AlbumArtist\": \"%@\",\n", [song valueForProperty: MPMediaItemPropertyAlbumArtist]];
        
        // Composer
        NSString *songComposer = [NSString stringWithFormat:@"\"Composer\": \"%@\",\n", [song valueForProperty: MPMediaItemPropertyComposer]];
        
        // Album
        NSString *albumName = [NSString stringWithFormat:@"\"Album\": \"%@\",\n", [song valueForProperty: MPMediaItemPropertyAlbumTitle]];
        
        // Genre
        NSString *genre = [NSString stringWithFormat:@"\"Genre\": \"%@\",\n",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyGenre]]];
        
        // Year
        NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat: @"YYYY"];
        
        NSString *year = [NSString stringWithFormat:@"\"Year\": \"%@\",\n", [yearFormatter stringFromDate: [song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyReleaseDate]]]];
        
        // BPM
        NSString *bpm = [NSString stringWithFormat:@"\"BPM\": \"%@\",\n",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyBeatsPerMinute]]];
        
        // Play Count
        NSString *playCount = [NSString stringWithFormat:@"\"PlayCount\": \"%@\",\n",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyPlayCount]]];
        
        // Skip Count
        NSString *skipCount = [NSString stringWithFormat:@"\"SkipCount\": \"%@\",\n",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertySkipCount]]];

        // Rating
        NSString *rating = [NSString stringWithFormat:@"\"Rating\": \"%@\",\n",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyRating]]];
        
        // Persistent ID
        NSString *persistentID = [NSString stringWithFormat:@"\"PersistentID\": \"%@\"\n",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyPersistentID]]];
        
        [songString appendString: songTitle];
        [songString appendString: songArtistName];
        [songString appendString: songAlbumArtistName];
        [songString appendString: songComposer];
        [songString appendString: albumName];
        [songString appendString: genre];
        [songString appendString: year];
        [songString appendString: bpm];        
        [songString appendString: playCount];
        [songString appendString: skipCount];
        [songString appendString: rating];
        [songString appendString: persistentID];
        [songString appendString:@"}\n"];
        
        [JSONString appendString: songString];
        
    }
    
    [JSONString appendString:@"]}"];

    [delegate songScrapingDidSucceed];
    
    return JSONString;
}

@end
