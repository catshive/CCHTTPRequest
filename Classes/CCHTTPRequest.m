//
//  CCHTTPRequest.m
//
//  Created by Cathy Shive on 11/15/12.
//
//  Copyright (c) 2012 Cathy Shive
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CCHTTPRequest.h"

@interface CCHTTPRequest ()

@property (nonatomic, readwrite, strong) NSMutableURLRequest *request;

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, assign) CCHTTPRequestMethod method;

@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) NSDictionary *headers;

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSURLResponse *response;

@property (nonatomic, strong) NSMutableData *responseData;

@property (nonatomic, strong) CCHTTPRequestCompletionBlock completionBlock;

@property (nonatomic, strong) CCHTTPRequestFailureBlock failureBlock;

@end

@implementation CCHTTPRequest

- (instancetype)initWithURL:(NSURL *)theURL
{
    return [self initWithURL:theURL method:CCHTTPRequestMethodGET parameters:nil headers:nil];
}

- (instancetype)initWithURL:(NSURL *)theURL parameters:(NSDictionary *)theParameters
{
    return [self initWithURL:theURL method:CCHTTPRequestMethodGET parameters:theParameters headers:nil];
}

- (instancetype)initWithURL:(NSURL *)theURL method:(CCHTTPRequestMethod)theMethod parameters:(NSDictionary *)theParameters headers:(NSDictionary *)theHeaders
{
    if(self = [super init]) {
        self.URL = theURL;
        self.method = theMethod;
        self.parameters = theParameters;
        self.headers = theHeaders;
        self.request = [NSMutableURLRequest requestWithURL:self.URL];
    }
    return self;
}

- (void)setCompletionBlock:(CCHTTPRequestCompletionBlock)theCompletionBlock failureBlock:(CCHTTPRequestFailureBlock)theFailureBlock
{
    self.completionBlock = theCompletionBlock;
    self.failureBlock = theFailureBlock;
}

- (void)begin
{
    NSMutableURLRequest *aRequest = self.request;
    
    // Method
    aRequest.HTTPMethod = [self _stringForMethodType:self.method];

    // Parameters
    if(self.parameters) {
        NSData *aBodyData = [self _bodyDataForParameters:self.parameters];
        aRequest.HTTPBody = aBodyData;
        NSString *aContentLength = [NSString stringWithFormat:@"%lu", (unsigned long)[aBodyData length]];
        [aRequest setValue:aContentLength forHTTPHeaderField:@"Content-Length"];
    }

    // Headers
    if (self.headers)
    {
        for (NSString *aKey in self.headers) {
            [aRequest setValue:[self.headers valueForKey:aKey] forHTTPHeaderField:aKey];
        }
    }

    self.request = aRequest;

    // Start connection on main thread so that connection callbacks are guaranteed on main thread
    [self performSelectorOnMainThread:@selector(_startConnection) withObject:nil waitUntilDone:NO];
}

- (void)_startConnection
{
    NSURLConnection *aConnection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
    [aConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [aConnection start];
    self.connection = aConnection;
}

- (void)cancel
{
    // Canceling will cancel the request, the callbacks and clear out any data that's been set
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.connection cancel];
    [self _cleanUp];
}

- (void)_cleanUp
{
    // Clean up
    self.responseData = nil;
    self.connection = nil;
    self.request = nil;
    self.completionBlock = nil;
    self.failureBlock = nil;
    self.response = nil;
    self.URL = nil;
}

#pragma mark -

- (NSString *)_stringForMethodType:(CCHTTPRequestMethod)theMethodType
{
    switch (theMethodType) {
        case CCHTTPRequestMethodGET:
            return @"GET";
        case CCHTTPRequestMethodPOST:
            return @"POST";
        case CCHTTPRequestMethodPUT:
            return @"PUT";
        case CCHTTPRequestMethodDELETE:
            return @"DELETE";
        default:
            break;
    }
    return nil;
}

- (NSData *)_bodyDataForParameters:(NSDictionary *)theParameters
{
    NSMutableString *aParametersString = [[NSMutableString alloc] init];
    [theParameters enumerateKeysAndObjectsUsingBlock:^(id theKey, id theObject, BOOL *shouldStop) {
        [aParametersString appendFormat:@"%@=%@&", theKey, theObject];
    }];
    return [aParametersString dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    if (self.responseData == nil) {
        self.responseData = [NSMutableData data];
    }
    [self.responseData appendData:theData];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)theResponse
{
    self.response = theResponse;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)theError
{
    if (self.failureBlock) {
        self.failureBlock(theError);
    }

    [self _cleanUp];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.completionBlock) {
        self.completionBlock(self.response, self.responseData);
    }
    
    [self _cleanUp];
}

@end
