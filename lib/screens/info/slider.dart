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
    _pageController = PageController(initialPage: _currentPage,viewportFraction: 1.0);
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
          padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                    AspectRatio(
                      aspectRatio: 0.70,
                      child: PageView.builder(
                        itemCount: sliderList.length,
                        physics: const ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int index){
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index){
                          return carouselView(index);
                        },
                      ),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: sliderList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(entry.key, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == entry.key ? Colors.deepPurple : Colors.blueGrey.shade200,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _currentPage < sliderList.length -1
      ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: (){
              Navigator.of(context).pushNamed('/welcome');
            }, child: Text('SKIP'),),
            TextButton(onPressed: (){
              _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
            }, child: Text('Next'),),
          ],
      )
    : Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(onPressed: (){
            Navigator.of(context).pushNamed('/welcome');
          }, child: Text('Get Started'),),
        ],
      ),
    );
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
     animation: _pageController,
     builder: (context, child){
       return carouselCard(sliderList[index]);
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
        const SizedBox(height: 30,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(data.subTitle,  style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 16, fontWeight: FontWeight.bold),),
        ),
        const SizedBox(height: 30,),
      ],
    );
  }
}
