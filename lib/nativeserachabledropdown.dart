import 'package:flutter/material.dart';

class NativeSearchableDropDown extends StatefulWidget {
  final List<String> items;          // ड्रॉपडाऊनमध्ये दाखवायची लिस्ट
  final String hintText;             // बॉक्समध्ये दाखवायचा मेसेज (उदा. "फळ निवडा")
  final ValueChanged<String> onChanged; // व्हॅल्यू निवडल्यावर काय करायचे ते फंक्शन

  const NativeSearchableDropDown({
    super.key,
    required this.items,
    required this.hintText,
    required this.onChanged,
  });
  @override
  State<NativeSearchableDropDown> createState() => _NativeSearchableDropDownState();
}

class _NativeSearchableDropDownState extends State<NativeSearchableDropDown> {

  final SearchController _searchController = SearchController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      searchController: _searchController,
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          controller: controller,
          hintText: widget.hintText,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onTap: () {
            controller.openView(); // क्लिक केल्यावर सर्च लिस्ट ओपन होईल
          },
          onChanged: (_) {
            controller.openView();
          },
          leading: const Icon(Icons.search),
          trailing: const [
            Icon(Icons.arrow_drop_down),
          ],
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final String text = controller.text.toLowerCase();

        // युझरने टाईप केलेल्या अक्षरांवरून लिस्ट फिल्टर करणे
        final List<String> filteredList = widget.items
            .where((item) => item.toLowerCase().contains(text))
            .toList();

        return filteredList.map((String item) {
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                _searchController.closeView(item); // लिस्ट बंद करा
                widget.onChanged(item);           // मेंन स्क्रीनला निवडलेली व्हॅल्यू पाठवा
              });
            },
          );
        }).toList();
      },
    );
  }
}
