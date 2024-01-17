import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'helper.dart';

void main() {
  Gemini.init(apiKey: 'AIzaSyBnMTjHX0bAOeBJ6xm6qF5hiAmzsEV6pec');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final gemini = Gemini.instance;

  String? searchedText, result;
  bool _loading = false;

  File? selectedFile;

  void getDataByText(File file) async {
    try {
      setState(() {
        _loading = true;
      });

      //final byteData = await file.readAsBytesSync();
      final Uint8List image = file.readAsBytesSync();

      gemini.textAndImage(
        /*text: "How healthy is this product? Rate this from 0 to 100."
            "Show the result in the below sequence."
            "0. Product name in bold and h1 style"
            "1. Rating in semi bold h2 style"
            "2. Nutri-Score in semi bold h2 style with description in body style in new line"
            "3. NOVA-Score in semi bold h2 style with description in body style in new line"
            "4. Eco-Score in semi bold h2 style with description in body style in new line"
            "5. Ingredients in semi bold h2 style with bullet points"
            "6. Nutrients in semi bold h2 style with bullet points"
            "7. Other details",*/
        /*text: '''
        You are a health expert and have a great knowledge of all food products.

        Based on this given image check how healthy is this product and rate it between 0 to 100.

        Show the result in the below sequence.
        # **Product Name**

        ## **1. Rating: **
        **Health Rating: [Insert Rating Here] out of 100**

        ## **2. Nutri-Score**
        **Nutri-Score: [Insert Nutri-Score Here]**
        *Description: [Insert Nutri-Score Description Here]*

        ## **3. NOVA-Score**
        **NOVA-Score: [Insert NOVA-Score Here]**
        *Description: [Insert NOVA-Score Description Here]*

        ## **4. Eco-Score**
        **Eco-Score: [Insert Eco-Score Here]**
        *Description: [Insert Eco-Score Description Here]*

        ## **5. Ingredients**
        - [Ingredient 1]
        - [Ingredient 2]
        - [Ingredient 3]
        ...

        ## **6. Nutrients**
        [show Ingredients data in Table format]

        ## **7. Brief description**
        [Provide your review on this product on health benefits and whether is it good to eat this product]
        ''',*/
        text: '''
      You are a health expert and have a great knowledge of all food products. 

      Based on this given image check how healthy is this product and rate it between 0 to 100.
      
      Show the result in the below sequence. 
      # **Product Name**
     
      ## **1. Overall Score: [Insert Rating Here] out of 100 **
      
      ## **2. Nutri-Score: [Insert Nutri-Score Here]**
      [Show Nutri-Score table with meaning and description]
      
      ## **3. NOVA-Score: [Insert NOVA-Score Here]**
      [Show NOVA-Score table with meaning]
      
      ## **4. Eco-Score: [Insert Eco-Score Here]**
      [Show Eco-Score table with meaning]
      
      ## **5. Nutrients**
      [show Ingredients data in Table format]
      
      ## **6. Ingredients**
      - [Ingredient 1]
      - [Ingredient 2]
      - [Ingredient 3]
      ...

      ## **7. Brief description**
      [Provide your review on this product on health benefits and whether is it good to eat this product]
      ''',
        images: [image],
      ).then((value) {
        //var data = value?.content?.parts?.last.text ?? {};
        //log('data: ${jsonEncode(data)}');

        result = value?.content?.parts?.last.text ?? '';
        _loading = false;
        setState(() {});
      }).catchError((e) {
        log('textAndImage', error: e);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog.adaptive(
              title: Text("Error: ${e.runtimeType.hashCode.toString()}"),
              content: Text(e.toString()),
            );
          },
        );
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: Text("Error: ${e.runtimeType.hashCode.toString()}"),
            content: Text(e.toString()),
          );
        },
      );
    }

    /* gemini.text("Write a story about a magic backpack.").then((candidate) {
      print(candidate?.output);
      result = candidate?.content?.parts?.last.text;
      _loading = false;
      setState(() {});
    })
        // or value?.content?.parts?.lastOrNull?.text
        .catchError((e) => print(e));*/
  }

  Future pickImage(ImageSource imageSource) async {
    File? file = await Helper().singleImagePicker(imageSource, allowOriginal: true);
    if (file != null) {
      selectedFile = file;
      getDataByText(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Food AI")),
      body: _loading
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(64),
                child: Lottie.asset('assets/lottie/aiLoading.json'),
              ),
            )
          : result != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Markdown(data: result!),
                )
              : const Center(
                  child: Text('Search something!'),
                ),
      bottomNavigationBar: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => attachmentBottomSheet(context),
          child: const Text("Choose image"),
        ),
      ),
    );
  }

  void attachmentBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Image source",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
