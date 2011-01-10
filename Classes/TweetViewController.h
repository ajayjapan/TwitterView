//
//  TweetViewController.h
//  TwitterView
//
//  Created by Ajay Chainani on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileHeader.h"

@interface TweetViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {

	UIWebView	*theWebView;
	NSString	*urlString;
	ProfileHeader *profileHeader;
	
}

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) ProfileHeader *profileHeader;

@end
