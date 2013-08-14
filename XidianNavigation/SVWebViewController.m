//
//  SVWebViewController.m
//
//  Created by Sam Vermette on 08.11.10.
//  Copyright 2010 Sam Vermette. All rights reserved.
//
//  https://github.com/samvermette/SVWebViewController

#import "SVWebViewController.h"

@interface SVWebViewController () <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;
@property (nonatomic, strong, readonly) UIActionSheet *pageActionSheet;

@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) NSURL *URL;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;

- (void)showLeft;

@end


@implementation SVWebViewController

@synthesize availableActions;
@synthesize rowImage;

@synthesize URL, mainWebView;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem, pageActionSheet;


- (void)showLeft
{
//    CCSideViewController *left = [[CCSideViewController alloc] initWithNibName:@"CCSideViewController" bundle:nil];
//    [self.revealSideViewController pushViewController:left onDirection:PPRevealSideDirectionLeft animated:YES];
    [self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];

}


#pragma mark - setters and getters

- (UIBarButtonItem *)backBarButtonItem {
    
    if (!backBarButtonItem) {
        backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
        backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		backBarButtonItem.width = 18.0f;
    }
    return backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    
    if (!forwardBarButtonItem) {
        forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SVWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
        forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		forwardBarButtonItem.width = 18.0f;
    }
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    
    if (!refreshBarButtonItem) {
        refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    }
    
    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    
    if (!stopBarButtonItem) {
        stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    }
    return stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    
    if (!actionBarButtonItem) {
        actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    }
    return actionBarButtonItem;
}

- (UIActionSheet *)pageActionSheet {
    
    if(!pageActionSheet) {
        pageActionSheet = [[UIActionSheet alloc]
                           initWithTitle:self.mainWebView.request.URL.absoluteString
                           delegate:self
                           cancelButtonTitle:nil
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
        
        if((self.availableActions & SVWebViewControllerAvailableActionsCopyLink) == SVWebViewControllerAvailableActionsCopyLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"复制链接", @"")];
        
        if((self.availableActions & SVWebViewControllerAvailableActionsOpenInSafari) == SVWebViewControllerAvailableActionsOpenInSafari)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"在Safari中打开", @"")];
        
        if([MFMailComposeViewController canSendMail] && (self.availableActions & SVWebViewControllerAvailableActionsMailLink) == SVWebViewControllerAvailableActionsMailLink)
            [pageActionSheet addButtonWithTitle:NSLocalizedString(@"用邮件分享此链接", @"")];
        
        [pageActionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
        pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
    }
    
    return pageActionSheet;
}

#pragma mark - Initialization

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init]) {
        self.URL = pageURL;
        self.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsMailLink;
    }
    
    return self;
}

#pragma mark - Memory management

- (void)dealloc {
    mainWebView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - View lifecycle

- (void)loadView {
    mainWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainWebView.delegate = self;
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//        mainWebView.scalesPageToFit = NO;
//    else
        mainWebView.scalesPageToFit = YES;
    
    mainWebView.dataDetectorTypes = YES;
    
    [mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    self.view = mainWebView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [self updateToolbarItems];
    
    self.mainWebView.backgroundColor = [UIColor whiteColor];
    
    UIImage *backButtonImageNormal = [[UIImage imageNamed:@"btn_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:backButtonImageNormal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *backButtonImageActive = [[UIImage imageNamed:@"btn_back_active.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setBackButtonBackgroundImage:backButtonImageActive forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"nav_bot.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"nav_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forBarMetrics:UIBarMetricsDefault];
    
    
    //    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(showLeft)];
    //
    //    menuButton.image = [UIImage imageNamed:@"navbar_toggle.png"];
    //    [menuButton setBackgroundImage:[UIImage imageNamed:@"btn_common.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //
    //    self.navigationItem.leftBarButtonItem = menuButton;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor blackColor], UITextAttributeTextColor,
                                [UIColor colorWithWhite:1.0 alpha:0.8], UITextAttributeTextShadowColor,
                                [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
                                nil];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    mainWebView = nil;
    backBarButtonItem = nil;
    forwardBarButtonItem = nil;
    refreshBarButtonItem = nil;
    stopBarButtonItem = nil;
    actionBarButtonItem = nil;
    pageActionSheet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
//    NSAssert(self.navigationController, @"SVWebViewController needs to be contained in a UINavigationController. If you are presenting SVWebViewController modally, use SVModalWebViewController instead.");
    
	[super viewWillAppear:animated];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:NO];
    }
    
    //    CCSideViewController *leftVC = [[CCSideViewController alloc] initWithNibName:@"CCSideViewController" bundle:nil];
    //
    //    [self.revealSideViewController preloadViewController:leftVC forSide:PPRevealSideDirectionLeft];
    
    
    // Swipe to right will appear reveal view
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showLeft)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    //    [self.navigationController.navigationBar addGestureRecognizer:swipeRight];
    
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //        [self.navigationController setToolbarHidden:YES animated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
//    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    } else
        return NO;
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    self.backBarButtonItem.enabled = self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
    self.actionBarButtonItem.enabled = !self.mainWebView.isLoading;
    
    UIBarButtonItem *refreshStopBarButtonItem = self.mainWebView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 5.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray *items;
        CGFloat toolbarWidth = 250.0f;
        
        if(self.availableActions == 0) {
            toolbarWidth = 200.0f;
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     fixedSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     self.actionBarButtonItem,
                     fixedSpace,
                     nil];
        }
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
        toolbar.items = items;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    }
    
    else {
        NSArray *items;
        
        if(self.availableActions == 0) {
            items = [NSArray arrayWithObjects:
                     flexibleSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     nil];
        } else {
            items = [NSArray arrayWithObjects:
                     fixedSpace,
                     self.backBarButtonItem,
                     flexibleSpace,
                     self.forwardBarButtonItem,
                     flexibleSpace,
                     refreshStopBarButtonItem,
                     flexibleSpace,
                     self.actionBarButtonItem,
                     fixedSpace,
                     nil];
        }
        
        self.toolbarItems = items;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
}

#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    [mainWebView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [mainWebView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    [mainWebView reload];
}

- (void)stopClicked:(UIBarButtonItem *)sender {
    [mainWebView stopLoading];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[self updateToolbarItems];
}

- (void)actionButtonClicked:(id)sender {
    
    if(pageActionSheet)
        return;
	
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [self.pageActionSheet showFromBarButtonItem:self.actionBarButtonItem animated:YES];
    else
        [self.pageActionSheet showFromToolbar:self.navigationController.toolbar];
    
}

- (void)doneButtonClicked:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
	if([title isEqualToString:NSLocalizedString(@"Open in Safari", @"")])
        [[UIApplication sharedApplication] openURL:self.mainWebView.request.URL];
    
    if([title isEqualToString:NSLocalizedString(@"Copy Link", @"")]) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.mainWebView.request.URL.absoluteString;
    }
    
    else if([title isEqualToString:NSLocalizedString(@"Mail Link to this Page", @"")]) {
        
		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        
		mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
  		[mailViewController setMessageBody:self.mainWebView.request.URL.absoluteString isHTML:NO];
		mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        
		[self presentModalViewController:mailViewController animated:YES];
	}
    
    pageActionSheet = nil;
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
