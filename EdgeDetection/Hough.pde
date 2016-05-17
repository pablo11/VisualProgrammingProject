import java.util.Collections;
import java.util.List;

class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }
  @Override
    public int compare(Integer l1, Integer l2) {
    if (accumulator[l1] > accumulator[l2]
      || (accumulator[l1] == accumulator[l2] && l1 < l2)) return -1;
    return 1;
  }
}


int[] hough(PImage edgeImg) {
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;

  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];

  // Fill the accumulator: on edge points (ie, white pixels of the edge image), 
  // store all possible (r, phi) pairs describing lines going through the point.
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        for (int phi = 0; phi < phiDim; ++phi) {
          int r = (int) (x * tabCos[phi] + y * tabSin[phi]);
          //int r = (int) ((x * cos(phi * discretizationStepsPhi) + y * sin(phi * discretizationStepsPhi)) / discretizationStepsR);
          r += (rDim - 1) / 2;
          accumulator[(phi + 1) * (rDim + 2) + r] += 1;
        }
      }
    }
  }
  return accumulator;
}

PImage displayAccumulator(PImage edgeImg) {
  int[] accumulator = hough(edgeImg);

  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;

  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

  PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }
  // You may want to resize the accumulator to make it easier to see:
  houghImg.resize(400, 400);
  houghImg.updatePixels();
  return houghImg;
}

ArrayList<PVector> displayLines(PImage edgeImg, int minVotes, int nLines) {
  int[] accumulator = hough(edgeImg);

  ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
  ArrayList<PVector> lines = new ArrayList<PVector>();

  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;

  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

  // size of the region we search for a local maximum
  int neighbourhood = 10;

  for (int accR = 0; accR < rDim; ++accR) {
    for (int accPhi = 0; accPhi < phiDim; ++accPhi) {
      // compute current index in the accumulator
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      if (accumulator[idx] > minVotes) {
        boolean bestCandidate = true;
        // iterate over the neighbourhood
        for (int dPhi = -neighbourhood / 2; dPhi < neighbourhood / 2 + 1; ++dPhi) {
          // check we are not outside the image
          if ((accPhi + dPhi < 0) || (accPhi + dPhi >= phiDim)) continue;
          for (int dR = -neighbourhood / 2; dR < neighbourhood / 2 + 1; ++dR) {
            // check we are not outside the image
            if ((accR+dR < 0) || (accR+dR >= rDim)) continue;
            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
            if (accumulator[idx] < accumulator[neighbourIdx]) {
              // the current idx is not a local maximum!
              bestCandidate = false;
              break;
            }
          }
          if (!bestCandidate) break;
        }
        if (bestCandidate) {
          // the current idx *is* a local maximum
          bestCandidates.add(idx);
        }
      }
    }
  }

  Collections.sort(bestCandidates, new HoughComparator(accumulator));

  //fill lines with best candidates lines
  for (int i = 0; i < min(nLines, bestCandidates.size()); ++i) {
    // first, compute back the (r, phi) polar coordinates:
    int accPhi = (int) (bestCandidates.get(i) / (rDim + 2)) - 1;
    int accR = bestCandidates.get(i) - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;
    lines.add(new PVector(r, phi));
  }

  //draw best lines
  drawLines(lines, edgeImg);

  return lines;
}

void drawLines(ArrayList<PVector> lines, PImage edgeImg) {
  for (PVector l : lines) {
    float r = l.x;
    float phi = l.y;

    int x0 = 0;
    int y0 = (int) (r / sin(phi));
    int x1 = (int) (r / cos(phi));
    int y1 = 0;
    int x2 = edgeImg.width;
    int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
    int y3 = edgeImg.width;
    int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));

    // Finally, plot the lines
    stroke(204, 102, 0);
    if (y0 > 0) {
      if (x1 > 0) line(x0, y0, x1, y1);
      else if (y2 > 0) line(x0, y0, x2, y2);
      else line(x0, y0, x3, y3);
    } else {
      if (x1 > 0) {
        if (y2 > 0) line(x1, y1, x2, y2);
        else line(x1, y1, x3, y3);
      } else line(x2, y2, x3, y3);
    }
  }
}

ArrayList<PVector> getIntersections(List<PVector> lines) {
  ArrayList<PVector> intersections = new ArrayList<PVector>();

  for (int i = 0; i < lines.size() - 1; ++i) {
    PVector line1 = lines.get(i);
    for (int j = i + 1; j < lines.size(); ++j) {
      PVector line2 = lines.get(j);
      // compute the intersection and add it to ’intersections’
      float d = cos(line2.y) * sin(line1.y) - cos(line1.y) * sin(line2.y);
      float x = (line2.x * sin(line1.y) - line1.x * sin(line2.y)) / d;
      float y = (-line2.x * cos(line1.y) + line1.x * cos(line2.y)) / d;

      intersections.add(new PVector(x, y));
      // draw the intersection
      fill(255, 128, 0);
      ellipse(x, y, 10, 10);
    }
  }
  return intersections;
}