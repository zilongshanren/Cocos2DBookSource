#import "MyContactListener.h"

MyContactListener::MyContactListener():contacts(){
  
}

MyContactListener::~MyContactListener(){
  
}

void MyContactListener::BeginContact(b2Contact* contact){

  //考虑到b2Contact所传递的数据可能被重用，因此需要拷贝出来
  MyContact myContact = {contact->GetFixtureA(),contact->GetFixtureB()};
  contacts.push_back(myContact);

}

void MyContactListener::EndContact(b2Contact* contact){
  
  MyContact myContact = {contact->GetFixtureA(),contact->GetFixtureB()};
  std::vector<MyContact>::iterator pos;
  pos = std::find(contacts.begin(),contacts.end(),myContact);
  if(pos != contacts.end()){
    contacts.erase(pos);
  }
}

void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold){
}

void MyContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impusle){}