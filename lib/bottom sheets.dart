import 'package:flutter/material.dart';

void ElecAndPlumbSheet(BuildContext context, List<String> categories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),
            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.5, // Set height based on your need
              child: ListView.separated(
                itemCount: categories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        categories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void HouseAndCleanSheet(BuildContext context, List<String> housecategories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),

            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.5, // Set height based on your need
              child: ListView.separated(
                itemCount: housecategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        housecategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void MachAndGarageSheet(BuildContext context, List<String> machinecategories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),

            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.2, // Set height based on your need
              child: ListView.separated(
                itemCount: machinecategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        machinecategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void TransportSheet(BuildContext context, List<String> transportcategories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),

            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.3, // Set height based on your need
              child: ListView.separated(
                itemCount: transportcategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        transportcategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void OfficeSheet(BuildContext context, List<String> officecategories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),

            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.2, // Set height based on your need
              child: ListView.separated(
                itemCount: officecategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        officecategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void EvenetSheet(BuildContext context, List<String> evenetcategories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),

            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.4, // Set height based on your need
              child: ListView.separated(
                itemCount: evenetcategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        evenetcategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void EntertainmentSheet(
    BuildContext context,
    List<String> entertainmentcategories,
    ) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),

            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.2, // Set height based on your need
              child: ListView.separated(
                itemCount: entertainmentcategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        entertainmentcategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void PetCareSheet(BuildContext context, List<String> petcategories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),
            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.2, // Set height based on your need
              child: ListView.separated(
                itemCount: petcategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        petcategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void SpeCareSheet(BuildContext context, List<String> specategories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),

            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.2, // Set height based on your need
              child: ListView.separated(
                itemCount: specategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        specategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void HomeImpSheet(BuildContext context, List<String> impcategories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),

            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.2, // Set height based on your need
              child: ListView.separated(
                itemCount: impcategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        impcategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
void FarmingSheet(BuildContext context, List<String> farmingcategories) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true, // Optional: allows full-height scrollable sheet
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Choose Sub-category",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1),

            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.2, // Set height based on your need
              child: ListView.separated(
                itemCount: farmingcategories.length,
                separatorBuilder: (_, __) => const Divider(thickness: 1),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                        farmingcategories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: "Poppins",
                          color: Color(0xFFF67C0A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
