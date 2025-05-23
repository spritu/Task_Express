import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../colors.dart';
import '../controllers/worknest_controller.dart';

class WorknestView extends GetView<WorknestController> {
  const WorknestView({super.key});
  @override
  Widget build(BuildContext context) {
    final WorknestController controller = Get.put(WorknestController());

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppColors.primaryGradient),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person_2_outlined, color: Colors.white),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Work ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: 'nest',
                          style: TextStyle(
                            color: Color(0xFF235CD7),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.notifications_active_outlined),
                ],
              ),
              SizedBox(height: 10),
              SearchBarWidget(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: GridView.builder(
                  itemCount: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 3 columns
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.95, // Square aspect ratio
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 87,
                        width: 77,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(blurRadius: 4, color: Color(0xFFD3D3D3)),
                          ],
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                controller.imagePaths[index],
                                fit: BoxFit.cover,
                                width: 27,
                                height: 27,
                              ),
                              SizedBox(height: 5),
                              Text(
                                controller.titles[index],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              DiscountBannerView(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Search for ‘Plumber’",
        prefixIcon: Icon(Icons.search, color: Color(0xFF5F5D5D)),
        suffixIcon: Icon(Icons.mic, color: Color(0xFF235CD7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Color(0xFF235CD7), width: 2),
        ),
      ),
    );
  }
}

class DiscountBannerController extends GetxController {
  final CarouselController carouselController = CarouselController();
  final currentIndex = 0.obs;

  List<Map<String, String>> banners = [
    {
      "title": "Fast, Affordable,\nand Leak-Free!",
      //"offer": "Flat 20% Off",
      "subtitle": "Professional plumbing service",
      "image": "assets/images/bro1.png",
    },
    {
      "title": "Electric Issues?\nWe’re On It!",
      "offer": "Up to 50% Off",
      "subtitle": "Electric Issues? We’re On It!",
      "image": "assets/images/bro2.png",
    },
    {
      "title": "Lush Lawns, One\nTap Away!",
      "offer": "Buy 1 Get 1 Free",
      "subtitle": "Professional plumbing service",
      "image": "assets/images/bro3.png",
    },
  ];
}

class DiscountBannerView extends StatelessWidget {
  final DiscountBannerController controller = Get.put(DiscountBannerController());

  @override
  Widget build(BuildContext context) {
    return SizedBox( // Ensuring the Column fits within a limited height
      height: MediaQuery.of(context).size.height*0.4,

      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents Column from taking unnecessary space
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 140, // Ensure this height isn't too large
              autoPlay: true,
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                controller.currentIndex.value = index;
              },
            ),
            items: controller.banners.map((banner) {
              return Card(color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Fixes overflow issue
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner["title"] ?? "No Title",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              banner["subtitle"] ?? "No Subtitle",
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4), // Add spacing for better layout
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF235CD7),
                                minimumSize: Size(69, 25),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Book now",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        banner["image"] ?? "assets/images/default.png",
                        width: 100,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          // Dots Indicator
          const SizedBox(height: 10),
          Obx(() => AnimatedSmoothIndicator(
            activeIndex: controller.currentIndex.value,
            count: controller.banners.length,
            effect: ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: const Color(0xff6055d8),
              dotColor: Colors.grey.shade400,
            ),
            onDotClicked: (index) {
              controller.carouselController.animateToPage(index);
            },
          )),
        ],
      ),
    );
  }
}


extension on CarouselController {
  void animateToPage(int index) {}
}
