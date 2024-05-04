import 'package:call_with_invitation_and_notification/constants.dart';
import 'package:call_with_invitation_and_notification/slider_model.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {

  List<SliderModel> slides =[];
  int currentIndex = 0;
  PageController? _controller;



  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
    slides = getSlides();
  }
  @override
  void dispose(){
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                onPageChanged: (value){
                  setState(() {
                    currentIndex = value;
                  });
                },
                itemCount: slides.length,
                itemBuilder: (context, index){

                  // contents of slider
                  return Slider(
                    image: slides[index].getImage(),
                    details: slides[index].getDetails(),

                  );
                }
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.purpleAccent,

                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: InkWell(
              child: Center(
                child: Text(
                    currentIndex == slides.length - 1 ? "Continue": "Next",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
              ),
              onTap: (){
                if(currentIndex == slides.length - 1){
                  Navigator.pushNamed(
                    context,
                    PageRouteNames.login,
                  );
                }
                _controller!.nextPage(duration: Duration(milliseconds: 100), curve: Curves.bounceIn);
              },
             /* textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),*/
            ),

          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Container buildDot(int index, BuildContext context){
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.purpleAccent,
      ),
    );
  }
}



class Slider extends StatelessWidget {
  String? image;
  String? details;

  Slider({this.image,this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          // image given in slider
          Image(image: AssetImage(image!)),
          SizedBox(height: 20),

          Container(
              margin: EdgeInsets.only(left: 30,right: 30),
              child: Text(details!,textAlign: TextAlign.center,style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),)),

        ],
      ),
    );
  }
}



