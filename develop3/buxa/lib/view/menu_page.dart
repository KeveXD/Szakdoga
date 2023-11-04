import 'package:flutter/material.dart';
import 'package:buxa/view/debt_page.dart';
import 'package:buxa/view/pocket_page.dart';
import 'package:buxa/view/query_page.dart';
import 'package:buxa/viewmodel/menu_viewmodel.dart';

class MenuPage extends StatelessWidget {
  final MenuPageViewModel? viewModel = MenuPageViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00008577),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF3C4787),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'BuXa',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Menü',
                      ),
                    ),
                    Image.asset(
                      'assets/kezdo.png',
                      height: 160,
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFF232B59),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: CardWidget(
                        icon: Icons.query_builder,
                        label: 'Lekérdezések',
                        onTap: () {
                          viewModel?.navigateToQueryPage(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFF232B59),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: CardWidget(
                        icon: Icons.attach_money,
                        label: 'Tartozások',
                        onTap: () {
                          viewModel?.navigateToDebtPage(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: CardWidget(
                        icon: Icons.shopping_cart,
                        label: 'Pénz áram',
                        onTap: () {
                          viewModel?.navigateToPocketPage(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Color(0xFF232B59),
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: CardWidget(
                        icon: Icons.cloud_upload,
                        label: 'Feltöltés',
                        onTap: () {
                          viewModel?.upload(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: CardWidget(
                        icon: Icons.cloud_download,
                        label: 'Letöltés',
                        onTap: () {
                          viewModel?.download(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  CardWidget({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 75,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MenuPage(),
  ));
}
