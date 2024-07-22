import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_demo/item.dart';
import 'package:provider_demo/item_view_model.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ItemViewModel(), child: const MyApp()));
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    final itemViewModel = Provider.of<ItemViewModel>(context, listen: false);
    itemViewModel.fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    final itemViewModel = Provider.of<ItemViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MVVM with Provider and HTTP'),
      ),
      body: Center(
        child: itemViewModel.item.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: itemViewModel.item.length,
                itemBuilder: (context, index) {
                  final item = itemViewModel.item[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.body),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showEditDialog(context, itemViewModel, item);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            itemViewModel.deleteItem(item.id);
                          },
                        ),
                      ],
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context, itemViewModel);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, ItemViewModel itemViewmodel) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(labelText: 'Body'),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final newItem = Item(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: titleController.text,
                        body: bodyController.text);
                    itemViewmodel.addItem(newItem);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'))
            ],
          );
        });
  }

  void _showEditDialog(
      BuildContext context, ItemViewModel itemViewModel, Item item) {
    final titleController = TextEditingController(text: item.title);
    final bodyController = TextEditingController(text: item.body);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(labelText: 'Body'),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final updateItem = Item(
                        id: item.id,
                        title: titleController.text,
                        body: bodyController.text);

                    itemViewModel.updateItem(updateItem);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update'))
            ],
          );
        });
  }
}
