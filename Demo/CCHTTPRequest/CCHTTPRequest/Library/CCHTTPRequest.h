//
//  CCHTTPRequest.h
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

#import <Foundation/Foundation.h>

typedef enum
{
    CCHTTPRequestMethodGET = 0,
    CCHTTPRequestMethodPOST,
    CCHTTPRequestMethodPUT,
    CCHTTPRequestMethodDELETE
    
}CCHTTPRequestMethod;

typedef void (^CCHTTPRequestCompletionBlock)(NSURLResponse *theResponse, NSData *theData);

typedef void (^CCHTTPRequestFailureBlock)(NSError *theError);

@interface CCHTTPRequest : NSObject

/**
    @return NSURLRequest - the actual request object.
 */
@property (nonatomic, readonly, strong) NSURLRequest *request;

/**
    @return an initialized CCHTTPReqest object ready to begin a GET request with the given url.
    
    @param theURL - the request url
 */
- (instancetype)initWithURL:(NSURL *)theURL;

/**
    @return an initialized CCHTTPReqest object ready to begin a GET request with the given url and paramters.

    @param theURL - the request url
    @param theParameters - the request parameters
 */
- (instancetype)initWithURL:(NSURL *)theURL parameters:(NSDictionary *)theParameters;

/**
    @return an initialized CCHTTPReqest object ready to begin a request configured according to the method parameters.

    @param theURL - the request url
    @param theMethod - CCHTTPRequestMethod - the request method
    @param theParameters - the request parameters
    @param theHeaders - the request headers
 */
- (instancetype)initWithURL:(NSURL *)theURL method:(CCHTTPRequestMethod)theMethod parameters:(NSDictionary *)theParameters headers:(NSDictionary *)theHeaders;

/**
    Sets the completion block and failure block. Blocks will be called on the main thread.

    @param theCompletionBlock
    @param theFailureBlock
 */
- (void)setCompletionBlock:(CCHTTPRequestCompletionBlock)theCompletionBlock failureBlock:(CCHTTPRequestFailureBlock)theFailureBlock;

/**
    Begin the request.
 */
- (void)begin;

/**
    Cancel the request.
 */
- (void)cancel;

@end
