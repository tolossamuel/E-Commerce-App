


double widthSize(double currentScreenWWidth, double figmaScreenWidth, double componentWidth){
  final double ratioWidth = (currentScreenWWidth * componentWidth)/figmaScreenWidth;
  return ratioWidth;
}

double heightSize(double currentScreenHeight, double figmaScreenHeight, double componentHeight){
  final double ratioHeight = (currentScreenHeight * componentHeight)/ figmaScreenHeight;
  return ratioHeight;
}

double textSize(double currentScreenTextSize, double figmaTextSize, double componentTextSize){
  final double ratioTextSize = (currentScreenTextSize * componentTextSize)/figmaTextSize;
  return ratioTextSize;
}