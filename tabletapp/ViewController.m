//
//  ViewController.m
//  tabletapp
//
//  Created by Edgar Nunez on 11/6/13.
//  Copyright (c) 2013 Musiome. All rights reserved.
//

#import "ViewController.h"
#import "MusiomeWebServiceManager.h"
#import "MusiomeiTunesLibraryScraper.h"

#define MUSIOME_MOBILE_SITE @"http://dev.musiome.com/"
#define MUSIOME_SESSION_ID @"musiomeSessionID"
#define MUSIOME_SESSION_EXPIREDATE @"musiomeExpireDate"

@interface ViewController () {
    UIWebView *_mobileSiteWindow;
    UIActivityIndicatorView *loaderSpinner;
    UIColor *bgColor;
    BOOL siteDidLoad;
    NSString *sid;
    NSDate *expireDate;
}

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    siteDidLoad = NO;
    bgColor = [UIColor colorWithRed: 0.1725 green: 0.2274 blue: 0.2627 alpha: 1.0];
    self.view.backgroundColor = bgColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    sid = [[NSUserDefaults standardUserDefaults] objectForKey: MUSIOME_SESSION_ID];
    expireDate = [[NSUserDefaults standardUserDefaults] objectForKey: MUSIOME_SESSION_EXPIREDATE];
    
    _mobileSiteWindow = [[UIWebView alloc] initWithFrame: CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _mobileSiteWindow.delegate = self;
    _mobileSiteWindow.backgroundColor = bgColor;
    _mobileSiteWindow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mobileSiteWindow.alpha = 0.0;
    [self.view addSubview: _mobileSiteWindow];
    [_mobileSiteWindow loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: MUSIOME_MOBILE_SITE]]];

    UILabel *lbl = [[UILabel alloc] initWithFrame: CGRectMake(415, 320, 200, 40)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont boldSystemFontOfSize: 18];
    lbl.text = @"Loading Musiome...";
    lbl.tag = 1111;
    [self.view addSubview: lbl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIWebView callbacks

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"URL String: %@", urlString);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (siteDidLoad == NO) {
        loaderSpinner = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 500, 500)];
        loaderSpinner.center = _mobileSiteWindow.center;
        loaderSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.view addSubview: loaderSpinner];
        [loaderSpinner startAnimating];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (siteDidLoad == NO) {
        
        UILabel *lbl = (UILabel *)[self.view viewWithTag: 1111];
        [lbl removeFromSuperview];
        
        [loaderSpinner stopAnimating];
        [loaderSpinner removeFromSuperview];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationDelay: 0.0];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
        
        _mobileSiteWindow.alpha = 1.0;
        
        [UIView commitAnimations];

        
//        [[MusiomeiTunesLibraryScraper sharedScraper] getJSONForiTunesLibrary];
//        [[MusiomeiTunesLibraryScraper sharedScraper] getJSONForiTunesPlaylists];
//        [[MusiomeWebServiceManager sharedManager] postJSONLibrary: iTunesLib];
        
        siteDidLoad = YES;
        
    }
    
    BOOL hasCookieExpired = ([[NSDate date] compare: expireDate] == NSOrderedDescending) ? YES : NO;
    
    // if the session ID pulled from NSUserDefaults is empty OR if the expiration date has been reached, get the session info from the cookie.
    if (!sid || (sid && hasCookieExpired == YES)) {
        [self getSessionIDFromCookie];
    }
}

- (void) getSessionIDFromCookie {
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        
        if ([[cookie name] isEqualToString: @"musiome.sid"] && [[cookie domain] isEqualToString: @"dev.musiome.com"]) {

            [[NSUserDefaults standardUserDefaults] setObject: [cookie value] forKey: MUSIOME_SESSION_ID];
            [[NSUserDefaults standardUserDefaults] setObject: [cookie expiresDate] forKey: MUSIOME_SESSION_EXPIREDATE];
            
            sid = [cookie value];
            expireDate = [cookie expiresDate];
            
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}


@end
