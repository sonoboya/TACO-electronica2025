//inspo = https://austinhenley.com/blog/raycasting.html

int map[][] = {
    {1, 1, 1, 1, 1, 1, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 1, 0, 2, 0, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 1, 2, 0, 1, 0, 0, 1},
    {1, 0, 1, 0, 0, 1, 0, 0, 1},
    {1, 0, 0, 1, 0, 1, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 1, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1, 1}
};

float playerX; float playerY;
float playerAngle; float playerFov = PI/2;

void setup(){
size(800, 400);
noStroke();

playerX = 4.5;
playerY = 4.5;
playerAngle = PI/2;
}

void draw(){
  background(100, 100, 255); // cielo
  fill(50, 200, 50);
  rect(0, height/2, width, height/2);
  raycast();
//  minMap();
  movement();
  
}

float[] castRay(float rayAngle) {
  float x = playerX;
  float y = playerY;
  float dx = cos(rayAngle);
  float dy = sin(rayAngle);
  
  int i = 0;
  while(map[floor(y)][floor(x)] == 0) {
    x += dx * 0.01;
    y += dy * 0.01;
    i++;
    if(i > 800){break;}
  }
  
  float distanceHeight[] = {0,0,0};
  distanceHeight[0] = sqrt(pow((x - playerX),2) + pow((y - playerY),2));
  //distanceHeight[0] *= cos(rayAngle - playerAngle);
  distanceHeight[1] = height/distanceHeight[0];
  distanceHeight[2] = map[floor(y)][floor(x)];
  return distanceHeight;
}

void drawWallSlice(float type, float i, float wallHeight, float sliceWidth){
  int yPos = floor((height - wallHeight) / 2);
  switch((int)type){
  case 1: 
  fill(200, 200, 200); break;
  case 2: 
  fill(255, 0, 0); break;
  }
  
  rect((i*sliceWidth),yPos,sliceWidth,wallHeight);
  return;
}

void raycast(){
  int rays = width;
  float sliceWidth = width/rays;
  float angleStep = playerFov/ rays;
  
  for(int i = 0; i < rays; i++){
  float rayAngle = playerAngle -(playerFov/2) + i* angleStep;
  float distanceHeight[] = castRay(rayAngle);
  
  drawWallSlice(distanceHeight[2],i,distanceHeight[1],sliceWidth);
  }
}

void movement(){
if (keyPressed) {
    if (key == 'a' || key == 'A') {
      playerAngle -= 0.01;
      //playerX += sin(playerAngle)*0.001;
      //playerY += cos(playerAngle)*0.001;
    }
    if (key == 'd' || key == 'D') {
      playerAngle += 0.01;
      //playerX -= sin(playerAngle)*0.001;
      //playerY -= cos(playerAngle)*0.001;
    }
    if (key == 'w' || key == 'W') {
      playerX += cos(playerAngle)*0.01;
      playerY += sin(playerAngle)*0.01;
}
if (key == 's' || key == 'S') {
      playerX -= cos(playerAngle)*0.01;
      playerY -= sin(playerAngle)*0.01;
}

}
}
