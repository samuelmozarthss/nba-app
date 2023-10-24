import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nba_app/model/team.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<Team> teams = [];

  //get teams
  Future fetchTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        name: eachTeam['name'],
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
        division: eachTeam['division'],
        full_name: eachTeam['full_name'],
      );
      teams.add(team);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchTeams(),
          builder: (context, snapshop) {
            //is it done loading? then show team data
            if (snapshop.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(
                      top: 4,
                      left: 16,
                      right: 16,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: Image.network(
                          'https://logowik.com/content/uploads/images/atlanta-hawks7500.jpg'),
                      title: Text(teams[index].name),
                      subtitle: Text(teams[index].city),
                      trailing: Text(teams[index].division),
                    ),
                  );
                },
              );
            }
            //if it's still loading, show loading circle
            else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
