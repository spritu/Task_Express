import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:worknest/colors.dart';
import '../../../../auth_controller.dart';
import '../../BricklayingHelper/views/bricklaying_helper_view.dart';
import '../../CementHelper/views/cement_helper_view.dart';
import '../../Scaffolding_helper/views/scaffolding_helper_view.dart';
import '../../bottom/controllers/bottom_controller.dart';
import '../../location/controllers/location_controller.dart';
import '../../plastering_helper/views/plastering_helper_view.dart';
import '../../professional_plumber/views/professional_plumber_view.dart';
import '../../road_construction_helper/views/road_construction_helper_view.dart';
import '../../tile_fixing_helper/views/tile_fixing_helper_view.dart';
import '../controllers/home_controller.dart';
import 'package:http/http.dart' as http;

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final bottomController = Get.find<BottomController>();
    controller.onNeedContext = (showSheet) {
      showSheet(context); // now controller can call showSignupSheet(context)
    };

    // Get.put(AuthController(), permanent: true);
    final locationController = Get.find<LocationController>();
    final  authController = Get.find<AuthController>();
    return Scaffold(backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location & Search Bar
                  InkWell(
                    onTap: () {
                      bottomController.checkAndShowSignupSheet(context);
                      // if (!authController.isLoggedIn.value) {
                      //   controller.showSignupSheet(context);
                      // } else {}
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xad87AAF6), Colors.white],),),
                      child:
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [SizedBox(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 30),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [  Row(
                                    children: const [
                                      //  Icon(Icons.location_on, color: Colors.black),
                                      SizedBox(width: 5),
                                      Text(
                                        "Address",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Icon(Icons.keyboard_arrow_down),
                                    ],
                                  ),
                                    Obx(() => Text(
                                      controller.landMark.value.isNotEmpty ? '${controller.houseNo.value} ${controller.landMark.value}'
                                          : locationController
                                          .currentAddress
                                          .value
                                          .isNotEmpty ? locationController
                                          .currentAddress
                                          .value
                                          : "Fetching location..",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: AppColors.textColor,
                                      ),),),],),
                                const Spacer(),
                                Text(
                                  'Task',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0XFF114BCA),
                                  ),),
                                Text(
                                  'Express',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.orage,),),],),
                            SizedBox(height: 20),
                            // TextField(
                            //   controller: controller.searchController,
                            //   onChanged: (value) {
                            //     if (value.isEmpty) {
                            //       controller.searchResults.clear();
                            //       FocusScope.of(context).unfocus();
                            //       return;
                            //     }
                            //
                            //     if (bottomController.authController.isLoggedIn.value) {
                            //       controller.fetchServiceProviders(value);
                            //     }
                            //   },
                            //   decoration: InputDecoration(
                            //     prefixIcon: Icon(Icons.search,size: 24,),
                            //     hintText: "Search for ‘Plumber’",
                            //     isDense: true,hintStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xff9B9999)),
                            //     contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(25),
                            //       borderSide: BorderSide.none,
                            //     ),
                            //     filled: true,
                            //     fillColor: Colors.white,
                            //   ),
                            // ),
                            Obx(() => Row(
                              children: [
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: controller.isFirstFocused.value ? 190 : 120,
                                  child: TextField(
                                    onChanged: (value) {
                                    if (value.isEmpty) {
                                      controller.searchResults.clear();
                                      FocusScope.of(context).unfocus();
                                      return;
                                    }

                                    if (bottomController.authController.isLoggedIn.value) {
                                      controller.fetchServiceProviders(value);
                                    }
                                  },
                                    controller: controller.plumberController,
                                    focusNode: controller.plumberFocusNode,
                                    decoration: InputDecoration(
                                      prefixIcon: controller.isFirstFocused.value
                                          ? Icon(Icons.search, size: 20)
                                          : null,
                                      hintText: "Search for Category",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff9B9999),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: controller.isFirstFocused.value ? 120 : 190,
                                  child: TextField(
                                    controller: controller.nameController,
                                    focusNode: controller.nameFocusNode,
                                    onChanged: (value) {
                                      print("Search changed: $value");
                                      if (value.isEmpty) {
                                        controller.searchResults.clear();
                                        FocusScope.of(context).unfocus();
                                        return;
                                      }

                                      if (bottomController.authController.isLoggedIn.value) {
                                        print("Calling fetchUsersByName");
                                        controller.fetchUsersByName();
                                      }
                                    },

                                    decoration: InputDecoration(
                                      prefixIcon: !controller.isFirstFocused.value ? Icon(Icons.search, size: 20) : null,
                                      hintText: "Search by Name",
                                      hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff9B9999)),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),

                              ],


                            ),),
                            SizedBox(height: 10),
                            Obx(() {
                              if (controller.searchResults.isEmpty) return const SizedBox();

                              return Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                constraints: BoxConstraints(maxHeight: 300),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: controller.searchResults.length,
                                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
                                  itemBuilder: (context, index) {
                                    final item = controller.searchResults[index];
                                    final itemName = item['name'] ?? 'No Name';

                                    return ListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      title: Text(itemName, style: TextStyle(fontSize: 14)),
                                      onTap: () {
                                        final matchedIn = item['matchedIn'];
                                        final catId = matchedIn == 'category'
                                            ? item['_id']?.toString()
                                            : item['parentId']?.toString();
                                        final catName = item['name'] ?? 'Professionals';

                                        if (matchedIn == 'name') {
                                          // Fill name in nameController
                                          controller.nameController.text = itemName;
                                          final userData = item['data'];
                                          if (userData != null && userData is Map<String, dynamic>) {
                                            controller.searchResults.clear();
                                            FocusScope.of(context).unfocus();
                                            Get.to(() => PlasteringHelperView(), arguments: userData)?.then((_) {
                                              controller.nameController.clear();
                                            });
                                          } else {
                                            print("❌ userData is null or not a map");
                                          }
                                        } else if (catId != null && catId.isNotEmpty) {
                                          // Fill category name in plumberController
                                          controller.plumberController.text = catName;
                                          controller.fetchUsersListByCategory(catId, categoryName: catName);
                                          controller.searchResults.clear();
                                          FocusScope.of(context).unfocus();
                                          Get.to(() => ProfessionalPlumberView(), arguments: {
                                            'users': controller.results,
                                            'title': catName,
                                          })?.then((_) {
                                            controller.plumberController.clear();
                                          });
                                        } else {
                                          print("❌ Invalid category ID in: $item");
                                        }
                                      },
                                    );
                                  },
                                ),
                              );
                            }),






                          ],),),
                    ),),
                  // Service Type Buttons
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Obx(() {
                            return Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [Row(children: [
                                Expanded(child: InkWell(
                                  onTap: () { bottomController.checkAndShowSignupSheet(context);
                                  // if (!authController.isLoggedIn.value) {
                                  //   // User not logged in, show bottom sheet
                                  //   controller.showSignupSheet(context);
                                  //   return;}
                                  // ✅ User is logged in, proceed
                                  final selectedCategory =
                                      controller
                                          .visitingProfessionals
                                          .first;
                                  controller.fetchUsersByCategory(
                                    selectedCategory.catid,
                                  );
                                  controller.toggleServiceExpansion(
                                    'Visiting Professionals',);},
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color:
                                      controller.expandedServiceType.value == 'Visiting Professionals'
                                          ? const Color(0xFFD9E4FC)
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),),), child: SizedBox(
                                    height: 80,
                                    width: 160,
                                    child: Card(color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0,),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/service_provider.png",
                                              color: const Color(0xffF67C0A,),),
                                            const SizedBox(height: 4),
                                            const Text(
                                              "Visiting\nProfessionals",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight:
                                                FontWeight.w500,
                                                height: 1.3,
                                              ),),],),),),),),),),
                                // Fixed Charge Helpers Button
                                Expanded(child: InkWell(
                                  onTap: () {
                                    //bottomController.checkAndShowSignupSheet(context);
                                    if (!authController.isLoggedIn.value) {
                                      bottomController.checkAndShowSignupSheet(context);
                                      return;
                                    }
                                    // ✅ User is logged in, proceed
                                    final selectedCategory = controller.fixedChargeHelpers.first;
                                    controller.fetchUsersByCategory(
                                      selectedCategory.catid,);
                                    controller.toggleServiceExpansion(
                                      'Fixed charge Helpers',);},
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(color:
                                    controller.expandedServiceType.value == 'Fixed charge Helpers'
                                        ? const Color(0xFFD9E4FC)
                                        : Colors.transparent,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),),),
                                    child: SizedBox(height: 80, width: 160,
                                      child: Card(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0,
                                          ),
                                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [Image.asset(
                                              "assets/images/helper.png",
                                              color: const Color(
                                                0xffF67C0A,
                                              ),),
                                              const SizedBox(height: 4),
                                              const Text(
                                                "Fixed charge\nHelpers",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  height: 1.3,),),],),),),),),)),],),
                                // Category Grid
                                if (controller.expandedServiceType.value.isNotEmpty)
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD9E4FC),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Obx(() {
                                      final categories = controller.categories;
                                      final isExpanded =
                                          controller.showAllCategories.value;
                                      final itemCount =
                                      isExpanded ? categories.length + 1 : (categories.length > 7 ? 8
                                          : categories.length);
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                          const NeverScrollableScrollPhysics(),
                                          itemCount: itemCount,
                                          gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                            childAspectRatio: 1,
                                          ),
                                          itemBuilder: (context, index) {
                                            if (!isExpanded &&
                                                index == 7 &&
                                                categories.length > 7) {
                                              return InkWell(
                                                onTap: () {bottomController.checkAndShowSignupSheet(context);
                                                controller.toggleCategoryView();
                                                },
                                                child: const Card(color: Colors.white, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment
                                                    .center, children: [Icon(Icons.add),
                                                  Text('More', style: TextStyle(fontSize: 10,
                                                  ),),],),),),);}
                                            if (isExpanded && index == categories.length) {
                                              return InkWell(
                                                onTap: controller.toggleCategoryView,
                                                child: const Card(
                                                  color: Colors.white,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.close),
                                                        Text('Close', style: TextStyle(fontSize: 10)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                            final cat = categories[index];
                                            return InkWell(
                                              onTap: () {
                                                //bottomController.checkAndShowSignupSheet(context);
                                                if (!authController.isLoggedIn.value) {
                                                  bottomController.checkAndShowSignupSheet(context);
                                                  return;
                                                }
                                                if (cat.spType == '2') {
                                                  // Show subcategories
                                                  Get.bottomSheet(
                                                    Container(
                                                      padding: const EdgeInsets.all(16,),
                                                      decoration: const BoxDecoration(
                                                        color: Color(0xFFD9E4FC),
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20,)),),
                                                      child: Column(mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [Text(cat.label,
                                                              style: const TextStyle(fontSize: 16,),),
                                                              InkWell(
                                                                onTap: () => Get.back(),
                                                                child: const Icon(
                                                                  Icons.close,),),],),
                                                          const SizedBox(height: 16,),
                                                          GridView.builder(
                                                            shrinkWrap: true,
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            itemCount: cat.subcategories.length,
                                                            gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: 3,
                                                                crossAxisSpacing: 10,
                                                                mainAxisSpacing: 10,
                                                                childAspectRatio: 1.8),
                                                            itemBuilder: (
                                                                context,
                                                                index,
                                                                ) {final sub = cat.subcategories[index];
                                                            return InkWell(
                                                              onTap: () {
                                                                //bottomController.checkAndShowSignupSheet(context);
                                                                // if (!authController.isLoggedIn.value) {
                                                                //   bottomController.checkAndShowSignupSheet(context);
                                                                //   return;
                                                                // }
                                                                controller.fetchUsersListByCategory(sub.id, categoryName: sub.name,);
                                                                Get.back();
                                                              },
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                padding:
                                                                const EdgeInsets.symmetric(horizontal: 8, vertical: 12,),
                                                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12,),
                                                                  boxShadow: [
                                                                    BoxShadow(color: Colors.black
                                                                        .withOpacity(0.05,), blurRadius: 4, offset: const Offset(0, 2,),),],), child: Text(
                                                                sub.name,
                                                                textAlign: TextAlign.center,
                                                                style: const TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w500,
                                                                ),),),);},),],),),
                                                    isScrollControlled: true,
                                                  );
                                                } else if (cat.spType == '1') {
                                                  if (!authController.isLoggedIn.value) {
                                                    bottomController.checkAndShowSignupSheet(context);
                                                    return;
                                                  }
                                                  // 🔥 Call API for Visiting Professionals
                                                  controller
                                                      .fetchUsersListByCategory(
                                                    cat.catid,
                                                    categoryName: cat.label,
                                                  );}},
                                              child: Card(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        Image.network(
                                                          cat.icon,
                                                          height: 20,
                                                          width: 20,
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (context, error, stackTrace,) => const Icon(
                                                            Icons.broken_image,),),
                                                        const SizedBox(height: 2),
                                                        Text(cat.label, style: const TextStyle(
                                                          fontSize: 10,),
                                                          textAlign: TextAlign.center, maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,)],)),),);},),);}),),

                                // 🔽 User List Section
                                // else if (controller.expandedServiceType.value == 'Visiting Professionals')
                                //     const Center(child: Text("No users found.")),
                              ],
                            );
                          }),
                        ),
                        SizedBox(height: 10),
                        DiscountBannerView(),
                        // Most booked services
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Most booked services", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textColor,),),],),
                        ),
                        SizedBox(height: 5), SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero, // ✅ remove default padding
                            itemCount: controller.services.length,
                            itemBuilder: (context, index) {
                              final service = controller.services[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start, // ✅ prevents vertical centering
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        service['image']!,
                                        width: 94,
                                        height: 94,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${service['Name']}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),),],),);},),),],),),),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
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
  final DiscountBannerController controller = Get.put(
    DiscountBannerController(),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        // Ensuring the Column fits within a limited height
        height: MediaQuery.of(context).size.height * 0.22, // Slightly increased

        child: Column(
          mainAxisSize:
          MainAxisSize.min, // Prevents Column from taking unnecessary space
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 135,
                // Ensure this height isn't too large
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
                      colors: [Color(0xFF235CD7), Color(0x40F5F5F5)],
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
                        Expanded(
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 8),

                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min, // Fixes overflow issue
                              mainAxisAlignment: MainAxisAlignment.center,
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
                        ),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            banner["image"] ?? "assets/images/default.png",
                            width: 90,
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
              final progress =
                  (controller.currentIndex.value + 1) /
                      controller.banners.length;
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


class SearchResultDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const SearchResultDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(data['name'] ?? 'Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${data['name'] ?? 'N/A'}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Email: ${data['email'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Mobile: ${data['mobile'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Profession: ${data['profession'] ?? 'N/A'}", style: TextStyle(fontSize: 16)),
            // Add more fields as needed
          ],
        ),
      ),
    );
  }
}