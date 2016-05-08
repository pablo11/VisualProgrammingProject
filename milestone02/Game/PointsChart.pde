class PointsChart {
  private ArrayList<Float> pointsChart;
  private Float max;
  float blockSize;
  
  PointsChart(float bSize) {
    pointsChart = new ArrayList<Float>();
    pointsChart.add(0f);
    max = 200f;
    blockSize = bSize;
  }

  void recordPoints() {
    Float p = score.points;
    if (p > max) {
      max = p;
    }
    pointsChart.add(p);
  }

  void drawChart(PGraphics canvas) {
    if (pointsChart.size() > 1) {
      canvas.fill(0, 255, 0);
      canvas.stroke(255);
      
      float scrollScale = score.scrollbar.getPos() + 0.5;
      
      for (int i = 0; i < pointsChart.size(); ++i) {
        float h = map(pointsChart.get(i), 0, max, 0, canvas.height);
        for (int j = 0; j < h / blockSize; ++j) {
          canvas.rect(i * blockSize * scrollScale, canvas.height - j * blockSize, blockSize * scrollScale, blockSize);
        }
      }
    }
  }
}