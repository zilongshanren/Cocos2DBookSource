//
//  MyStore.m
//  IAPGame
//
//  Created by Ricky on 11/5/12.
//  Copyright 2012 eseedo. All rights reserved.
//


#import "MyStore.h"
#import "HelloWorldLayer.h"
#import "GameData.h"

// 商品编号宏定义

#define ProductID_IAPLevel1 @"com.iapgame.1000coins"              //$0.99
#define ProductID_IAPLevel2 @"com.iapgame.10000dragoncoins"          //$1.99
#define ProductID_IAPLevel3 @"com.iapgame.20000dragoncoins"        //$2.99
#define ProductID_IAPLevel4 @"com.iapgame.100000dragoncoins"          //$4.99
#define ProductID_IAPLevel5 @"com.iapgame.1milliondragoncoins"       //$9.99


@implementation MyStore


+(CCScene *)scene{
    
    CCScene *scene = [CCScene node];
    
    MyStore *layer = [MyStore node];
    
    [scene addChild:layer];
    
    return scene;
    
    
}

-(void)addBg{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    CCSprite *bg = [CCSprite spriteWithFile:@"bg_store.png"];
    bg.position = ccp(size.width/2,size.height/2);
    [self addChild:bg z:-1];
    
}

-(void)addButton{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    CCMenuItemFont *item = [CCMenuItemFont itemWithString:@"返回主界面" target:self selector:@selector(backToMain)];
    item.fontSize = 25;
    
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    
    menu.position = ccp(size.width*0.15,size.height*0.8);
    
    [self addChild:menu z:1];
    
}

-(void)backToMain{
    
    CCTransitionFade *transition = [CCTransitionFade transitionWithDuration:2.0f scene:[HelloWorldLayer scene]];
    [[CCDirector sharedDirector]pushScene:transition];
    
}

-(void)purchaseProduct1{
    
    
    //购买商品1
    [self purchase:IAPLevel1];
    CCLOG(@"Purchase product 1 from IAP store");
    
}

-(void)purchaseProduct2{
    
    //购买商品2
    
    [self purchase:IAPLevel2];
    CCLOG(@"Purchase product 2 from IAP store");
}

-(void)purchaseProduct3{
    
    //购买商品3
    
    [self purchase:IAPLevel3];
    CCLOG(@"Purchase product 3 from IAP store");
}

-(void)purchaseProduct4{
    
    
    //购买商品4
    [self purchase:IAPLevel4];
    
    CCLOG(@"Purchase product 4 from IAP store");
}

-(void)purchaseProduct5{
    
    
    //购买商品5
    
    [self purchase:IAPLevel5];
    CCLOG(@"Purchase product 5 from IAP store");
}

-(void)showProducts{
    
    CGSize size = [CCDirector sharedDirector].winSize;
    [CCMenuItemFont setFontSize:25];
    
    CCMenuItemFont *product1Item = [CCMenuItemFont itemWithString:@"购买1000天龙币"  target:self selector:@selector(purchaseProduct1)];
    
    CCMenuItemFont *product2Item = [CCMenuItemFont itemWithString:@"购买10000天龙币"  target:self selector:@selector(purchaseProduct2)];
    
    CCMenuItemFont *product3Item = [CCMenuItemFont itemWithString:@"购买20000天龙币"  target:self selector:@selector(purchaseProduct3)];
    
    CCMenuItemFont *product4Item = [CCMenuItemFont itemWithString:@"购买100000天龙币"  target:self selector:@selector(purchaseProduct4)];
    
    CCMenuItemFont *product5Item = [CCMenuItemFont itemWithString:@"购买1000000天龙币"  target:self selector:@selector(purchaseProduct5)];
    
    CCMenu *menu = [CCMenu menuWithItems:product1Item,product2Item,product3Item,product4Item,product5Item, nil];
    [menu alignItemsVerticallyWithPadding:15];
    menu.position = ccp(size.width*0.7,size.height*0.5);
    
    [self addChild:menu z:0];
    
    
}

#pragma mark 处理IAP的相关方法

#pragma mark SKPaymentTransactionObserver 协议

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    for (SKPaymentTransaction *transaction in transactions){
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                CCLOG(@"交易完成");
                
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"购买成功！您已获得了天龙币!" delegate:self cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"购买失败！请重新尝试购买!" delegate:self cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil, nil];
                [alert2 show];
                [alert2 release];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                UIAlertView *alert3 = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"已经购买过该商品!" delegate:self cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil, nil];
                [alert3 show];
                [alert3 release];
                break;
            case SKPaymentTransactionStatePurchasing:
                CCLOG(@"已将商品添加进列表");
                break;
            default:
                break;
        }
    }
    
    
}

//删除交易

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
    
    CCLOG(@"删除已完成交易");
}


//恢复已完成交易失败

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    
    CCLOG(@"恢复已完成交易失败");
}

//恢复已完成交易成功

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
    CCLOG(@"恢复已完成交易成功");
    
}

#pragma mark SKProductsRequestDelegate 方法

//收到商品请求响应

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSArray *myProduct = response.products;
    
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        
    }
    
    SKPayment *payment = nil;
    switch (purchaseType) {
        case IAPLevel1:
            payment = [SKPayment paymentWithProductIdentifier:ProductID_IAPLevel1];
            break;
        case IAPLevel2:
            payment = [SKPayment paymentWithProductIdentifier:ProductID_IAPLevel2];
            break;
        case IAPLevel3:
            payment = [SKPayment paymentWithProductIdentifier:ProductID_IAPLevel3];
            break;
        case IAPLevel4:
            payment = [SKPayment paymentWithProductIdentifier:ProductID_IAPLevel4];
            break;
        case IAPLevel5:
            payment = [SKPayment paymentWithProductIdentifier:ProductID_IAPLevel5];
            break;
        default:
            break;
    }
    
    [[SKPaymentQueue defaultQueue]addPayment:payment];
    [request autorelease];
}

#pragma mark SKRequestDelegate 方法

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error localizedDescription] delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
}

-(void)requestDidFinish:(SKRequest *)request{
    
    CCLOG(@"---反馈信息结束---");
}

#pragma mark 和IAP购买相关的自定义方法

//请求升级商品数据

-(void)requestProUpgradeProductData{
    
    CCLOG(@"请求升级数据");
    
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
    
}

//请求商品数据

-(void)requestProductData{
    
    
    NSArray *product = nil;
    switch (purchaseType) {
        case IAPLevel1:
            product = [[NSArray alloc]initWithObjects:ProductID_IAPLevel1, nil];
            break;
        case IAPLevel2:
            product = [[NSArray alloc]initWithObjects:ProductID_IAPLevel2, nil];
            break;
        case IAPLevel3:
            product = [[NSArray alloc]initWithObjects:ProductID_IAPLevel3, nil];
            break;
        case IAPLevel4:
            product = [[NSArray alloc]initWithObjects:ProductID_IAPLevel4, nil];
            break;
        case IAPLevel5:
            product = [[NSArray alloc]initWithObjects:ProductID_IAPLevel5, nil];
            break;
            
        default:
            break;
    }
    
    NSSet *set = [NSSet setWithArray:product];
    SKProductsRequest *request = [[SKProductsRequest alloc]initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
    [product release];
}

//是否可以购买商品

-(bool)canMakePurchases{
    
    return [SKPaymentQueue canMakePayments];
}


//购买某种商品

-(void)purchase:(int)type{
    
    purchaseType = type;
    
    if([SKPaymentQueue canMakePayments]){
        [self requestProductData];
        CCLOG(@"允许应用内购买");
    }else {
        CCLOG(@"不允许应用内购买");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您不能使用应用内购买" delegate:self cancelButtonTitle:NSLocalizedString(@"关闭", nil) otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
}

//购买交易

-(void)purchasedTransaction:(SKPaymentTransaction *)transaction{
    
    CCLOG(@"购买的交易");
    NSArray *transactions = [[NSArray alloc]initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
    [transactions release];
    
    
}

//交易完成

-(void)completeTransaction:(SKPaymentTransaction *)transaction{
    
    CCLOG(@"交易完成");
    NSString *product = transaction.payment.productIdentifier;
    if([product length] >0){
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *productId = [tt lastObject];
        if([productId length] >0){
            
            [self recordTransaction:transaction];
            
            [self provideContent:productId];
        }
    }
    
    //将交易从购买队列中删除
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    
}

//交易失败

-(void)failedTransaction:(SKPaymentTransaction *)transaction{
    
    if(transaction.error.code != SKErrorPaymentCancelled){
        
    }
    
    [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
    
}

//恢复交易

-(void)restoreTransaction:(SKPaymentTransaction *)transaction{
    
    CCLOG(@" 交易恢复处理");
    
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    
}

//向玩家提供商品

-(void)provideContent:(NSString *)product{
    
    CCLOG(@"处理下载内容");
    
    //根据所购买商品的不同提供不同数量的天龙币
    
    switch (purchaseType) {
        case IAPLevel1:
            [GameData sharedData].currentDragonCoins += 1000;
            break;
        case IAPLevel2:
            [GameData sharedData].currentDragonCoins += 10000;
            break;
        case IAPLevel3:
            [GameData sharedData].currentDragonCoins += 20000;
            break;
        case IAPLevel4:
            [GameData sharedData].currentDragonCoins += 100000;
            break;
        case IAPLevel5:
            [GameData sharedData].currentDragonCoins += 1000000;
            break;
            
        default:
            break;
    }
    
}

//记录交易


-(void)recordTransaction:(SKPaymentTransaction *)transaction{
    
    CCLOG(@"记录交易");
}

#pragma mark NSURL连接代理

//确认接收数据

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    
    NSLog(@"%@",[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease]);
    
}


//连接完成

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    
}

//连接收到响应

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response{
    switch ([(NSHTTPURLResponse *)response statusCode]) {
            
            
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
            
        default:
            break;
    }
    
}

//连接失败

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"test");
}


#pragma mark 游戏初始化方法

-(id)init{
    if((self =[super init])){
        
        [self addButton];
        
        //添加商品
        
        [self showProducts];
        
        //添加背景
        
        [self addBg];
        
        //添加IAP监听
        
        [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
        
    }
    return self;
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    
    //解除监听
    [[SKPaymentQueue defaultQueue]removeTransactionObserver:self];
    
	[super dealloc];
}

@end
