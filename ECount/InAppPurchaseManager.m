//
//  InAppPurchaseManager.m
//  ECount
//
//  Created by Chris Desch on 1/4/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import "InAppPurchaseManager.h"


@implementation InAppPurchaseManager

static InAppPurchaseManager *_sharedInAppManager = nil;

+ (InAppPurchaseManager *)sharedInAppManager
{
	@synchronized([InAppPurchaseManager class])
	{
		if (!_sharedInAppManager)
			[[self alloc] init];
		
		return _sharedInAppManager;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([InAppPurchaseManager class])
	{
		NSAssert(_sharedInAppManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInAppManager = [super alloc];
		return _sharedInAppManager;
	}
	// to avoid compiler warning
	return nil;
}

-(id) init
{
	storeDoneLoading = NO;
	return self;
}

- (void) dealloc
{
	[levelUpgradeProduct release];
	[playerUpgradeOne release];
	[playerUpgradeTwo release];
	[super dealloc];
}

- (BOOL) storeLoaded
{
	return storeDoneLoading;
}

- (void)requestAppStoreProductData
{
	
#define kProductLevelPackUpgrade @"com.youcompany.001"
#define kProductPlayerUpgradeOne @"com.youcompany.002"
#define kProductPlayerUpgradeTwo @"com.youcompany.003"
	
    NSSet *productIdentifiers = [NSSet setWithObjects: kProductLevelPackUpgrade, kProductPlayerUpgradeOne, kProductPlayerUpgradeTwo, nil ];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    // we will release the request object in the delegate callback
}

#pragma mark In-App Product Accessor Methods

- (SKProduct *)getLevelUpgradeProduct
{
	return levelUpgradeProduct;
}

- (SKProduct *)getPlayerUpgradeOne
{
	return playerUpgradeOne;
}

- (SKProduct *)getPlayerUpgradeTwo
{
	return playerUpgradeTwo;
}


#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
	for (SKProduct *inAppProduct in products)
	{
		if ([inAppProduct.productIdentifier isEqualToString:kProductLevelPackUpgrade])
		{
			levelUpgradeProduct = [inAppProduct retain];
		}
		if ([inAppProduct.productIdentifier isEqualToString:kProductPlayerUpgradeOne])
		{
			playerUpgradeOne = [inAppProduct retain];
		}
		if ([inAppProduct.productIdentifier isEqualToString:kProductPlayerUpgradeTwo])
		{
			playerUpgradeTwo = [inAppProduct retain];
		}
	}
	
    /*** Used for testing AppStore responses
     if (specialUpgrade)
     {
     SKProduct *testProduct = specialUpgrade;
     
     NSLog(@"Product title: %@" , testProduct.localizedTitle);
     NSLog(@"Product description: %@" , testProduct.localizedDescription);
     NSLog(@"Product price: %@" , testProduct.price);
     NSLog(@"Product id: %@" , testProduct.productIdentifier);
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppStore OK" 
     message:[NSString stringWithFormat:@"title: %@ desc: %@ price: %@ id: %@",testProduct.localizedTitle,testProduct.localizedDescription,testProduct.localizedPrice,testProduct.productIdentifier]
     delegate:self 
     cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];
     [alert release];
     
     }
     ***/
    
	storeDoneLoading = YES;
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id: %@" , invalidProductId);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppStore Error" 
														message:invalidProductId
													   delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		storeDoneLoading = NO;
    }
    
    // finally release the reqest we alloc/init’ed in requestlevelUpgradeProductData
    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestAppStoreProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseLevelUpgrade
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductLevelPackUpgrade];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchasePlayerUpgradeOne
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductPlayerUpgradeOne];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)purchasePlayerUpgradeTwo
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:kProductPlayerUpgradeTwo];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


// Restore completed transactions
- (void) restoreCompletedTransactions
{
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kProductLevelPackUpgrade])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"levelUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([transaction.payment.productIdentifier isEqualToString:kProductPlayerUpgradeOne])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"playerUpgradeOneReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([transaction.payment.productIdentifier isEqualToString:kProductPlayerUpgradeTwo])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"playerUpgradeTwoReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kProductLevelPackUpgrade])
    {
        // enable the requested features by setting a global user value
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLevelUpgradePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([productId isEqualToString:kProductPlayerUpgradeOne])
    {
        // enable the requested features by setting a global user value
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlayerUpgradeOnePurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if ([productId isEqualToString:kProductPlayerUpgradeTwo])
    {
        // enable the requested features by setting a global user value
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlayerUpgradeTwoPurchased" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
		NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

@end

@implementation SKProduct (LocalizedPrice)

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    [numberFormatter release];
    return formattedString;
}

@end