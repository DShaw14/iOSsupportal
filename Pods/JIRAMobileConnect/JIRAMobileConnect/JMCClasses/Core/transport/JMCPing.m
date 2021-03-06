/**
   Copyright 2011 Atlassian Software

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
**/

#import "JMCPing.h"
#import "JMC.h"
#import "JMCIssueStore.h"
#import "JMCTransport.h"

@implementation JMCPing

- (void)start {

    if ([JMCIssueStore instance].count > 0) {
    // delay a little, then ping to make notificaiton not so jarring
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(sendPing) userInfo:nil repeats:NO];
    }
}

- (void)sendPing {
    
    if ([JMC sharedInstance].url == nil)
    {
        JMCDLog(@"JMC instance url not yet set. No ping this time.");
        return;
    }
    
    NSString *project = [[JMC sharedInstance] getProject];
    NSString *uuid = [[JMC sharedInstance] getUUID];
    NSNumber* lastPingTime = [[NSUserDefaults standardUserDefaults] objectForKey:kJMCLastSuccessfulPingTime];
    lastPingTime = lastPingTime ? lastPingTime : [NSNumber numberWithInt:0];
    
    NSDictionary *params = @{
                             @"project": project ,
                             @"uuid": uuid ,
                             @"apikey": [[JMC sharedInstance] getApiKey],
                             @"sinceMillis": [lastPingTime stringValue]
                            };
    NSString * queryString = [JMCTransport encodeParameters:params];
    NSString *resourceUrl = [NSString stringWithFormat:kJMCTransportNotificationsPath, [[JMC sharedInstance] getAPIVersion], queryString];

    NSURL *url = [NSURL URLWithString:resourceUrl relativeToURL:[JMC sharedInstance].url];
    JMCDLog(@"Retrieving notifications via: %@", [url absoluteURL]);

    // send ping
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 60;
    
    [[[NSURLSession sharedSession]
     dataTaskWithRequest:request
     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         
         if (error == nil) {
             statusCode = [(NSHTTPURLResponse *)response statusCode];
             responseData = data;
             NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding: NSUTF8StringEncoding];
             if ([responseString isEqualToString:@"null"] || [responseString isEqualToString:@""])
             {
                 JMCALog(@"Invalid, empty response from JIRA: %@", responseString);
                 return;
             }
             
             if (statusCode < 300)
             {
                 NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                 [self performSelectorOnMainThread:@selector(didReceiveComments:) withObject:data waitUntilDone:YES];
             }
             else
             {
                 JMCALog(@"Error request comments and issues: %@", responseString);
             }
             // Flush the request Queue on App launch and once the JIRA Ping has returned and potentially rebuilt the database
             JMCDLog(@"Flushing the request queue");
             [self performSelectorOnMainThread:@selector(flushQueue) withObject:nil waitUntilDone:YES];
         } else {
             NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding: NSUTF8StringEncoding];
             JMCALog(@"Ping request failed: '%@'", responseString);
         }
         
         
     }] resume];
}

- (void)didReceiveComments:(NSDictionary *)comments {
    [[JMCIssueStore instance] updateWithData:comments];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJMCReceivedCommentsNotification object:self];

    // update the timestamp since we last requested comments.
    // sinceMillis is the server's time
    NSNumber *sinceMillis = [comments valueForKey:@"sinceMillis"];
    [[NSUserDefaults standardUserDefaults] setObject:sinceMillis forKey:kJMCLastSuccessfulPingTime];
    JMCDLog(@"Time JIRA last saw this user: %@", [NSDate dateWithTimeIntervalSince1970:[sinceMillis doubleValue]/1000]);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)flushQueue {
    [[JMC sharedInstance] flushRequestQueue];
}

@synthesize baseUrl = _baseUrl;



@end
