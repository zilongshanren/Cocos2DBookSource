/* ContactListener.h
 
 该类负责碰撞检测的判断与处理
 
 */

#import "Box2D.h"
#import "GameSounds.h"

class ContactListener : public b2ContactListener
{
private:
	void BeginContact(b2Contact* contact);
	void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
	void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
	void EndContact(b2Contact* contact);
};