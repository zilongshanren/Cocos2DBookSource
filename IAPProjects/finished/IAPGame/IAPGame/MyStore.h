//
//  MyStore.h
//  IAPGame
//
//  Created by Ricky on 11/5/12.
//  Copyright 2012 eseedo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import <StoreKit/StoreKit.h>


enum{
    
    IAPLevel1 = 10,
    IAPLevel2,
    IAPLevel3,
    IAPLevel4,
    IAPLevel5,
    
}dragonCoinsTag;

@interface MyStore : CCLayer <SKProductsRequestDelegate, SKPaymentTransactionObserver,SKRequestDelegate> {
    
    int purchaseType;
    
}

+(CCScene *) scene;

//SKPaymentTransactionObserver 方法

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions;


-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error;
-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue;

//SKProductsRequestDelegate 方法

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response;

//SKRequestDelegate 方法

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error;

-(void)requestDidFinish:(SKRequest *)request;


//自定义方法

-(void)requestProUpgradeProductData;
-(void)requestProductData;

-(bool)canMakePurchases;
-(void)purchase:(int)type;


-(void)purchasedTransaction:(SKPaymentTransaction*)transaction;
-(void)completeTransaction:(SKPaymentTransaction*)transaction;
-(void)failedTransaction:(SKPaymentTransaction*)transaction;

-(void)restoreTransaction:(SKPaymentTransaction*)transaction;
-(void)provideContent:(NSString*)product;
- (void)recordTransaction:(SKPaymentTransaction *)transaction;

@end
