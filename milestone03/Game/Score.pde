class Score {
  public PGraphics background;
  private PGraphics topView;
  private PGraphics scoreBoard;
  private PGraphics barChart;
  private HScrollbar scrollbar;
  
  private int margin;
  private int counter;
  
  private PointsChart pointsChart; 
  private float previousPoints;
  private float points;

  Score() {
    counter = 0;
    margin = 5;
    previousPoints = 0;
    points = 0;
    pointsChart = new PointsChart(8);
    
    background = createGraphics(width, 200, P2D);
    topView = createGraphics(200 - 2 * margin, 200 - 2 * margin, P2D);
    scoreBoard = createGraphics(120, 200 - 2 * margin, P2D);
    barChart = createGraphics(width - topView.width - scoreBoard.width - 4 * margin, 200 - 10 - 3 * margin, P2D);
    scrollbar = new HScrollbar(topView.width + scoreBoard.width + 3 * margin, height - margin - 10, barChart.width, 10);
  }

  void display() {
    pushMatrix();
    translate(0, height - background.height, 0);

    //draw backgound
    createBackground();
    image(background, 0, 0);

    //draw topView
    createTopView();
    image(topView, margin, margin);

    //draw scoreBoard
    createScoreBoard();
    image(scoreBoard, topView.width + 2 * margin, margin);

    //draw barChart
    createBarChart();
    image(barChart, topView.width + scoreBoard.width + 3 * margin, margin); 

    translate(0, -height + background.height, 0);
    scrollbar.display();
    scrollbar.update();

    popMatrix();
  }

  private void createBackground() {
    background.beginDraw();
    background.background(0);
    background.endDraw();
  }

  private float mapFlatX(float toMap) {
    return map(toMap, -board.sizeX/2, board.sizeX/2, 0, topView.width);
  }

  private float mapFlatY(float toMap) {
    return map(toMap, -board.sizeZ/2, board.sizeZ/2, 0, topView.height);
  }

  private void createTopView() {
    //calculate ball and cylinders radius proportionally to the ones on the board
    float ballDiameter = 2 * ball.radius * topView.width / board.sizeX;
    float cylinderDiameter = 2 * cylinder.radius * topView.width / board.sizeX;

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
    translate(topView.width + 2 * margin, margin);

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

  private void createBarChart() {
    barChart.beginDraw();
    barChart.background(255);
    pushMatrix();
    pointsChart.drawChart(barChart);
    popMatrix();
    barChart.endDraw();
  }
}