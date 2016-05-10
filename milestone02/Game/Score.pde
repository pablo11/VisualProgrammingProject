class Score {
  private PVectorUInt backgroundSize;
  private PVectorUInt topViewSize;
  private PVectorUInt barChartSize;
  private int margin;
  private PGraphics background;
  private PGraphics topView;
  private PGraphics scoreBoard;
  private PGraphics barChart;

  PointsChart pointsChart; 

  float previousPoints;
  float points;

  private int counter;
  //maybe it's better to set only background size and define others in function of it

  HScrollbar scrollbar;

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
    
    background = createGraphics(backgroundSize.x, backgroundSize.y, P2D);
    topView = createGraphics(topViewSize.x, topViewSize.y, P2D);
    scoreBoard = createGraphics(120, backgroundSize.y - 2 * margin, P2D);
    
    barChartSize = new PVectorUInt(backgroundSize.x - topViewSize.x - scoreBoard.width - 4 * margin, backgroundSize.y - 10 - 3 * margin);
    
    barChart = createGraphics(barChartSize.x, barChartSize.y, P2D);
    
    pointsChart = new PointsChart(8);
    
    counter = 0;
    
    scrollbar = new HScrollbar(topViewSize.x + scoreBoard.width + 3 * margin, barChart.height + 2 * margin, barChart.width, 10);
  }

  void display() {
    pushMatrix();
    translate(-width / 2, height / 2 - backgroundSize.y + board.sizeY / 2, 0);

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
    image(barChart, topViewSize.x + scoreBoard.width + 3 * margin, margin); 
    
    scrollbar.update();
    scrollbar.display();
    
    popMatrix();
  }
  
  private void createBackground() {
    background.beginDraw();
    background.background(0);
    background.endDraw();
  }

  private float mapFlatX(float toMap) {
    return map(toMap, -board.sizeX/2, board.sizeX/2, 0, topViewSize.x);
  }
  
  private float mapFlatY(float toMap) {
    return map(toMap, -board.sizeZ/2, board.sizeZ/2, 0, topViewSize.y);
  }
  
  private void createTopView() {
    //calculate ball and cylinders radius proportionally to the ones on the board
    float ballDiameter = 2 * ball.radius * topViewSize.x / board.sizeX;
    float cylinderDiameter = 2 * cylinder.radius * topViewSize.x / board.sizeX;
    
    pushMatrix();
    topView.beginDraw();
    topView.background(board.colour);
    //draw cylinders
    topView.fill(cylinder.colour);
    topView.noStroke();
    for (PVector cyl : cylinderPositions) {
      topView.ellipse(mapFlatX(cyl.x), mapFlatY(cyl.z), cylinderDiameter, cylinderDiameter);
    }
    //draw ball
    topView.fill(ball.colour);
    topView.ellipse(mapFlatX(ball.position.x), mapFlatY(ball.position.z), ballDiameter, ballDiameter);

    topView.endDraw();
    popMatrix();
  }

  private void createScoreBoard() {
    pushMatrix();
    scoreBoard.beginDraw();
    scoreBoard.background(255);
    translate(topViewSize.x + 2 * margin, margin);

    scoreBoard.textSize(14);
    scoreBoard.fill(0);
    scoreBoard.text("Total score: \n" + points, 10, 20);
    scoreBoard.text("Velocity: \n" + ball.velocity.mag(), 10, scoreBoard.height / 3 + 20);
    scoreBoard.text("Last score: \n" + previousPoints, 10, scoreBoard.height / 3 * 2 + 20);

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
    pointsChart.drawChart(barChart);
    popMatrix();
    barChart.endDraw();
  }
}