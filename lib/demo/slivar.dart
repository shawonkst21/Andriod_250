import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class SliderWithSmoothIndicator extends StatefulWidget {
  const SliderWithSmoothIndicator({super.key});

  @override
  _SliderWithSmoothIndicatorState createState() => _SliderWithSmoothIndicatorState();
}

class _SliderWithSmoothIndicatorState extends State<SliderWithSmoothIndicator> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  final List<Widget> _containers = [
    Container(
      color: Colors.red,
      child: Center(child: Text('Container 1', style: TextStyle(color: Colors.white, fontSize: 24))),
    ),
    Container(
      color: Colors.green,
      child: Center(child: Text('Container 2', style: TextStyle(color: Colors.white, fontSize: 24))),
    ),
    Container(
      color: Colors.blue,
      child: Center(child: Text('Container 3', style: TextStyle(color: Colors.white, fontSize: 24))),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smooth Page Indicator")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CarouselSlider(
            items: _containers,
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: _containers.length,
            effect: WormEffect(
              dotHeight: 12,
              dotWidth: 12,
              activeDotColor: Colors.black,
              dotColor: Colors.grey.shade300,
            ),
            onDotClicked: (index) {
              _carouselController.animateToPage(index);
            },
          ),
        ],
      ),
    );
  }
}