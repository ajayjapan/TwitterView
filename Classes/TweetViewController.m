    //
//  TweetViewController.m
//  TwitterView
//
//  Created by Ajay Chainani on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TweetViewController.h"
#import "ProfileHeader.h"
#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation TweetViewController

@synthesize urlString, profileHeader;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		profileHeader = [[ProfileHeader alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];

        // Custom initialization.
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)tweetAnalysis 
{
	
	NSArray *splitURL = [urlString componentsSeparatedByString:@" "];
	
	NSMutableString *result = [[NSMutableString alloc] init];
	
	for (NSString *word in splitURL) {
		
		if([word hasPrefix:@"@"]){
			
			[result appendString:@"<a href=http://twitter.com/#!/"];
			[result appendString:word];
			[result appendString:@">"];
			[result appendString:word];
			[result appendString:@"</a>"];
		}
		else if([word hasPrefix:@"#"]){
			[result appendString:@"<a href=http://twitter.com/#!/search/"];
			[result appendString:word];
			[result appendString:@">"];
			[result appendString:word];
			[result appendString:@"</a>"];
		}
		else if([word hasPrefix:@"http"]){
			
			[result appendString:@"<b><a href="];
			[result appendString:word];
			[result appendString:@">"];
			
			//if (word.length>25) {
				
			//	[result appendString:[word substringToIndex:25]];
			//}
			//else {
				[result appendString:word];
			//}
			
			[result appendString:@"</a></b>"];
		}
		else {
			[result appendString:word];
		}
		
		
		[result appendString:@" "];
		
		
	}
	
	NSString *css = [[NSString alloc] initWithFormat: @"table { width:880px; padding:10px; font-family: \"%@\"; font-size: %@;}\n"
					 //".vc { vertical-align:middle; }"							
					 "pre { white-space: pre-line; }"
					 "a { word-wrap: break-word;}"
					 "A:link {text-decoration: none; word-BREAK:BREAK-ALL;}"
					 "A:visited {text-decoration: none; }"
					 "A:active {text-decoration: none; }",@"helvetica",
					 [NSNumber numberWithInt:58]];
	
	
	NSString *myDescriptionHTML = [[NSString alloc] initWithFormat:@"<html> \n"
								   "<head> \n"
								   "<style type=\"text/css\"> \n"
								   "%@"
								   "</style> \n"
								   "</head> \n"
								   "<body><center><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><table border=0><tr><td>%@</td></tr></table></body> \n"
								   "</html>", css, result];
	
	[css release];
	[result release];
	
	[theWebView loadHTMLString:myDescriptionHTML baseURL:nil];
	
	[myDescriptionHTML release];
	
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Tweet";
	
	[self.view addSubview: profileHeader];
	[profileHeader release];
	
}

- (void)dealloc
{
	theWebView.delegate = nil;
	[theWebView release];
	
	[urlString release];
	
	[super dealloc];
}

- (void)refreshWeb:(id)sender {
	[theWebView reload];
}



- (void)loadView
{	
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];	
	contentView.autoresizesSubviews = YES;
	contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.view = contentView;	
	[contentView release];
	
	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
	webFrame.origin.y = 0;	
	
	theWebView = [[UIWebView alloc] initWithFrame:webFrame];
	theWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	theWebView.scalesPageToFit = YES;
	theWebView.delegate = self;
	
	[self tweetAnalysis];
	//NSURL *url = [NSURL URLWithString:urlString];
	//[urlString release];
	//NSURLRequest *req = [NSURLRequest requestWithURL:url];
	//[theWebView loadRequest:req];
	
	[self.view addSubview: theWebView];
}


#pragma mark UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	UIActivityIndicatorView  *whirl = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	whirl.frame = CGRectMake(0.0, 0.0, 20.0, 20.0);
	whirl.center = self.view.center;
	[whirl startAnimating];
	self.navigationItem.titleView = whirl;
	[whirl release];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	self.navigationItem.titleView = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[[UIApplication sharedApplication] openURL:theWebView.request.URL];
	}
}

- (void)shareAction {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
													cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Open in Safari", nil];
	
	[actionSheet showInView: self.view];
	[actionSheet release];
	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		WebViewController *webViewController = [[WebViewController alloc] init];
		webViewController.urlString = request.URL.absoluteString;
		[self.navigationController pushViewController:webViewController animated:YES];
		[webViewController release];
		return NO;
	}
	return YES;
	
}

@end
