/*
 * Class describing the main storytelling logic of the game, switch between scenes and main render function here.
 * Class must be called in the draw loop.
 *
*/

class Screen{

    public int state;
    public int time;

    private PImage img_lose = loadImage("lose.png");
    private PImage img_win = loadImage("win.png");
    private PImage img_base = loadImage("base.png");

    // contructor
    Screen(){
        state = 0;
    }

    // setter for the index
    public void goToIndex(int index){
        state = index;
        time = 0;
    }

    // main controller of the app
    public void update(){
        switch(state){
            case 0 : 
                render0();
                break;
            case 1 : 
                render1();
                break;
            case 2 : 
                render2();
                break;
            case 3: 
                render3();
                break;
        }
    }

    // render landing screen
    private void render0(){
        time ++;
        if((stepPlayer != 0) && time > 200){
            goToIndex(1);
            sendOscMessage("/start",1);
             sendOscMessage_A1("/start",1);
            time = 0;
        } 
        pushStyle();
            background(0,0,0);
            fill(255);
            dispImage(img_base);
            rectMode(CORNER);
            rect(0,0,map(time,0,200,0,width),10);
        popStyle();
    }

    // render main game
    private void render1(){
        background(0,0,0);
        pushStyle();
            compute();
            items();
            calc();

            exit.render();

            chased.update();
            chased.render();

            chaser.applyForce(posChaser);
            chaser.update();
            chaser.render();
        popStyle();
    }

    // render lose screen
    private void render2(){
        time ++;
        if(time > 200){
            goToIndex(0);
            sendOscMessage("/rewind",1);
            sendOscMessage_A1("/rewind",1);
            time = 0;
            init();
        } 
        pushStyle();
            background(0,0,0);
            dispImage(img_lose);
            rectMode(CORNER);
            fill(255);
            rect(0,0,map(time,0,200,0,width),10);
        popStyle();
    }

    // render win screen
    private void render3(){
        time ++;
        if(time > 200){
            goToIndex(0);
            sendOscMessage("/rewind",1);
            sendOscMessage_A1("/rewind",1);
            time = 0;
            init();
        } 
        pushStyle();
            background(0,0,0);
            dispImage(img_win);
            rectMode(CORNER);
            fill(255);
            rect(0,0,map(time,0,200,0,width),10);
        popStyle();
    }

    //  helper function to display image
    private void dispImage(PImage img){
        pushMatrix();
            imageMode(CENTER);
            translate(width/2,height/2);
            image(img, 0, 0,width,height);
        popMatrix();
    }

}
