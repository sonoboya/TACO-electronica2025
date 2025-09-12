int textX = 200, textY = 400;
int X, Y, A, B;
//width and height
void setup(){ 
size(640, 480);
A = 80;
}

void draw(){
background(mouseY,mouseX,0);
textSize(30);
fill(0); //relleno de negro
text("The cake is a lie",textX,textY);
Y = height*2/3; X = width/2;

arc(X, Y, 200, 200,  PI, TWO_PI, CHORD);
rect(X-50, Y-130, 10, 130);

noFill();
A = A + 1;
for(int i = 0; i < 10; i++){
  arc(X, Y, A+i*100, A+i*100,  PI, TWO_PI);
  arc(X, Y, A-i*100, A-i*100,  PI, TWO_PI);
}
if(A > 2* width){A = 200;}
}
