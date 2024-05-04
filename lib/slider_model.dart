class SliderModel{
  String? image;
  String? details;

// images given
  SliderModel({this.image,this.details});

// setter for image
  void setImage(String getImage){
    image = getImage;
  }

// getter for image
  String getImage(){
    return image!;
  }

  // setter for image
  void setDetails(String getdetails){
    details = getdetails;
  }

// getter for image
  String getDetails(){
    return details!;
  }
}
List<SliderModel> getSlides(){
  List<SliderModel> slides = [];
  SliderModel sliderModel = new SliderModel();

// 1
  sliderModel.setImage("assets/image/slider_one.png");
  sliderModel.setDetails("Welcome to Soulmate\nExperience seamless video calls with high-quality audio and video,\nmaking connecting with loved ones easier than ever.");


  slides.add(sliderModel);

  sliderModel = new SliderModel();

// 2
  sliderModel.setImage("assets/image/slider_two.png");
  sliderModel.setDetails("A unique experience for every user.\nTailored to your preferences, Soulmate.");

  slides.add(sliderModel);

  sliderModel = new SliderModel();

// 3
  sliderModel.setImage("assets/image/slider_three.png");
  sliderModel.setDetails("Ready to go? Start using, Soulmate.");

  slides.add(sliderModel);

  sliderModel = new SliderModel();
  return slides;
}