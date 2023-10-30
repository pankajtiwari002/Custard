import 'package:custard_flutter/components/CustardButton.dart';
import 'package:custard_flutter/components/CustardTextField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('School'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            }, icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: fun2(),
    );
  }
}

fun1() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: 100,
        width: 100,
        child: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Adobe_Illustrator_CC_icon.svg/1051px-Adobe_Illustrator_CC_icon.svg.png'),
      ),
      const SizedBox(
        height: 20,
      ),
      const Text(
        'You don’t have any active roles',
        style: TextStyle(
          color: Color(0xFF090B0E),
          fontSize: 14,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: CustardButton(
            onPressed: () {},
            buttonType: ButtonType.NEGATIVE,
            label: "+ Create a New Role",
            backgroundColor: Color(0xFF665EE0),
            textColor: Colors.white,
          )),
    ],
  );
}

fun2() {
  TextEditingController roleController = new TextEditingController();
  List<String> colorCodes = [
    "0xFF0000",
    "0x00FF00",
    "0x0000FF",
    "0xFFFF00",
    "0x00FFFF",
    "0xFFFFD19B",
    "0x800080",
    "0xFFA500",
    "0xA52A2A",
    "0xFFC0CB",
    "0x008080",
    "0x4B0082",
    "0x00FF00",
    "0xE6E6FA",
    "0xFFCCCBD2",
    "0xFF00B0C8",
    "0xFFFF6161",
    "0xFF00FF66",
    "0xFFFFE17A",
    "0xFF546881",
  ];
  final Map<String, Color> colorMap = {
    "0xFF0000": Colors.red,
    "0x00FF00": Colors.green,
    "0x0000FF": Colors.blue,
    "0xFFFF00": Colors.yellow,
    "0x00FFFF": Colors.cyan,
    "0xFFFFD19B": Color(0xFFFFD19B),
    "0x800080": Colors.purple,
    "0xFFA500": Colors.orange,
    "0xA52A2A": Colors.brown,
    "0xFFC0CB": Colors.pink,
    "0x008080": Colors.teal,
    "0x4B0082": Colors.indigo,
    "0x00FF00": Colors.lime,
    "0xE6E6FA": Color.fromARGB(204, 99, 99, 219),
    "0xFFCCCBD2": Color(0xFFCCCBD2),
    "0xFF00B0C8": Color(0xFF00B0C8),
    "0xFFFF6161": Color(0xFFFF6161),
    "0xFF00FF66": Color(0xFF00FF66),
    "0xFFFFE17A": Color(0xFFFFE17A),
    "0xFF546881": Color(0xFF546881),
  };
  Rx<String> selectedColorCode = colorCodes[0].obs;
  Rx<Color> selectedColor = colorMap[selectedColorCode]!.obs;
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Role Name',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 10.0),
        CustardTextField(labelText: "new role", controller: roleController),
        SizedBox(height: 10.0),
        Text(
          'eg. Moderator, Coach, School',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 30.0),
        Row(
          children: [
            Text(
              'Role Color',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Spacer(),
            Obx(
              () => Container(
                width: 24.0,
                height: 24.0,
                color: selectedColor.value, // Define this color
              ),
            ),
            SizedBox(width: 8.0),
            Obx(
              () => Text(
                selectedColorCode.value, // Define this variable
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Text(
          'Use this color to stand out',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 16.0),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: colorCodes.length, // Define this list of colors
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Implement your logic to handle color selection
                selectedColorCode.value = colorCodes[index];
                selectedColor.value = colorMap[selectedColorCode.value]!;
              },
              child: Container(
                  width: 10.0,
                  height: 10.0,
                  // color: Color(int.parse(colorCodes[index].substring(1),radix: 16)),
                  // Define this list of colors
                  color: colorMap[colorCodes[index]],
                  child: Obx(
                    () => Icon(
                      Icons.done,
                      color: selectedColorCode == colorCodes[index]
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  )),
            );
          },
        ),
        // SizedBox(height: 16.0),
        Spacer(),
        CustardButton(
          onPressed: () {},
          buttonType: ButtonType.POSITIVE,
          label: "Create",
          backgroundColor: Color(0xFF7B61FF),
        ),
      ],
    ),
  );
}

fun3() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const TextField(
            decoration: InputDecoration(
                label: Text("Search Roles"),
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Role - 2",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: 10,
        ),
        ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("School"),
                subtitle: Text("12 Members"),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF7B61FF),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey,
                ),
              );
            })
      ],
    ),
  );
}

fun4() {
  TextEditingController roleController = new TextEditingController();
  List<String> colorCodes = [
    "0xFF0000",
    "0x00FF00",
    "0x0000FF",
    "0xFFFF00",
    "0x00FFFF",
    "0xFFFFD19B",
    "0x800080",
    "0xFFA500",
    "0xA52A2A",
    "0xFFC0CB",
    "0x008080",
    "0x4B0082",
    "0x00FF00",
    "0xE6E6FA",
    "0xFFCCCBD2",
    "0xFF00B0C8",
    "0xFFFF6161",
    "0xFF00FF66",
    "0xFFFFE17A",
    "0xFF546881",
  ];
  final Map<String, Color> colorMap = {
    "0xFF0000": Colors.red,
    "0x00FF00": Colors.green,
    "0x0000FF": Colors.blue,
    "0xFFFF00": Colors.yellow,
    "0x00FFFF": Colors.cyan,
    "0xFFFFD19B": Color(0xFFFFD19B),
    "0x800080": Colors.purple,
    "0xFFA500": Colors.orange,
    "0xA52A2A": Colors.brown,
    "0xFFC0CB": Colors.pink,
    "0x008080": Colors.teal,
    "0x4B0082": Colors.indigo,
    "0x00FF00": Colors.lime,
    "0xE6E6FA": Color.fromARGB(204, 99, 99, 219),
    "0xFFCCCBD2": Color(0xFFCCCBD2),
    "0xFF00B0C8": Color(0xFF00B0C8),
    "0xFFFF6161": Color(0xFFFF6161),
    "0xFF00FF66": Color(0xFF00FF66),
    "0xFFFFE17A": Color(0xFFFFE17A),
    "0xFF546881": Color(0xFF546881),
  };
  Rx<String> selectedColorCode = colorCodes[0].obs;
  Rx<Color> selectedColor = colorMap[selectedColorCode]!.obs;
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Role Name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10.0),
          CustardTextField(labelText: "new role", controller: roleController),
          SizedBox(height: 10.0),
          Text(
            'eg. Moderator, Coach, School',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 30.0),
          Row(
            children: [
              Text(
                'Role Color',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Spacer(),
              Obx(
                () => Container(
                  width: 24.0,
                  height: 24.0,
                  color: selectedColor.value, // Define this color
                ),
              ),
              SizedBox(width: 8.0),
              Obx(
                () => Text(
                  selectedColorCode.value, // Define this variable
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Text(
            'Use this color to stand out',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 16.0),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: colorCodes.length, // Define this list of colors
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Implement your logic to handle color selection
                  selectedColorCode.value = colorCodes[index];
                  selectedColor.value = colorMap[selectedColorCode.value]!;
                },
                child: Container(
                    width: 10.0,
                    height: 10.0,
                    // color: Color(int.parse(colorCodes[index].substring(1),radix: 16)),
                    // Define this list of colors
                    color: colorMap[colorCodes[index]],
                    child: Obx(
                      () => Icon(
                        Icons.done,
                        color: selectedColorCode == colorCodes[index]
                            ? Colors.white
                            : Colors.transparent,
                      ),
                    )),
              );
            },
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Display Seperately",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Adds space between the text and the toggle button
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.toggle_on,
                    color: Color(0xFF7B61FF),
                    size: 50,
                  )),
            ],
          ),
          const Text(
            'Display role members separately from online members',
            style: TextStyle(
              color: Color(0xFF546881),
              fontSize: 14,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Text(
              "Permission",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text(
              "Member",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text(
              "Delete Role",
              style: TextStyle(
                  color: Colors.red, fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 70,
          ),
          CustardButton(
            onPressed: () {},
            buttonType: ButtonType.POSITIVE,
            label: "Save Changes",
            backgroundColor: Color(0xFF7B61FF),
          )
        ],
      ),
    ),
  );
}

fun5() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const TextField(
            decoration: InputDecoration(
                label: Text("Search Roles"),
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("School"),
                subtitle: Text("12 Members"),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTdXX7GO70tKqiGR95LplD2avbw4oIOGll9jJBNCnvT&s"),
                ),
                trailing: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              );
            }),
        Spacer(),
        CustardButton(
          onPressed: () {},
          buttonType: ButtonType.POSITIVE,
          label: "Add Member",
          backgroundColor: Color(0xFF7B61FF),
        ),
      ],
    ),
  );
}
