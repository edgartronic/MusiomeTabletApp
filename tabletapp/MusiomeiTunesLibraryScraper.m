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
        [songString appendString:@"{"];
        
        // Song Title
        NSString *songTitle = [NSString stringWithFormat:@"\"Name\":\"%@\",",[song valueForProperty: MPMediaItemPropertyTitle]];
        
        // Artist Name
        NSString *songArtistName = [NSString stringWithFormat:@"\"Artist\":\"%@\",", [song valueForProperty: MPMediaItemPropertyArtist]];
        
        // Album Artist Name
        NSString *songAlbumArtistName = [NSString stringWithFormat:@"\"AlbumArtist\":\"%@\",", [song valueForProperty: MPMediaItemPropertyAlbumArtist]];
        
        // Composer
        NSString *songComposer = [NSString stringWithFormat:@"\"Composer\":\"%@\",", [song valueForProperty: MPMediaItemPropertyComposer]];
        
        // Album
        NSString *albumName = [NSString stringWithFormat:@"\"Album\":\"%@\",", [song valueForProperty: MPMediaItemPropertyAlbumTitle]];
        
        // Genre
        NSString *genre = [NSString stringWithFormat:@"\"Genre\":\"%@\",",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyGenre]]];
        
        // Year
        NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat: @"YYYY"];
        
        NSString *year = [NSString stringWithFormat:@"\"Year\":\"%@\",", [yearFormatter stringFromDate: [song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyReleaseDate]]]];
        
        // BPM
        NSString *bpm = [NSString stringWithFormat:@"\"BPM\":\"%@\",",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyBeatsPerMinute]]];
        
        // Play Count
        NSString *playCount = [NSString stringWithFormat:@"\"PlayCount\":\"%@\",",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyPlayCount]]];
        
        // Skip Count
        NSString *skipCount = [NSString stringWithFormat:@"\"SkipCount\":\"%@\",",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertySkipCount]]];

        // Rating
        NSString *rating = [NSString stringWithFormat:@"\"Rating\":\"%@\",",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyRating]]];
        
        // Persistent ID
        NSString *persistentID = [NSString stringWithFormat:@"\"PersistentID\":\"%@\"",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyPersistentID]]];
        
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
        
        if ([songsFromSongQuery lastObject] == song) {
            [songString appendString:@"}"];
        } else {
            [songString appendString:@"},"];
        }
        
        [JSONString appendString: songString];
        
    }
    
    [JSONString appendString:@"]}"];

    [delegate songScrapingDidSucceed];
    
    return JSONString;
}

- (NSString *) getJSONForiTunesPlaylists {
    
    [delegate playlistScrapingDidBegin];
    
    MPMediaQuery *playlistQuery = [MPMediaQuery playlistsQuery];
    
    NSArray *playlistsFromQuery = [playlistQuery collections];
    
    NSMutableString *JSONString = [NSMutableString string];
    [JSONString appendString: @"{\"Playlists\":["];
    
    // if no songs, error out & stop.
    if ([playlistQuery items].count == 0) {
        [delegate playlistScrapingDidFail];
        return Nil;
    }
    
    for (MPMediaPlaylist *playlist in playlistsFromQuery) {
        
        NSMutableString *playlistJSON = [NSMutableString string];
        [playlistJSON appendString: @"{"];

        
        // Playlist Title
        NSString *playlistTitle = [NSString stringWithFormat:@"\"Name\":\"%@\",",[playlist valueForProperty: MPMediaPlaylistPropertyName]];
        
        [playlistJSON appendString: playlistTitle];
        [playlistJSON appendString: @"\"Songs\":["];
        
        
        for (MPMediaItem *song in playlist.items) {
            
            NSString *persistentID = [NSString stringWithFormat:@"{\"PersistentID\":\"%@\"",[song valueForProperty: [NSString stringWithFormat:@"%@", MPMediaItemPropertyPersistentID]]];
            
            [playlistJSON appendString: persistentID];
            
            // Need to check if the playlist is the last item, so we can either leave off the comma separator or add it.
            if ([playlist.items lastObject] == song) {
                [playlistJSON appendString:@"}"];
            } else {
                [playlistJSON appendString:@"},"];
            }

        }
        [playlistJSON appendString:@"]}"];

        
        if (playlistsFromQuery.lastObject != playlist) {
            
            [playlistJSON appendString:@","];
            
        }
        
        [JSONString appendString: playlistJSON];

    }
    [JSONString appendString:@"]}"];
    
    [delegate playlistScrapingDidSucceed];
    
    return nil;
}

@end
