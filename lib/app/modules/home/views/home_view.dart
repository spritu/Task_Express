import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:worknest/colors.dart';
import '../controllers/home_controller.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Container(decoration: BoxDecoration( gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87AAF6),
            Colors.white,
          ],
        ),),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location & Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 30),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text('Scheme No 54', style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12,color: AppColors.textColor)),
                          Text('Fh-289, Vijaynagar,Indore',style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,color: AppColors.textColor)),
                        ],
                      ),
                      const Spacer(),
                       Text('Task', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Color(0XFF114BCA))),
                      Text('Express', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.orage)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: const Icon(Icons.tune),
                      hintText: "Search for ‘Plumber’",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Service Type Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Row with both service buttons side by side
                        Row(
                          children: controller.serviceTypes.map((type) {
                            bool isExpanded = controller.expandedServiceType.value == type['title'];
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => controller.toggleServiceExpansion(type['title']!),
                                child: Container(
                                // margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: isExpanded ? const Color(0xFFD9E4FC) : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            "assets/images/service_provider.png",
                                            color: const Color(0xffF67C0A),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            type['title']!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        // Grid under selected service
                        if (controller.expandedServiceType.value.isNotEmpty)
                          Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9E4FC),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          //  padding: const EdgeInsets.all(12),
                            child: Obx(() {
                              final isExpanded = controller.showAllCategories.value;
                              final itemCount = isExpanded
                                  ? controller.categories.length + 1 // Include "Close"
                                  : controller.categories.length > 7
                                  ? 8 // 7 items + "More"
                                  : controller.categories.length;

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: itemCount,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 0.7,
                                ),
                                itemBuilder: (context, index) {
                                  // If collapsed and this is 8th item, show "More"
                                  if (!isExpanded && index == 7 && controller.categories.length > 7) {
                                    return GestureDetector(
                                      onTap: controller.toggleCategoryView,
                                      child: Card(
                                        color:  Colors.white,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Icon(Icons.add),
                                            Text(
                                              'More',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  // If expanded and this is the last item, show "Close"
                                  if (isExpanded && index == controller.categories.length) {
                                    return GestureDetector(
                                      onTap: controller.toggleCategoryView,
                                      child: Card(
                                        color: AppColors.white,
                                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                          children: [Image.asset("assets/images/add.png"),
                                            Text(
                                              'Close',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  // Normal category item
                                  final cat = controller.categories[index];
                                  return SizedBox(
                                    height: 100,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(cat['icon']!, style: const TextStyle(fontSize: 24,color: AppColors.textColor)),
                                            const SizedBox(height: 4),
                                            Text(cat['label']!, style:  TextStyle(fontSize: 10,color: AppColors.textColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),



                          ),
                      ],
                    );
                  }),
                ),
                // Banner
                SizedBox(height: 10),
                DiscountBannerView(),

                // Most booked services
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Most booked services", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: AppColors.textColor)),
                ),
                SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.services.length,
                itemBuilder: (context, index) {
                  final service = controller.services[index]; // Corrected
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            service['image']!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.red, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${service['rating']} (${service['reviews']})',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (service['oldPrice'] != null)
                          Row(
                            children: [
                              Text(
                                '₹${service['oldPrice']}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),SizedBox(width: 5,),Text(
                                '₹${service['price']}',
                                style: const TextStyle(
                                  fontSize: 10,

                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),


            const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildServiceCard(String title, String imagePath, String rating, String price, {String? oldPrice}) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Image.asset(imagePath, height: 100, fit: BoxFit.cover),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.red, size: 14),
              Text(rating),
            ],
          ),
          Row(
            children: [
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (oldPrice != null)
                Text(
                  " $oldPrice",
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
  Widget _buildFullCategoryList(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: controller.categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 7,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(cat['icon']!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(cat['label']!, style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
          );
        },
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
  final DiscountBannerController controller = Get.put(
    DiscountBannerController(),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16),
      child: SizedBox(
        // Ensuring the Column fits within a limited height
        height: MediaQuery.of(context).size.height / 4,

        child: Column(
          mainAxisSize:
          MainAxisSize.min, // Prevents Column from taking unnecessary space
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 146, // Ensure this height isn't too large
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  controller.currentIndex.value = index;
                },
              ),
              items:
              controller.banners.map((banner) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [Color(0xFF235CD7),Color(0x40F5F5F5)],
                    ),
                  ),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            mainAxisSize:
                            MainAxisSize.min, // Fixes overflow issue
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner["title"] ?? "No Title",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                ),
                                maxLines: 2,
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
                              // SizedBox(height: 4), // Add spacing for better layout
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF114BCA),
                                  minimumSize: Size(69, 25),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
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
                  ),
                );
              }).toList(),
            ),

            // Dots Indicator
            const SizedBox(height: 10),
            Obx(() {
              final progress = (controller.currentIndex.value + 1) / controller.banners.length;
              return Center(
                child: SizedBox(
                  width: 80, // 👈 adjust this value to your desired width
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xff6055d8),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),


          ],
        ),
      ),
    );
  }
}

extension on CarouselController {
  void animateToPage(int index) {}
}