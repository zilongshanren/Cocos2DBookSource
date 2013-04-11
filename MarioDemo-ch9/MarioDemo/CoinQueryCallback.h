//
//  CoinQueryCallback.h
//  MarioDemo
//
//  Created by guanghui on 8/8/12.
//
//
#import "Box2d.h"
#import "cocos2d.h"

class CoinQueryCallback : public b2QueryCallback
{
public:
	
	enum
	{
		e_maxCount = 100  //最多一次能吸引多少个金币
	};
    
	CoinQueryCallback()
	{
		m_count = 0;
	}
    
	/// Called for each fixture found in the query AABB.
	/// @return false to terminate the query.
	bool ReportFixture(b2Fixture* fixture)
	{
		if (m_count == e_maxCount)
		{
			return false;  //返回假则不会继续执行queryAABB
		}
        
		b2Body* body = fixture->GetBody();
		b2Shape* shape = fixture->GetShape();
        //因为一个shape可以封装多个child shape，所以要指定childIndex
		bool overlap = b2TestOverlap(shape, 0, &m_circle,0, body->GetTransform(), m_transform);
        
        CCSprite *sprite = (CCSprite*)(body->GetUserData());
		if (overlap)
		{
            if (sprite != nil && sprite.tag == 101) {
                m_count++;
                
                sprite.visible = NO;
                world->DestroyBody(body);
                body = NULL;
                
                CCLOG(@"吸一个！");
            }
			
		}
        
		return true;
	}
    
	b2CircleShape m_circle;
	b2Transform m_transform;
	int32 m_count;
    b2World *world;
};
