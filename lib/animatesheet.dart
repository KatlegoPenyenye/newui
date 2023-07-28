import 'package:flutter/material.dart';
import 'dart:math';

import 'package:new_animateduis/details.dart';
// import 'dart:ui';
// import 'package:animated_uis/eventitem.dart';
//import 'package:animated_uis/sheetheader.dart';
//import 'package:animated_uis/menubutton.dart';

class AnimationSheet extends StatefulWidget {
  const AnimationSheet({Key? key}) : super(key: key);

  @override
  State<AnimationSheet> createState() => _AnimationSheetState();
}

class _AnimationSheetState extends State<AnimationSheet> {
  double _percent = 0.0;
  double initialPercentage = 0.15;
  bool isDragged = false;
  double initialHeight = 0.0;

  checkStateDragged() {
    if (_percent > 0.5) {
      setState(() {
        isDragged = true;
      });
    } else {
      setState(() {
        isDragged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // handle hiding disabled search field
    checkStateDragged();
    return Scaffold(
      body: Stack(
        children: [
          /* draggable scrollable sheet*/
          Positioned.fill(
            child: NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                setState(() {
                  _percent = 2 * notification.extent - 0.8;
                });
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 0.15,
                minChildSize: 0.15,
                maxChildSize: 1.0,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return AnimatedBuilder(
                      animation: scrollController,
                      builder: (BuildContext context, _) {
                        double percentage = initialPercentage;
                        if (scrollController.hasClients) {
                          // print('HAAAAS CLIEEEEEENTSSSSSS');
                          // print(percentage);
                          percentage =
                              ((scrollController.position.viewportDimension) /
                                  (MediaQuery.of(context).size.height));
                          // setState(() => scrollaction = !scrollaction);
                          // print(percentage);
                        }
                        double scaledPercentage =
                            (percentage - initialPercentage) /
                                (1 - initialPercentage);
                        return Container(
                          padding: const EdgeInsets.only(left: 32.0),
                          decoration: const BoxDecoration(
                            color: Color(0xFF162A49),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32.0)),
                          ),
                          child: Stack(
                            children: <Widget>[
                              !isDragged
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _percent = 1.0;
                                        });
                                      },
                                      child: Container(),
                                    )
                                  : Container(),
                              Opacity(
                                opacity: percentage == 1.0 ? 1.0 : 0.0,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(
                                      right: 32.0, top: 128.0, bottom: 40.0),
                                  controller: scrollController,
                                  itemCount: 20,
                                  itemBuilder: (context, index) {
                                    Event event = events[index % 3];
                                    return ListTile(
                                      title: MyEventItem(
                                        event: event,
                                        percentageCompleted: percentage,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailPage(
                                                      index: index,
                                                      assetName:
                                                          event.assetName,
                                                      assetTitle: event.title,
                                                      assetDate: event.date,
                                                    )));
                                      },
                                    );
                                  },
                                ),
                              ),
                              ...events.map((event) {
                                int index = events.indexOf(event);
                                int heightPerElement = 120 + 8 + 8;
                                double widthPerElement =
                                    40 + percentage * 80 + 8 * (1 - percentage);
                                double leftOffset = widthPerElement *
                                    (index > 4 ? index + 2 : index) *
                                    (1 - scaledPercentage);
                                return Positioned(
                                  top: 44.0 +
                                      scaledPercentage * (128.0 - 44.0) +
                                      index *
                                          heightPerElement *
                                          scaledPercentage,
                                  left: leftOffset,
                                  right: 32.0 - leftOffset,
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: Opacity(
                                      opacity: percentage == 1.0 ? 0.0 : 1.0,
                                      child: MyEventItem(
                                        event: event,
                                        percentageCompleted: percentage,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              SheetHeader(
                                fontSize: 14 + percentage * 8,
                                topMargin: 16 +
                                    percentage *
                                        MediaQuery.of(context).padding.top,
                              ),
                              const MenuButton(),
                            ],
                          ),
                        );
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyEventItem extends StatelessWidget {
  final Event event;
  final double percentageCompleted;

  const MyEventItem(
      {Key? key, required this.event, required this.percentageCompleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scale: 1 / 3 + 2 / 3 * percentageCompleted,
        child: SizedBox(
          height: 120.0,
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.horizontal(
                  left: const Radius.circular(16.0),
                  right: Radius.circular(16 * (1.0 - percentageCompleted)),
                ),
                child: Image.asset(
                  'assets/${event.assetName}',
                  width: 120.0,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Opacity(
                  opacity: max(0.0, percentageCompleted * 2 - 1.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(16.0)),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: _buildContent(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        Text(event.title, style: const TextStyle(fontSize: 12.0)),
        const SizedBox(height: 2.0),
        Row(
          children: <Widget>[
            Text(
              '1 ticket',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.0,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 2.0),
            Text(
              event.date,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: <Widget>[
            Icon(Icons.place, color: Colors.grey.shade400, size: 16.0),
            Text(
              'Science Park',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13.0),
            )
          ],
        )
      ],
    );
  }
}

final List<Event> events = [
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),
];
/*final List<Event> events = [
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
];*/

class Event {
  final String assetName;
  final String title;
  final String date;

  Event(this.assetName, this.title, this.date);
}

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader({Key? key, required this.fontSize, required this.topMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 32.0,
      child: IgnorePointer(
        child: Container(
          padding: EdgeInsets.only(top: topMargin, bottom: 12.0),
          decoration: const BoxDecoration(
            color: Color(0xFF162A49),
          ),
          child: Text(
            'Booked Exhibition',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      right: 12.0,
      bottom: 24.0,
      child: Icon(
        Icons.menu,
        color: Colors.white,
        size: 28.0,
      ),
    );
  }
}












/*
            Positioned(
              left: 0.0,
              right: 0.0,
              top: -180 * (1 - _percent),
              child: Opacity(
                opacity: _percent,
                child: const SearchDestination(),
              ),
            ),

            /* select destination on map */
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: -50 * (1 - _percent),
              child: Opacity(
                opacity: _percent,
                child: const PickOnMap(),
              ),
            ),*/
/*
class SearchDestination extends StatelessWidget {
  const SearchDestination({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10.0,
          bottom: 10.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black87,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "Choose Destination".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w900,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  //  pick up location
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Avenue 34 St 34 NY",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  //  destination
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Where are you going",
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*
class PickOnMap extends StatelessWidget {
  const PickOnMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
      elevation: 5.0,
      color: Colors.amber,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.place_sharp,
                color: Colors.purple,
              ),
              SizedBox(width: 30.0),
              Text(
                "Select on Map",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
/*drawer: Drawer(
        elevation: 0,
        child: SafeArea(
          child: Column(
            children: const [
              Text("Hello world"),
            ],
          ),
        ),
      ),*/
/*Positioned.fill(
              bottom: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset(
                'assets/efe-kurnaz.jpg',
                fit: BoxFit.cover,
              ),
            ),*/
/*Positioned(
              top: 10.0,
              left: 10.0,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {},
                child: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              ),
            ),*/
/*Container(
                            height: 10.0,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 120.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          const SizedBox(height: 15.0),*/
/*Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: const Text(
                                "Akwaaba !",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 5.0,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: const Text(
                                "Where are you going?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 22.0,
                                ),
                              ),
                            ),*/
/*child: TextFormField(
                                      decoration: InputDecoration(
                                        enabled: false,
                                        hintText: "Search Destination",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                          gapPadding: 2.0,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.purple[300],
                                        ),
                                      ),
                                    ),*/