#import "Box2D.h"
#import <vector>
#import <algorithm>


struct MyContact{
  b2Fixture *fixtureA;
  b2Fixture *fixtureB;
  bool operator == (const MyContact& other) const{
    return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    
  }
  
};

class MyContactListener: public b2ContactListener{
public:
  std::vector<MyContact>contacts;
  
  MyContactListener();
  ~MyContactListener();
  
  virtual void BeginContact(b2Contact* contact);
  virtual void EndContact(b2Contact* contact);
  virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
  virtual void PostSolve(b2Contact* contact,const b2ContactImpulse* impulse);
  
};