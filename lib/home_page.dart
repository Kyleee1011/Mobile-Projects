import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'models/team.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> teams = [];
  final String apiUrl = 'https://api.balldontlie.io/v1/teams';


  // Fetch teams data
  Future<void> getTeams() async {
    try {
      final Map<String, String> headers = {
        'Authorization': 'c6948efb-e968-4cd9-9d95-1d1785195323',
      };

      var response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        setState(() {
          teams.clear(); // Clear existing teams
          for (var eachTeam in jsonData['data']) {
            final team = Team(
              abbreviation: eachTeam['abbreviation'],
              city: eachTeam['city'],
            );
            teams.add(team);
          }
        });
        print('Number of teams: ${teams.length}');
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    getTeams();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text('NBA'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: teams.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: teams.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(teams[index].abbreviation),
              subtitle: Text(teams[index].city),
            );
          },
        ),
      ),
    );
  }
}
