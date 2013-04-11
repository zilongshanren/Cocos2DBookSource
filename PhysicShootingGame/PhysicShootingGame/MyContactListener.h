//
//  MyContactListener.h
//  PhysicShootingGame
//
//  Created by guanghui on 8/4/12.
//
//

#ifndef __PhysicShootingGame__MyContactListener__
#define __PhysicShootingGame__MyContactListener__

#include <iostream>
#include <vector>
#include <algorithm>
#import "Box2D/Box2D.h"

struct MyContact {
    b2Fixture *fixtureA;
    b2Fixture *fixtureB;
    bool operator==(const MyContact& other) const
    {
        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    }
};

class MyContactListener : public b2ContactListener
{
public:
    std::vector<MyContact>_contacts;
    
    MyContactListener(){}
    ~MyContactListener(){}
    
    /// Called when two fixtures begin to touch.
	virtual void BeginContact(b2Contact* contact);
    
	/// Called when two fixtures cease to touch.
	virtual void EndContact(b2Contact* contact);
    
	/// This is called after a contact is updated. This allows you to inspect a
	/// contact before it goes to the solver. If you are careful, you can modify the
	/// contact manifold (e.g. disable contact).
	/// A copy of the old manifold is provided so that you can detect changes.
	/// Note: this is called only for awake bodies.
	/// Note: this is called even when the number of contact points is zero.
	/// Note: this is not called for sensors.
	/// Note: if you set the number of contact points to zero, you will not
	/// get an EndContact callback. However, you may get a BeginContact callback
	/// the next step.
	virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);

    
	/// This lets you inspect a contact after the solver is finished. This is useful
	/// for inspecting impulses.
	/// Note: the contact manifold does not include time of impact impulses, which can be
	/// arbitrarily large if the sub-step is small. Hence the impulse is provided explicitly
	/// in a separate data structure.
	/// Note: this is only called for contacts that are touching, solid, and awake.
	virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);

};


#endif /* defined(__PhysicShootingGame__MyContactListener__) */
