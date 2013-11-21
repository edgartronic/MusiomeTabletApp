//
//  ViewController.m
//  tabletapp
//
//  Created by Edgar Nunez on 11/6/13.
//  Copyright (c) 2013 Musiome. All rights reserved.
//

#import "ViewController.h"
#define MUSIOME_MOBILE_SITE @"http://dev.musiome.com/"

@interface ViewController () {
    UIWebView *_mobileSiteWindow;
    UIActivityIndicatorView *loaderSpinner;
    UIColor *bgColor;
}

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    bgColor = [UIColor colorWithRed: 0.1725 green: 0.2274 blue: 0.2627 alpha: 1.0];
    self.view.backgroundColor = bgColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    
    _mobileSiteWindow = [[UIWebView alloc] initWithFrame: CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    _mobileSiteWindow.delegate = self;
    _mobileSiteWindow.backgroundColor = bgColor;
    _mobileSiteWindow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mobileSiteWindow.alpha = 0.0;
    [self.view addSubview: _mobileSiteWindow];
    [_mobileSiteWindow loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: MUSIOME_MOBILE_SITE]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UIWebView callbacks

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    loaderSpinner = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(0, 0, 500, 500)];
    loaderSpinner.center = _mobileSiteWindow.center;
    loaderSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview: loaderSpinner];
    [loaderSpinner startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [loaderSpinner stopAnimating];
    [loaderSpinner removeFromSuperview];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationDelay: 0.0];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
    
    _mobileSiteWindow.alpha = 1.0;
    
    [UIView commitAnimations];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}


@end
