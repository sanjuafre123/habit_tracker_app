import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../DataBase/habit_database.dart';
import '../../compontes/heat_map.dart';
import '../../compontes/my_habit_tilt.dart';
import '../../modal/habit_modal.dart';
import '../../provider/theme_provider.dart';
import '../../utils/habit_util.dart';

final TextEditingController textController = TextEditingController();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initiState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Create a new habit'),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancle'),
          ),
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;

              context.read<HabitDatabase>().addHabit(newHabitName);

              Navigator.pop(context);

              textController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void checkHabit(bool? value, HabitModal habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabit(habit.id, value);
    }
  }

  void editHabit(HabitModal habit) {
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancle'),
          ),
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;

              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);

              Navigator.pop(context);

              textController.clear();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void deletHabit(HabitModal habit) {
    textController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are sure want to delete?'),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);

              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancle'),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    ThemeProvider themeProviderTrue =
        Provider.of<ThemeProvider>(context, listen: true);
    ThemeProvider themeProviderFalse =
        Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Habit Tracker',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Switch(
            value: themeProviderTrue.isDarkMode,
            onChanged: (value) {
              themeProviderFalse.toggleTheme();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.blue,
        onPressed: createNewHabit,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 27,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          _buildHeatMap(),
          const SizedBox(
            height: 20,
          ),
          _buildHabitList(),
        ],
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<HabitModal> currentHabit = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HeatMapScreen(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataset(currentHabit));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<HabitModal> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday = isHabitCompletedToday(habit.complereDays);
        return MyHabitTilt(
          isCompled: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabit(value, habit),
          editHabit: (context) => editHabit(habit),
          deleteHabit: (context) => deletHabit(habit),
        );
      },
    );
  }
}
