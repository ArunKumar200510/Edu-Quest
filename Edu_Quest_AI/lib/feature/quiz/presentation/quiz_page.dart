import 'package:flutter/material.dart';
import 'package:edu_quest/feature/quiz/model/question.dart';
import 'package:edu_quest/feature/quiz/presentation/result_page.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({required this.questions, super.key});
  final List<Question> questions;

  @override
  State<StatefulWidget> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  late PageController _controller;
  int _counter = 0;
  bool selected = false;
  int selectedInd = -1;
  int totalScore = 0;
  bool loading = false;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    _counter = 0;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextQuestion() {
    if (_counter < widget.questions.length - 1) {
      setState(() {
        _controller.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) {
            return ResultPage(
              totalScore: totalScore,
              totalQuestions: widget.questions.length,
            );
          },
        ),
      );
      // context.goNamed(
      //   AppRoute.result.name,
      //   extra: Extras(
      //     datas: {
      //       'totalScore': totalScore,
      //       'totalQuestions': questions.length,
      //     },
      //   ),
      // );
    }
  }

  void selectAns(int selectedIndex, {bool isCorrect = false}) {
    if (!loading) {
      setState(() {
        loading = true;
      });
      if (!selected) {
        setState(() {
          selectedInd = selectedIndex;
          selected = true;
          if (isCorrect) {
            totalScore++;
          }
        });
      }
      Future.delayed(
        const Duration(seconds: 2),
        () {
          setState(() {
            selected = false;
            loading = false;
          });
          nextQuestion();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Question> questions = widget.questions;
    return PageView.builder(
      itemCount: questions.length,
      physics: const NeverScrollableScrollPhysics(),
      controller: _controller,
      itemBuilder: (context, index) {
        final Question question1 = questions[index];
        _counter = index;
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 14, 1, 33),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              'Question ${index + 1}/${questions.length}',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                letterSpacing: -0.1,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Theme.of(context).colorScheme.onSurface,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SizedBox.expand(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ProgressBar(index: index, questions: questions),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      // gradient color for the container
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6),
                        ],
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text(
                            question1.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              letterSpacing: -0.1,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: question1.options.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index1) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: ButtonWidget(
                        nextQuestion: selectAns,
                        question: question1,
                        ansInd: index1,
                        selected: selected,
                        selectedInd: selectedInd,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    // );
  }
}

class ProgressBar extends StatefulWidget {
  const ProgressBar({required this.index, required this.questions, super.key});

  final int index;
  final List<Question> questions;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: const Interval((1 / 9) * 1, 1, curve: Curves.fastOutSlowIn),
      ),
    );
    animationController?.forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Question> questions = widget.questions;
    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, child) {
        double progressBarWidth;
        if (widget.index + 1 == questions.length) {
          // If it's the last question, set the width to the maximum
          progressBarWidth = 350 * animation!.value;
        } else {
          // Otherwise, calculate the width based on the progress
          progressBarWidth =
              350 * animation!.value * (widget.index / questions.length);
        }

        return Container(
          height: 18,
          width: 200,
          decoration: BoxDecoration(
            color: HexColor('#87A0E5').withOpacity(0.2),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: progressBarWidth,
                height: 18,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    required this.nextQuestion,
    required this.question,
    required this.ansInd,
    required this.selected,
    required this.selectedInd,
    super.key,
  });
  final Function nextQuestion;
  final Question question;
  final bool selected;
  final int ansInd;
  final int selectedInd;

  @override
  State<ButtonWidget> createState() => ___ButtonWidgetState();
}

class ___ButtonWidgetState extends State<ButtonWidget>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController!,
        curve: Interval(
          (1 / widget.question.options.length) * widget.ansInd,
          1,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    animationController?.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (context, child) {
        final int ind = widget.ansInd;

        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
              0,
              100 * (1.0 - animation!.value),
              0,
            ),
            child: ListTile(
              title: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: widget.selected
                      ? (widget.question.options[ind].isCorrect
                          ? MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 43, 244, 63),
                            )
                          : (widget.selectedInd == ind
                              ? MaterialStateProperty.all<Color>(
                                  Colors.grey,
                                )
                              : MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 209, 85, 89),
                                )))
                      : MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 246, 246, 246),
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    widget.question.options[ind].text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                      letterSpacing: -0.1,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
                onPressed: () {
                  widget.nextQuestion(
                    widget.ansInd,
                    isCorrect: widget.question.options[ind].isCorrect,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class HexColor extends Color {
  HexColor(String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
