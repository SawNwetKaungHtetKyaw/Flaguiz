
import 'package:flaguiz/config/cc_constants.dart';
import 'package:flaguiz/providers/country_provider.dart';
import 'package:flaguiz/widgets/cc_glass_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryProvider>(
      builder: (context, provider, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: CcGlassWidget(
          height: 50,
          child: TextField(
            onChanged: provider.filteredSearchList,
            cursorColor: Colors.white,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold,fontSize: 12),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 10 ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: CcConstants.kSearch,
              hintStyle: TextStyle(color: Colors.grey.shade200,fontSize: 12),
              prefixIcon: const Icon(Icons.search, size: 30,color: Colors.white,),
            ),
          ),
        ),
      ),
    );
  }
}
