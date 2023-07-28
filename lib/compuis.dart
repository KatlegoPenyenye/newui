import 'package:flutter/material.dart';

class Foo extends StatefulWidget {
  const Foo({super.key});

  @override
  State<Foo> createState() => _FooState();
}

class _FooState extends State<Foo> with SingleTickerProviderStateMixin {
  bool isFav = false;
  // The SingleTickerProviderStateMixin allows our Widget to act as Ticker.
  late AnimationController _controller;
  late Animation _colorAnimation; // new Animation object

  // create the State.initState method and then dispose in the State.dispose method.( When used with a StatefulWidget  it is common for an AnimationController to be created in the State.initState method and then disposed in the State.dispose method.)

  // The vsync property is a TickerProvider // a Ticker is a bit like clock that ticks for our animation over and over
  // for every tick we get a new animation value from poiint A to B
  // vsync property allows us to sync the controller with a ticker
  // The ticker we sync the controller with is our stateful widget itself right here.

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // we use "this" to reference the current class itself.
      duration: const Duration(milliseconds: 300),
    );

    _colorAnimation = ColorTween(begin: Colors.grey[400], end: Colors.red)
        .animate(
            _controller); // we tell the controller to controls this animation

    // we can therefore play the animation by using this controller, // we do this by using the forward method on the controller itself
    // _controller.forward(); // this will start the animation controller forward

    // _controller.reverse();

    // The  addListener fires a function everytime the value changes from a controller
    // The statusListener listens for the status of the controller and its gonna run a function every time the status of the controller changes
    // e.g when the animation completes it will run a function, if the status changes back to its initial state then it will run a function
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
  // The duration of the controller is configured from a property in the Foo widget; as that changes, the State.didUpdateWidget method is used to update the controller

  @override
  void didUpdateWidget(Foo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = const Duration(milliseconds: 300);
  }

  // dispose the controller
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /*NB!!!!!! The Build Method is not going to automatically re-run and re-runder everytime the animation values change */
  // Its only goona be triggered to re-run if we use setState. unless if we use AnimatedBuilder.

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return IconButton(
            icon: Icon(
              Icons.favorite,
              color: _colorAnimation.value,
              size: 30,
            ),
            onPressed: () {
              isFav ? _controller.reverse() : _controller.forward();
            },
          );
        });
  }
}
