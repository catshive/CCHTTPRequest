# CCHTTPRequest

No-frills networking for iOS.

### Installation

Copy CCHTTPRequest.h and CCHTTPRequest.m into your Xcode project.

If you're using CocoaPods, add the following line to your Podfile:

    pod 'CCHTTPRequest'

## Documentation

Step 1: Initialize a CCHTTPRequest object.

Step 2: Set the completion and failure blocks.

Step 3: Begin the request.

#### Example
~~~
// Step 1. Create the request
CCHTTPRequest *aRequest = [[CCHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://graph.facebook.com/zowieso"]];

// Step 2. Set the completion and failure blocks
[aRequest setCompletionBlock:^(NSURLResponse *theResponse, NSData *theData) {
	NSError *anError;
   id aResponseJSON = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingAllowFragments error:&anError];
   if (!anError) {
      NSLog(@"%@", aResponseJSON);
   }
} failureBlock:^(NSError *theError) {
   NSLog(@"Request failed with error: %@", theError);
}];

// Step 3. Begin the request
[aRequest begin];

~~~

#### Author

Cathy Shive, catshive@gmail.com

#### License

CCCoreDataStore is available under the MIT license. See the LICENSE file for more info.
