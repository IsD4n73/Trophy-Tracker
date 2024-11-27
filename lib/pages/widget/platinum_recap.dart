import 'package:flutter/material.dart';
import 'package:trophy_tracker/model/trophy_model.dart';

class PlatinumRecap extends StatelessWidget {
  final List<TrophyModel> platinumTrophys;
  const PlatinumRecap({super.key, required this.platinumTrophys});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Text("POWERED BY PSNProfiles.com"),
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
            "https://pbs.twimg.com/profile_images/676408953287278593/DmVW8OUU_400x400.png",
          ),
        ),
        const SizedBox(height: 10),
        const Divider(
          color: Colors.blue,
        ),
        const SizedBox(height: 10),
        const Text(
          'Earned Platinum Trophies',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 10),
        platinumTrophys.isEmpty
            ? const Text('There\'s nothing to see here')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: platinumTrophys.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var trophy = platinumTrophys[index];
                  return ListTile(
                    title: Text(trophy.name),
                    subtitle: Text(
                      "${trophy.description}\n\nRarity: ${trophy.rarity}",
                      softWrap: true,
                    ),
                    leading: Image.network(trophy.image),
                    trailing: Image.network(trophy.type),
                  );
                },
              ),
      ],
    );
  }
}
