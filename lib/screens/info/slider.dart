import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/slider_data.dart';
class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage,viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.85,
                      child: PageView.builder(
                        itemCount: sliderList.length,
                        physics: const ClampingScrollPhysics(),
                        controller: _pageController,
                        itemBuilder: (context, index){
                          return carouselView(index);
                        },
                      ),
                    ),
                ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Row(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       TextButton(onPressed: (){
      //         Navigator.of(context).pushNamed('/welcome');
      //       }, child: Text('SKIP'),),
      //       TextButton(onPressed: (){
      //         Navigator.of(context).pushNamed('/welcome');
      //       }, child: Text('Get Started'),),
      //     ],
      // ),
    );
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
     animation: _pageController,
     builder: (context, child){
       return carouselCard(sliderList[index]);
      //  double value = 0.0;
      // if(_pageController.position.haveDimensions){
      //   value = index.toDouble() - (_pageController.page ?? 0);
      //   value = (value * 0.038).clamp(-1, 1);
      // }
      // return Transform.rotate(
      //   angle: pi * value,
      //   child: carouselCard(sliderList[index]),);
     },
    );

  }
  Widget carouselCard(SliderDataModel data){
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: AssetImage(
                    data.imageName,
                  ),
                  fit: BoxFit.fill,
                ),
                boxShadow: const[
                  BoxShadow(
                    offset: Offset(0, 4), blurRadius: 4, color: Colors.black26
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(data.title,  style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data.subTitle,  style: TextStyle(color: Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.bold),),
        ),
      ],
    );
  }
}
