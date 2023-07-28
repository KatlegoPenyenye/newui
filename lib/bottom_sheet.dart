import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation _colorAnimation;
  bool isFav = false;
  double initialPercentage = 0.15;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // we use "this" to reference the current class itself.
      duration: const Duration(milliseconds: 300),
    );

    _controller.addListener(() {
      // setState re-triggers the buid Function every time the value changes from a controller
      setState(() {});
      // print(_controller.value);
    });

    _controller.addStatusListener((status) {
      // the forward animation
      if (status == AnimationStatus.completed) {
        setState(() {
          isFav = true;
        });
      }
      // reverse animation
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isFav = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.15,
      initialChildSize: 0.15,
      builder: (BuildContext context, ScrollController scrollController) {
        return AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) {
              double percentage = initialPercentage;
              if (scrollController.hasClients) {
                // print('HAAAAS CLIEEEEEENTSSSSSS');
                // print(percentage);
                percentage = ((scrollController.position.viewportDimension) /
                    (MediaQuery.of(context).size.height));
                // setState(() => scrollaction = !scrollaction);
                // print(percentage);
              }
              // double scaledPercentage = (percentage - initialPercentage) / (1 - initialPercentage);
              return Container(
                  padding: const EdgeInsets.only(left: 32),
                  decoration: const BoxDecoration(
                    color: Color(0xFF162A49),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: percentage == 1.0 ? 1.0 : 0.0,
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: 25,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text('Item $index'),
                            );
                          },
                        ),
                      ),
                      Opacity(
                        opacity: percentage == 1.0 ? 0.0 : 1.0,
                        // duration: const Duration(milliseconds: 500),
                        child: const Text(
                          'Hi there!',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ));
            });
      },
    );
  }
}
