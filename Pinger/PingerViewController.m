//
//  PingerViewController.m
//  Pinger
//
//  Created by Stefan Dierauf on 11/18/13.
//  Copyright (c) 2013 Stefan Dierauf. All rights reserved.
//

#import "PingerViewController.h"

//#import <SystemConfiguration/framework.h>

@interface PingerViewController ()
@property (strong, nonatomic) IBOutlet UITextView *console;
@property (strong, nonatomic) IBOutlet UITextField *pingURL;

@end

@implementation PingerViewController
- (IBAction)ping {
    NSString * urlToPing = [self getURL];
    [self appendTextToConsole:[NSString stringWithFormat:@"Attempting to ping %@", urlToPing]];
    
    bool success = false;
    const char *host_name = [urlToPing cStringUsingEncoding:NSASCIIStringEncoding];
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
    SCNetworkReachabilityFlags flags;
    
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    bool isAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    
    if (isAvailable) {
        [self appendTextToConsole:[NSString stringWithFormat:@"%@ is reachable\n", urlToPing]];
    } else {
        [self appendTextToConsole:[NSString stringWithFormat:@"Attempt to reach %@ FAILED\n", urlToPing]];
    }
}

- (NSString*)getURL {
    //may need to do some checking about http etc.
    NSString * raw = self.pingURL.text;
    raw = [raw stringByAppendingString:@".cs.washington.edu"];
    return raw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)appendTextToConsole:(NSString*)text
{
    NSAttributedString * bootyLord = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@\n", text]];
    [self.console.textStorage appendAttributedString:bootyLord];
}

@end
