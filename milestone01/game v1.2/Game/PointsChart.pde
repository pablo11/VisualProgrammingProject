class PointsChart {
  private ArrayList<Float> pointsChart;
  private Float min;
  private Float max;
  private float precision;
  float chartBlockSize;

  PointsChart(float prec, float blockSize) {
    pointsChart = new ArrayList<Float>();
    pointsChart.add(0f);
    min = 0f;
    max = 0f;
    precision = prec;
    chartBlockSize = blockSize;
  }

  void recordPoints() {
    Float p = score.points;
    if (p < min) {
      min = p;
    }
    if (p > max) {
      max = p;
    }
    pointsChart.add(p);
  }

  void drawChart(PGraphics canvas, PVectorUInt size) {
    if (pointsChart.size() > 1) {
      canvas.fill(0, 0, 255);
      canvas.stroke(255);
      
      for (int i = 0; i < pointsChart.size(); ++i) {
        float h = map(pointsChart.get(i) - min, 0, max - min, 0, size.y);
        canvas.rect(chartBlockSize * i, size.y - h, chartBlockSize, h);
      }
    }
  }
}