import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemsTab extends StatefulWidget {
  const ItemsTab({Key? key}) : super(key: key);

  @override
  State<ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends State<ItemsTab> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = false;
  bool isError = false;
   //TODO Change type
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //TODO Implement items List
        ElevatedButton(
          onPressed: () async {
            //TODO Implement
            setState(() {
              isLoading = true;
              isError = false;
            });
            
            try {
              final response = await http.get(Uri.parse('https://potatotech.mocklab.io.potato-co.com/api/items'));

              if (response.statusCode == 200) {
        // Parse the JSON response
        List<dynamic> jsonResponse = json.decode(response.body);
        items = jsonResponse.cast<Map<String, dynamic>>();

                setState(() {
                  isLoading = false;
                  isError = false;
                });
              } else {
                throw Exception('Failed to load items');
              }
            } catch (e) {
              setState(() {
                isLoading = false;
                isError = true;
              });
            }
          },
          child: const Text('Load items'),
        ),
        if (isLoading)
          CircularProgressIndicator()
        else if (isError)
          Text('Error in loading items')
        else
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]["name"] ?? ''),
                  subtitle: Text("Price: \$${items[index]["price"] ?? 0.0}"),
                  onTap: () {
                    // Navigate to ItemDetailsWidget on item tap
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailsWidget(itemId: items[index]["id"]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class ItemDetailsWidget extends StatefulWidget {
  final int itemId;

  const ItemDetailsWidget({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ItemDetailsWidget> createState() => _ItemDetailsWidgetState();
}

class _ItemDetailsWidgetState extends State<ItemDetailsWidget> {
  late Map<String, dynamic> itemDetails;
  bool isLoading = false;
  bool isError = false;

  //TODO Change type
  @override
  void initState() {
    super.initState();
    _fetchItemDetails();
  }

  Future<void> _fetchItemDetails() async {
    setState(() {
      isLoading = true;
      isError = false;
    });

    try {
      final response = await http.get(Uri.parse('https://potatotech.mocklab.io.potato-co.com/api/item?id=${widget.itemId}'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        itemDetails = json.decode(response.body);

        setState(() {
          isLoading = false;
          isError = false;
        });
      } else {
        throw Exception('Failed to load item details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : isError
                ? Text('Error in loading item details')
                : Column(
                    children: [
                      Image.network(itemDetails["https://media.wired.com/photos/62d75d34ddaaa99a1df8e61d/master/pass/Phone-Camera-Webcam-Gear-GettyImages-1241495650.jpg"] ?? ''),
                      Text(itemDetails["type"] ?? ''),
                      // TODO: Implement Related items List
                    ],
                  ),
      ),
    );
  }
}
