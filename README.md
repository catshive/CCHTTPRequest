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
CCHTTPRequest *aRequest = [[CCHTTPRequest alloc] initWithURL:[NSURL urlWithString: @"http://www.google.com"];

[aRequest setCompletionBlock:nil failureBlock:nil];

[aRequest begin];
~~~

#### Author

Cathy Shive, catshive@gmail.com

#### License

CCCoreDataStore is available under the MIT license. See the LICENSE file for more info.
