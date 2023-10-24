import 'package:custard_flutter/components/EventCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      tabIndex = _tabController.index;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: size.height,
          child: SingleChildScrollView(
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.25,
                        child: Image.asset(
                          'assets/images/background.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.arrow_back_ios),
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.more_vert),
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 150,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      elevation: 12.0,
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      // minimumSize: const Size.fromHeight(40),
                                      padding: const EdgeInsets.all(5)),
                                  child: Text(
                                    "Replace Image",
                                    style: TextStyle(
                                      color: Color(0xFF7B61FF),
                                      fontSize: 16,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.05,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  // alignment: Alignment.topLeft,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/background.jpeg'),
                                        fit: BoxFit.cover),
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      "#ASTRONAUTS",
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "The Mountainers",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      "Jaipur, Rajasthan",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Spread Positivity With daily Affirmations',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: size.width * 0.9,
                              height: 70,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0x30FFB661),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Today's Affirmation:",
                                    style: TextStyle(
                                      color: Color(0xFF4B3A00),
                                      fontSize: 14,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '"Your potential is endless. Go conquer the day!"',
                                    style: TextStyle(
                                      color: Color(0xFF546881),
                                      fontSize: 12,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: size.width,
                    height: 30,
                    color: Color.fromARGB(255, 247, 247, 242),
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Details'),
                      Tab(text: 'Member'),
                      Tab(text: 'Access'),
                    ],
                    labelColor: Color(0xFF7B61FF),
                    unselectedLabelColor: Colors.black,
                    indicatorColor: Color(0xFF7B61FF),
                    indicatorWeight: 3.0,
                  ),
                  Container(
                    height: size.height * 1.15,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Details(),
                        Text('Member Content'),
                        Text('Access Content')
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Details() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'About',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit))
          ],
        ),
        Text(
            "This case study aligns with the goals outlined in Executive Order [Specify the Executive Order Number if applicable]. The Executive Order emphasizes the modernization of government operations through the adoption of innovative technology solutions, with a focus on streamlining processes and enhancing digital services."),
        Row(
          children: [
            Text(
              'Our Events',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit))
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          height: 300,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return EventCard();
              }),
        ),
        Row(
          children: [
            Text(
              'Highlights',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit))
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          height: 200,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return HighlightContainer();
              }),
        ),
        Row(
          children: [
            Text(
              'Hosts',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          ],
        ),
        Container(
          alignment: Alignment.topLeft,
          height: 100,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                    ),
                    radius: 40,
                  ),
                );
              }),
        ),
      ],
    ),
  );
}

class HighlightContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 200,
      width: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdXX7GO70tKqiGR95LplD2avbw4oIOGll9jJBNCnvT&s",
          ),
          fit: BoxFit.cover,
        ),
        borderRadius:
            BorderRadius.circular(15.0), // Adjust the radius as needed
      ),
      // alignment: AlignmentDirectional.bottomStart,
      child: Container(
        padding: EdgeInsets.only(left: 5),
        alignment: Alignment.bottomLeft,
        child: Text(
          'Revisit the\n Moment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
