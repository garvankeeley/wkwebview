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
  // Do any additional setup after loading the view, typically from a nib.


//  NSString *userAgent = @"Mozilla/5.0 (Linux; <Android Version>; <Build Tag etc.>) AppleWebKit/<WebKit Rev> (KHTML, like Gecko) Chrome/<Chrome Rev> Mobile Safari/<WebKit Rev>";
//  NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"UserAgent", nil];
//  [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];


}
-(void)injectScript:(WKWebViewConfiguration*)config
{
 // NSString* src = @"window.webkit.messageHandlers.interOp.postMessage( {'count': 1111 })";

  NSString* src = @"";
 //  "if (!HTMLIFrameElement.prototype.watch) { Object.defineProperty(HTMLIFrameElement.prototype, 'watch', { enumerable: false , configurable: true , writable: false , value: function (prop, handler) { var oldval = this[prop] , newval = oldval , getter = function () { return newval; } , setter = function (val) { oldval = newval; newval = handler.call(this, prop, oldval, val); return newval; } ; if (delete this[prop]) { Object.defineProperty(this, prop, { get: getter , set: setter , enumerable: true , configurable: true }); } } }); }"
 // " function override(object, methodName, callback) { object[methodName] = callback(object[methodName]); } function compose(extraBehavior) { return function(original) { return function() { return extraBehavior.call(this, original.apply(this, arguments)); }; }; } override(document, 'createElement', compose(function(obj) { if (!(obj instanceof HTMLIFrameElement)) { return obj; } obj.watch('src', function(prop, old, newval) { if (this.id.indexOf('google') > -1 && newval.length > 0) { this.srcdoc='hello world!'; } return newval; }); return obj; })); "

  NSString* filePath = [[NSBundle mainBundle] pathForResource:
                       // @"inject"
                        @"add-src-watch"
                                                       ofType:@"js"];
  NSData* htmlData = [NSData dataWithContentsOfFile:filePath];
  NSString* fileSrc = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];

  WKUserScript* script = [[WKUserScript alloc] initWithSource:fileSrc injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                             forMainFrameOnly:NO];
  [config.userContentController addUserScript:script];

//  script = [[WKUserScript alloc] initWithSource:@"adsweep();" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
 // [config.userContentController addUserScript:script];

}

//NSURLConnection* connection;
//-(void)get:(NSURL*)url
//{
//  NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
// connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
//}
//
//NSMutableData* mdata;
//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//  mdata = [[NSMutableData alloc]init];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//  [mdata appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//  NSString* filePath = [NSString stringWithFormat:@"%u/%@", NSDocumentDirectory, @"file.html"];
//  [mdata writeToFile:filePath atomically:YES];
//
//  [self.webview loadData:mdata MIMEType:@"text/html" characterEncodingName:@"utf-8" baseURL:[NSURL URLWithString:@"http://nytimes.com"]];
//  activity.hidden = YES;
//  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:false];
//
//}

-(void)viewWillAppear:(BOOL)animated
{
  WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
  [theConfiguration.userContentController addScriptMessageHandler:self name:@"interOp"];

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
  NSDictionary *sentData = (NSDictionary*)message.body;
  long aCount = [sentData[@"count"] integerValue];
  aCount++;
  [self.webview evaluateJavaScript:[NSString
                                   stringWithFormat:@"storeAndShow(%ld)", aCount] completionHandler:nil];
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
//  if (navigationAction.targetFrame.isMainFrame && ![navigationAction.request.URL.absoluteString hasPrefix:webView.URL.absoluteString]) {
//    //NSLog(@"her");
//    decisionHandler(WKNavigationActionPolicyCancel);
//
//    NSData* data = [NSData dataWithContentsOfURL:navigationAction.request.URL];
//    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//    //////////////////////////////////str = [self injectCss:str];
//
//    [webView loadHTMLString:str baseURL:navigationAction.request.URL];
//    {
//      if (!activity) {
//        activity= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        [self.view addSubview:activity];
//        [activity setFrame:self.view.frame];
//        activity.transform = CGAffineTransformMakeScale(2, 2);
//        [activity startAnimating];
//
//      }
//
//      activity.hidden = NO;
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:true];
//
//    }
//
//    return;
//  }
//
//  NSString *request = navigationAction.request.URL.absoluteString;
  //NSLog(@"decidePolicyForNavigationAction %@", request);
  decisionHandler(WKNavigationActionPolicyAllow);
//  if (navigationAction.navigationType == WKNavigationType.LinkActivated &&
//      !navigationAction.request.URL.host!.lowercaseString.hasPrefix("www.appcoda.com"))
//  {
//    UIApplication.sharedApplication().openURL(navigationAction.request.URL)
//    decisionHandler(WKNavigationActionPolicy.Cancel)
//  } else {
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

//  [webView evaluateJavaScript:@" window.webkit.messageHandlers.interOp.postMessage( {'count': 1111 })" completionHandler:^(id obj, NSError* err) {
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
