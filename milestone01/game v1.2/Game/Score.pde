class Score {
  PVectorUInt backgroundSize;
  private int margin;
  private PVectorUInt topViewSize;
  private PVectorUInt scoreBoardSize;
  private PVectorUInt barChartSize;
  private PGraphics background;
  private PGraphics topView;
  private PGraphics scoreBoard;
  private PGraphics barChart;

  PointsChart pointsChart; 

  float previousPoints;
  float points;

  private int counter;
  //maybe it's better to set only background size and define others in function of it


  Score() {
    previousPoints = 0;
    points = 0;

    backgroundSize = new PVectorUInt(width, 200);
    margin = 5;

    //calculate size of topView
    topViewSize = new PVectorUInt(0, 0);
    if (board.sizeX >= board.sizeZ) {
      topViewSize.x = backgroundSize.y - 2 * margin;
      topViewSize.y = topViewSize.x * board.sizeZ / board.sizeX;
    } else {
      topViewSize.y = backgroundSize.y - 2 * margin;
      topViewSize.x = topViewSize.y * board.sizeX / board.sizeZ;
    }

    scoreBoardSize = new PVectorUInt(120, backgroundSize.y - 2 * margin);
    barChartSize = new PVectorUInt(backgroundSize.x - topViewSize.x - scoreBoardSize.x - 4 * margin, backgroundSize.y - 2 * margin);
    
    background = createGraphics(backgroundSize.x, backgroundSize.y, P2D);
    topView = createGraphics(topViewSize.x, topViewSize.y, P2D);
    scoreBoard = createGraphics(scoreBoardSize.x, scoreBoardSize.y, P2D);
    barChart = createGraphics(barChartSize.x, barChartSize.y, P2D);
    
    pointsChart = new PointsChart(10, 10);
    
    counter = 0;
  }

  void display() {
    pushMatrix();
    //inverseCameraRotation(0);

    translate(-width / 2, height / 2 - backgroundSize.y, 0);
    //translate(-width/2+10, 200, -80);

    //draw backgound
    createBackground();
    image(background, 0, 0);

    //draw topView
    createTopView();
    image(topView, margin, margin);

    //draw scoreBoard
    createScoreBoard();
    image(scoreBoard, topViewSize.x + 2 * margin, margin);
    
    //draw barChart
    createBarChart();
    image(barChart, topViewSize.x + scoreBoardSize.x + 3 * margin, margin); 

    popMatrix();
  }
  
  private void createBackground() {
    background.beginDraw();
    background.background(0, 0, 0);
    background.endDraw();
  }

  private void createTopView() {
    //calculate ball and cylinders radius proportionally to the ones on the board
    float ballRadius = (ball.radius * topViewSize.x) / board.sizeX;
    float cylindersRadius = (cylinder.radius * topViewSize.x) / board.sizeX;

    pushMatrix();
    topView.beginDraw();
    topView.background(board.colour);
    topView.fill(cylinder.colour);
    topView.noStroke();
    for (PVector cyl : cylinderPositions) {
      //here bouns board size are wrong
      //float x = map(cyl.x, -board.sizeX/2, board.sizeX/2, 0, topViewSize.x);
      //float y = map(cyl.z, -board.sizeZ/2, board.sizeZ/2, 0, topViewSize.y);
      float x = map(cyl.x, -(board.sizeX/2 - cylinder.radius), board.sizeX/2 - cylinder.radius, 0, topViewSize.x);
      float y = map(cyl.z, -(board.sizeZ/2 - cylinder.radius), board.sizeZ/2 - cylinder.radius, 0, topViewSize.y);
      topView.ellipse(x, y, cylindersRadius, cylindersRadius);
    }
    topView.fill(255, 0, 0);
    float x = map(ball.position.x, -(board.sizeX/2 - cylinder.radius), board.sizeX/2 - cylinder.radius, 0, topViewSize.x);
    float y = map(ball.position.z, -(board.sizeZ/2 - cylinder.radius), board.sizeZ/2 - cylinder.radius, 0, topViewSize.y);
    topView.ellipse(x, y, ballRadius, ballRadius);

    topView.endDraw();
    popMatrix();
  }

  private void createScoreBoard() {
    pushMatrix();
    scoreBoard.beginDraw();
    scoreBoard.background(255, 255, 0);

    String currPoints = "Total score: \n" + points;
    String vel = "Velocity: \n" + ball.velocity.mag();
    String prevPoints = "Last score: \n" + previousPoints;

    translate(topViewSize.x + 2 * margin, margin);

    scoreBoard.textSize(16);
    scoreBoard.fill(0);
    scoreBoard.text(currPoints, 10, 20);
    scoreBoard.text(vel, 10, 80);
    scoreBoard.text(prevPoints, 10, 140);

    scoreBoard.endDraw();
    popMatrix();
  }

  void gainPoints() {
    previousPoints = points;
    points += ball.velocity.mag();
  }

  void losePoints() {
    previousPoints = points;
    points -= ball.velocity.mag();
  }
  
  void recordPoints() {
    if (counter > 50) {
     pointsChart.recordPoints();
     counter = 0;
    } else {
      counter += 1;
    }
  }
  
  void createBarChart() {
    barChart.beginDraw();
    barChart.background(255);
    pushMatrix();
    pointsChart.drawChart(barChart, barChartSize);
    popMatrix();
    barChart.endDraw();
  }
}