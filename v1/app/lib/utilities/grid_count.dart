int getGridCount(double screenWidth) {
  if (400 > screenWidth) {
    return 1;
  }

  if (800 > screenWidth) {
    return 1;
  }

  if (1080 > screenWidth) {
    return 3;
  }

  if (1400 > screenWidth) {
    return 4;
  }

  return 5;
}
