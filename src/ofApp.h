#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxOsc.h"

#define HOST "172.16.42.89"// this is for SFPC
//#define HOST "192.168.1.16"//this is for K's

#define PORT 12345

class ofApp : public ofxiOSApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        ofVec2f orientations;
    
        ofSoundPlayer subway[10];//set number of sounds
        string file;

        ofVec2f stationPos[10];
        ofVec2f yourPos;
        float  disVol[10];
        float  disPan[10];
        bool loop = true;
    
        int flag;
    
        ofImage subwayMap;
    
        ofxOscSender sender;
        float soundVol_R;
        float soundPan_GB;
    
    
    

};


