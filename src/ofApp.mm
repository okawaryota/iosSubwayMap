#include "ofApp.h"

int soundNum = 7 + 1;

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofxAccelerometer.setup();
    
    subwayMap.loadImage("image/subwayMap01.png");
    
    //load sounds
    for(int i = 1; i < soundNum; i++){
        file = "sounds/sound" + ofToString(i) + ".m4a";
        subway[i].loadSound(file);
        subway[i].setVolume(0.75);
        subway[i].setLoop(loop);
        subway[i].play();
    }
    
    //how do i set stationPos?
    stationPos[1].set(270, 253);//timesSQ1 286, 253
    //stationPos[2].set(493, 443);//timesSQ 493, 443
    stationPos[3].set(502, 254);//Grandcentral1 502, 254
    stationPos[4].set(404, 257);//Grandcentral2 404, 257
    stationPos[5].set(184, 437);//Grandcentral3184, 437
    stationPos[6].set(649, 631);//delancy 649, 631
    stationPos[7].set(333, 653);//canal st 333, 653
    stationPos[8].set(360, 146);//57th st 360, 146
    subway[2].setVolume(0);
    sender.setup( HOST, PORT );
    
    
    
    //ofSplitString();
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    orientations = ofxAccelerometer.getOrientation();
    yourPos.x += orientations.y/10;
    yourPos.y += -(orientations.x/10);
    
    //updating sound control
    for(int i = 1; i <soundNum; i++){
        
        disVol[i] = (ofDist(stationPos[i].x/ofGetWidth(), stationPos[i].y/ofGetHeight(), yourPos.x/ofGetWidth(), yourPos.y/ofGetHeight()));
        disVol[i] = 1-disVol[i]*2;
        if(disVol[i] < 0){
            disVol[i] = 0;
        }
    
        disPan[i] = (stationPos[i].x/ofGetWidth()) - (yourPos.x/ofGetWidth());
        disPan[i] = disPan[i]*10;
        
        subway[i].setVolume(disVol[i]);
        subway[i].setPan(disPan[i]);
        
        soundVol_R += disVol[i];
        soundPan_GB += disPan[i];
    }
    
        soundVol_R = soundVol_R/soundNum;
        soundPan_GB = soundPan_GB/soundNum;
    
    
    //OSC
    //----------------------------------------------------------------------------------
    if( ofGetFrameNum() % 120 == 0 ){
		ofxOscMessage m;
		m.setAddress( "/misc/heartbeat" );
		m.addIntArg( ofGetFrameNum() );
		sender.sendMessage( m );
	}
    
        ofxOscMessage m;
        m.setAddress( "/your/data" );
        m.addFloatArg( yourPos.x);//0
        m.addFloatArg( yourPos.y );//1
        m.addFloatArg( orientations.x);//2
        m.addFloatArg( orientations.y );//3
        m.addFloatArg( soundVol_R);//4
        m.addFloatArg(soundPan_GB);//5
        sender.sendMessage( m );
    //----------------------------------------------------------------------------------

    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofSetColor(255,255,255);
    subwayMap.draw(0,0,ofGetWidth(),ofGetHeight());
    
    ofSetColor(0, 0, 255,70);
	ofCircle(yourPos.x, yourPos.y, 20);
    
    //Debug mode---------------------------------------------------------------------------
    if(flag == 1){
        
        ofSetColor(0, 0, 0,50);
        ofRect(10, 90, 240, 80);
        ofSetColor(255,255,255);
        ofDrawBitmapString("mapX: "+ofToString(ofGetWidth()), 10, 120);
        ofDrawBitmapString("mapY: "+ofToString(ofGetHeight()), 10, 130);
        ofDrawBitmapString("posX: "+ofToString(yourPos.x), 10, 100);
        ofDrawBitmapString("posY: "+ofToString(yourPos.y), 10, 110);
        ofDrawBitmapString("orientationX: "+ofToString(orientations.x), 10, 160);
        ofDrawBitmapString("orientationY: "+ofToString(orientations.y), 10, 170);
        ofDrawBitmapString("soundVol: "+ofToString(soundVol_R), 10, 140);
        ofDrawBitmapString("soundPan1: "+ofToString(soundPan_GB), 10, 150);
        
        ofSetColor(255, 0, 0,50);
        for(int i = 1; i<soundNum; i++){
            ofRect(stationPos[i].x, stationPos[i].y, 20, 20);
        }
    }
    //-------------------------------------------------------------------------------------
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    if(touch.x < ofGetWidth()-10 && touch.y < ofGetHeight()-10){
        ofxOscMessage m;
        m.setAddress( "/window" );
        m.addIntArg( ofGetWidth() );
        m.addIntArg( ofGetHeight() );
        sender.sendMessage( m );
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    yourPos.x = touch.x;
    yourPos.y = touch.y;
    cout << touch <<endl;
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    
    if(flag == 0){
        flag = 1;
    }else{
        flag = 0;
    }

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
