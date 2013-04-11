/*
 * ZJoystick: http://zaldzbugz.posterous.com/first-article
 *
 * Copyright (c) 2011-2013 Zaldy Bernabe N. Bughaw
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "ZJoystick.h"

@interface ZJoystick (PrivateMethods)
CGFloat getDistanceBetweenTwoPoints(CGPoint point1,CGPoint point2);
//version 1.3
-(CGSize)getControlledObjectSize;
@end

@implementation ZJoystick
@synthesize normalTexture			= _normalTexture;
@synthesize selectedTexture			= _selectedTexture;
@synthesize controllerSpriteFile	= _controllerSpriteFile;

@synthesize controller				= _controller;
@synthesize delegate				= _delegate;
@synthesize isControlling			= _isControlling;
@synthesize isJostickDisabled        = _isJostickDisabled;
@synthesize controlQuadrant			= _controlQuadrant;
@synthesize controllerActualDistance= _controllerActualDistance;
@synthesize speedRatio				= _speedRatio;
@synthesize controllerActualPoint	= _controllerActualPoint;
@synthesize controlledObject		= _controlledObject;

//version 1.2
@synthesize joystickRadius          = _joystickRadius;
//version 1.3
@synthesize joystickTag             = _joystickTag;

//m = y2-y1 / x2-x1
CGFloat getSlope(CGPoint point1, CGPoint point2) {
	
	if (point2.x <= 1.0f && point2.x >= -1.0f) {
		//point2.x = 1.0f;
	}
	
	CGFloat my = point2.y - point1.y;
	CGFloat mx = point2.x - point1.x;
	CGFloat m = my/mx;
	
	if (m == INFINITY || m == -INFINITY) {
		//CCLOG(@"INFINITE");
		//m = 2;
	}
	
	return m;
};

//b = y - mx
//y = mx + b
//we dont need b since b = 0 always
//distance  = sqrt((X2 - X1)^2 + )
CGPoint getCPoint(CGFloat slope, CGFloat distance) {
	
	//y = mx + b
	//b = 0
	CGFloat x = sqrt(((distance * distance) / (1 + (slope*slope))));
	CGFloat y = slope * x;
	return CGPointMake(x, y);
};

CGFloat getDistanceBetweenTwoPoints(CGPoint point1,CGPoint point2)
{
	CGFloat dx = point2.x - point1.x;
	CGFloat dy = point2.y - point1.y;
	return sqrt(dx*dx + dy*dy );
};

-(CGRect) getBoundingRect
{
	CGSize size = [self contentSize];
	size.width	*= scaleX_;
	size.height *= scaleY_;
	return CGRectMake(position_.x - size.width * anchorPoint_.x, 
					  position_.y - size.height * anchorPoint_.y, 
					  size.width, size.height);
}

tControlQuadrant getQuadrantForPoint (CGPoint point) {
    
	tControlQuadrant controlQuadrant;
	
	//Quadrants setup
	if (point.x >= 0 && point.y >= 0) {
		controlQuadrant = kFirstQuadrant;
	} else if (point.x >= 0 && point.y < 0) {
		controlQuadrant = kSecondQuadrant;
	} else if (point.x < 0 && point.y >= 0) {
		controlQuadrant = kThirdQuadrant;
	} else if (point.x < 0 && point.y < 0) {
		controlQuadrant = kFourthQuadrant;
	}
	
	return controlQuadrant;
};

-(CGFloat)getYMinimumLimit {
    //version 1.3
    CGSize cSize = [self getControlledObjectSize];
	
	return cSize.height/2;
}

-(CGFloat)getYMaximumLimit {
	CGSize winSize  = [CCDirector sharedDirector].winSize;
    //version 1.3
    CGSize cSize = [self getControlledObjectSize];
    
	return winSize.height - cSize.height/2;
}

-(CGFloat)getXMinimumLimit {
    //version 1.3
    CGSize cSize = [self getControlledObjectSize];
    
	return cSize.width/2;
}

-(CGFloat)getXMaximumLimit {
	CGSize winSize  = [CCDirector sharedDirector].winSize;
    //version 1.3
    CGSize cSize = [self getControlledObjectSize];
    
	return winSize.width - cSize.width/2;
}

//version 1.3
-(CGSize)getControlledObjectSize {
    //version 1.3
	CCSprite *controlledObject = (CCSprite *)_controlledObject;
    CGSize  cSize = controlledObject.contentSize;
    
    return cSize;
}

#pragma mark -
#pragma mark Scheduler methods
-(void)activateScheduler {
	[self schedule:@selector(update:)];
}

-(void)deactivateScheduler {
	[self unschedule:@selector(update:)];
}

#pragma mark -
#pragma mark Set Timers For Objects to move
-(void)update:(ccTime) dt {
    
	CCSprite *controlledObject = (CCSprite *)_controlledObject;
    
	CGPoint cPoint =  controlledObject.position;
	
	CGFloat xMinLimit = [self getXMinimumLimit];
	CGFloat xMaxLimit = [self getXMaximumLimit];
	
	CGFloat yMinLimit = [self getYMinimumLimit];
	CGFloat yMaxLimit = [self getYMaximumLimit];
	
	//N = point * 1 / _joystickRadius
	CGFloat xSpeedRatio = _controllerActualPoint.x / _joystickRadius;
	CGFloat ySpeedRatio = _controllerActualPoint.y / _joystickRadius;
	
    //BORDERS
    //X limits
    if (cPoint.x < xMinLimit) {
        if (xSpeedRatio < 0) {
            xSpeedRatio = 0;
        }
    } else if (cPoint.x > xMaxLimit) {
        if (xSpeedRatio > 0) {
            xSpeedRatio = 0;
        }
    }
    
    //Y limits
    if (cPoint.y < yMinLimit) {
        if (ySpeedRatio < 0) {
            ySpeedRatio = 0;
        }
    } else if (cPoint.y > yMaxLimit) {
        if (ySpeedRatio > 0) {
            ySpeedRatio = 0;
        }
    }
	
    //if we dont set speed ration, we give it deafault value to 1
    if (_speedRatio == 0) {
        _speedRatio = 1;
    }
    
    xSpeedRatio = xSpeedRatio * _speedRatio;
    ySpeedRatio = ySpeedRatio * _speedRatio;
    
    //version 1.3
    if (controlledObject) {
        //position object
        controlledObject.position = ccp(controlledObject.position.x + xSpeedRatio, controlledObject.position.y + ySpeedRatio);
    }
    //call protocol method here to gain speed ratios
    //check if _delegate conforms to the protocol and responds to the selector
    if ([_delegate conformsToProtocol:@protocol(ZJoystickDelegate)]) {
        if([_delegate respondsToSelector:@selector(joystickControlDidUpdate:toXSpeedRatio:toYSpeedRatio:)]) {
            [_delegate joystickControlDidUpdate:self toXSpeedRatio:xSpeedRatio toYSpeedRatio:ySpeedRatio];
        }
    }
}

+(id)joystickNormalSpriteFile:(NSString *)filename1 selectedSpriteFile:(NSString *)filename2 controllerSpriteFile:(NSString *)controllerSprite{
	
	ZJoystick *joystick		= [[[self alloc] initWithFile:filename2] autorelease];
	joystick.normalTexture	= [[CCTextureCache sharedTextureCache] addImage:filename1];
	joystick.selectedTexture= [[CCTextureCache sharedTextureCache] addImage:filename2];
	joystick.controllerSpriteFile = controllerSprite;
    joystick.speedRatio     = 1.0;                  //added default values which is 1
    joystick.joystickRadius = kJoystickRadius;      //added default values for joystick radius which is 50
	return joystick;
}

#pragma mark -
#pragma mark Touches
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
	CCLOG(@"Joystick ccTouchBegan");
    CGPoint location	= [touch locationInView: [touch view]];
	location			= [[CCDirector sharedDirector] convertToGL:location];
	//CGRect rect			= [self getBoundingRect];
	
    //check if we already have touched the background
    //and check if our jostick is enabled
	if (isCurrentlyControlling || _isJostickDisabled ) {
        CCLOG(@"Joystick Disabled");
		return NO;
	}
	
	CGPoint actualPoint = CGPointMake(location.x - self.position.x, location.y - self.position.y);
	
	//actual distance of joystick and the touch point
	//this is when the touch is inside the joystick
	CGFloat actualPointDistance = getDistanceBetweenTwoPoints(self.position, location);
	
    NSLog(@"Actual Distance - %f", actualPointDistance);
    
	//check if the touch point is within the joystick container's radius
	if (actualPointDistance <= _joystickRadius){
        //if (CGRectContainsPoint(rect, location)) {
		CCLOG(@"Joystick Touched");
		
        //call delegate method
        //check if _delegate conforms to the protocol and responds to the selector
        if ([_delegate conformsToProtocol:@protocol(ZJoystickDelegate)]) {
            if([_delegate respondsToSelector:@selector(joystickControlBegan)]) {
                [_delegate performSelector:@selector(joystickControlBegan)];
            }
        }
        
		//[_delegate joystickControlBegan];	
		
		//Speed ratio
		//distance of joystick center point to touch point
		self.controllerActualDistance = getDistanceBetweenTwoPoints(self.position, location);
		
		//Point Ratio
		self.controllerActualPoint = actualPoint;
		
		//Quadrants
		self.controlQuadrant = getQuadrantForPoint(actualPoint);
		
		//set touch began to YES
		isCurrentlyControlling = YES;
		
		//change joystick to normal image
		//CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"JoystickContainer_norm.png"];
		//[self setDisplayFrame:frame];
		[self setTexture:_normalTexture];
		
		//jostick button controller
		_controller.position = ccp(self.contentSize.width/2 + actualPoint.x, self.contentSize.height/2 + actualPoint.y);
        
		//add fadeIn animation
		id inAction = [CCFadeIn actionWithDuration:kControlActionInterval];
		[_controller runAction:inAction];
		
		CCLOG(@"POINT DISTANCE - %f", getDistanceBetweenTwoPoints(self.position, location));
		
		self.isControlling = YES;			//our joystick is now controlling
		
		//Activate Scheduler
		[self activateScheduler];
		
		return YES;
	}
	
	CCLOG(@"Quadrant = %d", _controlQuadrant);
	
    
	
	return NO; //we return yes to gain access control of MOVE and ENDED delegate methods
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
	CCLOG(@"Joystick ccTouchMoved");
	CGPoint location	= [touch locationInView: [touch view]];
	location			= [[CCDirector sharedDirector] convertToGL:location];
	//CGRect rect			= [self getBoundingRect];
    
	
	CGPoint actualPoint = CGPointMake(location.x - self.position.x, location.y - self.position.y);
	
	
    
	if (isCurrentlyControlling) {
		
        //execute our delegate method
        //check if _delegate conforms to the protocol and responds to the selector
        if ([_delegate conformsToProtocol:@protocol(ZJoystickDelegate)]) {
            if([_delegate respondsToSelector:@selector(joystickControlMoved)]) {
                [_delegate performSelector:@selector(joystickControlMoved)];
            }
        }
        
		//[_delegate joystickControlMoved];
		
		//actual distance of joystick and the touch point
		//this is when the touch is inside the joystick
		CGFloat actualPointDistance = getDistanceBetweenTwoPoints(self.position, location);
		
		//check if touch is inside the 
		if (actualPointDistance <= _joystickRadius){
			//if (CGRectContainsPoint(rect, location)) {
			
			//Speed ratio
			//distance of joystick center point to touch point
			self.controllerActualDistance = actualPointDistance;
			
			//Point Ratio
			self.controllerActualPoint = actualPoint;
			
			//jostick button controller
			_controller.position = ccp(self.contentSize.width/2 + actualPoint.x, self.contentSize.height/2 + actualPoint.y);
			//call delegate method
			
		} else {
			//CCLOG(@"JOYSTICK POSITION = (%f, %f)", self.position.x, self.position.y);
			//CCLOG(@"TOUCH POSITION = (%f, %f)", location.x, location.y);
			//CCLOG(@"RELATIVE TOUCH AND JOYSTICK POSITION = (%f, %f)", actualPoint.x, actualPoint.y);
			
			//Speed ratio
			//radius of joystick
			self.controllerActualDistance = _joystickRadius;
			
			//we compute our SLOPE 
			//Slope are the same in ever points that passes the slope line
			CGFloat slope = getSlope(CGPointMake(0, 0), actualPoint);
			//CCLOG(@"SLOPE VALUE = %f",slope);
			
			CGPoint point;
			
			//X = 0 or -0
			//if we have an Infinite slope result 
			//means that we are in the 4th Quadrant
			if (slope == -INFINITY) {
				point = ccp(0 , -_joystickRadius);
                //3rd Quadrant
			} else if (slope == INFINITY) {
				point = ccp(0 , _joystickRadius);
                //1st & 2nd Quadrant
			} else {
				//no matter if SLOPE and DISTANCE are (-), it would still result a positive value since they are computed by ^2
				point = getCPoint(slope, _joystickRadius);
			}
			
			//X > or < 0
			//We check our actual points if we reach points of in 3rd Quadrant
			if (actualPoint.x < 0 && actualPoint.y >= 0) {
				point = CGPointMake(-1 * point.x, point.y * -1);
                //We check our actual points if we reach points of in 4th Quadrant
			} else if (actualPoint.x < 0 && actualPoint.y <= 0) {
				point = CGPointMake(-1 * point.x, -1 * point.y);
			}
			
			//we add the position of joystick since we need to position the controller surrounding the joystick
			CGPoint controllerPoint = CGPointMake(point.x + self.contentSize.width/2, point.y + self.contentSize.height/2);
			
			//CCLOG(@"POINT VALUE = (%f, %f)", point.x, point.y);
			//CCLOG(@"SQUAREROOT of 1 = %f",sqrt(1.0f));		
			//CCLOG(@"CONTROLLER POSITION (%f, %f)",controllerPoint.x, controllerPoint.y);
			
			//Point Ratio
			self.controllerActualPoint = point;
			
			//we position out controller
			_controller.position = controllerPoint;
		}
        
		//Quadrants
		self.controlQuadrant = getQuadrantForPoint(actualPoint);
		
		
	}
	
	//CCLOG(@"Quadrant = %d", _controlQuadrant);
}


//Thanks to Joey Hengst for this update.
//this will allow more than one joysticks in a screen both simulator and device
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self ccTouchEnded:touch withEvent:event];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CCLOG(@"Joystick ccTouchEnded");
	
    //execute our delegate method
    //check if _delegate conforms to the protocol and responds to the selector
    if ([_delegate conformsToProtocol:@protocol(ZJoystickDelegate)]) {
        if([_delegate respondsToSelector:@selector(joystickControlEnded)]) {
            [_delegate performSelector:@selector(joystickControlEnded)];
        }
    }
    
	//[_delegate joystickControlEnded];			//call delegate method
	
	//change joystick to transparent image
	//CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"JoystickContainer_trans.png"];
	//[self setDisplayFrame:frame];
	[self setTexture:_selectedTexture];
	
	//to avoid fading out everytime touch is ended anywhere.
	if (isCurrentlyControlling) {
		//use fadeOut action to fade the controller
		id outAction = [CCFadeOut actionWithDuration:kControlActionInterval];
		[_controller runAction:outAction];
	}
	
	//set the boolean if touched inside to NO
	isCurrentlyControlling	= NO;
	
	self.isControlling	= NO;				//our joystick has stopped controlling
	
	//Deactivate Scheduler
	[self deactivateScheduler];
	
	
}

#pragma mark -
#pragma mark OnEnter & OnExit
- (void)onEnter
{	
	CCLOG(@"onEnter");
	[super onEnter];
	
	self.isControlling = NO; //initially our joystick should stop controlling
	
	//we add joystick button sprite initialy
	self.controller		= nil;
	self.controller		= [CCSprite spriteWithFile:_controllerSpriteFile];
	_controller.position= ccp(-200, -200);
	_controller.opacity	= 0.0f;
	[self addChild:_controller];
	
	//we call touch dispatcher to swallow touches
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
													 priority:0 
											  swallowsTouches:YES];
}

- (void)onExit
{
	CCLOG(@"onExit");
	[self removeChild:_controller cleanup:YES];
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	
	[super onExit];
}

#pragma mark -
-(void)dealloc {
	
	self.controllerSpriteFile = nil;
	self.normalTexture      = nil;
	self.selectedTexture    = nil;
	self.controlledObject   = nil;
	self.delegate           = nil;
    
	[super dealloc];
}

@end
