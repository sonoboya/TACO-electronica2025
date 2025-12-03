/**
 Camera → multi-level contour vectorizer → SVG (plotter-optimized)
 Fix: polylines globally ordered & oriented to minimize pen-up travel.
*/

import processing.video.*;
import processing.svg.*;
import java.util.*;

Capture cam;
PImage frameImg;
PImage small;

// ===== PARAMETERS =====
int CAP_W = 1280;
int CAP_H = 720;
int WORK_W = 512;
int WORK_H = 0;
int PIXEL_STEP = 4;
int LEVELS = 6;
float SIMPLIFY_TOL = 1.5;
boolean DRAW_CONTOURS_ON_SCREEN = true;
String OUT_FILENAME = "output.svg";
// ======================

boolean haveFrame = false;
PGraphicsSVG svg;

void settings(){ size(1000,600); }

void setup(){
  println("Available cameras:");
  String[] cams = Capture.list();
  for (int i=0;i<cams.length;i++) println(i+": "+cams[i]);
  if (cams.length > 0){
    cam = new Capture(this, CAP_W, CAP_H, cams[0]);
    cam.start();
  }
  textAlign(LEFT,TOP);
  WORK_H = (WORK_H == 0) ? int(WORK_W*(float(height)/width)) : WORK_H;
}

void captureEvent(Capture c){
  c.read();
  frameImg = c.get();
  haveFrame = true;
}

void draw(){
  background(30);
  if (haveFrame){
    PImage preview = frameImg.copy();
    float pw = width*0.6;
    float ph = pw*(float)preview.height/preview.width;
    image(preview,10,10,pw,ph);
    if (DRAW_CONTOURS_ON_SCREEN){
      fill(255);
      text("SPACE = vectorize + save SVG",10,12+ph);
    }
  } else {
    fill(200);
    text("Waiting for camera frame...",10,10);
  }
}

void keyPressed(){
  if (key==' '){
    if (!haveFrame){ println("No frame"); return; }
    small = frameImg.copy();
    small.resize(WORK_W,0);
    vectorizeAndSave(small, OUT_FILENAME);
  }
}


/* ============================================================
   VECTORIZE + PLOTTER-OPTIMIZED ORDERING
   ============================================================ */
void vectorizeAndSave(PImage src, String outName){
  src.loadPixels();
  int w = src.width;
  int h = src.height;

  float[][] field = new float[w][h];
  for (int y=0;y<h;y++)
    for (int x=0;x<w;x++)
      field[x][y] = brightnessFromColor(src.pixels[y*w+x]) / 255.0;

  // prepare SVG
  svg = (PGraphicsSVG) createGraphics(w, h, SVG, outName);
  svg.beginDraw();
  svg.background(255);
  svg.noFill();
  svg.stroke(0);
  svg.strokeWeight(1);

  ArrayList<ArrayList<PVector>> allPolylines = new ArrayList<>();

  for (int lvl=1; lvl<=LEVELS; lvl++){
    float t = 1.0 * lvl / (LEVELS+1);
    ArrayList<Segment> segs = marchingSquares(field,w,h,PIXEL_STEP,t);
    ArrayList<ArrayList<PVector>> polys = stitchSegments(segs);

    // simplify each
    ArrayList<ArrayList<PVector>> simp = new ArrayList<>();
    for (var poly : polys){
      if (poly.size() > 2)
        simp.add(rdpSimplify(poly, SIMPLIFY_TOL));
    }

    allPolylines.addAll(simp);
  }

  // *** NEW: global nearest-neighbor ordering ***
  ArrayList<ArrayList<PVector>> ordered = orderPolylines(allPolylines);

  // draw
  for (var poly : ordered){
    svg.beginShape();
    for (PVector p : poly) svg.vertex(p.x,p.y);
    svg.endShape();
  }

  svg.endDraw();

  println("Saved optimized SVG → " + sketchPath(outName));
  
  // --- Call svg2gcode automatically ---
try {
    String svgInput = "C:\\Users\\andy\\Desktop\\test\\" + OUT_FILENAME;
    String OUT_GCODE = "C:\\Users\\andy\\Desktop\\test\\vector.gcode";
    String cfg = "C:\\Users\\andy\\Desktop\\test\\config.json";

    String cmd = "\"C:\\Program Files (x86)\\svg2gcode_cli-v0.0.17_x86_64-pc-windows-gnu\\svg2gcode\" "
                 + "--settings " + cfg
                 + " -o " + OUT_GCODE
                 + " " + svgInput;

    println("Running: " + cmd);
    Process p = Runtime.getRuntime().exec(cmd);

    // stdout
    new Thread(() -> {
        try (Scanner s = new Scanner(p.getInputStream())) {
            while (s.hasNextLine()) println("[svg2gcode] " + s.nextLine());
        } catch(Exception e){ e.printStackTrace(); }
    }).start();

    // stderr
    new Thread(() -> {
        try (Scanner s = new Scanner(p.getErrorStream())) {
            while (s.hasNextLine()) println("[svg2gcode][ERR] " + s.nextLine());
        } catch(Exception e){ e.printStackTrace(); }
    }).start();

    p.waitFor();
    println("svg2gcode process finished.");

} catch(Exception e){
    println("Error calling svg2gcode: " + e);
}



}

// brightness 0..255
float brightnessFromColor(int c){
  return (red(c)*0.299 + green(c)*0.587 + blue(c)*0.114f);
}


/* ============================================================
   MARCHING SQUARES + STITCHING (unchanged from last code)
   ============================================================ */

class Segment { PVector a,b; Segment(PVector A,PVector B){a=A;b=B;} }

ArrayList<Segment> marchingSquares(float[][] field,int w,int h,int step,float T){
  ArrayList<Segment> segs=new ArrayList<>();
  for(int y=0;y<h-step;y+=step){
    for(int x=0;x<w-step;x+=step){
      float v0=field[x][y];
      float v1=field[x+step][y];
      float v2=field[x+step][y+step];
      float v3=field[x][y+step];
      int c0=(v0>T)?1:0;
      int c1=(v1>T)?1:0;
      int c2=(v2>T)?1:0;
      int c3=(v3>T)?1:0;
      int code=c0*1 + c1*2 + c2*4 + c3*8;

      PVector e0=null,e1=null,e2=null,e3=null;
      float gx=x, gy=y;

      if(c0!=c1){ float t=(T-v0)/(v1-v0); e0=new PVector(gx+t*step, gy); }
      if(c1!=c2){ float t=(T-v1)/(v2-v1); e1=new PVector(gx+step, gy+t*step); }
      if(c3!=c2){ float t=(T-v3)/(v2-v3); e2=new PVector(gx+t*step, gy+step); }
      if(c0!=c3){ float t=(T-v0)/(v3-v0); e3=new PVector(gx, gy+t*step); }

      switch(code){
        case 1: case 14: if(e0!=null&&e3!=null) segs.add(new Segment(e0,e3)); break;
        case 2: case 13: if(e0!=null&&e1!=null) segs.add(new Segment(e0,e1)); break;
        case 3: case 12: if(e1!=null&&e3!=null) segs.add(new Segment(e1,e3)); break;
        case 4: case 11: if(e1!=null&&e2!=null) segs.add(new Segment(e1,e2)); break;
        case 5: case 10:
          if(e0!=null&&e3!=null) segs.add(new Segment(e0,e3));
          if(e1!=null&&e2!=null) segs.add(new Segment(e1,e2));
          break;
        case 6: case 9: if(e0!=null&&e2!=null) segs.add(new Segment(e0,e2)); break;
        case 7: case 8: if(e2!=null&&e3!=null) segs.add(new Segment(e2,e3)); break;
      }
    }
  }
  return segs;
}

ArrayList<ArrayList<PVector>> stitchSegments(ArrayList<Segment> segments){
  ArrayList<ArrayList<PVector>> polylines=new ArrayList<>();
  if(segments.size()==0) return polylines;

  HashMap<String,ArrayList<PVector>> adj=new HashMap<>();
  HashMap<String,PVector> keyToPt=new HashMap<>();
  float SNAP=0.5;

  for(Segment s:segments){
    String ak=pKey(s.a,SNAP);
    String bk=pKey(s.b,SNAP);
    keyToPt.putIfAbsent(ak,s.a.copy());
    keyToPt.putIfAbsent(bk,s.b.copy());
    adj.putIfAbsent(ak,new ArrayList<>());
    adj.putIfAbsent(bk,new ArrayList<>());
    adj.get(ak).add(keyToPt.get(bk));
    adj.get(bk).add(keyToPt.get(ak));
  }

  HashSet<String> visited=new HashSet<>();

  for(String startKey:adj.keySet()){
    if(visited.contains(startKey)) continue;

    ArrayList<PVector> poly=new ArrayList<>();
    String curKey=startKey;
    PVector cur=keyToPt.get(curKey);

    while(curKey!=null && !visited.contains(curKey)){
      visited.add(curKey);
      poly.add(cur.copy());

      ArrayList<PVector> nbs=adj.get(curKey);
      PVector best=null;
      float bestd=1e9;
      String bestKey=null;

      if(nbs!=null){
        for(PVector nb:nbs){
          String k=pKey(nb,SNAP);
          if(visited.contains(k)) continue;
          float d=PVector.dist(cur,nb);
          if(d<bestd){ bestd=d; best=nb; bestKey=k; }
        }
      }
      if(best==null) break;

      cur=best;
      curKey=bestKey;
    }

    if(poly.size()>1) polylines.add(poly);
  }

  return polylines;
}

String pKey(PVector p,float s){
  int xi=round(p.x/s);
  int yi=round(p.y/s);
  return xi+"_"+yi;
}


/* ============================================================
   RDP simplification (unchanged)
   ============================================================ */
ArrayList<PVector> rdpSimplify(ArrayList<PVector> pts,float eps){
  if(pts.size()<3) return (ArrayList<PVector>)pts.clone();
  boolean[] use=new boolean[pts.size()];
  use[0]=true; use[pts.size()-1]=true;
  rdpRec(pts,0,pts.size()-1,eps,use);

  ArrayList<PVector> out=new ArrayList<>();
  for(int i=0;i<pts.size();i++) if(use[i]) out.add(pts.get(i).copy());
  return out;
}

void rdpRec(ArrayList<PVector> pts,int a,int b,float eps,boolean[] use){
  if(b-a<2) return;
  PVector A=pts.get(a);
  PVector B=pts.get(b);
  float maxd=-1; int idx=-1;

  for(int i=a+1;i<b;i++){
    float d=pointLineDistance(pts.get(i),A,B);
    if(d>maxd){ maxd=d; idx=i; }
  }

  if(maxd>eps){
    use[idx]=true;
    rdpRec(pts,a,idx,eps,use);
    rdpRec(pts,idx,b,eps,use);
  }
}

float pointLineDistance(PVector p,PVector a,PVector b){
  float l2=PVector.sub(b,a).magSq();
  if(l2==0) return PVector.dist(p,a);
  float t=max(0, min(1, PVector.sub(p,a).dot(PVector.sub(b,a))/l2));
  PVector proj=PVector.add(a, PVector.mult(PVector.sub(b,a),t));
  return PVector.dist(p,proj);
}


/* ============================================================
   *** NEW: GLOBAL PATH ORDERING ***
   ============================================================ */
ArrayList<ArrayList<PVector>> orderPolylines(ArrayList<ArrayList<PVector>> polys){
  if(polys.size() < 2) return polys;

  ArrayList<ArrayList<PVector>> remaining = new ArrayList<>(polys);
  ArrayList<ArrayList<PVector>> out = new ArrayList<>();

  // start with the longest polyline for stability
  remaining.sort((a,b)->Float.compare(lengthOfPoly(b), lengthOfPoly(a)));

  ArrayList<PVector> cur = remaining.remove(0);
  out.add(cur);
  PVector curEnd = cur.get(cur.size()-1);

  while(!remaining.isEmpty()){
    int bestIdx = -1;
    boolean bestReverse = false;
    float bestDist = 1e12;

    for(int i=0;i<remaining.size();i++){
      ArrayList<PVector> p = remaining.get(i);
      PVector s = p.get(0);
      PVector e = p.get(p.size()-1);

      float d1 = PVector.dist(curEnd, s);
      float d2 = PVector.dist(curEnd, e);

      if(d1 < bestDist){
        bestDist = d1;
        bestIdx = i;
        bestReverse = false;
      }
      if(d2 < bestDist){
        bestDist = d2;
        bestIdx = i;
        bestReverse = true;
      }
    }

    ArrayList<PVector> chosen = remaining.remove(bestIdx);

    if(bestReverse) Collections.reverse(chosen);

    out.add(chosen);
    curEnd = chosen.get(chosen.size()-1);
  }

  return out;
}

float lengthOfPoly(ArrayList<PVector> p){
  float L=0;
  for(int i=1;i<p.size();i++)
    L += PVector.dist(p.get(i-1),p.get(i));
  return L;
}
