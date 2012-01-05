//
//  InAppPurchaseManager.h
//  ECount
//
//  Created by Chris Desch on 1/4/12.
//  Copyright (c) 2012 Desch Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>


#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

// add a couple notifications sent out when the transaction completes
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *levelUpgradeProduct, *playerUpgradeOne, *playerUpgradeTwo;
    SKProductsRequest *productsRequest;
	BOOL storeDoneLoading;
}

+(InAppPurchaseManager *)sharedInAppManager;

- (void)requestAppStoreProductData;
- (void)loadStore;
- (BOOL)storeLoaded;
- (BOOL)canMakePurchases;
- (void)purchaseLevelUpgrade;
- (void)purchasePlayerUpgradeOne;
- (void)purchasePlayerUpgradeTwo;
- (void)restoreCompletedTransactions;
- (SKProduct *)getLevelUpgradeProduct;
- (SKProduct *)getPlayerUpgradeOne;
- (SKProduct *)getPlayerUpgradeTwo;

@end

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end