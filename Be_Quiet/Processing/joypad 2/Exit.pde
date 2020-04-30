/*
 * Simple class to display and calc colsion with the exit
 *
*/



class Exit{

    public PVector location;
    public int state;
    public int size;

    // constructor
    Exit(){
        location = new PVector(0,0);
        state = 0;
        size =  100;
    }

    // hadle all the logic
    void update(){
        float dist = _dist(chased.location,location);
        float delta = dist  - (chased.size*0.5 + size*0.5);
        int range = 10;

        if(  delta < range && delta > -range ){
            screen.goToIndex(3);
            sendOscMessage("/win",1);
            sendOscMessage_A1("/win",1);
        }
    }

    // main render function
    void render(){
        pushStyle();

        if(state == 0){

        }else{
            update();
            fill(30,30,30);
            rect(0,0,size,size);
        }
        popStyle();
    }
}