// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
//
// class EmployeeDropdownSearch extends StatefulWidget {
//   @override
//   _EmployeeDropdownSearchState createState() => _EmployeeDropdownSearchState();
// }
//
// class _EmployeeDropdownSearchState extends State<EmployeeDropdownSearch> {
//   List<String> _employeeList = [
//     // Add your employee names here
//   ];
//
//   String _selectedEmployee;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Employee Dropdown Search')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TypeAheadField(
//               textFieldConfiguration: TextFieldConfiguration(
//                 decoration: InputDecoration(labelText: 'Search Employee'),
//               ),
//               suggestionsCallback: (pattern) {
//                 return _employeeList
//                     .where((employee) =>
//                     employee.toLowerCase().contains(pattern.toLowerCase()))
//                     .toList();
//               },
//               itemBuilder: (context, suggestion) {
//                 return ListTile(title: Text(suggestion));
//               },
//               onSuggestionSelected: (suggestion) {
//                 setState(() {
//                   _selectedEmployee = suggestion;
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             Text('Selected Employee: $_selectedEmployee'),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
