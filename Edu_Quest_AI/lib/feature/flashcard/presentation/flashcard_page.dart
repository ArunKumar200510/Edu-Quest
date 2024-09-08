import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:edu_quest/core/app/style.dart';
import 'package:edu_quest/feature/quiz/model/question.dart';
import 'package:edu_quest/feature/quiz/presentation/result_page.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({required this.questions, super.key});
  final List<Question> questions;

  @override
  State<StatefulWidget> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage>
    with TickerProviderStateMixin {
  late PageController _controller;
  int _counter = 0;
  bool selected = false;
  bool loading = false;
  int selectedInd = -1;
  int totalScore = 0;

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
              isFlashcard: true,
            );
          },
        ),
      );
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: darkTheme.copyWith(
            bottomSheetTheme: const BottomSheetThemeData(
              showDragHandle: false,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
            ),
          ),
          builder: (context, child) => Scaffold(
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
                  FlipCard(
                    direction: FlipDirection.HORIZONTAL,
                    side: CardSide.FRONT,
                    front: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context)
                                  .colorScheme
                                  .onTertiary
                                  .withOpacity(0.2),
                              Theme.of(context)
                                  .colorScheme
                                  .onTertiary
                                  .withOpacity(0.4),
                            ],
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
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
                                  fontSize: 36,
                                  letterSpacing: -0.1,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    back: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                              Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.7),
                            ],
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Text(
                                question1.options.first.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  letterSpacing: -0.1,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                    onPressed: () {
                      _controller.previousPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear,
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Tap to see the answer',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      letterSpacing: -0.1,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                    onPressed: nextQuestion,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
          progressBarWidth = 350 * animation!.value;
        } else {
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
                    widget.question.options[ind].isCorrect,
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
