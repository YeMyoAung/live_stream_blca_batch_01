// void main() {
//   String url = "http://143.198.87.85:8080/api/v1/live?page=1&limit=10";
//
//   final f = Uri.parse(url);
//
//   final n = f.replace(
//     pathSegments: [
//       ...f.pathSegments,
//       "1",
//       "like",
//     ],
//     query: '',
//   );
//
//   // List<String> parts = url.split("?");
//   // String baseUrl = parts[0];
//   // if (parts.length > 1) {
//   //   for (var i in parts[1].split("&")) {
//   //     if (i.split("=").length != 2) {
//   //       print("injection detect");
//   //     }
//   //   }
//   //
//   //   ///Query
//   //   ///? empty // not empty
//   //   //   print(parts[1]);
//   // }
// }
