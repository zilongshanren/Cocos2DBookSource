//
//  HelloWorldLayer.mm
//  PhysicShootingGame
//
//  Created by guanghui on 8/4/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "PhysicsSprite.h"
#import "Helper.h"
#import "GB2ShapeCache.h"

enum {
	kTagParentNode = 1,
    kTagBulletBody = 101,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) initPlayer;
-(void) initDestination;
-(void) initScore;
-(void) initKinematicBody;
@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		
        [[GB2ShapeCache sharedShapeCache] addShapesWithFile:@"ComplexShape.plist"];
		
		// init physics
		[self initPhysics];
        [self initPlayer];
        [self initDestination];
        [self initScore];
        [self initKinematicBody];
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) initKinematicBody{
    {
        b2BodyDef kinematicDef;
        kinematicDef.type = b2_kinematicBody;
        kinematicDef.position.Set(200 / PTM_RATIO, 10.0 / PTM_RATIO);
        kinematicDef.linearVelocity = b2Vec2(0,6.0);
        b2Body* body =  world->CreateBody(&kinematicDef);
        
        b2PolygonShape kinematicShape;
        kinematicShape.SetAsBox(10.0 / PTM_RATIO, 5.0 / PTM_RATIO);
        body->CreateFixture(&kinematicShape, 10);

    }
    {
        b2BodyDef kinematicDef;
        kinematicDef.type = b2_kinematicBody;
        kinematicDef.position.Set(250 / PTM_RATIO, 10.0 / PTM_RATIO);
        kinematicDef.linearVelocity = b2Vec2(0,4.0);
        b2Body* body =  world->CreateBody(&kinematicDef);
        
        b2PolygonShape kinematicShape;
        kinematicShape.SetAsBox(10.0 / PTM_RATIO, 5.0 / PTM_RATIO);
        body->CreateFixture(&kinematicShape, 10);

    }
    
    {
        b2BodyDef kinematicDef;
        kinematicDef.type = b2_kinematicBody;
        kinematicDef.position.Set(300 / PTM_RATIO, 10.0 / PTM_RATIO);
        kinematicDef.linearVelocity = b2Vec2(0,8.0);
        b2Body* body =  world->CreateBody(&kinematicDef);
        
        b2PolygonShape kinematicShape;
        kinematicShape.SetAsBox(10.0 / PTM_RATIO, 5.0 / PTM_RATIO);
        body->CreateFixture(&kinematicShape, 10);

    }
        
    
}

-(void) initScore{
    _score = 0;
    NSString *strScore = [NSString stringWithFormat:@"%d",_score];
    _scoreLabel = [CCLabelTTF labelWithString:strScore fontName:@"Arial" fontSize:20];
    _scoreLabel.position = ccp(50,280);
    [self addChild:_scoreLabel];
}

-(void) initPlayer{
    //创建头部
    b2BodyDef headDef;
    headDef.type = b2_dynamicBody;
    CGPoint headPos = ccp(50,100);
    headDef.position = [Helper metersFromPoint:headPos];
    
    b2Body *headBody = world->CreateBody(&headDef);
    b2CircleShape circleShape;
    circleShape.m_radius = 10.0 / PTM_RATIO;
    headBody->CreateFixture(&circleShape, 10.0);
    
    
    //创建身体
    b2BodyDef bodyDef;
//    bodyDef.type = b2_dynamicBody;
    CGPoint bodyPos = ccp(50,20);
    bodyDef.position = [Helper metersFromPoint:bodyPos];
    b2Body *bodyBody = world->CreateBody(&bodyDef);
    
    b2PolygonShape bodyShape;
    bodyShape.SetAsBox(12.0 / PTM_RATIO, 20.0 / PTM_RATIO);
    bodyBody->CreateFixture(&bodyShape, 15);
    
    //创建脖子（使用焊接关节）
    b2WeldJointDef neckJoint;
    neckJoint.bodyA = headBody;
    neckJoint.bodyB = bodyBody;
    neckJoint.localAnchorA = headBody->GetLocalCenter() + b2Vec2(0,-10/PTM_RATIO);
    neckJoint.localAnchorB = bodyBody->GetLocalCenter() + b2Vec2(0,10 / PTM_RATIO);
    neckJoint.collideConnected = false;
    
    world->CreateJoint(&neckJoint);
    
    
    //创建发射手臂，后面，我们将使用此手臂来发射子弹
    b2BodyDef armBodyDef;
    armBodyDef.type = b2_dynamicBody;
    armBodyDef.position = bodyBody->GetWorldCenter() + b2Vec2(5.0 / PTM_RATIO,0);
    _armBody = world->CreateBody(&armBodyDef);
    
    
    b2PolygonShape armBodyShape;
    armBodyShape.SetAsBox(18.0 / PTM_RATIO, 5.0 / PTM_RATIO);
    _armBody->CreateFixture(&armBodyShape, 3.0);
    
    
    //创建一个转动关节 连接手臂和身体
    b2RevoluteJointDef armJointDef;
    armJointDef.bodyA = bodyBody;
    armJointDef.bodyB = _armBody;
    armJointDef.enableLimit = true;
    armJointDef.enableMotor = true;
    armJointDef.maxMotorTorque = 10.0;  //防止手臂乱动
//    armJointDef.motorSpeed = 2.0f;  //如果想让手臂自己旋转的话，需要设置motorSpeed
    armJointDef.lowerAngle = CC_DEGREES_TO_RADIANS(0);
    armJointDef.upperAngle = CC_DEGREES_TO_RADIANS(90);
    armJointDef.localAnchorA = bodyBody->GetLocalCenter() + b2Vec2(5.0/PTM_RATIO,0);
    armJointDef.localAnchorB = _armBody->GetLocalCenter() + b2Vec2(-10.0 / PTM_RATIO , 0.0 / PTM_RATIO);
    armJointDef.collideConnected = false;
    
    world->CreateJoint(&armJointDef);
}

-(void) initDestination{
    //制作一个凹型的body,因为box2d要求shape必须是凸多边形，所以，要制作凹多边形的body，必须进行分解，把
    //凹多边形拆分成3个凸多边形
    
    b2BodyDef destBodyDef;
    destBodyDef.type = b2_dynamicBody;
    destBodyDef.position = [Helper metersFromPoint:ccp(400,50)];
    
    _destBody = world->CreateBody(&destBodyDef);
    
    //使用PhysicEditor辅助创建复杂的shape
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:_destBody forShapeName:@"Icon"];
    
    
    //在凹槽内部的下方制作一个sensor，用来检测球是否打进去
    b2BodyDef scoreBodyDef;
    scoreBodyDef.type = b2_dynamicBody;
    scoreBodyDef.position = _destBody->GetWorldCenter();
    
    _scoreBody = world->CreateBody(&scoreBodyDef);
    
    b2PolygonShape scoreBodyShape;
    scoreBodyShape.SetAsBox(10 / PTM_RATIO, 5 / PTM_RATIO);
    b2FixtureDef scoreFixture;
    scoreFixture.shape = &scoreBodyShape;
    scoreFixture.filter.groupIndex = 1;
    scoreFixture.filter.categoryBits = 0x0001;
    scoreFixture.filter.maskBits = 0xffff;
    scoreFixture.isSensor = true;
    
    _scoreBody->CreateFixture(&scoreFixture);
    
    //把凹槽和这个传感器连接起来
    b2WeldJointDef scoreJointDef;
    scoreJointDef.dampingRatio = 1.0f;
    scoreJointDef.collideConnected = false;
    scoreJointDef.Initialize(_destBody, _scoreBody,
                             _destBody->GetLocalCenter());
    world->CreateJoint(&scoreJointDef);
    
    
    
    //创建一个上下升降的关节，让这个凹槽子上下移动
    b2PrismaticJointDef jointDef;
    jointDef.enableLimit = true;
    jointDef.enableMotor = true;
    jointDef.upperTranslation = 320 / PTM_RATIO; //表示上下可以移动的位移，使用的也是“米”作为单位
    jointDef.lowerTranslation = 0;
    jointDef.collideConnected = true;
    jointDef.motorSpeed = 5;
    jointDef.maxMotorForce = _destBody->GetMass() * 10000.0f;
    
    b2Vec2 worldAxis = b2Vec2(0.0,1.0);  //垂直方向
    jointDef.Initialize(_groundBody,_destBody, _destBody->GetWorldCenter(), worldAxis);
    
    _destJoint = (b2PrismaticJoint*)world->CreateJoint(&jointDef);
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
    
    delete _contactListener;
    _contactListener = NULL;
	
	[super dealloc];
}	

-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
    
    
    _contactListener = new MyContactListener;
    world->SetContactListener(_contactListener);
    
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body. 默认是 static类型的body
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	_groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	_groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	_groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	_groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	_groundBody->CreateFixture(&groundBox,0);
    
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();	
	
	kmGLPopMatrix();
}


-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
    
        
    for (b2Body *body = world->GetBodyList(); body; ) {
        int *tag = (int*)body->GetUserData();
        
        //处理上下飞行的障碍物
        if (body->GetType() == b2_kinematicBody) {
            CGPoint pos = [Helper pointFromMeters:body->GetPosition()];
            float velocity = body->GetLinearVelocity().y;
            if ((pos.y > 300 && velocity > 0) || (pos.y < 10 && velocity <0)) {
                velocity *= -1;
                body->SetLinearVelocity(b2Vec2(0,velocity));
            }
        }
        
        //删除快静止的子弹
        /// 如果不使用b2ContactListener的话，可能会丢失一些contact信息.
        if (NULL != tag && *tag == kTagBulletBody && body->GetContactList() != NULL) {
            //如果打进凹槽，则加1分
            b2Contact *contact = body->GetContactList()->contact;
            b2Manifold *manifold = contact->GetManifold();
            
            std::vector<MyContact>::iterator pos;
            for(pos = _contactListener->_contacts.begin();
                pos != _contactListener->_contacts.end(); ++pos) {
                MyContact contact =*pos;
                
                if ((contact.fixtureA == body->GetFixtureList() && contact.fixtureB == _scoreBody->GetFixtureList()) ||
                    (contact.fixtureA == _scoreBody->GetFixtureList() && contact.fixtureB == body->GetFixtureList())) {
                    //防止内存泄漏
                    delete tag;
                    tag = NULL;
                    
                    //错误防止
                    b2Body *newBody = body;
                    body = body->GetNext();
                    
                    world->DestroyBody(newBody);
                    newBody = NULL;
                    
                    _score++;
                    CCLOG(@"得分!");
                    return;

                }
            }
                         
             

            
            //如果速度过低 或者进入睡眠状态，则删除此子弹
            if (b2Abs(body->GetLinearVelocity().Length()) < 0.01f ) {
                
                int contactCount = manifold->pointCount;
                
                
                //子弹必须着地 或者靠墙 才让它销毁
                if (contactCount > 0 || !body->IsAwake()) {
                    //防止内存泄漏
                    delete tag;
                    tag = NULL;
                    
                    //错误防止
                    b2Body *newBody = body;
                    body = body->GetNext();
                    
                    world->DestroyBody(newBody);
                    newBody = NULL;
                    return;
                }
            }
        }
        
        body = body->GetNext();
    }
    
    
    //处理凹槽上下移动
    CGPoint destPos = [Helper pointFromMeters:_destBody->GetPosition()];
    if (destPos.y > 250) {
        _destJoint->SetMotorSpeed(-5);
    }
    
    if (destPos.y <= 50) {
        _destJoint->SetMotorSpeed(5);
    }
    
    //更新分数
    [_scoreLabel setString:[NSString stringWithFormat:@"%d",_score]];

}


-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_mouseJoint != NULL) {
        return;
    }
    
    for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		b2Vec2 worldLocation = [Helper metersFromPoint:location];
        
        b2Fixture *armFixture = _armBody->GetFixtureList();
        //只有选中了手臂才可以拖动人物
        if (armFixture->TestPoint(worldLocation)) {
            b2MouseJointDef mouseDef;
            mouseDef.bodyA = _groundBody;
            mouseDef.bodyB = _armBody;
            mouseDef.maxForce = _armBody->GetMass() * 1000.0f;
            mouseDef.target = worldLocation;  //设置鼠标点击的位置点
            
            _mouseJoint =  (b2MouseJoint*)world->CreateJoint(&mouseDef);

        }
    }
    
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		b2Vec2 worldLocation = [Helper metersFromPoint:location];
        
        if (_mouseJoint) {
            _mouseJoint->SetTarget(worldLocation);
        }
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_mouseJoint) {
        world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		if (_mouseJoint) {
            world->DestroyJoint(_mouseJoint);
            _mouseJoint = NULL;
            
            
            //计算射击的方向和用力大小
            CGFloat shootAngle = _armBody->GetAngle();
//            CCLOG(@"角度= %f",CC_RADIANS_TO_DEGREES(shootAngle));
            int power = 20;
            float x1 =  cos(shootAngle);
            float y1 =  sin(shootAngle);
            
            b2Vec2 force = b2Vec2(x1 * power,y1 * power);
            
            //松手之后，发射一个子弹出去  之后子弹再消失            
            b2BodyDef bulletDef;
            bulletDef.position = _armBody->GetWorldCenter() + (4.0 / PTM_RATIO) * b2Vec2(x1,y1) ;
            bulletDef.bullet = true;
            bulletDef.type = b2_dynamicBody;
            bulletDef.fixedRotation = true;
            bulletDef.linearDamping = 0.5f;
            b2Body *bulletBody =  world->CreateBody(&bulletDef);
            int *bulletTag = new int(kTagBulletBody);
            bulletBody->SetUserData(bulletTag);
            
            b2CircleShape bulletShape;
            bulletShape.m_radius = 5.0 / PTM_RATIO;
            
            b2FixtureDef bulletFixture;
            bulletFixture.shape = &bulletShape;
            bulletFixture.friction = 0.4f;
            bulletFixture.restitution = 0.2f;
            bulletFixture.density = 10.0f;
            bulletFixture.filter.categoryBits = 0x0001;
            bulletFixture.filter.maskBits = 0xffff;
            bulletFixture.filter.groupIndex = 4;
            bulletBody->CreateFixture(&bulletFixture);
            
          
            bulletBody->ApplyLinearImpulse(force, bulletBody->GetLocalCenter());
            
            
        }
	}
}


@end
