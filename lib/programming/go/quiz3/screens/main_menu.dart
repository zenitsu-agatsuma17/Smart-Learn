import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:SmartLearn/programming/go/quiz3/screens/quizz_screen.dart';
import 'package:SmartLearn/programming/go/quiz3/ui/shared/color.dart';

class GoQuiz3 extends StatefulWidget {
  const GoQuiz3({Key? key}) : super(key: key);

  @override
  _GoQuiz3State createState() => _GoQuiz3State();
}

class _GoQuiz3State extends State<GoQuiz3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.pripmaryColor,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: AppColor.pripmaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 48.0,
          horizontal: 12.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  "Test Time 🤕",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: RawMaterialButton(
                  onPressed: () {
                    //Navigating the the Quizz Screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizzScreen(),
                        ));
                  },
                  shape: const StadiumBorder(),
                  fillColor: AppColor.secondaryColor,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: Text(
                      "Start the Quizz",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                "Test Yourslef 💪",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
