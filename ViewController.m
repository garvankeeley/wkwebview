//
//  ViewController.m
//  WebViewExperiment
//
//  Created by Garvan Keeley on 2015-09-08.
//  Copyright (c) 2015 brave. All rights reserved.
//

#import "ViewController.h"
#import <Webkit/Webkit.h>
#import <objc/runtime.h>


@interface ViewController () <WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView* webview;
@end
//
//@implementation WKWebView(Mod)
//
//- (void)xxx_customUserAgent:(BOOL)animated {
//  [self xxx_customUserAgent:animated];
//  //NSLog(@"viewWillAppear: %@", self);
//}
//
//+ (void)load {
//  static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
//    Class class = [self class];
//
//    SEL originalSelector = @selector(customUserAgent:);
//    SEL swizzledSelector = @selector(xxx_customUserAgent:);
//
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//    // When swizzling a class method, use the following:
//    // Class class = object_getClass((id)self);
//    // ...
//    // Method originalMethod = class_getClassMethod(class, originalSelector);
//    // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
//
//    BOOL didAddMethod =
//    class_addMethod(class,
//                    originalSelector,
//                    method_getImplementation(swizzledMethod),
//                    method_getTypeEncoding(swizzledMethod));
//
//    if (didAddMethod) {
//      class_replaceMethod(class,
//                          swizzledSelector,
//                          method_getImplementation(originalMethod),
//                          method_getTypeEncoding(originalMethod));
//    } else {
//      method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//  });
//}
//
//@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)injectScript:(WKWebViewConfiguration*)config
{
  NSString* filePath = [[NSBundle mainBundle] pathForResource:
                       // @"inject"
                        @"add-src-watch"
                                                       ofType:@"js"];
  NSData* data = [NSData dataWithContentsOfFile:filePath];
  NSString* fileSrc = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

  WKUserScript* script = [[WKUserScript alloc] initWithSource:fileSrc injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                             forMainFrameOnly:NO];
  [config.userContentController addUserScript:script];

  [config.userContentController addScriptMessageHandler:self name:@"inter"];

//  script = [[WKUserScript alloc] initWithSource:@"adsweep();" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
 // [config.userContentController addUserScript:script];

//  {
//    NSString* filePath = [[NSBundle mainBundle] pathForResource:
//                          @"easyXDM.min"
//                                                         ofType:@"js"];
//    NSData* data = [NSData dataWithContentsOfFile:filePath];
//    NSString* fileSrc = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    WKUserScript* script = [[WKUserScript alloc] initWithSource:fileSrc injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
//                                               forMainFrameOnly:NO];
//    [config.userContentController addUserScript:script];
//}

}

-(void)viewWillAppear:(BOOL)animated
{
  WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
  [theConfiguration.userContentController addScriptMessageHandler:self name:@"interop"];

  [self injectScript:theConfiguration];

  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:theConfiguration];
  webView.navigationDelegate = self;

  NSURL *nsurl=[NSURL URLWithString:
               @"http://www.nytimes.com"
               // @"http:/cnn.com"
  //              @"http://simple-adblock.com/faq/testing-your-adblocker/"
//  @"http://simple-adblock.com/adblocktest/adblocktest.htm"
    //            @"http://safeframes.net/examples/IAB_RisingStars/sidekick_sample.html"
   ];


  NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
  [webView loadRequest:nsrequest];
//
//  NSString*html = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nytimes" ofType:@"html"]
//                                            encoding:NSUTF8StringEncoding error:nil];
//
//  [webView loadHTMLString:html b
  [self.view addSubview:webView];
  self.webview = webView;
}


- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
  //return;

  NSString* src = (NSString*)message.body;
  //NSString* src = sentData[@"src"];
  assert(src);
  NSLog(@" eval using: %@", src);
  [self.webview evaluateJavaScript:[NSString stringWithFormat:@"replace_src('%@')", src]
                 completionHandler:^(id msg, NSError* error) {
                   NSLog(@"%@ %@", msg, error);
                 }];
}

- (NSString*)injectCss:(NSString*)str
{
  static NSString* css= nil;
  if (!css)
     css = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blockercss" ofType:@"css"]
                                            encoding:NSUTF8StringEncoding error:nil];

  NSRange loc = [str rangeOfString:@"<head>" options:NSCaseInsensitiveSearch];
  unsigned long start = loc.location + loc.length;
  NSString* outStr = [NSString stringWithFormat:@"%@<style>%@</style>%@", [str substringToIndex:start], css, [str substringFromIndex:start]];
  return outStr;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
  NSString *request = navigationAction.request.URL.absoluteString;
  decisionHandler(WKNavigationActionPolicyAllow);
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
//{
//  //NSLog(@"decidePolicyForNavigationResponse");
//  decisionHandler(WKNavigationResponsePolicyAllow);
//}
//

//UIActivityIndicatorView* activity;
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
  //NSLog(@"didStartProvisionalNavigation");
}

//
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
//{
//  //NSLog(@"didReceiveServerRedirectForProvisionalNavigation");
//}
//
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withdir:(NSError *)error
{
  //NSLog(@"didFailProvisionalNavigation");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
  //NSLog(@"didCommitNavigation");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
  //NSLog(@"didFinishNavigation");

//  [webView evaluateJavaScript:@" window.webkit.messageHandlers.interop.postMessage( {'count': 1111 })" completionHandler:^(id obj, NSError* err) {
//    //NSLog(@"≈≈≈ ");
//    [err isEqual:nil];
//  }];

 // [activity stopAnimating];
 // activity.hidden = YES;
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
}
//
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
//{
//  //NSLog(@"didFailNavigation");
//}

//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
//{
//  //NSLog(@"didReceiveAuthenticationChallenge");
//}


@end
