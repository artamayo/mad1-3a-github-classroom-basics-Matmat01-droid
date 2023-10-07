import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuizState(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title:const  Text('Quiz App'),
            backgroundColor: const Color.fromARGB(255, 22, 11, 80),
          ),
          body: QuizPage(),
        ),
      ),
    );
  }
}

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quizState = Provider.of<QuizState>(context);

    return quizState.isQuizFinished
        ? ResultScreen()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  QuestionText(quizState.getCurrentQuestionText()),
                  ...quizState.getCurrentQuestionAnswers().map(
                    (answer) => AnswerButton(
                      answerText: answer,
                      onPressed: () {
                        quizState.answerQuestion(answer);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quizState = Provider.of<QuizState>(context);

    String resultMessage = '';
    if (quizState.score >= 9) {
      resultMessage = 'Perfect!';
    } else if (quizState.score >= 6) {
      resultMessage = "That's Good!";
    } else {
      resultMessage = 'You Failed!';
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Score: ${quizState.score}/10',
              style: const TextStyle(fontSize: 28),
            ),
            Text(
              resultMessage,
              style: const TextStyle(fontSize: 24),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () {
                      quizState.resetQuiz();
                    },
                    child: const Column(
                      children: [
                        Icon(Icons.repeat),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionText extends StatelessWidget {
  final String questionText;

  QuestionText(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget> [
          const SizedBox(height: 1,),
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(10),
            child: Text(
              questionText,
              style:const TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final String answerText;
  final VoidCallback onPressed;

  AnswerButton({
    required this.answerText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
    margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
          ElevatedButton(
            onPressed: onPressed,
            child: Text(answerText),
          ),
        ],
      ),
    );
  }
}

class QuizState extends ChangeNotifier {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '1. Which planet is the hottest?',
      'answers': ['A. Saturn', 'B.Venus', 'C. Mercury', 'D. Mars'],
      'correctAnswer': 'Venus',
    },
    {
      'question': '2. What is the rarest blood type?',
      'answers': ['A. Blood B', 'B. Blood A', 'C. Blood O', 'D. Blood AB-Negative'],
      'correctAnswer': 'Blood O',
    },
    {
      'question': '3. How many bones are there in the human body?',
      'answers': ['A. 201', 'B. 205', 'C. 206', 'D. 209'],
      'correctAnswer': '206',
    },
    {
      'question': '4. What language is the most spoken worldwide?',
      'answers': ['A. English', 'B. Chinese', 'C. Spanish', 'D. Arabic'],
      'correctAnswer': 'English',
    },
    {
      'question': '5. Which social media platform came out in 2003?',
      'answers': ['A. Facebook', 'B. Twitter', 'C. MySpace', 'D. Tumblr'],
      'correctAnswer': 'MySpace',
    },
    {
      'question': '6. Which planet in our solar system is the largest?',
      'answers': ['A. Earth', 'B. Neptune', 'C. Saturn', 'D. Jupiter'],
      'correctAnswer': 'Jupiter',
    },
    {
      'question': '7. Which boyband sings the song “I Want It That Way”?',
      'answers': ['A. One Direction', 'B. Backstreet Boys', 'C. Westlife', 'D. NSYNC'],
      'correctAnswer': 'Backstreet Boys',
    },
    {
      'question': '8. Who painted the Mona Lisa?',
      'answers': ['A. Van Gogh', 'B. Picasso', 'C. Da Vinci', 'D. Monet'],
      'correctAnswer': 'Da Vinci',
    },
    {
      'question': '9. How many days are in February during a leap?',
      'answers': ['A. 28', 'B. 29', 'C. 30', 'D. 31'],
      'correctAnswer': '29',
    },
    {
      'question': '10. Which city is known as the City of Love?',
      'answers': ['A. Rome', 'B. New York', 'C. Paris', 'D. Barcelona'],
      'correctAnswer': 'Paris',
    },
  ];

  int _questionIndex = 0;
  int _score = 0;

  bool get isQuizFinished => _questionIndex >= _questions.length;

  int get score => _score;

  String getCurrentQuestionText() {
    return _questions[_questionIndex]['question'] as String;
  }

  List<String> getCurrentQuestionAnswers() {
    return _questions[_questionIndex]['answers'].cast<String>();
  }


  void answerQuestion(String selectedAnswer) {
  final correctAnswer = _questions[_questionIndex]['correctAnswer'] as String;

  selectedAnswer = selectedAnswer.replaceAll(RegExp(r'^[A-D]\. '), '');

  if (selectedAnswer == correctAnswer) {
    _score++;
  }
  _questionIndex++;
  notifyListeners();
}


  void resetQuiz() {
    _questionIndex = 0;
    _score = 0;
    notifyListeners();
  }
}

