PGraphics tex, depthBuffer, rgbBuffer;

void setup() {
  size(640, 480, P2D);
  rgbImg = loadImage("color.png");
  depthImg = loadImage("depth.png");

  depthBuffer = createGraphics(640, 480, P2D);
  rgbBuffer = createGraphics(640, 480, P2D);
  tex = createGraphics(1280, 960, P2D);

  setupShaders();
  updateShaders();
  
  background(0);
  
  depthBuffer.beginDraw();
  depthBuffer.filter(shader_depth_color);
  depthBuffer.endDraw();
  
  rgbBuffer.beginDraw();
  rgbBuffer.filter(shader_color_depth);
  rgbBuffer.endDraw();
  
  tex.beginDraw();
  tex.image(depthImg, 0, 0);  
  tex.image(rgbImg, width, 0);  
  tex.image(depthBuffer, 0, height);  
  tex.image(rgbBuffer, width, height);  
  tex.endDraw();
}

void draw() { 
  image(tex, 0, 0, width, height);
}
