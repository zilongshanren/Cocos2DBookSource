//
//  MyContactListener.cpp
//  PhysicShootingGame
//
//  Created by guanghui on 8/4/12.
//
//

#include "MyContactListener.h"


void MyContactListener::BeginContact(b2Contact *contact)
{
//    std::cout<<"contacted!"<<std::endl;
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    _contacts.push_back(myContact);
}

void MyContactListener::EndContact(b2Contact *contact)
{
    MyContact myContact = { contact->GetFixtureA(), contact->GetFixtureB() };
    
    std::vector<MyContact>::iterator pos;
    pos = std::find(_contacts.begin(), _contacts.end(), myContact);
    if (pos != _contacts.end()) {
        _contacts.erase(pos);
    }
}

void MyContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold)
{
    
}

void MyContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse)
{
    
//    b2Body *bodyA = contact->GetFixtureA()->GetBody();
//    b2Body *bodyB = contact->GetFixtureB()->GetBody();
//    b2World *world = bodyA->GetWorld();
//    int *tagA = (int*)bodyA->GetUserData();
//    int *tagB = (int*)bodyB->GetUserData();
//    if (NULL != tagA && *tagA == 10) {
//        world->DestroyBody(bodyA);
//    }
//    
//    if (NULL != tagB && *tagB == 10) {
//        world->DestroyBody(bodyB);
//    }
}